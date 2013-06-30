//
//  bfgminerViewController.m
//  MacMiner
//
//  Created by Administrator on 01/05/2013.
//  Copyright (c) 2013 fabulouspanda. All rights reserved.
//

#import "bfgminerViewController.h"
#import "AppDelegate.h"

@implementation bfgminerViewController

@synthesize bfgOutputView, bfgRememberButton, bfgStartButton, bfgStatLabel, bfgView, bfgWindow, bfgOptionsView, speedRead, acceptRead, rejectRead, sliderValue, intenseSlider, bfgOptionsWindow, openOptions, workSlider, workSizeLabel, vectorOverride, vectorSlide, debugOutput, disableGPU, dynamicIntensity, useScrypt, quietOutput, workSizeOverride, vectorSizeLabel, intenseSizeLabel, hashRead, bfgLookupGap, bfgShaders, bfgThreadConc;


- (IBAction)sliderChanged:(id)sender {
    
    int current = lroundf([workSlider floatValue]);
    [workSizeLabel setStringValue:[workValues objectAtIndex:current]];
    
}
- (IBAction)vectorChanged:(id)sender {
    
    int current = lroundf([vectorSlide floatValue]);
    [vectorSizeLabel setStringValue:[vectorValues objectAtIndex:current]];
    
}


- (IBAction)stopBFG:(id)sender {
    // change the button's title back for the next search
    [bfgStartButton setTitle:@"Start"];
    // This stops the task and calls our callback (-processFinished)
    [bfgTask stopTask];
    searchTaskIsRunning=NO;
    
    // Release the memory for this wrapper object
    
    bfgTask=nil;
    [rejectRead setStringValue:@""];
    return;
    
    [[NSApplication sharedApplication] terminate:nil];
}

