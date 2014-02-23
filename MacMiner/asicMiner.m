//
//  asicminerViewController.m
//  MacMiner
//
//  Created by John O'Mara on 01/05/2013.
//  Copyright (c) 2013 John O'Mara. All rights reserved.
//  the apiaccess binary is based on luke-jr's api-example.c in the bfgminer github repo
//  Many thanks to Scott Holben for modifying the api-example.c to allow fetching of
//  RPC data from multiple IPs

#import "asicMiner.h"
#import "AppDelegate.h"


@implementation asicMiner



- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:(NSCoder *)aDecoder];
    if (self) {
        
        // Initialization code here.
        //            NSLog(@"startup");
        //        AppDelegate *appDelegate = (AppDelegate *)[[NSApplication sharedApplication] delegate];


        
        self.asicAPIOutput.delegate = self;
        
        
        self.acceptLabel.tag = 1;
        
        self.apiDataArray = [[NSMutableArray alloc] init];

        [self startToggling];
        
            toggleTimer = [NSTimer scheduledTimerWithTimeInterval:250. target:self selector:@selector(startToggling) userInfo:nil repeats:YES];
        
        self.prefs = [NSUserDefaults standardUserDefaults];
        
        [self.prefs synchronize];
        
        self.minerAddressesArray = [[NSMutableArray alloc] init];
//        self.minerAddressesArray = [self.prefs objectForKey:@"ipAddress"];
        
        
 
    }
    
    
    
    return self;
}



-(void)stopAsicMiner
{
    // change the button's title back for the next search
    [self.asicStartButton setTitle:@"Start"];
//    [self stopToggling];
    // This stops the task and calls our callback (-processFinished)
    [asicTask stopTask];
    findRunning=NO;
    
    // Release the memory for this wrapper object
    
    asicTask=nil;
    
    AppDelegate *appDelegate = (AppDelegate *)[[NSApplication sharedApplication] delegate];
    
    appDelegate.mobileMinerStatus = @"NONE";
    
    [appDelegate.asicReadBack setHidden:YES];
    [appDelegate.asicReading setHidden:YES];
    [[NSApp dockTile] display];
    appDelegate = nil;
    
    return;
}

- (IBAction)start:(id)sender
{
    if (findRunning)
    {
        // change the button's title back for the next search
        [self.asicStartButton setTitle:@"Start"];
        self.asicStartButton.tag = 1;
//        [self stopToggling];
        // This stops the task and calls our callback (-processFinished)
        [asicTask stopTask];
        findRunning=NO;
        
        // Release the memory for this wrapper object
        
        asicTask=nil;
        
self.megaHashLabel.stringValue = @"0";
        self.megaHashLabel.tag = 0;
        
        AppDelegate *appDelegate = (AppDelegate *)[[NSApplication sharedApplication] delegate];
        
        appDelegate.mobileMinerStatus = @"NONE";

        [appDelegate.asicReadBack setHidden:YES];
        [appDelegate.asicReading setHidden:YES];
        [[NSApp dockTile] display];
        appDelegate = nil;

        return;
    }
    else
    {
        [self.asicStartButton setTitle:@"Stop"];
                self.asicStartButton.tag = 0;

    //            self.asicAPIOutput.string = @"";
        [self.asicAPIOutput delete:nil];


        
        // If the task is still sitting around from the last run, release it
        if (asicTask!=nil) {
            asicTask = nil;
        }


        

        
        [self.prefs synchronize];
        

        self.noGPU = [self.prefs stringForKey:@"disableASICGPU"];
        self.debugOutputOn = [self.prefs stringForKey:@"debugASICOutput"];
        self.quietOutputOn = [self.prefs stringForKey:@"quietASICOutput"];
        self.bonusOptions = [self.prefs stringForKey:@"asicOptionsValue"];
        NSString *cpuThreads = [self.prefs stringForKey:@"cpuASICThreads"];

        NSString *executableName = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleExecutable"];
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, YES);
        NSString *userpath = [paths objectAtIndex:0];
        userpath = [userpath stringByAppendingPathComponent:executableName];    // The file will go in this directory
        
        NSMutableArray *launchArray = [NSMutableArray arrayWithObjects: @"-T", @"--api-listen", @"--api-allow", @"R:0/0", nil];
        if ([self.bonusOptions isNotEqualTo:@""]) {
            NSArray *deviceItems = [self.bonusOptions componentsSeparatedByString:@" "];

            [launchArray addObjectsFromArray:deviceItems];
        }
        
        if ([cpuThreads isNotEqualTo:nil]) {
            [launchArray addObject:@"-t"];
            [launchArray addObject:cpuThreads];
        }
        else {
            [launchArray addObject:@"-t"];
            [launchArray addObject:@"0"];
        }

        if ([self.debugOutputOn isNotEqualTo:nil]) {
            [launchArray addObject:self.debugOutputOn];
        }
        if ([self.quietOutputOn isNotEqualTo:nil]) {
            [launchArray addObject:self.quietOutputOn];
        }
        
        if (self.bigpicEnable.state == NSOnState) {
            [launchArray addObject:@"-S"];
            [launchArray addObject:@"bigpic:all"];
        }
        if (self.antminerEnable.state == NSOnState) {
            [launchArray addObject:@"-S"];
            [launchArray addObject:@"antminer:all"];
        }
        if (self.bflEnable.state == NSOnState) {
            [launchArray addObject:@"-S"];
            [launchArray addObject:@"bfl:all"];
        }
        if (self.bitfuryEnable.state == NSOnState) {
            [launchArray addObject:@"-S"];
            [launchArray addObject:@"bifury:all"];
        }
        if (self.erupterEnable.state == NSOnState) {
            [launchArray addObject:@"-S"];
            [launchArray addObject:@"erupter:all"];
        }

                NSString *saveLogFile = [self.prefs stringForKey:@"saveLogFile"];
        if ([saveLogFile  isEqual: @"save"]) {
            [launchArray addObject:@"--debuglog"];
            [launchArray addObject:@"-L"];
            
            NSDateFormatter *DateFormatter=[[NSDateFormatter alloc] init];
            [DateFormatter setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
            NSString *dateString = [NSString stringWithFormat:@"%@",[DateFormatter stringFromDate:[NSDate date]]];
            
                    NSString *saveBTCConfigFilePath = [userpath stringByAppendingPathComponent:@"bfgurls.conf"];
            NSString *btcConfig = [NSString stringWithContentsOfFile : saveBTCConfigFilePath encoding:NSUTF8StringEncoding error:nil];
            NSString *acceptString = [self getDataBetweenFromString:btcConfig
                                                         leftString:@"user" rightString:@"," leftOffset:9];
            NSString *bfgUserValue = [acceptString stringByReplacingOccurrencesOfString:@"\"" withString:@""];
            acceptString = nil;

            
            NSString *logFile = [userpath stringByAppendingString:[@"/" stringByAppendingString:[bfgUserValue stringByAppendingString:[dateString stringByAppendingString:@".txt"]]]];

            [launchArray addObject:logFile];
        }
        
        if ([self.noGPU isNotEqualTo:nil]) {
            [launchArray addObject:@"-S"];
            [launchArray addObject:@"opencl:auto"];
        }
        
            cpuThreads = nil;
        

        NSString *saveBTCConfigFilePath = [userpath stringByAppendingPathComponent:@"bfgurls.conf"];
        
        [launchArray addObject:@"-c"];
        [launchArray addObject:saveBTCConfigFilePath];
        


        NSString *bundlePath2 = [[NSBundle mainBundle] resourcePath];
        
        NSString *bfgPath = [bundlePath2 stringByAppendingString:@"/bfgminer/bin/bfgminer"];

        [self.asicOutputView setString:@""];

       asicTask =[[TaskWrapper alloc] initWithCommandPath:bfgPath
                                        arguments:launchArray
                                      environment:nil
                                         delegate:self];
        // kick off the process asynchronously

        [asicTask startTask];

        
    }
    
}

