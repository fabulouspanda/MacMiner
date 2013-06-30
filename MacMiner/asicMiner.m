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

@synthesize asicOutputView, asicStartButton, asicView, asicWindow, asicOptionsView, megaHashLabel, acceptLabel, rejecttLabel, tempsLabel, asicDebugButton, asicNoGpuButton, asicOptionsWindow, asicQuietButton, asicOptionsButton, asicHashField;

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


- (IBAction)start:(id)sender
{
    if (findRunning)
    {
        // change the button's title back for the next search
        [asicStartButton setTitle:@"Start"];
        [self stopToggling];
        // This stops the task and calls our callback (-processFinished)
        [asicTask stopTask];
        findRunning=NO;
        
        // Release the memory for this wrapper object
        
        asicTask=nil;

        return;
    }
    else
    {
        [asicStartButton setTitle:@"Stop"];
        // If the task is still sitting around from the last run, release it
        if (asicTask!=nil) {
            asicTask = nil;
        }


        
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        
        [prefs synchronize];
        
        //        NSString *mainPool = [prefs stringForKey:@"defaultPoolValue"];
        //        NSString *mainBTCUser = [prefs stringForKey:@"defaultBTCUser"];
        //        NSString *mainBTCPass = [prefs stringForKey:@"defaultBTCPass"];

        NSString *noGPU = [prefs stringForKey:@"disableGPU"];
        NSString *debugOutputOn = [prefs stringForKey:@"debugOutput"];
        NSString *quietOutputOn = [prefs stringForKey:@"quietOutput"];
        NSString *bonusOptions = [prefs stringForKey:@"asicOptionsValue"];

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
        if ([bonusOptions isNotEqualTo:@""]) {
            NSArray *deviceItems = [bonusOptions componentsSeparatedByString:@" "];
            [launchArray addObjectsFromArray:deviceItems];
        }
        

        if ([noGPU isNotEqualTo:nil]) {
            [launchArray addObject:noGPU];
        }

        if ([debugOutputOn isNotEqualTo:nil]) {
            [launchArray addObject:debugOutputOn];
        }
        if ([quietOutputOn isNotEqualTo:nil]) {
            [launchArray addObject:quietOutputOn];
        }

        
        NSString *executableName = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleExecutable"];
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, YES);
        NSString *userpath = [paths objectAtIndex:0];
        userpath = [userpath stringByAppendingPathComponent:executableName];    // The file will go in this directory
        NSString *saveBTCConfigFilePath = [userpath stringByAppendingPathComponent:@"bfgurls.conf"];
        
        [launchArray addObject:@"-c"];
        [launchArray addObject:saveBTCConfigFilePath];
        


        
        
//        if ([asicOptionsView.stringValue isEqual: @""]) {
//            [asicOptionsView setStringValue:@"-S /dev/cu.usbserial-FTWILFLM"];
//        }
//        NSString *optionsString = asicOptionsView.stringValue;


        NSString *asicPath = @"/Applications/MacMiner.app/Contents/Resources/bfgminer/bin/bfgminer";
        //        NSLog(poclbmPath);
        [self.asicOutputView setString:@""];

        //            self.outputView.string = [self.outputView.string stringByAppendingString:poclbmPath];
        //            self.outputView.string = [self.outputView.string stringByAppendingString:finalNecessities];
//                NSLog(optionsString);
        
        

//        asicTask=[[TaskWrapper alloc] initWithController:self arguments:launchArray];
       asicTask =[[TaskWrapper alloc] initWithCommandPath:asicPath
                                        arguments:launchArray
                                      environment:nil
                                         delegate:self];
        // kick off the process asynchronously

        [asicTask startTask];



        
        
    }
    