- (IBAction)start:(id)sender
{
    if (searchTaskIsRunning)
    {
        // change the button's title back for the next search
        [bfgStartButton setTitle:@"Start"];
        // This stops the task and calls our callback (-processFinished)
        [bfgTask stopTask];
        searchTaskIsRunning=NO;
        
        // Release the memory for this wrapper object
        
        bfgTask=nil;
        [rejectRead setStringValue:@""];
        

        
        return;
    }
    else
    {
        [bfgStartButton setTitle:@"Stop"];
        // If the task is still sitting around from the last run, release it
        if (bfgTask!=nil) {
            bfgTask = nil;
        }
        

        
        // Let's allocate memory for and initialize a new TaskWrapper object, passing
        // in ourselves as the controller for this TaskWrapper object, the path
        // to the command-line tool, and the contents of the text field that
        // displays what the user wants to search on
        
        NSString *bundlePath2 = [[NSBundle mainBundle] resourcePath];

        NSString *bfgPath = [bundlePath2 stringByAppendingString:@"/bfgminer/bin/bfgminer"];
        
        


            //        NSLog(poclbmPath);
            [self.bfgOutputView setString:@""];
            NSString *startingText = @"Starting…";
            self.bfgStatLabel.stringValue = startingText;
        startingText = nil;

        
        NSMutableArray *launchArray = [NSMutableArray arrayWithObjects: nil];

        
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        
        [prefs synchronize];
        
//        NSString *mainPool = [prefs stringForKey:@"defaultPoolValue"];
//        NSString *mainBTCUser = [prefs stringForKey:@"defaultBTCUser"];
//        NSString *mainBTCPass = [prefs stringForKey:@"defaultBTCPass"];
        NSString *intensityValue = [prefs stringForKey:@"intenseValue"];
        NSString *worksizeValue = [prefs stringForKey:@"worksizeValue"];
        NSString *vectorValue = [prefs stringForKey:@"vectorValue"];
        NSString *noGPU = [prefs stringForKey:@"disableGPU"];
        NSString *onScrypt = [prefs stringForKey:@"useScrypt"];
        NSString *debugOutputOn = [prefs stringForKey:@"debugOutput"];
        NSString *quietOutputOn = [prefs stringForKey:@"quietOutput"];
        NSString *bonusOptions = [prefs stringForKey:@"bfgOptionsValue"];
        NSString *threadConc = [prefs stringForKey:@"bfgThreadConc"];
        NSString *shaders = [prefs stringForKey:@"bfgShaders"];
        NSString *lookupGap = [prefs stringForKey:@"bfgLookupGap"];
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
                        
            [launchArray addObject:@"-T"];
        
        if ([intensityValue isNotEqualTo:nil]) {
            [launchArray addObject:@"-I"];
            [launchArray addObject:intensityValue];
        }
        if ([worksizeValue isNotEqualTo:nil]) {
            [launchArray addObject:@"-w"];
            [launchArray addObject:worksizeValue];
        }
        if ([vectorValue isNotEqualTo:nil]) {
            [launchArray addObject:@"-v"];
            [launchArray addObject:vectorValue];
        }
        if ([noGPU isNotEqualTo:nil]) {
            [launchArray addObject:noGPU];
        }
        if ([onScrypt isNotEqualTo:nil]) {
            [launchArray addObject:onScrypt];
        }
        if ([debugOutputOn isNotEqualTo:nil]) {
            [launchArray addObject:debugOutputOn];
        }
        if ([quietOutputOn isNotEqualTo:nil]) {
            [launchArray addObject:quietOutputOn];
        }
        if (threadConc.length >= 1) {
            [launchArray addObject:@"--thread-concurrency"];
            [launchArray addObject:threadConc];
        }
        if (shaders.length >= 1) {
            [launchArray addObject:@"--shaders"];
            [launchArray addObject:shaders];
        }
        if (lookupGap.length >= 1) {
            [launchArray addObject:@"--lookup-gap"];
            [launchArray addObject:lookupGap];
        }

        NSString *executableName = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleExecutable"];
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, YES);
        NSString *userpath = [paths objectAtIndex:0];
        userpath = [userpath stringByAppendingPathComponent:executableName];    // The file will go in this directory
        NSString *saveBTCConfigFilePath = [userpath stringByAppendingPathComponent:@"bfgurls.conf"];
        NSString *saveLTCConfigFilePath = [userpath stringByAppendingPathComponent:@"ltcurls.conf"];

            [launchArray addObject:@"-c"];
        [launchArray addObject:saveBTCConfigFilePath];

        if ([onScrypt isEqualTo:@"--scrypt"]) {
            [launchArray removeLastObject];
            [launchArray addObject:saveLTCConfigFilePath];
        }

        if ([bonusOptions isNotEqualTo:nil]) {
            NSArray *bonusStuff = [bonusOptions componentsSeparatedByString:@" "];
            if (bonusStuff.count >= 2) {
            [launchArray addObjectsFromArray:bonusStuff];
                bonusStuff = nil;
            }
        }
  
//        NSString *testString = [launchArray componentsJoinedByString:@" "];
//        NSLog(testString);
        
            bfgTask=[[TaskWrapper alloc] initWithCommandPath:bfgPath
                                                   arguments:launchArray
    environment:nil
                     delegate:self];

            // kick off the process asynchronously
            [bfgTask startTask];
        
        
        BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:saveBTCConfigFilePath];
        if (fileExists) {
            NSString *btcConfig = [NSString stringWithContentsOfFile : saveBTCConfigFilePath encoding:NSUTF8StringEncoding error:nil];
            NSString *ltcConfig = [NSString stringWithContentsOfFile : saveLTCConfigFilePath encoding:NSUTF8StringEncoding error:nil];
            

            if ([onScrypt length] <= 1) {
                NSString *numberString = [self getDataBetweenFromString:btcConfig
                                                             leftString:@"url" rightString:@"," leftOffset:8];
                NSString *bfgURLValue = [numberString stringByReplacingOccurrencesOfString:@"\"" withString:@""];
                numberString = nil;
                NSString *acceptString = [self getDataBetweenFromString:btcConfig
                                                             leftString:@"user" rightString:@"," leftOffset:9];
                NSString *bfgUserValue = [acceptString stringByReplacingOccurrencesOfString:@"\"" withString:@""];
                acceptString = nil;


                        NSAlert *startAlert = [[NSAlert alloc] init];
                        [startAlert addButtonWithTitle:@"Indeed"];
                        
                        [startAlert setMessageText:@"bfgminer has started"];
                        NSString *infoText = @"The primary pool is set to ";
                        infoText = [infoText stringByAppendingString:bfgURLValue];
                        infoText = [infoText stringByAppendingString:@" and the user is set to "];
                        infoText = [infoText stringByAppendingString:bfgUserValue];
                        [startAlert setInformativeText:infoText];

                
                        [startAlert setAlertStyle:NSWarningAlertStyle];

                        
                        [startAlert beginSheetModalForWindow:bfgWindow modalDelegate:self didEndSelector:nil contextInfo:nil];
            }
            

                    if ([onScrypt isEqualTo:@"--scrypt"]) {
                        NSString *numberString = [self getDataBetweenFromString:ltcConfig
                                                                     leftString:@"url" rightString:@"," leftOffset:8];
                        NSString *bfgURLValue = [numberString stringByReplacingOccurrencesOfString:@"\"" withString:@""];
                        numberString = nil;
                        NSString *acceptString = [self getDataBetweenFromString:ltcConfig
                                                                     leftString:@"user" rightString:@"," leftOffset:9];
                        NSString *bfgUserValue = [acceptString stringByReplacingOccurrencesOfString:@"\"" withString:@""];
                        acceptString = nil;
                        
                        
                        NSAlert *startAlert = [[NSAlert alloc] init];
                        [startAlert addButtonWithTitle:@"Indeed"];
                        
                        [startAlert setMessageText:@"bfgminer has started"];
                        NSString *infoText = @"The primary pool is set to ";
                        infoText = [infoText stringByAppendingString:bfgURLValue];
                        infoText = [infoText stringByAppendingString:@" and the user is set to "];
                        infoText = [infoText stringByAppendingString:bfgUserValue];
                        [startAlert setInformativeText:infoText];
                        

                        [startAlert setAlertStyle:NSWarningAlertStyle];

                        
                        [startAlert beginSheetModalForWindow:bfgWindow modalDelegate:self didEndSelector:nil contextInfo:nil];
                
            }
            
            
        }

        
        
        

        
        launchArray = nil;

        intensityValue = nil;
        worksizeValue = nil;
        vectorValue = nil;
        noGPU = nil;
        onScrypt = nil;
        debugOutputOn = nil;
        quietOutputOn = nil;
