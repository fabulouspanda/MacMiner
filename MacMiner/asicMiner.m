//
//  asicminerViewController.m
//  MacMiner
//
//  Created by Administrator on 01/05/2013.
//  Copyright (c) 2013 fabulouspanda. All rights reserved.
//

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

  
        
    }
    
    
    
    return self;
}
/*
 - (void)alertDidEnd:(NSAlert *)pipAlert returnCode:(NSInteger)returnCode contextInfo:(void *)contextInfo {
 if (returnCode == NSAlertFirstButtonReturn) {
 NSLog(@"install pip");
 }
 if (returnCode == NSAlertSecondButtonReturn) {
 NSLog(@"quit");
 }
 }
 */



-(void)stopAsicMiner
{
    // change the button's title back for the next search
    [self.asicStartButton setTitle:@"Start"];
    [self stopToggling];
    // This stops the task and calls our callback (-processFinished)
    [asicTask stopTask];
    findRunning=NO;
    
    // Release the memory for this wrapper object
    
    asicTask=nil;
    
    AppDelegate *appDelegate = (AppDelegate *)[[NSApplication sharedApplication] delegate];
    
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
        [self stopToggling];
        // This stops the task and calls our callback (-processFinished)
        [asicTask stopTask];
        findRunning=NO;
        
        // Release the memory for this wrapper object
        
        asicTask=nil;
        
                                    self.apiDataArray = nil;
        
        AppDelegate *appDelegate = (AppDelegate *)[[NSApplication sharedApplication] delegate];

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
        
                                    self.apiDataArray = [[NSMutableArray alloc] init];
        
        // If the task is still sitting around from the last run, release it
        if (asicTask!=nil) {
            asicTask = nil;
        }


        
        self.prefs = [NSUserDefaults standardUserDefaults];
        
        [self.prefs synchronize];
        
        //        NSString *mainPool = [prefs stringForKey:@"defaultPoolValue"];
        //        NSString *mainBTCUser = [prefs stringForKey:@"defaultBTCUser"];
        //        NSString *mainBTCPass = [prefs stringForKey:@"defaultBTCPass"];

        self.noGPU = [self.prefs stringForKey:@"disableASICGPU"];
        self.debugOutputOn = [self.prefs stringForKey:@"debugASICOutput"];
        self.quietOutputOn = [self.prefs stringForKey:@"quietASICOutput"];
        self.bonusOptions = [self.prefs stringForKey:@"asicOptionsValue"];
        NSString *cpuThreads = [self.prefs stringForKey:@"cpuASICThreads"];

        //        NSString *autoWasSetup = [prefs stringForKey:@"defaultBTC"];
        /*
         if ([mainBTCUser isNotEqualTo:nil]) {
         mainPool = [oString stringByAppendingString:mainPool];
         mainBTCUser = [uString stringByAppendingString:mainBTCUser];
         mainBTCPass = [pString stringByAppendingString:mainBTCPass];
         [launchArray addObject:mainPool];
         [launchArray addObject:mainBTCUser];
         [launchArray addObject:mainBTCPass];
         }
         else if ([autoWasSetup isEqualTo:nil] && [mainBTCUser isEqualTo:nil]) {
         
         [launchArray addObject:poolString];
         [launchArray addObject:userString];
         [launchArray addObject:passString];
         
         }
         */
        
        NSMutableArray *launchArray = [NSMutableArray arrayWithObjects: @"-T", @"--api-listen", @"--api-allow", @"W:0/0", nil];
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

        if ([self.noGPU isNotEqualTo:nil]) {
            [launchArray addObject:@"-S"];
                        [launchArray addObject:@"opencl:auto"];
        }

        if ([self.debugOutputOn isNotEqualTo:nil]) {
            [launchArray addObject:self.debugOutputOn];
        }
        if ([self.quietOutputOn isNotEqualTo:nil]) {
            [launchArray addObject:self.quietOutputOn];
        }
            cpuThreads = nil;
        
        NSString *executableName = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleExecutable"];
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, YES);
        NSString *userpath = [paths objectAtIndex:0];
        userpath = [userpath stringByAppendingPathComponent:executableName];    // The file will go in this directory
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

    toggleTimer = [NSTimer scheduledTimerWithTimeInterval:5. target:self selector:@selector(startToggling) userInfo:nil repeats:NO];
//            [self startToggling];
    
}