/*
[[NSFileManager defaultManager] removeItemAtPath: @"/Applications/MacMiner.app/Contents/Resources/startASICMining.sh" error: nil];

    NSString *oString = @"-o ";
    NSString *poolString = [oString stringByAppendingString:asicPoolView.stringValue];
    NSString *uString = @"-u ";
    NSString *userString = [uString stringByAppendingString:asicUserView.stringValue];
    NSString *pString = @"-p ";
    NSString *passString = [pString stringByAppendingString:asicPassView.stringValue];
    
    
    NSString *optionsString = asicOptionsView.stringValue;
    
    
NSArray *apiArray = [NSArray arrayWithObjects: poolString, userString, passString, optionsString, nil];


    NSString * result = [apiArray componentsJoinedByString:@" "];
    NSString *startBFGCommand = @"/Applications/MacMiner.app/Contents/Resources/asicminer/bin/bfgminer ";
    NSString *fullCommand = [startBFGCommand stringByAppendingString:result];
    NSString *plusAPI = [fullCommand stringByAppendingString:@" --api-listen --api-allow W:0/0"];
//    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:result];
//    NSString *path = [bundlePath stringByAppendingString:@"/startASICMining.sh"];
//    [data writeToFile:path options:NSDataWritingAtomic error:nil];
    [plusAPI writeToFile:@"/Applications/MacMiner.app/Contents/Resources/startASICMining.sh"
                          atomically:YES
                            encoding:NSASCIIStringEncoding
                               error:nil];
    
//    NSString *scriptPath = [[NSBundle mainBundle] pathForResource: @"/Resources/startASICMining.sh" ofType: nil];

    [NSTask launchedTaskWithLaunchPath:@"/bin/bash" arguments: [NSArray arrayWithObjects:@"/Applications/MacMiner.app/Contents/Resources/startASICMining.sh", nil]];

    if (asicRememberButton.state == NSOnState) {
        
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        
        // saving an NSString
        [prefs setObject:asicUserView.stringValue forKey:@"asicUserValue"];
        [prefs setObject:asicPassView.stringValue forKey:@"asicPassValue"];
        [prefs setObject:asicPoolView.stringValue forKey:@"asicPoolValue"];
        [prefs setObject:asicOptionsView.stringValue forKey:@"asicOptionsValue"];
        
        
        [prefs synchronize];
    }
    */
    toggleTimer = [NSTimer scheduledTimerWithTimeInterval:5. target:self selector:@selector(startToggling) userInfo:nil repeats:NO];
//            [self startToggling];
    
}