bonusOptions = nil;
        prefs = nil;
        bfgPath = nil;


        
    }
    
}

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
        speedRead.stringValue = [numberString stringByReplacingOccurrencesOfString:@" " withString:@""];
        numberString = nil;
        NSString *acceptString = [self getDataBetweenFromString:output
                                                     leftString:@"A:" rightString:@"R" leftOffset:0];
        acceptRead.stringValue = [acceptString stringByReplacingOccurrencesOfString:@"A:" withString:@"Accepted: "];
        acceptString = nil;
        NSString *rejectString = [self getDataBetweenFromString:output
                                                     leftString:@"R:" rightString:@"+" leftOffset:0];
        rejectRead.stringValue = [rejectString stringByReplacingOccurrencesOfString:@"R:" withString:@"Rejected: "];
        rejectString = nil;
        
            if ([output rangeOfString:khOutput].location != NSNotFound) {
             hashRead.stringValue = @"Kh";
            }
        if ([output rangeOfString:mhOutput].location != NSNotFound) {
            hashRead.stringValue = @"Mh";
        }
        if ([output rangeOfString:ghOutput].location != NSNotFound) {
            hashRead.stringValue = @"Gh";
        }

        
    }

//    else
            //    AppDelegate *appDelegate = (AppDelegate *)[[NSApplication sharedApplication] delegate];
            // add the string (a chunk of the results from locate) to the NSTextView's
            // backing store, in the form of an attributed string
        
        
    if ([output rangeOfString:unknownMessage].location != NSNotFound) {
        output = nil;
    }
    else
            self.bfgOutputView.string = [self.bfgOutputView.string stringByAppendingString:output];
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    
    [prefs synchronize];
    
   NSString *logLength = [prefs objectForKey:@"logLength" ];
    if (logLength.intValue <= 1) {
        logLength = @"5000";
    }
    
    if (self.bfgOutputView.string.length >= logLength.intValue) {
        [self.bfgOutputView setEditable:true];
        [self.bfgOutputView setSelectedRange:NSMakeRange(0,1000)];
        [self.bfgOutputView delete:nil];
        [self.bfgOutputView setEditable:false];
    }

        
        // setup a selector to be called the next time through the event loop to scroll
        // the view to the just pasted text.  We don't want to scroll right now,
        // because of a bug in Mac OS X version 10.1 that causes scrolling in the context
        // of a text storage update to starve the app of events
    
                if ([[prefs objectForKey:@"scrollLog"] isNotEqualTo:@"hide"]) {
        [self performSelector:@selector(scrollToVisible:) withObject:nil afterDelay:0.0];
                }
    apiOutput = nil;
    khOutput = nil;
    mhOutput = nil;
    ghOutput = nil;
    output = nil;
    prefs = nil;
    logLength = nil;
    unknownMessage = nil;

    }