- (void)toggleTimerFired:(NSTimer*)timer
{
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    
    [prefs synchronize];
    
    NSString *speechSetting = [prefs objectForKey:@"enableSpeech"];
    if ([speechSetting  isEqual: @"silence"]) {
        
    }
    
    else if ([self.megaHashLabel.stringValue isEqual: @"0"] && self.megaHashLabel.tag == 1) {
        _speechSynth = [[NSSpeechSynthesizer alloc] initWithVoice:nil];
        [self.speechSynth startSpeakingString:@"Mining Stopped"];
    }
    speechSetting = nil;
    prefs = nil;
    
    if ([self.megaHashLabel.stringValue isNotEqualTo:@"0"]) {
        self.megaHashLabel.tag = 1;
    }

    
    if (findTwoRunning == YES) {
        [apiTask stopTask];
        findTwoRunning = NO;
    }
    
    if (findTwoRunning == NO) {
        
    
    NSMutableArray *apiArray = [NSMutableArray arrayWithObjects: @"devs", nil];

    
    
    NSString *executableName = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleExecutable"];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, YES);
    NSString *userpath = [paths objectAtIndex:0];
    userpath = [userpath stringByAppendingPathComponent:executableName];    // The file will go in this directory


    NSString *bundlePath2 = [[NSBundle mainBundle] resourcePath];
    
    NSString *apiPath = [bundlePath2 stringByAppendingString:@"/apiaccess"];

    
    apiTask =[[taskTwoWrapper alloc] initWithCommandPath:apiPath
                                             arguments:apiArray
                                           environment:nil
                                              delegate:self];
    // kick off the process asynchronously
    
    [apiTask startTask];
        

        apiArray = nil;
        paths = nil;
        userpath = nil;
        executableName = nil;
        bundlePath2 = nil;
        apiPath = nil;
        
    }
    
    if (findThreeRunning == YES) {
        [apiNetworkTask stopTask];
        findThreeRunning = NO;
    }
    
        if (findThreeRunning == NO) {

            NSString *executableName = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleExecutable"];
            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, YES);
            NSString *userpath = [paths objectAtIndex:0];
            userpath = [userpath stringByAppendingPathComponent:executableName];    // The file will go in this directory
            
            
            //    [apiArray addObject:@"-c"];
            //    [apiArray addObject:saveBTCConfigFilePath];
            
            
            NSString *bundlePath2 = [[NSBundle mainBundle] resourcePath];
            
            NSString *apiPath = [bundlePath2 stringByAppendingString:@"/apiaccess"];

            
            self.prefs = [NSUserDefaults standardUserDefaults];
            
            [self.prefs synchronize];
            
            NSString *networkedMiners = [self.prefs stringForKey:@"ipAddress"];
            NSString *portString = [self.prefs stringForKey:@"portNumber"];
            if (networkedMiners.length >= 7) {
                NSMutableArray *apiIPArray = [NSMutableArray arrayWithObjects: @"devs", networkedMiners, portString, nil];
                
                apiNetworkTask =[[taskThreeWrapper alloc] initWithCommandPath:apiPath
                                                                    arguments:apiIPArray
                                                                  environment:nil
                                                                     delegate:self];
                
                [apiNetworkTask startTask];
                networkedMiners = nil;
                portString = nil;
                
                apiPath = nil;
                apiIPArray = nil;
                
                paths = nil;
                userpath = nil;
                executableName = nil;
                bundlePath2 = nil;

                // Needs addition of wait for task to end and run again
        }
        }
}

- (void)taskThreeWrapper:(taskThreeWrapper *)taskThreeWrapper didProduceOutput:(NSString *)output
{

    if (output.length >= 1) {
         self.networkMinerData.string = output;
    }
 
    output = nil;
 
}

- (void)taskThreeWrapperWillStartTask:(taskThreeWrapper *)taskThreeWrapper
{
    //    AppDelegate *appDelegate = (AppDelegate *)[[NSApplication sharedApplication] delegate];
    findThreeRunning=YES;

    // clear the results
    //    [self.outputView setString:@""];
    // change the "Start" button to say "Stop"
    //    [asicStartButton setTitle:@"Stop"];
}

// A callback that gets called when a TaskWrapper is completed, allowing us to do any cleanup
// that is needed from the app side.  This method is implemented as a part of conforming
// to the ProcessController protocol.
- (void)taskThreeWrapper:(taskThreeWrapper *)taskThreeWrapper didFinishTaskWithStatus:(int)terminationStatus
{
    findThreeRunning=NO;
    
    
    
}