- (void)toggleTimerFired:(NSTimer*)timer
{
    /*
            NSString *bundlePath = [[NSBundle mainBundle] resourcePath];
    NSString *apiPath = [bundlePath stringByDeletingLastPathComponent];
    
    apiPath = [apiPath stringByAppendingString:@"/Resources/apiaccess"];
    //        NSLog(cpuPath);
    [self.asicOutputView setString:@""];
    //    NSString *startingText = @"Starting…";
    //    self.asicStatLabel.stringValue = startingText;
    //            self.outputView.string = [self.outputView.string stringByAppendingString:cpuPath];
    //            self.outputView.string = [self.outputView.string stringByAppendingString:finalNecessities];
//    asicTask=[[TaskWrapper alloc] initWithController:self arguments:[NSArray arrayWithObjects:apiPath, apiPath, @"devs", nil]];
    NSTask *apiReadTask = [NSTask new];
    [apiReadTask setLaunchPath:apiPath];
    [apiReadTask setArguments:[NSArray arrayWithObjects:apiPath, @"devs", nil]];
    NSFileManager *filemgr;
    filemgr = [NSFileManager defaultManager];
    NSFileHandle *apiHandle = [NSFileHandle fileHandleForWritingAtPath:@"/Applications/Macminer.app/Contents/Resources/apiscratch.txt"];
    [apiReadTask setStandardOutput:apiHandle];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(readCompleted:) name:NSFileHandleReadToEndOfFileCompletionNotification object:[outputPipe fileHandleForReading]];
//    [[outputPipe fileHandleForReading] readToEndOfFileInBackgroundAndNotify];
    [apiReadTask launch];
//    [apiReadTask launchedTaskWithLaunchPath:apiPath arguments: [NSArray arrayWithObjects:apiPath, @"devs", nil]];
    // kick off the process asynchronously
    //        [cpuTask setLaunchPath: @"/sbin/ping"];
//    [asicTask startProcess];
    [apiReadTask waitUntilExit];
    [self readAPI];
    */
    NSString *theReturnValue = nil;
    NSTask *theTask = nil;
    NSString *theTempFilePath = @"/Applications/Macminer.app/Contents/Resources/apiscratch.txt";
    char theTP[[theTempFilePath cStringLength]+1];
    [theTempFilePath getCString : theTP];
    
    int theFD = mkstemp(theTP);
    if (theFD != 0)
    {
        theTempFilePath = [NSString stringWithCString : theTP];
        NSFileHandle *theTempFile = [[NSFileHandle alloc]
                                     initWithFileDescriptor : theFD closeOnDealloc : YES];
        
        theTask = [[NSTask alloc] init];
        [theTask setLaunchPath : @"/Applications/Macminer.app/Contents/Resources/apiaccess"];
        [theTask setArguments:[NSArray arrayWithObjects:@"devs", nil]];
        [theTask setStandardOutput : theTempFile];
        [theTask launch];
        [theTask waitUntilExit];

        theReturnValue = [NSString stringWithContentsOfFile : theTempFilePath encoding:NSUTF8StringEncoding error:nil];
        
        NSString *apiOutput = @"[MHS av]";
        if ([theReturnValue rangeOfString:apiOutput].location != NSNotFound) {
            /*
            NSString *numberString = [self getDataBetweenFromString:theReturnValue
                                                         leftString:@"[MHS av] => " rightString:@"[" leftOffset:11];
            megaHashLabel.stringValue = [numberString stringByReplacingOccurrencesOfString:@" " withString:@""];
            NSString *acceptString = [self getDataBetweenFromString:theReturnValue
                                                         leftString:@"Accepted=" rightString:@"," leftOffset:0];
            acceptLabel.stringValue = [acceptString stringByReplacingOccurrencesOfString:@"=" withString:@": "];
            NSString *rejectString = [self getDataBetweenFromString:theReturnValue
                                                         leftString:@"Rejected=" rightString:@"," leftOffset:0];
            rejecttLabel.stringValue = [rejectString stringByReplacingOccurrencesOfString:@"=" withString:@": "];
            NSString *tempsString = [self getDataBetweenFromString:theReturnValue
                                                        leftString:@"[Temperature] => " rightString:@"[" leftOffset:0];
            tempsLabel.stringValue = [tempsString stringByReplacingOccurrencesOfString:@"=" withString:@": "];
            */
            
            NSString *pgaZeroTemp = nil;
            NSString *pgaOneTemp = nil;
            NSString *pgaTwoTemp = nil;
            NSString *pgaThreeTemp = nil;

            if ([theReturnValue rangeOfString:@"PGA0"].location != NSNotFound) {
            NSString *pgaZero = [self getDataBetweenFromString:theReturnValue leftString:@"PGA0" rightString:@")" leftOffset:0];
                        pgaZeroTemp = [self getDataBetweenFromString:pgaZero leftString:@"[Temperature] => " rightString:@"." leftOffset:0];
            pgaZeroTemp = [pgaZeroTemp stringByReplacingOccurrencesOfString:@"[Temperature] => " withString:@"Temperature: "];
            }
        if ([theReturnValue rangeOfString:@"PGA1"].location != NSNotFound) {
            NSString *pgaOne = [self getDataBetweenFromString:theReturnValue leftString:@"PGA1" rightString:@")" leftOffset:0];
                        pgaOneTemp = [self getDataBetweenFromString:pgaOne leftString:@"[Temperature] => " rightString:@"." leftOffset:17];
            pgaOne = nil;
        }
                    if ([theReturnValue rangeOfString:@"PGA2"].location != NSNotFound) {
            NSString *pgaTwo = [self getDataBetweenFromString:theReturnValue leftString:@"PGA2" rightString:@")" leftOffset:0];
                        pgaTwoTemp = [self getDataBetweenFromString:pgaTwo leftString:@"[Temperature] => " rightString:@"." leftOffset:17];
                        pgaTwo = nil;
                    }
                    if ([theReturnValue rangeOfString:@"PGA3"].location != NSNotFound) {
            NSString *pgaThree = [self getDataBetweenFromString:theReturnValue leftString:@"PGA3" rightString:@")" leftOffset:0];
                        pgaThreeTemp = [self getDataBetweenFromString:pgaThree leftString:@"[Temperature] => " rightString:@"." leftOffset:17];
                        pgaThree = nil;
                    }
            
            if ([pgaZeroTemp isNotEqualTo:@""] && [pgaOneTemp isNotEqualTo:@""]) {
                pgaZeroTemp = [pgaZeroTemp stringByAppendingString:@", "];
            }
            if ([pgaTwoTemp isNotEqualTo:@""] && [pgaOneTemp isNotEqualTo:@""]) {
                pgaOneTemp = [pgaOneTemp stringByAppendingString:@", "];
            }
            if ([pgaTwoTemp isNotEqualTo:@""] && [pgaThreeTemp isNotEqualTo:@""]) {
                pgaTwoTemp = [pgaTwoTemp stringByAppendingString:@", "];
            }
            

            
            NSArray *pgaTempsArray = [NSArray arrayWithObjects:pgaZeroTemp, pgaOneTemp, pgaTwoTemp, pgaThreeTemp, nil];
            
            tempsLabel.stringValue = [pgaTempsArray componentsJoinedByString:@""];
            
pgaZeroTemp = nil;
pgaOneTemp = nil;
pgaTwoTemp = nil;
pgaThreeTemp = nil;
            theReturnValue = nil;


        }
    
    // Delay execution of my block for 3s.
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 3 * NSEC_PER_SEC), dispatch_get_current_queue(), ^{
        [[NSFileManager defaultManager] removeFileAtPath : theTempFilePath
                                                 handler : nil];
    });
        

    }

}
/*
- (void)readAPI {
//    NSData *data2 = [[bNotification userInfo] objectForKey:NSFileHandleNotificationDataItem];
    // If the length of the data is zero, then the task is basically over - there is nothing
    // more to get from the handle so we may as well shut down.
    NSString *apiInfo = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource: @"apiscratch" ofType: @"txt"] usedEncoding:nil error:nil];
    if ([apiInfo length])
    {
        // Send the data on to the controller; we can't just use +stringWithUTF8String: here
        // because -[data bytes] is not necessarily a properly terminated string.
        // -initWithData:encoding: on the other hand checks -[data length]
        //        NSLog(@"controlappend");
//        NSString *apiInfo = [[NSString alloc] initWithData:data2 encoding:NSUTF8StringEncoding];
        
        NSString *apiOutput = @"[MHS av]";
        if ([apiInfo rangeOfString:apiOutput].location != NSNotFound) {
            NSString *numberString = [self getDataBetweenFromString:apiInfo
                                                         leftString:@"[MHS av] => " rightString:@"]" leftOffset:11];
            megaHashLabel.stringValue = [numberString stringByReplacingOccurrencesOfString:@" " withString:@""];
            NSString *acceptString = [self getDataBetweenFromString:apiInfo
                                                         leftString:@"Accepted=" rightString:@"," leftOffset:0];
            acceptLabel.stringValue = [acceptString stringByReplacingOccurrencesOfString:@"=" withString:@": "];
            NSString *rejectString = [self getDataBetweenFromString:apiInfo
                                                         leftString:@"Rejected=" rightString:@"," leftOffset:0];
            rejecttLabel.stringValue = [rejectString stringByReplacingOccurrencesOfString:@"=" withString:@": "];
            NSString *tempsString = [self getDataBetweenFromString:apiInfo
                                                        leftString:@"Temperature=" rightString:@",M" leftOffset:0];
            tempsLabel.stringValue = [tempsString stringByReplacingOccurrencesOfString:@"=" withString:@": "];
            
            NSLog(@"apioutput");
        }
        
        //        NSLog([[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
    } else {
        // We're finished here
//        [self stopProcess];
//        NSLog(@"finished");
    }
    
    // we need to schedule the file handle go read more data in the background again.
//    [[bNotification object] readInBackgroundAndNotify];

    

    
//    NSLog(@"Read data: %@", [[bNotification userInfo] objectForKey:NSFileHandleNotificationDataItem]);
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:NSFileHandleReadToEndOfFileCompletionNotification object:[bNotification object]];
}
*/
- (void)stopToggling
{
    [toggleTimer invalidate], toggleTimer = nil;  // you don't want dangling pointers...
    // perform any other needed house-keeping here
                            [asicStartButton setTitle:@"Start"];
}