- (NSString *)getDataBetweenFromString:(NSString *)data leftString:(NSString *)leftData rightString:(NSString *)rightData leftOffset:(NSInteger)leftPos;
{
    NSInteger left, right;
    NSString *foundData;
    NSScanner *scanner=[NSScanner scannerWithString:data];
    [scanner scanUpToString:leftData intoString: nil];
    left = [scanner scanLocation];
    [scanner setScanLocation:left + leftPos];
    [scanner scanUpToString:rightData intoString: nil];
    right = [scanner scanLocation] + 1;
    left += leftPos;
    foundData = [data substringWithRange: NSMakeRange(left, (right - left) - 1)];         return foundData;
    foundData = nil;
    scanner = nil;
    leftData = nil;
    rightData = nil;
    data = nil;

}


// This routine is called after adding new results to the text view's backing store.
// We now need to scroll the NSScrollView in which the NSTextView sits to the part
// that we just added at the end
- (void)scrollToVisible:(id)ignore {
    //   AppDelegate *appDelegate = (AppDelegate *)[[NSApplication sharedApplication] delegate];
    [self.bfgOutputView scrollRangeToVisible:NSMakeRange([[self.bfgOutputView string] length], 0)];
}

// A callback that gets called when a TaskWrapper is launched, allowing us to do any setup
// that is needed from the app side.  This method is implemented as a part of conforming
// to the ProcessController protocol.
- (void)taskWrapperWillStartTask:(TaskWrapper *)taskWrapper
{
    //    AppDelegate *appDelegate = (AppDelegate *)[[NSApplication sharedApplication] delegate];
    searchTaskIsRunning=YES;
    // clear the results
    //    [self.outputView setString:@""];
    // change the "Start" button to say "Stop"
    [bfgStartButton setTitle:@"Stop"];
}

// A callback that gets called when a TaskWrapper is completed, allowing us to do any cleanup
// that is needed from the app side.  This method is implemented as a part of conforming
// to the ProcessController protocol.
- (void)taskWrapper:(TaskWrapper *)taskWrapper didFinishTaskWithStatus:(int)terminationStatus
{
    searchTaskIsRunning=NO;
    // change the button's title back for the next search
    [bfgStartButton setTitle:@"Start"];
}