- (void)taskTwoWrapper:(taskTwoWrapper *)taskTwoWrapper didProduceOutput:(NSString *)output
{
    
    if (output.length >= 1) {
        
    
    
    if (self.networkMinerData.string.length >= 7) {
         output = [output stringByAppendingString:self.networkMinerData.string];
    }
    

    self.asicAPIOutput.string = output;
    

    
    NSRange range = NSMakeRange(0, [[self.apiTableViewController arrangedObjects] count]);
    [self.apiTableViewController removeObjectsAtArrangedObjectIndexes:[NSIndexSet indexSetWithIndexesInRange:range]];
    
    if ([output rangeOfString:@"GPU0"].location != NSNotFound) {
        
        
        
        int strCount = [output length] - [[output stringByReplacingOccurrencesOfString:@"GPU[0-9]+" withString:@""] length];
        strCount /= [@"GPU[0-9]+" length];
        
        
        strCount += 1;
        for (int i = 0; i < strCount; i++) {
            
            
            NSString *pgaCount = [NSString stringWithFormat:@"GPU%d", i];
            NSString *pgaAPIData = [self getDataBetweenFromString:output leftString:pgaCount rightString:@")" leftOffset:0];
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
            
            
            
            [self.apiTableViewController addObject:[NSDictionary dictionaryWithObjectsAndKeys:pgaCount,@"name",apiStatus,@"status",mhs5S,@"uid",mhsAv,@"average",apiAccepted,@"accepted",apiRejected,@"rejected",apiHWError,@"error",@" ",@"temp",apiUtility,@"utility",apiDiff1,@"diff1",apiDiffAcc,@"diffaccepted",apiDiffRej,@"diffrejected",apiIntensity,@"intensity",nil]];
            
            
        }

        
    }
    
    if ([output rangeOfString:@"PGA0"].location != NSNotFound) {
        

        for (int i = 0; i >= 0; i++) {
            
        
            
            NSString *pgaCount = [NSString stringWithFormat:@"PGA%d", i];
            
            if ([output rangeOfString:pgaCount].location == NSNotFound) {
                break;
            }
            
            NSString *pgaAPIData = [self getDataBetweenFromString:output leftString:pgaCount rightString:@")" leftOffset:0];
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
            
            if ([pgaAPIData rangeOfString:@"Temperature"].location != NSNotFound) {
                NSString *apiTemp = [self getDataBetweenFromString:pgaAPIData leftString:@"[Temperature] => " rightString:@"[" leftOffset:16];
                
                [self.apiTableViewController addObject:[NSDictionary dictionaryWithObjectsAndKeys:pgaCount,@"name",apiStatus,@"status",mhs5S,@"uid",mhsAv,@"average",apiAccepted,@"accepted",apiRejected,@"rejected",apiHWError,@"error",apiTemp,@"temp",apiUtility,@"utility",apiDiff1,@"diff1",apiDiffAcc,@"diffaccepted",apiDiffRej,@"diffrejected",@" ",@"intensity",nil]];


                apiTemp = nil;

            }
            else {
                NSString *apiTemp = @" ";
                [self.apiTableViewController addObject:[NSDictionary dictionaryWithObjectsAndKeys:pgaCount,@"name",apiStatus,@"status",mhs5S,@"uid",mhsAv,@"average",apiAccepted,@"accepted",apiRejected,@"rejected",apiHWError,@"error",apiTemp,@"temp",apiUtility,@"utility",apiDiff1,@"diff1",apiDiffAcc,@"diffaccepted",apiDiffRej,@"diffrejected",@" ",@"intensity",nil]];
                apiTemp = nil;
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
    
    if ([output rangeOfString:@"ASC0"].location != NSNotFound) {
        

        for (int i = 0; i >= 0; i++) {
            
            
            
            NSString *pgaCount = [NSString stringWithFormat:@"ASC%d", i];
            
            if ([output rangeOfString:pgaCount].location == NSNotFound) {
                break;
            }
            
            NSString *pgaAPIData = [self getDataBetweenFromString:output leftString:pgaCount rightString:@")" leftOffset:0];
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
            
            if ([pgaAPIData rangeOfString:@"Temperature"].location != NSNotFound) {
                NSString *apiTemp = [self getDataBetweenFromString:pgaAPIData leftString:@"[Temperature] => " rightString:@"[" leftOffset:16];
                
                [self.apiTableViewController addObject:[NSDictionary dictionaryWithObjectsAndKeys:pgaCount,@"name",apiStatus,@"status",mhs5S,@"uid",mhsAv,@"average",apiAccepted,@"accepted",apiRejected,@"rejected",apiHWError,@"error",apiTemp,@"temp",apiUtility,@"utility",apiDiff1,@"diff1",apiDiffAcc,@"diffaccepted",apiDiffRej,@"diffrejected",@" ",@"intensity",nil]];
                


                apiTemp = nil;
                
            }
            else {
                NSString *apiTemp = @" ";
                [self.apiTableViewController addObject:[NSDictionary dictionaryWithObjectsAndKeys:pgaCount,@"name",apiStatus,@"status",mhs5S,@"uid",mhsAv,@"average",apiAccepted,@"accepted",apiRejected,@"rejected",apiHWError,@"error",apiTemp,@"temp",apiUtility,@"utility",apiDiff1,@"diff1",apiDiffAcc,@"diffaccepted",apiDiffRej,@"diffrejected",@" ",@"intensity",nil]];
                apiTemp = nil;
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
    [toggleTimer invalidate], toggleTimer = nil;  // you don't want dangling pointers...
    // perform any other needed house-keeping here
                            [self.asicStartButton setTitle:@"Start"];
}


- (void)startToggling
{
//    if ([asicStartButton.title isEqual: @"Start"]) {


//            [asicStartButton setTitle:@"Stop"];
//    [self stopToggling:self];
    
    toggleTimer = [NSTimer scheduledTimerWithTimeInterval:5. target:self selector:@selector(toggleTimerFired:) userInfo:nil repeats:YES];
//    }


}


// This callback is implemented as part of conforming to the ProcessController protocol.
// It will be called whenever there is output from the TaskWrapper.
- (void)taskWrapper:(TaskWrapper *)taskWrapper didProduceOutput:(NSString *)output
{
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    
    [prefs synchronize];
    
    NSString *speechSetting = [prefs objectForKey:@"enableSpeech"];
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
        
        
        self.prefs = [NSUserDefaults standardUserDefaults];
        
        [self.prefs synchronize];
        
        
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
    
    self.prefs = [NSUserDefaults standardUserDefaults];
    
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
        self.prefs = nil;
        
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
self.prefs = [NSUserDefaults standardUserDefaults];
    
//                NSString *existingString = [self.prefs stringForKey:@"ipAddress"];
    
        [self.prefs setObject:self.ipAddress.stringValue forKey:@"ipAddress"];
            [self.prefs setObject:self.portNumber.stringValue forKey:@"portNumber"];
    [self.prefs synchronize];
    
    [self.addNetworkedMinerWindow orderOut:sender];
}

- (IBAction)clearNetworkedMinerApply:(id)sender
{
    self.prefs = [NSUserDefaults standardUserDefaults];
    
    //                NSString *existingString = [self.prefs stringForKey:@"ipAddress"];
    
    [self.prefs setObject:@"" forKey:@"ipAddress"];
    [self.prefs setObject:@"" forKey:@"portNumber"];
    [self.prefs synchronize];
    

}



// when first launched, this routine is called when all objects are created
// and initialized.  It's a chance for us to set things up before the user gets
// control of the UI.
-(void)awakeFromNib
{
    findRunning=NO;
    findThreeRunning=NO;
    findTwoRunning=NO;
    asicTask=nil;
    // Lets make sure that there is something valid in the locate database; otherwise,
    // all searches will come back empty.
    /*
     if ([self ensureLocateDBExists]==NO)
     {
     // Explain to the user that they need to go update the database as root.
     // That is, if they want locate to be able to really find *any* file
     // on their hard drive (perhaps not great for security, but good for usability).
     NSRunAlertPanel(@"Error",@"Sorry, Moriarity's 'locate' database is missing or empty.  In a terminal, as root run '/usr/libexec/locate.updatedb' and try Moriarity again.", @"OK",NULL,NULL);
     [NSApp terminate:nil];
     }*/
    
    
    self.prefs = [NSUserDefaults standardUserDefaults];
    
    // getting an NSString
    NSString *asicOptionsString = [self.prefs stringForKey:@"asicOptionsValue"];
    

    if (asicOptionsString != nil) {
        [self.asicOptionsView setStringValue:asicOptionsString];
    }
    self.prefs = nil;
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
            
            self.prefs = [NSUserDefaults standardUserDefaults];
            
            [self.prefs synchronize];
            
            
            NSString *noGPU = [self.prefs stringForKey:@"disableASICGPU"];
            NSString *debugOutputOn = [self.prefs stringForKey:@"debugASICOutput"];
            NSString *quietOutputOn = [self.prefs stringForKey:@"quietASICOutput"];
            NSString *bonusOptions = [self.prefs stringForKey:@"asicOptionsValue"];
            NSString *cpuThreads = [self.prefs stringForKey:@"cpuASICThreads"];

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

            
            self.prefs = nil;
            
        }
        
        
        
    }
    
    
- (IBAction)optionsApply:(id)sender {
        
        self.prefs = [NSUserDefaults standardUserDefaults];

        
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

        
        
        [self.prefs setObject:self.asicOptionsView.stringValue forKey:@"asicOptionsValue"];
    
    if (self.asicThreadsField.stringValue.length >= 1) {
    [self.prefs setObject:self.asicThreadsField forKey:@"cpuASICThreads"];
    }

    
        [self.prefs synchronize];
        
        [self.asicOptionsButton setState:NSOffState];
        [self.asicOptionsWindow orderOut:sender];
        
        self.prefs = nil;
        
    }



@end