- (IBAction)stopToggling:(id)sender
{
    [toggleTimer invalidate], toggleTimer = nil;  // you don't want dangling pointers...
    // perform any other needed house-keeping here
//    [asicStartButton setTitle:@"Start"];
    /*
    [asicTask stopProcess];
    
    NSString *bundlePath = [[NSBundle mainBundle] resourcePath];
    NSString *apiPath = [bundlePath stringByDeletingLastPathComponent];
    
    apiPath = [apiPath stringByAppendingString:@"/Resources/apiaccess"];
    //        NSLog(cpuPath);
    [self.asicOutputView setString:@""];
    //    NSString *startingText = @"Starting…";
    //    self.asicStatLabel.stringValue = startingText;
    //            self.outputView.string = [self.outputView.string stringByAppendingString:cpuPath];
    //            self.outputView.string = [self.outputView.string stringByAppendingString:finalNecessities];
    asicTask=[[TaskWrapper alloc] initWithController:self arguments:[NSArray arrayWithObjects:apiPath, apiPath, @"quit", nil]];
    // kick off the process asynchronously
    //        [cpuTask setLaunchPath: @"/sbin/ping"];
    [asicTask startProcess];
     */
}

- (void)startToggling
{
//    if ([asicStartButton.title isEqual: @"Start"]) {


//            [asicStartButton setTitle:@"Stop"];
//    [self stopToggling:self];
    
    toggleTimer = [NSTimer scheduledTimerWithTimeInterval:5. target:self selector:@selector(toggleTimerFired:) userInfo:nil repeats:YES];
//    }


}
/*

- (IBAction)runProcessAsAdministrator:(NSString*)scriptPath
                     withArguments:(NSArray *)arguments
                            output:(NSString **)output
                  errorDescription:(NSString **)errorDescription {
    scriptPath = @"/Applications/MacMiner.app/Contents/Resources/asicminer/bin/bfgminer";
    NSString *oString = @"-o";
    NSString *poolString = [oString stringByAppendingString:asicPoolView.stringValue];
    NSString *uString = @"-u";
    NSString *userString = [uString stringByAppendingString:asicUserView.stringValue];
    NSString *pString = @"-p";
    NSString *passString = [pString stringByAppendingString:asicPassView.stringValue];
    arguments = [NSArray arrayWithObjects:poolString, userString, passString, @"-S /dev/cu.usbserial-FTWILFLM", nil];
    NSString * allArgs = [arguments componentsJoinedByString:@" "];
    NSString * fullScript = [NSString stringWithFormat:@"%@ %@", scriptPath, allArgs];
    
    NSDictionary *errorInfo = [NSDictionary new];
    NSString *script =  [NSString stringWithFormat:@"do shell script \"%@\" with administrator privileges", fullScript];
    
    NSAppleScript *appleScript = [[NSAppleScript new] initWithSource:script];
    NSAppleEventDescriptor * eventResult = [appleScript executeAndReturnError:&errorInfo];
    
    // Check errorInfo
    if (! eventResult)
    {
        // Describe common errors
//        *errorDescription = nil;
        if ([errorInfo valueForKey:NSAppleScriptErrorNumber])
        {
            NSNumber * errorNumber = (NSNumber *)[errorInfo valueForKey:NSAppleScriptErrorNumber];
            if ([errorNumber intValue] == -128)
                *errorDescription = @"The administrator password is required to do this.";
        }
        
        // Set error message from provided message
//        if (*errorDescription == nil)
        else
        {
            if ([errorInfo valueForKey:NSAppleScriptErrorMessage])
                *errorDescription =  (NSString *)[errorInfo valueForKey:NSAppleScriptErrorMessage];
        }
        
//        return NO;
    }
    else
    {
        // Set output to the AppleScript's output
        *output = [eventResult stringValue];
        self.asicStatLabel.stringValue = [eventResult stringValue];
        
//        return YES;
    }
}
 */