// If the user closes the search window, let's just quit
-(BOOL)windowShouldClose:(id)sender
{
    [bfgTask stopTask];
    searchTaskIsRunning = NO;
    bfgTask = nil;
    //    [NSApp terminate:nil];
    [bfgStatLabel setStringValue:@""];
    return YES;
}

// when first launched, this routine is called when all objects are created
// and initialized.  It's a chance for us to set things up before the user gets
// control of the UI.
-(void)viewDidLoad
{
    
    
    searchTaskIsRunning=NO;
    bfgTask=nil;

    
    
    workValues = [[NSArray alloc] initWithObjects:@"64",@"128",@"256",@"512",@"1024",nil];
    
    [workSlider setNumberOfTickMarks:[workValues count]];
    [workSlider setMinValue:0];
    [workSlider setMaxValue:[workValues count]-1];
    [workSlider setAllowsTickMarkValuesOnly:YES];
    [workSlider setEnabled:YES];
    [workSlider setContinuous:YES];
    
    [workSizeLabel setStringValue:[workValues objectAtIndex:0]];
    [workSlider setIntValue:0];
    
    vectorValues = [[NSArray alloc] initWithObjects:@"1",@"2",@"4",nil];
    
    [vectorSlide setNumberOfTickMarks:[vectorValues count]];
    [vectorSlide setMinValue:0];
    [vectorSlide setMaxValue:[vectorValues count]-1];
    [vectorSlide setAllowsTickMarkValuesOnly:YES];
    [vectorSlide setEnabled:YES];
    [vectorSlide setContinuous:YES];
    
    [vectorSizeLabel setStringValue:[vectorValues objectAtIndex:0]];
    [vectorSlide setIntValue:0];
    
    
    
}

- (IBAction)bfgMinerToggle:(id)sender {
    
    if ([bfgWindow isVisible]) {
        [bfgWindow orderOut:sender];
    }
    else
    {
        [bfgWindow orderFront:sender];
    }
}

- (void)bfgMinerToggled:(id)sender {
    
    if ([bfgWindow isVisible]) {
        [bfgWindow orderOut:sender];
    }
    else
    {
        [bfgWindow orderFront:sender];
    }
}