- (void)toggleLoopTimerFired:(NSTimer*)timer
{
//    NSLog(@"Loop1");
    

    NSString *apiOutputString = self.asicAPIOutput.string;
    
       AppDelegate *appDelegate = (AppDelegate *)[[NSApplication sharedApplication] delegate];
    
    
//  Just messing around here
//    NSData *data = [self.asicAPIOutput.string dataUsingEncoding:NSUTF8StringEncoding];
//    NSError *error;
//    if ([NSJSONSerialization JSONObjectWithData:data
//                                         options:kNilOptions
//                                           error:&error] != nil) {
//        NSLog(@"here");
//            id json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
//        NSLog(@"%@",[json objectForKey:@"STATUS"]);
//    }
//
    
    
    
    
    
    
    if([apiOutputString hasPrefix:@"R"] && [apiOutputString hasSuffix:@")"]) {
        
    
    [self.prefs synchronize];

 
    appDelegate.mobileMinerDataArray = nil;
    appDelegate.mobileMinerDataArray = [[NSMutableArray alloc]init];
        
        if ([appDelegate.mobileMinerStatus isEqualToString:@"START"]) {
//            [self start:nil];
            appDelegate.mobileMinerStatus = @"NONE";
            [self.asicStartButton setTitle:@"Stop"];
            self.asicStartButton.tag = 0;

//            self.asicAPIOutput.string = @"";
            [self.asicAPIOutput delete:nil];
            
            
            // If the task is still sitting around from the last run, release it
            if (asicTask!=nil) {
                asicTask = nil;
            }
            
            
            
            
            
            [self.prefs synchronize];
            
            
            self.noGPU = [self.prefs stringForKey:@"disableASICGPU"];
            self.debugOutputOn = [self.prefs stringForKey:@"debugASICOutput"];
            self.quietOutputOn = [self.prefs stringForKey:@"quietASICOutput"];
            self.bonusOptions = [self.prefs stringForKey:@"asicOptionsValue"];
            NSString *cpuThreads = [self.prefs stringForKey:@"cpuASICThreads"];
            
            
            NSString *executableName = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleExecutable"];
            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, YES);
            NSString *userpath = [paths objectAtIndex:0];
            userpath = [userpath stringByAppendingPathComponent:executableName];    // The file will go in this directory
            NSString *saveBTCConfigFilePath = [userpath stringByAppendingPathComponent:@"bfgurls.conf"];
            
            
            NSMutableArray *launchArray = [NSMutableArray arrayWithObjects: @"-T", @"--api-listen", @"--api-allow", @"R:0/0", nil];
            if ([self.bonusOptions isNotEqualTo:@""]) {
                NSArray *deviceItems = [self.bonusOptions componentsSeparatedByString:@" "];
                
                [launchArray addObjectsFromArray:deviceItems];
            }
            
            if ([cpuThreads isNotEqualTo:nil]) {
                [launchArray addObject:@"-t"];
                [launchArray addObject:cpuThreads];
            }
            else {
                [launchArray addObject:@"-t"];
                [launchArray addObject:@"0"];
            }
            
            if ([self.debugOutputOn isNotEqualTo:nil]) {
                [launchArray addObject:self.debugOutputOn];
            }
            if ([self.quietOutputOn isNotEqualTo:nil]) {
                [launchArray addObject:self.quietOutputOn];
            }
            
            if (self.bigpicEnable.state == NSOnState) {
                [launchArray addObject:@"-S"];
                [launchArray addObject:@"bigpic:all"];
            }
            if (self.antminerEnable.state == NSOnState) {
                [launchArray addObject:@"-S"];
                [launchArray addObject:@"antminer:all"];
            }
            if (self.bflEnable.state == NSOnState) {
                [launchArray addObject:@"-S"];
                [launchArray addObject:@"bfl:all"];
            }
            if (self.bitfuryEnable.state == NSOnState) {
                [launchArray addObject:@"-S"];
                [launchArray addObject:@"bifury:all"];
            }
            if (self.erupterEnable.state == NSOnState) {
                [launchArray addObject:@"-S"];
                [launchArray addObject:@"erupter:all"];
            }
            
            NSString *saveLogFile = [self.prefs stringForKey:@"saveLogFile"];
            if ([saveLogFile  isEqual: @"save"]) {
                [launchArray addObject:@"--debuglog"];
                [launchArray addObject:@"-L"];
                NSDateFormatter *DateFormatter=[[NSDateFormatter alloc] init];
                [DateFormatter setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
                NSString *dateString = [NSString stringWithFormat:@"%@",[DateFormatter stringFromDate:[NSDate date]]];
                
                NSString *saveBTCConfigFilePath = [userpath stringByAppendingPathComponent:@"bfgurls.conf"];
                NSString *btcConfig = [NSString stringWithContentsOfFile : saveBTCConfigFilePath encoding:NSUTF8StringEncoding error:nil];
                NSString *acceptString = [self getDataBetweenFromString:btcConfig
                                                             leftString:@"user" rightString:@"," leftOffset:9];
                NSString *bfgUserValue = [acceptString stringByReplacingOccurrencesOfString:@"\"" withString:@""];
                acceptString = nil;
                
                
                NSString *logFile = [userpath stringByAppendingString:[@"/" stringByAppendingString:[bfgUserValue stringByAppendingString:[dateString stringByAppendingString:@".txt"]]]];
                
                [launchArray addObject:logFile];
            }
            
            
            if ([self.noGPU isNotEqualTo:nil]) {
                [launchArray addObject:@"-S"];
                [launchArray addObject:@"opencl:auto"];
            }
            
            cpuThreads = nil;
            

            
            [launchArray addObject:@"-c"];
            [launchArray addObject:saveBTCConfigFilePath];
            
            
            
            NSString *bundlePath2 = [[NSBundle mainBundle] resourcePath];
            
            NSString *bfgPath = [bundlePath2 stringByAppendingString:@"/bfgminer/bin/bfgminer"];
            
            [self.asicOutputView setString:@""];
            
            asicTask =[[TaskWrapper alloc] initWithCommandPath:bfgPath
                                                     arguments:launchArray
                                                   environment:nil
                                                      delegate:self];
            // kick off the process asynchronously
            
            [asicTask startTask];
            

        }
        if ([appDelegate.mobileMinerStatus isEqualToString:@"RESTART"]) {
            [self start:nil];
            appDelegate.mobileMinerStatus = @"NONE";
        }
        if ([appDelegate.mobileMinerStatus isEqualToString:@"STOP"]) {
//            [self stopAsicMiner];
                appDelegate.mobileMinerStatus = @"NONE";
            
            [self.asicStartButton setTitle:@"Start"];
            self.asicStartButton.tag = 1;
            //        [self stopToggling];
            // This stops the task and calls our callback (-processFinished)
            [asicTask stopTask];
            findRunning=NO;
            
            // Release the memory for this wrapper object
            
            asicTask=nil;
            
            
            appDelegate.mobileMinerStatus = @"NONE";
            
            [appDelegate.asicReadBack setHidden:YES];
            [appDelegate.asicReading setHidden:YES];
            [[NSApp dockTile] display];

        }
    
    NSRange range = NSMakeRange(0, [[self.apiTableViewController arrangedObjects] count]);
    [self.apiTableViewController removeObjectsAtArrangedObjectIndexes:[NSIndexSet indexSetWithIndexesInRange:range]];
    
    if ([apiOutputString rangeOfString:@"GPU0"].location != NSNotFound) {
        
        
        
        int strCount = [apiOutputString length] - [[apiOutputString stringByReplacingOccurrencesOfString:@"GPU[0-9]+" withString:@""] length];
        strCount /= [@"GPU[0-9]+" length];
        
        
        strCount += 1;
        for (int i = 0; i < strCount; i++) {

            
            NSString *pgaCount = [NSString stringWithFormat:@"GPU%d", i];
            NSString *pgaAPIData = [self getDataBetweenFromString:apiOutputString leftString:pgaCount rightString:@")" leftOffset:0];
            NSString *apiStatus = [self getDataBetweenFromString:pgaAPIData leftString:@"[Status] =>" rightString:@"[" leftOffset:11];
            NSString *mhs5S = [self getDataBetweenFromString:pgaAPIData leftString:@"5s] =>" rightString:@"[" leftOffset:7];
            NSString *mhsAv = [self getDataBetweenFromString:pgaAPIData leftString:@"av] =>" rightString:@"[" leftOffset:7];
            NSString *apiAccepted = [self getDataBetweenFromString:pgaAPIData leftString:@"[Accepted] =>" rightString:@"[" leftOffset:13];
            NSString *apiRejected = [self getDataBetweenFromString:pgaAPIData leftString:@"[Rejected] =>" rightString:@"[" leftOffset:13];
            NSString *apiHWError = [self getDataBetweenFromString:pgaAPIData leftString:@"rors] =>" rightString:@"[" leftOffset:8];
            NSString *apiUtility = [self getDataBetweenFromString:pgaAPIData leftString:@"[Utility] =>" rightString:@"[" leftOffset:12];
            NSString *apiDiff1 = [self getDataBetweenFromString:pgaAPIData leftString:@"1 Work] =>" rightString:@"[" leftOffset:10];
            NSString *apiDiffAcc = [self getDataBetweenFromString:pgaAPIData leftString:@"[Difficulty Accepted] =>" rightString:@"[" leftOffset:25];
            NSString *apiDiffRej = [self getDataBetweenFromString:pgaAPIData leftString:@"[Difficulty Rejected] =>" rightString:@"[" leftOffset:25];
            NSString *apiIntensity = [self getDataBetweenFromString:pgaAPIData leftString:@"sity] =>" rightString:@"[" leftOffset:8];
            NSString *apiName = pgaCount;
            
            [self.apiTableViewController addObject:[NSDictionary dictionaryWithObjectsAndKeys:pgaCount,@"name",apiStatus,@"status",mhs5S,@"uid",mhsAv,@"average",apiAccepted,@"accepted",apiRejected,@"rejected",apiHWError,@"error",@" ",@"temp",apiUtility,@"utility",apiDiff1,@"diff1",apiDiffAcc,@"diffaccepted",apiDiffRej,@"diffrejected",apiIntensity,@"intensity",nil]];
            
            NSInteger u = [mhs5S integerValue];
            NSString *apiHash5s = [NSString stringWithFormat:@"%ld", (long)u];
            apiHash5s = [apiHash5s stringByAppendingString:@"000"];

            
            NSInteger v = [mhsAv integerValue];
            NSString *apiHashAv = [NSString stringWithFormat:@"%ld", (long)v];
            apiHashAv = [apiHashAv stringByAppendingString:@"000"];

            NSString *apiPoolString = @"unknown";
            
            NSString *coinChoiceString = @"unknown";
            
            NSString *algorithmString = @"unknown";
            
            if ([self.prefs objectForKey:@"gpuAlgoChoice"]) {
                if ([[self.prefs objectForKey:@"gpuAlgoChoice"]  isEqual: @"0"]) {
coinChoiceString = @"Scrypt";
algorithmString = @"Scrypt";
                    if ([self.prefs stringForKey:@"defaultLTCPoolValue"]) {
                    apiPoolString = [self.prefs stringForKey:@"defaultLTCPoolValue"];
                    }
                }
                if ([[self.prefs objectForKey:@"gpuAlgoChoice"]  isEqual: @"1"]) {
                    coinChoiceString = @"ScryptN";
                    algorithmString = @"ScryptN";
                    if ([self.prefs stringForKey:@"defaultVTCPoolValue"]) {
                        apiPoolString = [self.prefs stringForKey:@"defaultVTCPoolValue"];
                    }
                }
                if ([[self.prefs objectForKey:@"gpuAlgoChoice"]  isEqual: @"2"]) {
                    coinChoiceString = @"Bitcoin";
                    algorithmString = @"SHA256d";
                    if ([self.prefs stringForKey:@"defaultPoolValue"]) {
                      apiPoolString = [self.prefs stringForKey:@"defaultPoolValue"];
                    }

                }
                if ([[self.prefs objectForKey:@"gpuAlgoChoice"]  isEqual: @"3"]) {
                    coinChoiceString = @"MaxCoin";
                    algorithmString = @"Keccak";
                    if ([self.prefs stringForKey:@"defaultMAXPoolValue"]) {
                        apiPoolString = [self.prefs stringForKey:@"defaultMAXPoolValue"];
                    }
                }
            }

            
            
            
            NSString *pgaStats = [NSString stringWithFormat:@"{\"MinerName\":\"MacMiner\",\"CoinSymbol\":\"BTC\",\"CoinName\":\"%@\",\"Algorithm\":\"%@\",\"Kind\":\"GPU\",\"Index\":0,\"Enabled\":true,\"Status\":\"%@\",\"Temperature\":%@,\"FanSpeed\":0,\"FanPercent\":0,\"GpuClock\":0,\"MemoryClock\":0,\"GpuVoltage\":0,\"GpuActivity\":0,\"PowerTune\":0,\"AverageHashrate\":%@,\"CurrentHashrate\":%@,\"AcceptedShares\":%@,\"RejectedShares\":%@,\"HardwareErrors\":%@,\"Utility\":%@,\"Intensity\":\"%@\",\"Name\":\"%@\",\"DeviceID\":0,\"PoolIndex\":0,\"RejectedSharesPercent\":0,\"HardwareErrorsPercent\":0,\"FullName\":\"%@\",\"PoolName\":\"%@\"}", coinChoiceString, algorithmString, apiStatus, @"0", apiHash5s, apiHashAv, apiAccepted, apiRejected, apiHWError, apiUtility, apiIntensity, pgaCount, apiName, apiPoolString];
            
            
            pgaStats = [pgaStats stringByReplacingOccurrencesOfString:@"\n" withString:@""];
            pgaStats = [pgaStats stringByReplacingOccurrencesOfString:@" " withString:@""];
            pgaStats = [pgaStats stringByTrimmingCharactersInSet:[NSCharacterSet newlineCharacterSet]];
            pgaStats = [pgaStats stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            
            [appDelegate.mobileMinerArrayController addObject:pgaStats];
            
            
            apiPoolString = nil;
            apiName = nil;
            pgaStats = nil;
        
        }
        
        
    }
    
    if ([apiOutputString rangeOfString:@"PGA0"].location != NSNotFound) {
        
        
        for (int i = 0; i >= 0; i++) {
            
            
            
            
            NSString *pgaCount = [NSString stringWithFormat:@"PGA%d", i];
            
            if ([apiOutputString rangeOfString:pgaCount].location == NSNotFound) {
                break;
            }
            
            NSString *pgaAPIData = [self getDataBetweenFromString:apiOutputString leftString:pgaCount rightString:@")" leftOffset:0];
            //                                NSLog(pgaCount);
            NSString *apiStatus = [self getDataBetweenFromString:pgaAPIData leftString:@"[Status] =>" rightString:@"[" leftOffset:11];
            NSString *mhs5S = [self getDataBetweenFromString:pgaAPIData leftString:@"5s] =>" rightString:@"[" leftOffset:7];
            NSString *mhsAv = [self getDataBetweenFromString:pgaAPIData leftString:@"av] =>" rightString:@"[" leftOffset:7];
            NSString *apiAccepted = [self getDataBetweenFromString:pgaAPIData leftString:@"[Accepted] =>" rightString:@"[" leftOffset:13];
            NSString *apiRejected = [self getDataBetweenFromString:pgaAPIData leftString:@"[Rejected] =>" rightString:@"[" leftOffset:13];
            NSString *apiHWError = [self getDataBetweenFromString:pgaAPIData leftString:@"rors] =>" rightString:@"[" leftOffset:8];
            NSString *apiUtility = [self getDataBetweenFromString:pgaAPIData leftString:@"[Utility] =>" rightString:@"[" leftOffset:12];
            NSString *apiDiff1 = [self getDataBetweenFromString:pgaAPIData leftString:@"1 Work] =>" rightString:@"[" leftOffset:10];
            NSString *apiDiffAcc = [self getDataBetweenFromString:pgaAPIData leftString:@"[Difficulty Accepted] =>" rightString:@"[" leftOffset:25];
            NSString *apiDiffRej = [self getDataBetweenFromString:pgaAPIData leftString:@"[Difficulty Rejected] =>" rightString:@"[" leftOffset:25];
            NSString *apiName = [self getDataBetweenFromString:pgaAPIData leftString:@"[Name] =>" rightString:@"[" leftOffset:10];
            
            NSInteger u = [mhs5S integerValue];
            NSString *apiHash5s = [NSString stringWithFormat:@"%ld", (long)u];
            apiHash5s = [apiHash5s stringByAppendingString:@"000"];

            
            NSInteger v = [mhsAv integerValue];
            NSString *apiHashAv = [NSString stringWithFormat:@"%ld", (long)v];
            apiHashAv = [apiHashAv stringByAppendingString:@"000"];

            
            
            if ([pgaAPIData rangeOfString:@"Temperature"].location != NSNotFound) {
                NSString *apiTemp = [self getDataBetweenFromString:pgaAPIData leftString:@"[Temperature] => " rightString:@"[" leftOffset:16];
                
                [self.apiTableViewController addObject:[NSDictionary dictionaryWithObjectsAndKeys:pgaCount,@"name",apiStatus,@"status",mhs5S,@"uid",mhsAv,@"average",apiAccepted,@"accepted",apiRejected,@"rejected",apiHWError,@"error",apiTemp,@"temp",apiUtility,@"utility",apiDiff1,@"diff1",apiDiffAcc,@"diffaccepted",apiDiffRej,@"diffrejected",@" ",@"intensity",nil]];
                
                
                NSString *apiPoolString = [self.prefs stringForKey:@"defaultPoolValue"];
                
                NSString *pgaStats = [NSString stringWithFormat:@"{\"MinerName\":\"MacMiner\",\"CoinSymbol\":\"BTC\",\"CoinName\":\"Bitcoin\",\"Algorithm\":\"SHA-256\",\"Kind\":\"PGA\",\"Index\":%d,\"Enabled\":true,\"Status\":\"%@\",\"Temperature\":%@,\"FanSpeed\":0,\"FanPercent\":0,\"GpuClock\":0,\"MemoryClock\":0,\"GpuVoltage\":0,\"GpuActivity\":0,\"PowerTune\":0,\"AverageHashrate\":%@,\"CurrentHashrate\":%@,\"AcceptedShares\":%@,\"RejectedShares\":%@,\"HardwareErrors\":%@,\"Utility\":%@,\"Intensity\":\"0\",\"Name\":\"%@\",\"DeviceID\":0,\"PoolIndex\":0,\"RejectedSharesPercent\":0,\"HardwareErrorsPercent\":0,\"FullName\":\"%@\",\"PoolName\":\"%@\"}", i, apiStatus, apiTemp, apiHash5s, apiHashAv, apiAccepted, apiRejected, apiHWError, apiUtility, pgaCount, apiName, apiPoolString];
                
                
                pgaStats = [pgaStats stringByTrimmingCharactersInSet:[NSCharacterSet newlineCharacterSet]];
                pgaStats = [pgaStats stringByReplacingOccurrencesOfString:@"\n" withString:@""];
                pgaStats = [pgaStats stringByReplacingOccurrencesOfString:@" " withString:@""];
                pgaStats = [pgaStats stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
                
                [appDelegate.mobileMinerArrayController addObject:pgaStats];
                
                apiTemp = nil;
                apiPoolString = nil;
                apiName = nil;
                pgaStats = nil;
                
            }
            else {
                NSString *apiTemp = @"0";
                [self.apiTableViewController addObject:[NSDictionary dictionaryWithObjectsAndKeys:pgaCount,@"name",apiStatus,@"status",mhs5S,@"uid",mhsAv,@"average",apiAccepted,@"accepted",apiRejected,@"rejected",apiHWError,@"error",apiTemp,@"temp",apiUtility,@"utility",apiDiff1,@"diff1",apiDiffAcc,@"diffaccepted",apiDiffRej,@"diffrejected",@" ",@"intensity",nil]];
                
                
                NSString *apiPoolString = [self.prefs stringForKey:@"defaultPoolValue"];
                
                NSString *pgaStats = [NSString stringWithFormat:@"{\"MinerName\":\"MacMiner\",\"CoinSymbol\":\"BTC\",\"CoinName\":\"Bitcoin\",\"Algorithm\":\"SHA-256\",\"Kind\":\"PGA\",\"Index\":%d,\"Enabled\":true,\"Status\":\"%@\",\"Temperature\":%@,\"FanSpeed\":0,\"FanPercent\":0,\"GpuClock\":0,\"MemoryClock\":0,\"GpuVoltage\":0,\"GpuActivity\":0,\"PowerTune\":0,\"AverageHashrate\":%@,\"CurrentHashrate\":%@,\"AcceptedShares\":%@,\"RejectedShares\":%@,\"HardwareErrors\":%@,\"Utility\":%@,\"Intensity\":\"0\",\"Name\":\"%@\",\"DeviceID\":0,\"PoolIndex\":0,\"RejectedSharesPercent\":0,\"HardwareErrorsPercent\":0,\"FullName\":\"%@\",\"PoolName\":\"%@\"}", i, apiStatus, apiTemp, apiHash5s, apiHashAv, apiAccepted, apiRejected, apiHWError, apiUtility, pgaCount, apiName, apiPoolString];
                
                
                pgaStats = [pgaStats stringByReplacingOccurrencesOfString:@"\n" withString:@""];
                pgaStats = [pgaStats stringByReplacingOccurrencesOfString:@" " withString:@""];
                pgaStats = [pgaStats stringByTrimmingCharactersInSet:[NSCharacterSet newlineCharacterSet]];
                pgaStats = [pgaStats stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
                
                [appDelegate.mobileMinerArrayController addObject:pgaStats];
                
                
                apiTemp = nil;
                apiPoolString = nil;
                apiName = nil;
                pgaStats = nil;
                
            }
            
            
            pgaCount = nil;
            pgaAPIData = nil;
            apiStatus = nil;
            mhsAv = nil;
            mhs5S = nil;
            apiAccepted = nil;
            apiRejected = nil;
            apiHWError = nil;
            apiUtility = nil;
            apiDiff1 = nil;
            apiDiffAcc = nil;
            apiDiffRej = nil;
            
            
            
        }
        
        
        
    }
    
    if ([apiOutputString rangeOfString:@"ASC0"].location != NSNotFound) {
        
        
        for (int i = 0; i >= 0; i++) {
            
            
            
            NSString *pgaCount = [NSString stringWithFormat:@"ASC%d", i];
            
            if ([apiOutputString rangeOfString:pgaCount].location == NSNotFound) {
                break;
            }
            
            NSString *pgaAPIData = [self getDataBetweenFromString:apiOutputString leftString:pgaCount rightString:@")" leftOffset:0];
            //                                NSLog(pgaCount);
            NSString *apiStatus = [self getDataBetweenFromString:pgaAPIData leftString:@"[Status] =>" rightString:@"[" leftOffset:11];
            NSString *mhs5S = [self getDataBetweenFromString:pgaAPIData leftString:@"5s] =>" rightString:@"[" leftOffset:7];
            NSString *mhsAv = [self getDataBetweenFromString:pgaAPIData leftString:@"av] =>" rightString:@"[" leftOffset:7];
            NSString *apiAccepted = [self getDataBetweenFromString:pgaAPIData leftString:@"[Accepted] =>" rightString:@"[" leftOffset:13];
            NSString *apiRejected = [self getDataBetweenFromString:pgaAPIData leftString:@"[Rejected] =>" rightString:@"[" leftOffset:13];
            NSString *apiHWError = [self getDataBetweenFromString:pgaAPIData leftString:@"rors] =>" rightString:@"[" leftOffset:8];
            NSString *apiUtility = [self getDataBetweenFromString:pgaAPIData leftString:@"[Utility] =>" rightString:@"[" leftOffset:12];
            NSString *apiDiff1 = [self getDataBetweenFromString:pgaAPIData leftString:@"1 Work] =>" rightString:@"[" leftOffset:10];
            NSString *apiDiffAcc = [self getDataBetweenFromString:pgaAPIData leftString:@"[Difficulty Accepted] =>" rightString:@"[" leftOffset:25];
            NSString *apiDiffRej = [self getDataBetweenFromString:pgaAPIData leftString:@"[Difficulty Rejected] =>" rightString:@"[" leftOffset:25];
            NSString *apiName = [self getDataBetweenFromString:pgaAPIData leftString:@"[Name] =>" rightString:@"[" leftOffset:10];
            
            NSInteger u = [mhs5S integerValue];
            NSString *apiHash5s = [NSString stringWithFormat:@"%ld", (long)u];
            apiHash5s = [apiHash5s stringByAppendingString:@"000"];

            
            NSInteger v = [mhsAv integerValue];
            NSString *apiHashAv = [NSString stringWithFormat:@"%ld", (long)v];
            apiHashAv = [apiHashAv stringByAppendingString:@"000"];

            
            
            if ([pgaAPIData rangeOfString:@"Temperature"].location != NSNotFound) {
                
                NSString *apiTemp = [self getDataBetweenFromString:pgaAPIData leftString:@"[Temperature] => " rightString:@"[" leftOffset:16];
                
                [self.apiTableViewController addObject:[NSDictionary dictionaryWithObjectsAndKeys:pgaCount,@"name",apiStatus,@"status",mhs5S,@"uid",mhsAv,@"average",apiAccepted,@"accepted",apiRejected,@"rejected",apiHWError,@"error",apiTemp,@"temp",apiUtility,@"utility",apiDiff1,@"diff1",apiDiffAcc,@"diffaccepted",apiDiffRej,@"diffrejected",@" ",@"intensity",nil]];
                
                
                NSString *apiPoolString = [self.prefs stringForKey:@"defaultPoolValue"];
                
                NSString *pgaStats = [NSString stringWithFormat:@"{\"MinerName\":\"MacMiner\",\"CoinSymbol\":\"BTC\",\"CoinName\":\"Bitcoin\",\"Algorithm\":\"SHA-256\",\"Kind\":\"ASC\",\"Index\":%d,\"Enabled\":true,\"Status\":\"%@\",\"Temperature\":%@,\"FanSpeed\":0,\"FanPercent\":0,\"GpuClock\":0,\"MemoryClock\":0,\"GpuVoltage\":0,\"GpuActivity\":0,\"PowerTune\":0,\"AverageHashrate\":%@,\"CurrentHashrate\":%@,\"AcceptedShares\":%@,\"RejectedShares\":%@,\"HardwareErrors\":%@,\"Utility\":%@,\"Intensity\":\"0\",\"Name\":\"%@\",\"DeviceID\":0,\"PoolIndex\":0,\"RejectedSharesPercent\":0,\"HardwareErrorsPercent\":0,\"FullName\":\"%@\",\"PoolName\":\"%@\"}", i, apiStatus, apiTemp, apiHash5s, apiHashAv, apiAccepted, apiRejected, apiHWError, apiUtility, pgaCount, apiName, apiPoolString];
                
                
                pgaStats = [pgaStats stringByTrimmingCharactersInSet:[NSCharacterSet newlineCharacterSet]];
                pgaStats = [pgaStats stringByReplacingOccurrencesOfString:@"\n" withString:@""];
                pgaStats = [pgaStats stringByReplacingOccurrencesOfString:@" " withString:@""];
                pgaStats = [pgaStats stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
                
                [appDelegate.mobileMinerArrayController addObject:pgaStats];
                
                apiTemp = nil;
                apiPoolString = nil;
                apiName = nil;
                pgaStats = nil;
                
            }
            else {
                
                NSString *apiTemp = @"0";
                [self.apiTableViewController addObject:[NSDictionary dictionaryWithObjectsAndKeys:pgaCount,@"name",apiStatus,@"status",mhs5S,@"uid",mhsAv,@"average",apiAccepted,@"accepted",apiRejected,@"rejected",apiHWError,@"error",apiTemp,@"temp",apiUtility,@"utility",apiDiff1,@"diff1",apiDiffAcc,@"diffaccepted",apiDiffRej,@"diffrejected",@" ",@"intensity",nil]];
                
                
                NSString *apiPoolString = [self.prefs stringForKey:@"defaultPoolValue"];
                
                NSString *pgaStats = [NSString stringWithFormat:@"{\"MinerName\":\"MacMiner\",\"CoinSymbol\":\"BTC\",\"CoinName\":\"Bitcoin\",\"Algorithm\":\"SHA-256\",\"Kind\":\"ASC\",\"Index\":%d,\"Enabled\":true,\"Status\":\"%@\",\"Temperature\":%@,\"FanSpeed\":0,\"FanPercent\":0,\"GpuClock\":0,\"MemoryClock\":0,\"GpuVoltage\":0,\"GpuActivity\":0,\"PowerTune\":0,\"AverageHashrate\":%@,\"CurrentHashrate\":%@,\"AcceptedShares\":%@,\"RejectedShares\":%@,\"HardwareErrors\":%@,\"Utility\":%@,\"Intensity\":\"0\",\"Name\":\"%@\",\"DeviceID\":0,\"PoolIndex\":0,\"RejectedSharesPercent\":0,\"HardwareErrorsPercent\":0,\"FullName\":\"%@\",\"PoolName\":\"%@\"}", i, apiStatus, apiTemp, apiHash5s, apiHashAv, apiAccepted, apiRejected, apiHWError, apiUtility, pgaCount, apiName, apiPoolString];
                
                
                pgaStats = [pgaStats stringByReplacingOccurrencesOfString:@"\n" withString:@""];
                pgaStats = [pgaStats stringByReplacingOccurrencesOfString:@" " withString:@""];
                pgaStats = [pgaStats stringByTrimmingCharactersInSet:[NSCharacterSet newlineCharacterSet]];
                pgaStats = [pgaStats stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
                
                [appDelegate.mobileMinerArrayController addObject:pgaStats];
                
                
                apiTemp = nil;
                apiPoolString = nil;
                apiName = nil;
                pgaStats = nil;
            }
            
            
            pgaCount = nil;
            pgaAPIData = nil;
            apiStatus = nil;
            mhsAv = nil;
            mhs5S = nil;
            apiAccepted = nil;
            apiRejected = nil;
            apiHWError = nil;
            apiUtility = nil;
            apiDiff1 = nil;
            apiDiffAcc = nil;
            apiDiffRej = nil;
            
            
            
            
        }
        
        
    }
    
    
    [self.apiTableView reloadData];
    [self.apiTableView setNeedsDisplay:YES];
            
        NSString *email = [self.prefs objectForKey:@"emailAddress"];
        
        
        if (email.length >= 5) {
            [appDelegate mobilePost];
        }
        
        email = nil;

    }
    NSString *email = [self.prefs objectForKey:@"emailAddress"];

    
    if (email.length >= 5) {
        [appDelegate mobileCommands];
    }
    
    email = nil;
    appDelegate = nil;

}

- (void)toggleTimerFired:(NSTimer*)timer
{
//        NSLog(@"Loop2");

    
    [self.prefs synchronize];
    
    NSString *speechSetting = [self.prefs objectForKey:@"enableSpeech"];
    if ([speechSetting  isEqual: @"silence"]) {
        
    }
    
    else if ([self.megaHashLabel.stringValue isEqual: @"0"] && self.megaHashLabel.tag == 1) {
        _speechSynth = [[NSSpeechSynthesizer alloc] initWithVoice:nil];
        [self.speechSynth startSpeakingString:@"Mining Stopped"];
    }
    speechSetting = nil;

    
    if ([self.megaHashLabel.stringValue isNotEqualTo:@"0"]) {
        self.megaHashLabel.tag = 1;
    }

    
    if (findTwoRunning == YES) {
        [apiTask stopTask];
        apiTask = nil;
        findTwoRunning = NO;
    }
    else {

        // If the task is still sitting around from the last run, release it
        if (apiTask!=nil) {
            apiTask = nil;
        }
        
        if (self.acceptLabel.tag == 0) {
        self.acceptLabel.tag = 1;
        }
        else {
        self.acceptLabel.tag = 0;
        }

                 AppDelegate *appDelegate = (AppDelegate *)[[NSApplication sharedApplication] delegate];
        
    NSMutableArray *apiArray = [NSMutableArray arrayWithObjects: nil];
        if ([appDelegate.asicReadBack isHidden] == NO) {
            [apiArray addObject:@"devs"];
                       [apiArray addObject:@"4028"];
        }

        if ([appDelegate.cgReadBack isHidden] == NO) {
                        [apiArray addObject:@"devs"];
            [apiArray addObject:@"127.0.0.1:4048"];
        }
        if ([appDelegate.bfgReadBack isHidden] == NO) {
            [apiArray addObject:@"devs"];
            [apiArray addObject:@"127.0.0.1:4052"];
        }

        if (self.minerAddressesArray.count >= 1) {
            
        
        [apiArray addObjectsFromArray:self.minerAddressesArray];
//        NSLog([NSString stringWithFormat:@"%lu", (unsigned long)self.minerAddressesArray.count]);
//        NSLog([self.minerAddressesArray componentsJoinedByString:@" "]);
        }
    
    NSString *executableName = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleExecutable"];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, YES);
    NSString *userpath = [paths objectAtIndex:0];
    userpath = [userpath stringByAppendingPathComponent:executableName];

    NSString *bundlePath2 = [[NSBundle mainBundle] resourcePath];
    
    NSString *apiPath = [bundlePath2 stringByAppendingString:@"/apiaccess"];

    
    apiTask =[[taskTwoWrapper alloc] initWithCommandPath:apiPath
                                             arguments:apiArray
                                           environment:nil
                                              delegate:self];
    // kick off the process asynchronously
//        NSString *logger = [apiArray componentsJoinedByString:@" "];
//        NSLog(logger);
        if ([apiArray containsObject:@"devs"] || [appDelegate.asicReadBack isHidden] == NO || [appDelegate.cgReadBack isHidden] == NO || [appDelegate.bfgReadBack isHidden] == NO) {
    [apiTask startTask];
        }

        

        apiArray = nil;
        paths = nil;
        userpath = nil;
        executableName = nil;
        bundlePath2 = nil;
        apiPath = nil;
        
    }
    

}


- (void)taskTwoWrapper:(taskTwoWrapper *)taskTwoWrapper didProduceOutput:(NSString *)output
{
//    NSLog(@"output");
    output = [output substringToIndex:[output length]-1];
    
    if ([output rangeOfString:@"Reply was"].location != NSNotFound) {
        
        
        if([output hasPrefix:@"R"] && [output hasSuffix:@")"]) {

//            self.asicAPIOutput.string = @"";
            
            [self.asicAPIOutput delete:nil];
            [self.asicAPIOutput didChangeText];
            
            self.asicAPIOutput.string = output;

        }
        
    }
        output = nil;
}

- (void)taskTwoWrapperWillStartTask:(taskTwoWrapper *)taskTwoWrapper
{
    //    AppDelegate *appDelegate = (AppDelegate *)[[NSApplication sharedApplication] delegate];
    findTwoRunning=YES;
    // clear the results
    //    [self.outputView setString:@""];
    // change the "Start" button to say "Stop"
    //    [asicStartButton setTitle:@"Stop"];
}

// A callback that gets called when a TaskWrapper is completed, allowing us to do any cleanup
// that is needed from the app side.  This method is implemented as a part of conforming
// to the ProcessController protocol.
- (void)taskTwoWrapper:(taskTwoWrapper *)taskTwoWrapper didFinishTaskWithStatus:(int)terminationStatus
{
    findTwoRunning=NO;


    
}

- (void)stopToggling
{
    [loopTimer invalidate], loopTimer = nil;  // you don't want dangling pointers...
    
    // perform any other needed house-keeping here
                            [self.asicStartButton setTitle:@"Start"];
}


- (void)startToggling
{
    [timerTimer invalidate], timerTimer = nil;
    [loopTimer invalidate], loopTimer = nil;  // you don't want dangling pointers...
//    if ([asicStartButton.title isEqual: @"Start"]) {


//            [asicStartButton setTitle:@"Stop"];
//    [self stopToggling:self];
    
    loopTimer = [NSTimer scheduledTimerWithTimeInterval:6. target:self selector:@selector(toggleLoopTimerFired:) userInfo:nil repeats:YES];
        timerTimer = [NSTimer scheduledTimerWithTimeInterval:6. target:self selector:@selector(toggleTimerFired:) userInfo:nil repeats:YES];
    
//    }


}


// This callback is implemented as part of conforming to the ProcessController protocol.
// It will be called whenever there is output from the TaskWrapper.
- (void)taskWrapper:(TaskWrapper *)taskWrapper didProduceOutput:(NSString *)output
{
    
    
    [self.prefs synchronize];
    
    NSString *speechSetting = [self.prefs objectForKey:@"enableSpeech"];
    if ([speechSetting  isEqual: @"silence"]) {
        
    }

    else if ([output rangeOfString:@"auth failed"].location != NSNotFound) {
        _speechSynth = [[NSSpeechSynthesizer alloc] initWithVoice:nil];
        [self.speechSynth startSpeakingString:@"Authorisation Failed"];
    }
    
    if ([output rangeOfString:@"5s:"].location != NSNotFound) {
        self.numberString = [self getDataBetweenFromString:output
                                                     leftString:@"5s" rightString:@"a" leftOffset:3];
        self.megaHashLabel.stringValue = [self.numberString stringByReplacingOccurrencesOfString:@" " withString:@""];
        self.numberString = nil;
        self.acceptString = [self getDataBetweenFromString:output
                                                     leftString:@"A:" rightString:@"R" leftOffset:0];
        self.acceptLabel.stringValue = [self.acceptString stringByReplacingOccurrencesOfString:@"A:" withString:@"Accepted: "];
        self.acceptString = nil;
        self.rejectString = [self getDataBetweenFromString:output
                                                     leftString:@"R:" rightString:@"+" leftOffset:0];
        self.rejecttLabel.stringValue = [self.rejectString stringByReplacingOccurrencesOfString:@"R:" withString:@"Rejected: "];
        self.rejectString = nil;
        
        if ([output rangeOfString:@"kh"].location != NSNotFound) {
            self.asicHashField.stringValue = @"Kh";
        }
        if ([output rangeOfString:@"Mh"].location != NSNotFound) {
            self.asicHashField.stringValue = @"Mh";
        }
        if ([output rangeOfString:@"Gh"].location != NSNotFound) {
            self.asicHashField.stringValue = @"Gh";
        }
        
        
        
        if ([[self.prefs objectForKey:@"showDockReading"] isEqualTo:@"hide"]) {
            AppDelegate *appDelegate = (AppDelegate *)[[NSApplication sharedApplication] delegate];
            [appDelegate.bfgReadBack setHidden:YES];
            [appDelegate.bfgReading setHidden:YES];
            [[NSApp dockTile] display];
            appDelegate = nil;
        }
        else
        {
            
            
            AppDelegate *appDelegate = (AppDelegate *)[[NSApplication sharedApplication] delegate];
            appDelegate.asicReading.stringValue = [self.megaHashLabel.stringValue stringByAppendingString:self.asicHashField.stringValue];
            [appDelegate.asicReadBack setHidden:NO];
            [appDelegate.asicReading setHidden:NO];
            [[NSApp dockTile] display];
            appDelegate = nil;
        }


        self.numberString = nil;
        self.acceptString = nil;
        self.rejectString = nil;
        output = nil;

    }
  
    if ([output rangeOfString:@"Unknown stratum msg"].location != NSNotFound) {
        output = nil;
    }
    else {
        
        NSString *newOutput = [self.asicOutputView.string stringByAppendingString:output];
        self.asicOutputView.string = newOutput;
        newOutput = nil;
    
    
    [self.prefs synchronize];

    self.logLength = [self.prefs objectForKey:@"logLength" ];
    if (self.logLength.intValue <= 1) {
        self.logLength = @"5000";
    }
    
    if (self.asicOutputView.string.length >= self.logLength.intValue) {
        [self.asicOutputView setEditable:true];
        [self.asicOutputView setSelectedRange:NSMakeRange(0,1000)];
        [self.asicOutputView delete:nil];
        [self.asicOutputView setEditable:false];
    }
        
        self.logLength = nil;
        
    }


        /*    [[appDelegate.pingReport textStorage] appendAttributedString: [[NSAttributedString alloc]
         initWithString: output]];
         */
        
        // setup a selector to be called the next time through the event loop to scroll
        // the view to the just pasted text.  We don't want to scroll right now,
        // because of a bug in Mac OS X version 10.1 that causes scrolling in the context
        // of a text storage update to starve the app of events
        [self performSelector:@selector(scrollToVisible:) withObject:nil afterDelay:0.0];
    output = nil;
    }


- (NSString *)getDataBetweenFromString:(NSString *)data leftString:(NSString *)leftData rightString:(NSString *)rightData leftOffset:(NSInteger)leftPos;
{
            if ([leftData isNotEqualTo:nil]) {
    NSInteger left, right;

    NSScanner *scanner=[NSScanner scannerWithString:data];
    [scanner scanUpToString:leftData intoString: nil];
    left = [scanner scanLocation];
    [scanner setScanLocation:left + leftPos];
    [scanner scanUpToString:rightData intoString: nil];
    right = [scanner scanLocation] + 1;
    left += leftPos;
    self.foundData = [data substringWithRange: NSMakeRange(left, (right - left) - 1)];

    return self.foundData;
                
                self.foundData = nil;
                scanner = nil;
                leftData = nil;
                rightData = nil;
    }
    else return nil;
}

// This routine is called after adding new results to the text view's backing store.
// We now need to scroll the NSScrollView in which the NSTextView sits to the part
// that we just added at the end
- (void)scrollToVisible:(id)ignore {
    //   AppDelegate *appDelegate = (AppDelegate *)[[NSApplication sharedApplication] delegate];
    [self.asicOutputView scrollRangeToVisible:NSMakeRange([[self.asicOutputView string] length], 0)];
}

// A callback that gets called when a TaskWrapper is launched, allowing us to do any setup
// that is needed from the app side.  This method is implemented as a part of conforming
// to the ProcessController protocol.
- (void)taskWrapperWillStartTask:(TaskWrapper *)taskWrapper
{
    //    AppDelegate *appDelegate = (AppDelegate *)[[NSApplication sharedApplication] delegate];
    findRunning=YES;
    // clear the results
    //    [self.outputView setString:@""];
    // change the "Start" button to say "Stop"
//    [asicStartButton setTitle:@"Stop"];
}

// A callback that gets called when a TaskWrapper is completed, allowing us to do any cleanup
// that is needed from the app side.  This method is implemented as a part of conforming
// to the ProcessController protocol.
- (void)taskWrapper:(TaskWrapper *)taskWrapper didFinishTaskWithStatus:(int)terminationStatus
{
    AppDelegate *appDelegate = (AppDelegate *)[[NSApplication sharedApplication] delegate];

    [appDelegate.asicReadBack setHidden:YES];
    [appDelegate.asicReading setHidden:YES];
    
    findRunning=NO;
    // change the button's title back for the next search
    [self.asicStartButton setTitle:@"Start"];
    if (self.asicStartButton.tag == 0) {
        
        [self performSelector:@selector(start:) withObject:nil afterDelay:10.0];
        
        NSAlert *restartMessage = [[NSAlert alloc] init];
        [restartMessage addButtonWithTitle:@"Umm… OK."];
        
        [restartMessage setMessageText:@"Settings changed"];
        
        NSDate * now = [NSDate date];
        NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
        [outputFormatter setDateFormat:@"HH:mm:ss"];
        NSString *newDateString = [outputFormatter stringFromDate:now];
//        NSLog(@"newDateString %@", newDateString);
        outputFormatter = nil;
        NSString *restartMessageInfo = [NSString stringWithFormat:@"Your miner was resarted automatically after a sudden stop at %@.", newDateString];
        [restartMessage setInformativeText:restartMessageInfo];
        
        restartMessage = nil;
        
        [restartMessage setAlertStyle:NSWarningAlertStyle];
        //        returnCode: (NSInteger)returnCode
        
        [restartMessage beginSheetModalForWindow:self.asicWindow modalDelegate:self didEndSelector:nil contextInfo:nil];
    }
    appDelegate = nil;

}


-(BOOL)windowShouldClose:(id)sender
{



    return YES;
    
}

// Display the release notes, as chosen from the menu item in the Help menu.
- (IBAction)displayHelp:(id)sender
{
[[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:@"http://fabulouspanda.co.uk/macminer/docs/"]];
}

- (IBAction)addNetworkedMiner:(id)sender
{
        [self.addNetworkedMinerWindow orderFront:sender];
}

- (IBAction)addNetworkedMinerApply:(id)sender
{
//self.prefs = [NSUserDefaults standardUserDefaults];
        [self.minerAddressesArray addObject:@"devs"];
    [self.minerAddressesArray addObject:self.ipAddress.stringValue];
    
//        [self.prefs setObject:self.minerAddressesArray forKey:@"ipAddress"];

    [self.prefs synchronize];
    
    [self.addNetworkedMinerWindow orderOut:sender];
}

- (IBAction)clearNetworkedMinerApply:(id)sender
{
    

    [self.minerAddressesArray removeAllObjects];
    

}



// when first launched, this routine is called when all objects are created
// and initialized.  It's a chance for us to set things up before the user gets
// control of the UI.
-(void)awakeFromNib
{
    
    
    
    findRunning=NO;

    findTwoRunning=NO;
    asicTask=nil;
    apiTask=nil;
    

    
    // getting an NSString
    NSString *asicOptionsString = [self.prefs stringForKey:@"asicOptionsValue"];
    

    if (asicOptionsString != nil) {
        [self.asicOptionsView setStringValue:asicOptionsString];
    }
    
    if ([[self.prefs objectForKey:@"startAsic"] isEqualToString:@"start"]) {
        
                        [self.asicWindow orderFront:nil];
        
        
        [self.asicStartButton setTitle:@"Stop"];
        self.asicStartButton.tag = 0;
        //            self.asicAPIOutput.string = @"";
        //            [self.asicAPIOutput delete:nil];
        
        
        
        // If the task is still sitting around from the last run, release it
        if (asicTask!=nil) {
            asicTask = nil;
        }
        
        
        NSString *executableName = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleExecutable"];
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, YES);
        NSString *userpath = [paths objectAtIndex:0];
        userpath = [userpath stringByAppendingPathComponent:executableName];    // The file will go in this directory
        
        
        
        
        self.noGPU = [self.prefs stringForKey:@"disableASICGPU"];
        self.debugOutputOn = [self.prefs stringForKey:@"debugASICOutput"];
        self.quietOutputOn = [self.prefs stringForKey:@"quietASICOutput"];
        self.bonusOptions = [self.prefs stringForKey:@"asicOptionsValue"];
        NSString *cpuThreads = [self.prefs stringForKey:@"cpuASICThreads"];
        
        
        
        NSMutableArray *launchArray = [NSMutableArray arrayWithObjects: @"-T", @"--api-listen", @"--api-allow", @"R:0/0", nil];
        if ([self.bonusOptions isNotEqualTo:@""]) {
            NSArray *deviceItems = [self.bonusOptions componentsSeparatedByString:@" "];
            
            [launchArray addObjectsFromArray:deviceItems];
        }
        
        if ([cpuThreads isNotEqualTo:nil]) {
            [launchArray addObject:@"-t"];
            [launchArray addObject:cpuThreads];
        }
        else {
            [launchArray addObject:@"-t"];
            [launchArray addObject:@"0"];
        }
        
        if ([self.debugOutputOn isNotEqualTo:nil]) {
            [launchArray addObject:self.debugOutputOn];
        }
        if ([self.quietOutputOn isNotEqualTo:nil]) {
            [launchArray addObject:self.quietOutputOn];
        }
        
        if (self.bigpicEnable.state == NSOnState) {
            [launchArray addObject:@"-S"];
            [launchArray addObject:@"bigpic:all"];
        }
        if (self.antminerEnable.state == NSOnState) {
            [launchArray addObject:@"-S"];
            [launchArray addObject:@"antminer:all"];
        }
        if (self.bflEnable.state == NSOnState) {
            [launchArray addObject:@"-S"];
            [launchArray addObject:@"bfl:all"];
        }
        if (self.bitfuryEnable.state == NSOnState) {
            [launchArray addObject:@"-S"];
            [launchArray addObject:@"bifury:all"];
        }
        if (self.erupterEnable.state == NSOnState) {
            [launchArray addObject:@"-S"];
            [launchArray addObject:@"erupter:all"];
        }

        NSString *saveLogFile = [self.prefs stringForKey:@"saveLogFile"];
        if ([saveLogFile  isEqual: @"save"]) {
            [launchArray addObject:@"--debuglog"];
            [launchArray addObject:@"-L"];
            
            NSDateFormatter *DateFormatter=[[NSDateFormatter alloc] init];
            [DateFormatter setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
            NSString *dateString = [NSString stringWithFormat:@"%@",[DateFormatter stringFromDate:[NSDate date]]];
            
            NSString *saveBTCConfigFilePath = [userpath stringByAppendingPathComponent:@"bfgurls.conf"];
            NSString *btcConfig = [NSString stringWithContentsOfFile : saveBTCConfigFilePath encoding:NSUTF8StringEncoding error:nil];
            NSString *acceptString = [self getDataBetweenFromString:btcConfig
                                                         leftString:@"user" rightString:@"," leftOffset:9];
            NSString *bfgUserValue = [acceptString stringByReplacingOccurrencesOfString:@"\"" withString:@""];
            acceptString = nil;
            
            
            NSString *logFile = [userpath stringByAppendingString:[@"/" stringByAppendingString:[bfgUserValue stringByAppendingString:[dateString stringByAppendingString:@".txt"]]]];
            
            [launchArray addObject:logFile];

        }
        
        
        
        if ([self.noGPU isNotEqualTo:nil]) {
            [launchArray addObject:@"-S"];
            [launchArray addObject:@"opencl:auto"];
        }
        
        cpuThreads = nil;
        

        NSString *saveBTCConfigFilePath = [userpath stringByAppendingPathComponent:@"bfgurls.conf"];
        
        [launchArray addObject:@"-c"];
        [launchArray addObject:saveBTCConfigFilePath];
        
        
        
        NSString *bundlePath2 = [[NSBundle mainBundle] resourcePath];
        
        NSString *bfgPath = [bundlePath2 stringByAppendingString:@"/bfgminer/bin/bfgminer"];
        
        [self.asicOutputView setString:@""];
        
        asicTask =[[TaskWrapper alloc] initWithCommandPath:bfgPath
                                                 arguments:launchArray
                                               environment:nil
                                                  delegate:self];
        // kick off the process asynchronously
        
        [asicTask startTask];
        
        
    }


}

- (IBAction)asicMinerToggle:(id)sender {
    
    if ([self.asicWindow isVisible]) {
        [self.asicWindow orderOut:sender];
    }
    else
    {
        [self.asicWindow orderFront:sender];
    }
}


- (IBAction)optionsToggle:(id)sender {
    
        if ([self.asicOptionsWindow isVisible]) {
            [self.asicOptionsButton setState:NSOffState];
            [self.asicOptionsWindow orderOut:sender];
        }
        else
        {
            [self.asicOptionsButton setState:NSOnState];
            [self.asicOptionsWindow orderFront:sender];
            
            
            [self.prefs synchronize];
            
            
            NSString *noGPU = [self.prefs stringForKey:@"disableASICGPU"];
            NSString *debugOutputOn = [self.prefs stringForKey:@"debugASICOutput"];
            NSString *quietOutputOn = [self.prefs stringForKey:@"quietASICOutput"];
            NSString *bonusOptions = [self.prefs stringForKey:@"asicOptionsValue"];
            NSString *cpuThreads = [self.prefs stringForKey:@"cpuASICThreads"];
            
            NSString *bflEnable = [self.prefs stringForKey:@"bflEnable"];
            NSString *bigpicEnable = [self.prefs stringForKey:@"bigpicEnable"];
            NSString *bitfuryEnable = [self.prefs stringForKey:@"bitfuryEnable"];
            NSString *erupterEnable = [self.prefs stringForKey:@"erupterEnable"];
            NSString *antminerEnable = [self.prefs stringForKey:@"antminerEnable"];

            NSString *saveLogFile = [self.prefs stringForKey:@"saveLogFile"];

            if ([saveLogFile isNotEqualTo:nil]) {
                self.saveLogFile.state = NSOnState;
            }
            
            if ([bflEnable isNotEqualTo:nil]) {
                self.bflEnable.state = NSOffState;
            }
            if ([bigpicEnable isNotEqualTo:nil]) {
                self.bigpicEnable.state = NSOffState;
            }
            if ([bitfuryEnable isNotEqualTo:nil]) {
                self.bitfuryEnable.state = NSOffState;
            }
            if ([erupterEnable isNotEqualTo:nil]) {
                self.erupterEnable.state = NSOffState;
            }
            if ([antminerEnable isNotEqualTo:nil]) {
                self.antminerEnable.state = NSOffState;
            }
            
            if ([noGPU isNotEqualTo:nil]) {
                self.asicNoGpuButton.state = NSOnState;
            }

            if ([debugOutputOn isNotEqualTo:nil]) {
                self.asicDebugButton.state = NSOnState;
            }
            else {
                self.asicDebugButton.state = NSOffState;
            }
            if ([quietOutputOn isNotEqualTo:nil]) {
                self.asicQuietButton.state = NSOnState;
            }
            
            if ([bonusOptions isNotEqualTo:nil]) {
                self.asicOptionsView.stringValue = bonusOptions;
            }
            
            if ([cpuThreads isNotEqualTo:nil]) {
                self.asicThreadsField.stringValue = cpuThreads;
            }

            noGPU = nil;
            debugOutputOn = nil;
            quietOutputOn = nil;
            bonusOptions = nil;
            cpuThreads = nil;
            
            bflEnable = nil;
            bigpicEnable = nil;
            bitfuryEnable = nil;
            erupterEnable = nil;
            antminerEnable = nil;

            
        }
        
        
        
    }


    
- (IBAction)optionsApply:(id)sender {
    

        
        if (self.asicNoGpuButton.state == NSOffState) {
            [self.prefs setObject:nil forKey:@"disableASICGPU"];
        }
        else {
            [self.prefs setObject:@"-S opencl:auto" forKey:@"disableASICGPU"];
        }

        if (self.asicDebugButton.state == NSOnState) {
            [self.prefs setObject:@"-D" forKey:@"debugASICOutput"];
        }
        else {
            [self.prefs setObject:nil forKey:@"debugASICOutput"];
        }
        if (self.asicQuietButton.state == NSOnState) {
            [self.prefs setObject:@"-q" forKey:@"quietASICOutput"];
        }
        else {
            [self.prefs setObject:nil forKey:@"quietASICOutput"];
        }
    
    
    if (self.bflEnable.state == NSOnState) {
        [self.prefs setObject:nil forKey:@"bflEnable"];
    }
    else {
        [self.prefs setObject:@"disable" forKey:@"bflEnable"];
    }
    if (self.bigpicEnable.state == NSOnState) {
        [self.prefs setObject:nil forKey:@"bigpicEnable"];
    }
    else {
        [self.prefs setObject:@"disable" forKey:@"bigpicEnable"];
    }
    if (self.bitfuryEnable.state == NSOnState) {
        [self.prefs setObject:nil forKey:@"bitfuryEnable"];
    }
    else {
        [self.prefs setObject:@"disable" forKey:@"bitfuryEnable"];
    }
    if (self.erupterEnable.state == NSOnState) {
        [self.prefs setObject:nil forKey:@"erupterEnable"];
    }
    else {
        [self.prefs setObject:@"disable" forKey:@"erupterEnable"];
    }
    if (self.antminerEnable.state == NSOnState) {
        [self.prefs setObject:nil forKey:@"antminerEnable"];
    }
    else {
        [self.prefs setObject:@"disable" forKey:@"antminerEnable"];
    }
    if (self.saveLogFile.state == NSOnState) {
        [self.prefs setObject:@"save" forKey:@"saveLogFile"];
    }
    else {
        [self.prefs setObject:nil forKey:@"saveLogFile"];
    }

    
    
        [self.prefs setObject:self.asicOptionsView.stringValue forKey:@"asicOptionsValue"];
    
    if (self.asicThreadsField.stringValue.length >= 1) {
    [self.prefs setObject:self.asicThreadsField forKey:@"cpuASICThreads"];
    }

    
        [self.prefs synchronize];
        
        [self.asicOptionsButton setState:NSOffState];
        [self.asicOptionsWindow orderOut:sender];
    
        
}

- (IBAction)showLogFiles:(id)sender {

    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, YES);
    NSString *applicationSupportDirectory = [paths firstObject];
    applicationSupportDirectory = [applicationSupportDirectory stringByAppendingString:@"/MacMiner"];
    
NSURL* urlToDirectory = [NSURL fileURLWithPath:applicationSupportDirectory isDirectory:YES];

NSArray *fileURL = [NSArray arrayWithObjects:urlToDirectory, nil];
[[NSWorkspace sharedWorkspace] activateFileViewerSelectingURLs:fileURL];
    
    
}



@end