// This callback is implemented as part of conforming to the ProcessController protocol.
// It will be called whenever there is output from the TaskWrapper.
- (void)taskWrapper:(TaskWrapper *)taskWrapper didProduceOutput:(NSString *)output
{
 
    NSString *unknownMessage = @"Unknown stratum msg";
    NSString *apiOutput = @"5s:";
    NSString *khOutput = @"kh";
    NSString *mhOutput = @"Mh";
    NSString *ghOutput = @"Gh";
    if ([output rangeOfString:apiOutput].location != NSNotFound) {
        NSString *numberString = [self getDataBetweenFromString:output
                                                     leftString:@"5s" rightString:@"a" leftOffset:3];
        megaHashLabel.stringValue = [numberString stringByReplacingOccurrencesOfString:@" " withString:@""];
        numberString = nil;
        NSString *acceptString = [self getDataBetweenFromString:output
                                                     leftString:@"A:" rightString:@"R" leftOffset:0];
        acceptLabel.stringValue = [acceptString stringByReplacingOccurrencesOfString:@"A:" withString:@"Accepted: "];
        acceptString = nil;
        NSString *rejectString = [self getDataBetweenFromString:output
                                                     leftString:@"R:" rightString:@"+" leftOffset:0];
        rejecttLabel.stringValue = [rejectString stringByReplacingOccurrencesOfString:@"R:" withString:@"Rejected: "];
        rejectString = nil;
        
        if ([output rangeOfString:khOutput].location != NSNotFound) {
            asicHashField.stringValue = @"Kh";
        }
        if ([output rangeOfString:mhOutput].location != NSNotFound) {
            asicHashField.stringValue = @"Mh";
        }
        if ([output rangeOfString:ghOutput].location != NSNotFound) {
            asicHashField.stringValue = @"Gh";
        }
        
        
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        
        [prefs synchronize];

        
        apiOutput = nil;
        numberString = nil;
        acceptString = nil;
        rejectString = nil;
        output = nil;

    }
  
//    megaHashLabel.stringValue = [NSString stringWithFormat:@"%i",[newTextMH intValue]];
    
    
/*
    NSString *asicOutput = @"5s:";
    if ([output rangeOfString:asicOutput].location != NSNotFound) {
        
        // Substring found...
        self.asicStatLabel.stringValue = output;
    }
    else {
        
        NSString *poolString = @"MH/s)] [Rej:";
        NSRange result = [output rangeOfString:poolString];
        if (result.length >0){
            output = [[output componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]] componentsJoinedByString:@" "];
            NSMutableCharacterSet *_space = [NSMutableCharacterSet characterSetWithCharactersInString:@" "];
            output = [output stringByTrimmingCharactersInSet:_space];
            output = [output stringByReplacingOccurrencesOfString:asicPoolView.stringValue withString:@""];
            self.asicStatLabel.stringValue = output;
        }
        else
 */
            //    AppDelegate *appDelegate = (AppDelegate *)[[NSApplication sharedApplication] delegate];
            // add the string (a chunk of the results from locate) to the NSTextView's
            // backing store, in the form of an attributed string

    if ([output rangeOfString:unknownMessage].location != NSNotFound) {
        output = nil;
    }
    else
        self.asicOutputView.string = [self.asicOutputView.string stringByAppendingString:output];
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    
    [prefs synchronize];
    
    NSString *logLength = [prefs objectForKey:@"logLength" ];
    if (logLength.intValue <= 1) {
        logLength = @"5000";
    }
    
    if (self.asicOutputView.string.length >= logLength.intValue) {
        [self.asicOutputView setEditable:true];
        [self.asicOutputView setSelectedRange:NSMakeRange(0,1000)];
        [self.asicOutputView delete:nil];
        [self.asicOutputView setEditable:false];
    }
    
    ghOutput = nil;
    khOutput = nil;
    mhOutput = nil;
    unknownMessage = nil;
    logLength = nil;
    prefs = nil;
    apiOutput = nil;


        /*    [[appDelegate.pingReport textStorage] appendAttributedString: [[NSAttributedString alloc]
         initWithString: output]];
         */
        
        // setup a selector to be called the next time through the event loop to scroll
        // the view to the just pasted text.  We don't want to scroll right now,
        // because of a bug in Mac OS X version 10.1 that causes scrolling in the context
        // of a text storage update to starve the app of events
        [self performSelector:@selector(scrollToVisible:) withObject:nil afterDelay:0.0];
    }