- (IBAction)optionsToggle:(id)sender {
    
    if ([bfgOptionsWindow isVisible]) {
                [openOptions setState:NSOffState];
        [bfgOptionsWindow orderOut:sender];
    }
    else
    {
        [openOptions setState:NSOnState];
        [bfgOptionsWindow orderFront:sender];
        
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        
        [prefs synchronize];
        

        NSString *intensityValue = [prefs stringForKey:@"intenseValue"];
        NSString *worksizeValue = [prefs stringForKey:@"worksizeValue"];
        NSString *vectorValue = [prefs stringForKey:@"vectorValue"];
        NSString *noGPU = [prefs stringForKey:@"disableGPU"];
        NSString *onScrypt = [prefs stringForKey:@"useScrypt"];
        NSString *debugOutputOn = [prefs stringForKey:@"debugOutput"];
        NSString *quietOutputOn = [prefs stringForKey:@"quietOutput"];
        NSString *bonusOptions = [prefs stringForKey:@"bfgOptionsValue"];
        NSString *threadConc = [prefs stringForKey:@"bfgThreadConc"];
        NSString *shaders = [prefs stringForKey:@"bfgShaders"];
        NSString *lookupGap = [prefs stringForKey:@"bfgLookupGap"];

        
        if ([intensityValue isNotEqualTo:nil]) {
            intenseSizeLabel.stringValue = intensityValue;
            dynamicIntensity.state = NSOffState;
        }
        if ([worksizeValue isNotEqualTo:nil]) {
            workSizeLabel.stringValue = worksizeValue;
            workSizeOverride.state = NSOnState;
        }
        if ([vectorValue isNotEqualTo:nil]) {
            vectorSizeLabel.stringValue = vectorValue;
            vectorOverride.state = NSOnState;
        }
        if ([noGPU isNotEqualTo:nil]) {
            disableGPU.state = NSOnState;
        }
        if ([onScrypt isNotEqualTo:nil]) {
            useScrypt.state = NSOnState;
        }
        if ([debugOutputOn isNotEqualTo:nil]) {
            debugOutput.state = NSOnState;
        }
        if ([quietOutputOn isNotEqualTo:nil]) {
            quietOutput.state = NSOnState;
        }
        
        if ([bonusOptions isNotEqualTo:nil]) {
            bfgOptionsView.stringValue = bonusOptions;
            }
        if (threadConc.length >= 1) {
            bfgThreadConc.stringValue = threadConc;
        }
        if (shaders.length >= 1) {
            bfgShaders.stringValue = shaders;
        }
        if (lookupGap.length >= 1) {
            bfgLookupGap.stringValue = lookupGap;
        }
        
        intensityValue = nil;
        worksizeValue = nil;
        vectorValue = nil;
        noGPU = nil;
        onScrypt = nil;
        debugOutputOn = nil;
        quietOutputOn = nil;
        bonusOptions = nil;
        threadConc = nil;
        shaders = nil;
        lookupGap = nil;
        
        prefs = nil;
        
        }


    
    }


- (IBAction)optionsApply:(id)sender {
    
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    if (dynamicIntensity.state == NSOffState) {
            [prefs setObject:intenseSizeLabel.stringValue forKey:@"intenseValue"];
    }
    else {
        [prefs setObject:nil forKey:@"intenseValue"];
    }
    if (workSizeOverride.state == NSOnState) {
    [prefs setObject:workSizeLabel.stringValue forKey:@"worksizeValue"];
    }
    else    {
        [prefs setObject:nil forKey:@"worksizeValue"];
    }
    if (vectorOverride.state == NSOnState) {
    [prefs setObject:vectorSizeLabel.stringValue forKey:@"vectorValue"];
    }
    else {
        [prefs setObject:nil forKey:@"vectorValue"];
    }
    if (disableGPU.state == NSOnState) {
        [prefs setObject:@"-G" forKey:@"disableGPU"];
    }
    else {
        [prefs setObject:nil forKey:@"disableGPU"];
    }
    if (useScrypt.state == NSOnState) {
        [prefs setObject:@"--scrypt" forKey:@"useScrypt"];
    }
    else {
        [prefs setObject:nil forKey:@"useScrypt"];
    }
    if (debugOutput.state == NSOnState) {
        [prefs setObject:@"-D" forKey:@"debugOutput"];
    }
    else {
        [prefs setObject:nil forKey:@"debugOutput"];
    }
    if (quietOutput.state == NSOnState) {
        [prefs setObject:@"-q" forKey:@"quietOutput"];
    }
    else {
        [prefs setObject:nil forKey:@"quietOutput"];
    }
    if (bfgThreadConc.stringValue.length >= 1) {
        [prefs setObject:bfgThreadConc.stringValue forKey:@"bfgThreadConc"];
    }
    if (bfgShaders.stringValue.length >= 1) {
        [prefs setObject:bfgShaders.stringValue forKey:@"bfgShaders"];
    }
    if (bfgLookupGap.stringValue.length >= 1) {
        [prefs setObject:bfgLookupGap.stringValue forKey:@"bfgLookupGap"];
    }
    
    [prefs setObject:bfgOptionsView.stringValue forKey:@"bfgOptionsValue"];
    
    [prefs synchronize];

        [openOptions setState:NSOffState];
        [bfgOptionsWindow orderOut:sender];
    
    prefs = nil;

}



@end