- (NSString *)getDataBetweenFromString:(NSString *)data leftString:(NSString *)leftData rightString:(NSString *)rightData leftOffset:(NSInteger)leftPos;
{
            if ([leftData isNotEqualTo:nil]) {
    NSInteger left, right;
    NSString *foundData;
    NSScanner *scanner=[NSScanner scannerWithString:data];
    [scanner scanUpToString:leftData intoString: nil];
    left = [scanner scanLocation];
    [scanner setScanLocation:left + leftPos];
    [scanner scanUpToString:rightData intoString: nil];
    right = [scanner scanLocation] + 1;
    left += leftPos;
    foundData = [data substringWithRange: NSMakeRange(left, (right - left) - 1)];

    return foundData;
                
                foundData = nil;
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
    [asicStartButton setTitle:@"Start"];
}

// If the user closes the search window, let's just quit
-(BOOL)windowShouldClose:(id)sender
{
    [asicTask stopTask];
    findRunning = NO;
    asicTask = nil;
    //    [NSApp terminate:nil];

    return YES;
    
    NSString *bundlePath = [[NSBundle mainBundle] resourcePath];
    NSString *apiPath = [bundlePath stringByDeletingLastPathComponent];
    
    apiPath = [apiPath stringByAppendingString:@"/Resources/apiaccess"];
    //        NSLog(cpuPath);
    [self.asicOutputView setString:@""];
    //    NSString *startingText = @"Starting…";
    //    self.asicStatLabel.stringValue = startingText;
    //            self.outputView.string = [self.outputView.string stringByAppendingString:cpuPath];
    //            self.outputView.string = [self.outputView.string stringByAppendingString:finalNecessities];
//    asicTask=[[TaskWrapper alloc] initWithController:self arguments:[NSArray arrayWithObjects:apiPath, apiPath, @"quit", nil]];
    NSArray *arrayForQuit = [NSArray arrayWithObject:@"quit"];
   asicTask =[[TaskWrapper alloc] initWithCommandPath:apiPath
                                    arguments:arrayForQuit
                                  environment:nil
                                     delegate:self];
    
    [asicTask startTask];
}

// Display the release notes, as chosen from the menu item in the Help menu.
- (IBAction)displayReleaseNotes:(id)sender
{
    // Grab the release notes from the Resources folder in the app bundle, and stuff
    // them into the proper text field
    //   [relNotesTextField readRTFDFromFile:[[NSBundle mainBundle] pathForResource:@"Credits" ofType:@"rtf"]];
    // [relNotesWin makeKeyAndOrderFront:self];
}

// when first launched, this routine is called when all objects are created
// and initialized.  It's a chance for us to set things up before the user gets
// control of the UI.
-(void)awakeFromNib
{
    findRunning=NO;
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
    
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    
    // getting an NSString
    NSString *asicOptionsString = [prefs stringForKey:@"asicOptionsValue"];
    

    if (asicOptionsString != nil) {
        [asicOptionsView setStringValue:asicOptionsString];
    }
}

- (IBAction)asicMinerToggle:(id)sender {
    
    if ([asicWindow isVisible]) {
        [asicWindow orderOut:sender];
    }
    else
    {
        [asicWindow orderFront:sender];
    }
}
    

- (IBAction)optionsToggle:(id)sender {
        
        if ([asicOptionsWindow isVisible]) {
            [asicOptionsButton setState:NSOffState];
            [asicOptionsWindow orderOut:sender];
        }
        else
        {
            [asicOptionsButton setState:NSOnState];
            [asicOptionsWindow orderFront:sender];
            
            NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
            
            [prefs synchronize];
            
            
            NSString *noGPU = [prefs stringForKey:@"disableGPU"];
            NSString *debugOutputOn = [prefs stringForKey:@"debugOutput"];
            NSString *quietOutputOn = [prefs stringForKey:@"quietOutput"];
            NSString *bonusOptions = [prefs stringForKey:@"asicOptionsValue"];

            if ([noGPU isNotEqualTo:nil]) {
                asicNoGpuButton.state = NSOnState;
            }

            if ([debugOutputOn isNotEqualTo:nil]) {
                asicDebugButton.state = NSOnState;
            }
            if ([quietOutputOn isNotEqualTo:nil]) {
                asicQuietButton.state = NSOnState;
            }
            
            if ([bonusOptions isNotEqualTo:nil]) {
                asicOptionsView.stringValue = bonusOptions;
            }

            noGPU = nil;
            debugOutputOn = nil;
            quietOutputOn = nil;
            bonusOptions = nil;

            
            prefs = nil;
            
        }
        
        
        
    }
    
    
- (IBAction)optionsApply:(id)sender {
        
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];

        
        if (asicNoGpuButton.state == NSOnState) {
            [prefs setObject:@"-G" forKey:@"disableGPU"];
        }
        else {
            [prefs setObject:nil forKey:@"disableGPU"];
        }

        if (asicDebugButton.state == NSOnState) {
            [prefs setObject:@"-D" forKey:@"debugOutput"];
        }
        else {
            [prefs setObject:nil forKey:@"debugOutput"];
        }
        if (asicQuietButton.state == NSOnState) {
            [prefs setObject:@"-q" forKey:@"quietOutput"];
        }
        else {
            [prefs setObject:nil forKey:@"quietOutput"];
        }

        
        
        [prefs setObject:asicOptionsView.stringValue forKey:@"asicOptionsValue"];
        
        [prefs synchronize];
        
        [asicOptionsButton setState:NSOffState];
        [asicOptionsWindow orderOut:sender];
        
        prefs = nil;
        
    }



@end
