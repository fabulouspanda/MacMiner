//
//  bfgminerViewController.m
//  MacMiner
//
//  Created by Administrator on 01/05/2013.
//  Copyright (c) 2013 fabulouspanda. All rights reserved.
//

#import "bfgminerViewController.h"
#import "AppDelegate.h"

#include <stdlib.h>
#include <stdio.h>
#include <sys/types.h>
#include <sys/sysctl.h>

@implementation bfgminerViewController


/*
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
*/
- (IBAction)sliderChanged:(id)sender {
    
    int current = lroundf([self.workSlider floatValue]);
    [self.workSizeLabel setStringValue:[workValues objectAtIndex:current]];
    
}
- (IBAction)vectorChanged:(id)sender {
    
    int current = lroundf([self.vectorSlide floatValue]);
    [self.vectorSizeLabel setStringValue:[vectorValues objectAtIndex:current]];
    
}
/*
 - (void)alertDidEnd:(NSAlert *)startAlert returnCode:(NSInteger)returnCode contextInfo:(void *)contextInfo {
 if (returnCode == NSAlertFirstButtonReturn) {
 NSLog(@"install pip");
 }
 if (returnCode == NSAlertSecondButtonReturn) {
 NSLog(@"quit");
 }
 }
 */

- (IBAction)bfgDisplayHelp:(id)sender
{
    [[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:@"http://fabulouspanda.co.uk/macminer/docs/"]];
}

- (void)stopBFG {
    // change the button's title back for the next search
    [self.bfgStartButton setTitle:@"Start"];
    // This stops the task and calls our callback (-processFinished)
    [bfgTask stopTask];
    searchTaskIsRunning=NO;
            self.speedRead.tag = 0;

    // Release the memory for this wrapper object
    
    bfgTask=nil;
    [self.rejectRead setStringValue:@""];
    return;
    

}

- (IBAction)start:(id)sender
{
    if (searchTaskIsRunning)
    {
                self.bfgStartButton.tag = 1;
        // change the button's title back for the next search
        [self.bfgStartButton setTitle:@"Start"];
        // This stops the task and calls our callback (-processFinished)
        [bfgTask stopTask];
        searchTaskIsRunning=NO;
                self.speedRead.tag = 0;

        
        // Release the memory for this wrapper object
        
        bfgTask=nil;
        [self.rejectRead setStringValue:@""];
        
        AppDelegate *appDelegate = (AppDelegate *)[[NSApplication sharedApplication] delegate];
//        appDelegate.bfgReading.stringValue = @"";
        [appDelegate.bfgReadBack setHidden:YES];
        [appDelegate.bfgReading setHidden:YES];

        
        [[NSApp dockTile] display];
        appDelegate = nil;
        
        return;
    }
    else
    {
        [self.bfgStartButton setTitle:@"Stop"];
        // If the task is still sitting around from the last run, release it
        if (bfgTask!=nil) {
            bfgTask = nil;
        }

        
        AppDelegate *appDelegate = (AppDelegate *)[[NSApplication sharedApplication] delegate];
        appDelegate.bfgReading.stringValue = @"";
        [appDelegate.bfgReadBack setHidden:NO];
        [appDelegate.bfgReading setHidden:NO];

        
        [[NSApp dockTile] display];

        
        // Let's allocate memory for and initialize a new TaskWrapper object, passing
        // in ourselves as the controller for this TaskWrapper object, the path
        // to the command-line tool, and the contents of the text field that
        // displays what the user wants to search on
        
        //        AppDelegate *appDelegate = (AppDelegate *)[[NSApplication sharedApplication] delegate];

        
        NSString *bundlePath2 = [[NSBundle mainBundle] resourcePath];

        NSString *bfgPath = [bundlePath2 stringByAppendingString:@"/bfgminer/bin/bfgminer"];
        
        

            [self.bfgOutputView setString:@""];
            NSString *startingText = @"Starting…";
            self.bfgStatLabel.stringValue = startingText;
        startingText = nil;

        
        NSMutableArray *launchArray = [NSMutableArray arrayWithObjects: nil];

        
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        
        [prefs synchronize];
        

        self.intensityValue = [prefs stringForKey:@"intenseValue"];
        self.worksizeValue = [prefs stringForKey:@"worksizeValue"];
        self.vectorValue = [prefs stringForKey:@"vectorValue"];
        self.noGPU = [prefs stringForKey:@"disableGPU"];
        self.onScrypt = [prefs stringForKey:@"useScrypt"];
        self.debugOutputOn = [prefs stringForKey:@"debugOutput"];
        self.quietOutputOn = [prefs stringForKey:@"quietOutput"];
        self.bonusOptions = [prefs stringForKey:@"bfgOptionsValue"];
        self.threadConc = [prefs stringForKey:@"bfgThreadConc"];
        self.shaders = [prefs stringForKey:@"bfgShaders"];
        self.lookupGap = [prefs stringForKey:@"bfgLookupGap"];
        NSString *cpuThreads = [prefs stringForKey:@"bfgCpuThreads"];

                        
            [launchArray addObject:@"-T"];
        
        if ([self.intensityValue isNotEqualTo:nil]) {
            [launchArray addObject:@"-I"];
            [launchArray addObject:self.intensityValue];
        }
        if ([self.worksizeValue isNotEqualTo:nil]) {
            [launchArray addObject:@"-w"];
            [launchArray addObject:self.worksizeValue];
        }
        if ([self.vectorValue isNotEqualTo:nil]) {
            [launchArray addObject:@"-v"];
            [launchArray addObject:self.vectorValue];
        }
        if (self.noGPU.length >= 1) {
            [launchArray addObject:@"-S"];
            [launchArray addObject:@"opencl:auto"];
        }
        if ([self.onScrypt isNotEqualTo:nil]) {
            [launchArray addObject:self.onScrypt];
        }
        if ([self.debugOutputOn isNotEqualTo:nil]) {
            [launchArray addObject:self.debugOutputOn];
        }
        if ([self.quietOutputOn isNotEqualTo:nil]) {
            [launchArray addObject:self.quietOutputOn];
        }
        if (self.threadConc.length >= 1) {
            [launchArray addObject:@"--thread-concurrency"];
            [launchArray addObject:self.threadConc];
        }
        if (self.shaders.length >= 1) {
            [launchArray addObject:@"--shaders"];
            [launchArray addObject:self.shaders];
        }
        if (self.lookupGap.length >= 1) {
            [launchArray addObject:@"--lookup-gap"];
            [launchArray addObject:self.lookupGap];
        }
        if (cpuThreads.length >= 1) {
            [launchArray addObject:@"-t"];
            [launchArray addObject:cpuThreads];
        }
        else {
            [launchArray addObject:@"-t"];
            [launchArray addObject:@"0"];
        }

        self.executableName = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleExecutable"];
        self.paths = NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, YES);
        self.userpath = [self.paths objectAtIndex:0];
        self.userpath2 = [self.userpath stringByAppendingPathComponent:self.executableName];    // The file will go in this directory
        self.saveBTCConfigFilePath = [self.userpath2 stringByAppendingPathComponent:@"bfgurls.conf"];
        self.saveLTCConfigFilePath = [self.userpath2 stringByAppendingPathComponent:@"ltcurls.conf"];
        self.userpath = nil;
        self.userpath2 = nil;
        self.paths = nil;
        self.executableName = nil;
        
            [launchArray addObject:@"-c"];
        [launchArray addObject:self.saveBTCConfigFilePath];

        if ([self.onScrypt isEqualTo:@"--scrypt"]) {
            [launchArray removeLastObject];
            [launchArray addObject:self.saveLTCConfigFilePath];
        }

        if ([self.bonusOptions isNotEqualTo:nil]) {
            NSArray *bonusStuff = [self.bonusOptions componentsSeparatedByString:@" "];
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
        
        NSString *logItString = [launchArray componentsJoinedByString:@"_"];
        appDelegate.bfgSettingText.stringValue = logItString;
                appDelegate = nil;
        
        self.lookupGap = nil;
        self.shaders = nil;
        self.threadConc = nil;
        
        
        BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:self.saveBTCConfigFilePath];
        if (fileExists) {
            NSString *btcConfig = [NSString stringWithContentsOfFile : self.saveBTCConfigFilePath encoding:NSUTF8StringEncoding error:nil];
            NSString *ltcConfig = [NSString stringWithContentsOfFile : self.saveLTCConfigFilePath encoding:NSUTF8StringEncoding error:nil];
            

            if ([self.onScrypt length] <= 1) {
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
                NSString *infoText = [@"The primary pool is set to " stringByAppendingString:bfgURLValue];
                NSString *infoText2 = [infoText stringByAppendingString:@" and the user is set to "];
                NSString *infoText3 = [infoText2 stringByAppendingString:bfgUserValue];
                [startAlert setInformativeText:infoText3];
                
                infoText3 = nil;
                infoText2 = nil;
                infoText = nil;
                
                        //            [[NSAlert init] alertWithMessageText:@"This app requires python pip. Click 'Install' and you will be asked your password so it can be installed, or click 'Quit' and install pip yourself before relaunching this app." defaultButton:@"Install" alternateButton:@"Quit" otherButton:nil informativeTextWithFormat:nil];
                        //            NSAlertDefaultReturn = [self performSelector:@selector(installPip:)];
                        [startAlert setAlertStyle:NSWarningAlertStyle];
                        //        returnCode: (NSInteger)returnCode
                        
                        [startAlert beginSheetModalForWindow:self.bfgWindow modalDelegate:self didEndSelector:nil contextInfo:nil];
            }
            
//            if ([ltcConfig rangeOfString:stringUser].location != NSNotFound) {
                    if ([self.onScrypt isEqualTo:@"--scrypt"]) {
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
                        NSString *infoText = [@"The primary pool is set to " stringByAppendingString:bfgURLValue];
                        NSString *infoText2 = [infoText stringByAppendingString:@" and the user is set to "];
                        NSString *infoText3 = [infoText2 stringByAppendingString:bfgUserValue];
                        [startAlert setInformativeText:infoText3];
                        
                        infoText3 = nil;
                        infoText2 = nil;
                        infoText = nil;
                        ltcConfig = nil;
                        btcConfig = nil;
                        bfgURLValue = nil;
                        bfgUserValue = nil;
                    
                        
                        //            [[NSAlert init] alertWithMessageText:@"This app requires python pip. Click 'Install' and you will be asked your password so it can be installed, or click 'Quit' and install pip yourself before relaunching this app." defaultButton:@"Install" alternateButton:@"Quit" otherButton:nil informativeTextWithFormat:nil];
                        //            NSAlertDefaultReturn = [self performSelector:@selector(installPip:)];
                        [startAlert setAlertStyle:NSWarningAlertStyle];
                        //        returnCode: (NSInteger)returnCode
                        
                        [startAlert beginSheetModalForWindow:self.bfgWindow modalDelegate:self didEndSelector:nil contextInfo:nil];
                
            }
            
            
        }

        
        
        

        
        launchArray = nil;

        self.intensityValue = nil;
        self.worksizeValue = nil;
        self.vectorValue = nil;
        self.noGPU = nil;
        self.onScrypt = nil;
        self.debugOutputOn = nil;
        self.quietOutputOn = nil;
        self.bonusOptions = nil;
        prefs = nil;
        bfgPath = nil;
        self.saveBTCConfigFilePath = nil;
        self.saveLTCConfigFilePath = nil;

            /*
            if (bfgRememberButton.state == NSOnState) {
                
//                NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
                
                // saving an NSString
                [prefs setObject:bfgUserView.stringValue forKey:@"bfgUserValue"];
                [prefs setObject:bfgPassView.stringValue forKey:@"bfgPassValue"];
                [prefs setObject:bfgPoolView.stringValue forKey:@"bfgPoolValue"];
//                [prefs setObject:bfgOptionsView.stringValue forKey:@"bfgOptionsValue"];
                
                
                [prefs synchronize];
            }
*/
        
    }
    
}

// This callback is implemented as part of conforming to the ProcessController protocol.
// It will be called whenever there is output from the TaskWrapper.
- (void)taskWrapper:(TaskWrapper *)taskWrapper didProduceOutput:(NSString *)output
{
    
    if ([self.speedRead.stringValue isNotEqualTo:@"0"]) {
        self.speedRead.tag = 1;
    }
    
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    
    [prefs synchronize];
    
    NSString *speechSetting = [prefs objectForKey:@"enableSpeech"];
    if ([speechSetting  isEqual: @"silence"]) {
        
    }

    
    else if ([self.speedRead.stringValue isEqual: @"0"] && self.speedRead.tag == 1) {
        _speechSynth = [[NSSpeechSynthesizer alloc] initWithVoice:nil];
        [self.speechSynth startSpeakingString:@"Mining Stopped"];
    }
    
    if ([speechSetting  isEqual: @"silence"]) {
        
    }
    else if ([output rangeOfString:@"auth failed"].location != NSNotFound) {
        _speechSynth = [[NSSpeechSynthesizer alloc] initWithVoice:nil];
        [self.speechSynth startSpeakingString:@"Authorisation Failed"];
    }
    
    speechSetting = nil;
    prefs = nil;
    
    if ([output rangeOfString:@"5s:"].location != NSNotFound) {
        NSString *numberString = [self getDataBetweenFromString:output
                                                     leftString:@"5s" rightString:@"a" leftOffset:3];
        self.speedRead.stringValue = [numberString stringByReplacingOccurrencesOfString:@" " withString:@""];
        numberString = nil;
        NSString *acceptString = [self getDataBetweenFromString:output
                                                     leftString:@"A:" rightString:@"R" leftOffset:0];
        self.acceptRead.stringValue = [acceptString stringByReplacingOccurrencesOfString:@"A:" withString:@"Accepted: "];
        acceptString = nil;
        NSString *rejectString = [self getDataBetweenFromString:output
                                                     leftString:@"R:" rightString:@"+" leftOffset:0];
        self.rejectRead.stringValue = [rejectString stringByReplacingOccurrencesOfString:@"R:" withString:@"Rejected: "];
        rejectString = nil;
        
            if ([output rangeOfString:@"kh"].location != NSNotFound) {
             self.hashRead.stringValue = @"Kh";
            }
        if ([output rangeOfString:@"Mh"].location != NSNotFound) {
            self.hashRead.stringValue = @"Mh";
        }
        if ([output rangeOfString:@"Gh"].location != NSNotFound) {
            self.hashRead.stringValue = @"Gh";
        }

        
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        
        [prefs synchronize];


                if ([[prefs objectForKey:@"showDockReading"] isEqualTo:@"hide"]) {
                    AppDelegate *appDelegate = (AppDelegate *)[[NSApplication sharedApplication] delegate];
                    [appDelegate.bfgReadBack setHidden:YES];
            [appDelegate.bfgReading setHidden:YES];
                    [[NSApp dockTile] display];
                    appDelegate = nil;
                }
        else
        {
            
            
            AppDelegate *appDelegate = (AppDelegate *)[[NSApplication sharedApplication] delegate];
            appDelegate.bfgReading.stringValue = [self.speedRead.stringValue stringByAppendingString:self.hashRead.stringValue];
            [appDelegate.bfgReadBack setHidden:NO];
            [appDelegate.bfgReading setHidden:NO];
            [[NSApp dockTile] display];
            appDelegate = nil;
        }
    }
//    else
            //    AppDelegate *appDelegate = (AppDelegate *)[[NSApplication sharedApplication] delegate];
            // add the string (a chunk of the results from locate) to the NSTextView's
            // backing store, in the form of an attributed string
        
        
    if ([output rangeOfString:@"Unknown stratum msg"].location != NSNotFound) {
        output = nil;
    }
    else {
       
       NSString *newOutput = [self.bfgOutputView.string stringByAppendingString:output];

            self.bfgOutputView.string = newOutput;
        
        newOutput = nil;
    
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
        logLength = nil;
    }

        
        // setup a selector to be called the next time through the event loop to scroll
        // the view to the just pasted text.  We don't want to scroll right now,
        // because of a bug in Mac OS X version 10.1 that causes scrolling in the context
        // of a text storage update to starve the app of events
    
                if ([[prefs objectForKey:@"scrollLog"] isNotEqualTo:@"hide"]) {
        [self performSelector:@selector(scrollToVisible:) withObject:nil afterDelay:0.0];
                }
        prefs = nil;
    }
 

    output = nil;


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
    [self.bfgStartButton setTitle:@"Stop"];
}

// A callback that gets called when a TaskWrapper is completed, allowing us to do any cleanup
// that is needed from the app side.  This method is implemented as a part of conforming
// to the ProcessController protocol.
- (void)taskWrapper:(TaskWrapper *)taskWrapper didFinishTaskWithStatus:(int)terminationStatus
{
    searchTaskIsRunning=NO;
            self.speedRead.tag = 0;

    // change the button's title back for the next search
    [self.bfgStartButton setTitle:@"Start"];
    
    if (self.bfgStartButton.tag == 0) {
        
        [self performSelector:@selector(start:) withObject:nil afterDelay:10.0];
    
    NSAlert *restartMessage = [[NSAlert alloc] init];
    [restartMessage addButtonWithTitle:@"Umm… OK."];
    
    [restartMessage setMessageText:@"Settings changed"];
    
    NSDate * now = [NSDate date];
    NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
    [outputFormatter setDateFormat:@"HH:mm:ss"];
    NSString *newDateString = [outputFormatter stringFromDate:now];
    NSLog(@"newDateString %@", newDateString);
    outputFormatter = nil;
    NSString *restartMessageInfo = [NSString stringWithFormat:@"Your miner was resarted automatically after a sudden stop at %@.", newDateString];
    [restartMessage setInformativeText:restartMessageInfo];
    
    [restartMessage setAlertStyle:NSWarningAlertStyle];
    //        returnCode: (NSInteger)returnCode
    
    [restartMessage beginSheetModalForWindow:self.bfgWindow modalDelegate:self didEndSelector:nil contextInfo:nil];
            restartMessage = nil;
    }

}

// If the user closes the search window, let's just quit
-(BOOL)windowShouldClose:(id)sender
{

    return YES;
}

// when first launched, this routine is called when all objects are created
// and initialized.  It's a chance for us to set things up before the user gets
// control of the UI.
-(void)viewDidLoad
{
    
    
    searchTaskIsRunning=NO;
        self.bfgStatLabel.tag = 0;
            self.speedRead.tag = 0;
    bfgTask=nil;
    
    
}

- (IBAction)bfgMinerToggle:(id)sender {
    
    if ([self.bfgWindow isVisible]) {
        [self.bfgWindow orderOut:sender];
    }
    else
    {
        [self.bfgWindow orderFront:sender];
    }
}

- (void)bfgMinerToggled:(id)sender {
    
    if ([self.bfgWindow isVisible]) {
        [self.bfgWindow orderOut:sender];
    }
    else
    {
        [self.bfgWindow orderFront:sender];
    }
}

- (IBAction)optionsToggle:(id)sender {
    
    if ([self.bfgOptionsWindow isVisible]) {
                [self.openOptions setState:NSOffState];
        [self.bfgOptionsWindow orderOut:sender];
    }
    else
    {
        [self.openOptions setState:NSOnState];
        [self.bfgOptionsWindow orderFront:sender];
        
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
        NSString *cpuThreads = [prefs stringForKey:@"bfgCpuThreads"];


        if ([cpuThreads isNotEqualTo:nil]) {
            self.bfgCpuThreads.stringValue = cpuThreads;
        }
        if ([intensityValue isNotEqualTo:nil]) {
            self.intenseSizeLabel.stringValue = intensityValue;
            self.dynamicIntensity.state = NSOffState;
        }
        if ([worksizeValue isNotEqualTo:nil]) {
            self.workSizeLabel.stringValue = worksizeValue;
            self.workSizeOverride.state = NSOnState;
        }
        if ([vectorValue isNotEqualTo:nil]) {
            self.vectorSizeLabel.stringValue = vectorValue;
            self.vectorOverride.state = NSOnState;
        }
        if ([noGPU isNotEqualTo:nil]) {
            self.disableGPU.state = NSOnState;
        }
        if ([onScrypt isNotEqualTo:nil]) {
            self.useScrypt.state = NSOnState;
        }
        if ([debugOutputOn isNotEqualTo:nil]) {
            self.debugOutput.state = NSOnState;
        }
        if ([quietOutputOn isNotEqualTo:nil]) {
            self.quietOutput.state = NSOnState;
        }
        
        if ([bonusOptions isNotEqualTo:nil]) {
            self.bfgOptionsView.stringValue = bonusOptions;
            }
        if (threadConc.length >= 1) {
            self.bfgThreadConc.stringValue = threadConc;
        }
        if (shaders.length >= 1) {
            self.bfgShaders.stringValue = shaders;
        }
        if (lookupGap.length >= 1) {
            self.bfgLookupGap.stringValue = lookupGap;
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
        cpuThreads = nil;
        
        prefs = nil;
        
        }


    
    }


- (IBAction)optionsApply:(id)sender {
    
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    if (self.bfgCpuThreads.stringValue.length >= 1) {
        [prefs setObject:self.bfgCpuThreads.stringValue forKey:@"bfgCpuThreads"];
    }
    else {
               [prefs setObject:@"0" forKey:@"bfgCpuThreads"];
    }
    if (self.dynamicIntensity.state == NSOffState) {
            [prefs setObject:self.intenseSizeLabel.stringValue forKey:@"intenseValue"];
    }
    else {
        [prefs setObject:nil forKey:@"intenseValue"];
    }
    if (self.workSizeOverride.state == NSOnState) {
    [prefs setObject:self.workSizeLabel.stringValue forKey:@"worksizeValue"];
    }
    else    {
        [prefs setObject:nil forKey:@"worksizeValue"];
    }
    if (self.vectorOverride.state == NSOnState) {
    [prefs setObject:self.vectorSizeLabel.stringValue forKey:@"vectorValue"];
    }
    else {
        [prefs setObject:nil forKey:@"vectorValue"];
    }
    if (self.disableGPU.state == NSOnState) {
        [prefs setObject:@"-G" forKey:@"disableGPU"];
    }
    else {
        [prefs setObject:nil forKey:@"disableGPU"];
    }
    if (self.useScrypt.state == NSOnState) {
        [prefs setObject:@"--scrypt" forKey:@"useScrypt"];
    }
    else {
        [prefs setObject:nil forKey:@"useScrypt"];
    }
    if (self.debugOutput.state == NSOnState) {
        [prefs setObject:@"-D" forKey:@"debugOutput"];
    }
    else {
        [prefs setObject:nil forKey:@"debugOutput"];
    }
    if (self.quietOutput.state == NSOnState) {
        [prefs setObject:@"-q" forKey:@"quietOutput"];
    }
    else {
        [prefs setObject:nil forKey:@"quietOutput"];
    }
    if (self.bfgThreadConc.stringValue.length >= 1) {
        [prefs setObject:self.bfgThreadConc.stringValue forKey:@"bfgThreadConc"];
    }
    else {
        [prefs setObject:nil forKey:@"bfgThreadConc"];
    }
    if (self.bfgShaders.stringValue.length >= 1) {
        [prefs setObject:self.bfgShaders.stringValue forKey:@"bfgShaders"];
    }
    else {
        [prefs setObject:nil forKey:@"bfgShaders"];
    }
    if (self.bfgLookupGap.stringValue.length >= 1) {
        [prefs setObject:self.bfgLookupGap.stringValue forKey:@"bfgLookupGap"];
    }
    else {
        [prefs setObject:nil forKey:@"bfgLookupGap"];
    }
    
    [prefs setObject:self.bfgOptionsView.stringValue forKey:@"bfgOptionsValue"];
    
    [prefs synchronize];

        [self.openOptions setState:NSOffState];
        [self.bfgOptionsWindow orderOut:sender];
    
    prefs = nil;

}

- (IBAction)setRecommendedBFGValues:(id)sender {

    size_t len = 0;
    sysctlbyname("hw.model", NULL, &len, NULL, 0);
    
    if (len)
    {
        char *model = malloc(len*sizeof(char));
        sysctlbyname("hw.model", model, &len, NULL, 0);
        NSString *model_ns = [NSString stringWithUTF8String:model];
        free(model);

//        NSLog(model_ns);
        
        if ([model_ns rangeOfString:@"MacPro"].location != NSNotFound) {
            self.dynamicIntensity.state = NSOffState;
            self.intenseSizeLabel.stringValue = @"4";
            self.workSizeOverride.state = NSOffState;
            self.vectorOverride.state = NSOffState;
            self.quietOutput.state = NSOnState;
            self.debugOutput.state = NSOffState;
        }
        if ([model_ns rangeOfString:@"MacBook"].location != NSNotFound) {

                    if ([model_ns rangeOfString:@"MacBookPro8,2"].location != NSNotFound || [model_ns rangeOfString:@"MacBookPro8,3"].location != NSNotFound) {
                        self.dynamicIntensity.state = NSOffState;
                        self.intenseSizeLabel.stringValue = @"2";
                        self.workSizeOverride.state = NSOnState;
                        self.workSizeLabel.stringValue = @"128";
                        self.vectorOverride.state = NSOffState;
                        self.quietOutput.state = NSOnState;
                        self.debugOutput.state = NSOffState;
                    }
            else
            self.dynamicIntensity.state = NSOffState;
            self.intenseSizeLabel.stringValue = @"2";
            self.workSizeOverride.state = NSOffState;
            self.vectorOverride.state = NSOffState;
            self.quietOutput.state = NSOnState;
            self.debugOutput.state = NSOffState;
        }
        if ([model_ns rangeOfString:@"Mini"].location != NSNotFound) {
            self.dynamicIntensity.state = NSOffState;
            self.intenseSizeLabel.stringValue = @"2";
            self.workSizeOverride.state = NSOffState;
            self.vectorOverride.state = NSOffState;
            self.quietOutput.state = NSOnState;
            self.debugOutput.state = NSOffState;
        }
        if ([model_ns rangeOfString:@"iMac"].location != NSNotFound) {
            
            if ([model_ns rangeOfString:@"iMac12,1"].location != NSNotFound || [model_ns rangeOfString:@"iMac12,2"].location != NSNotFound) {
                self.dynamicIntensity.state = NSOffState;
                self.intenseSizeLabel.stringValue = @"2";
                self.workSizeOverride.state = NSOnState;
                self.workSizeLabel.stringValue = @"128";
                self.vectorOverride.state = NSOffState;
                self.quietOutput.state = NSOnState;
                self.debugOutput.state = NSOffState;
            }
            else
            self.dynamicIntensity.state = NSOffState;
            self.intenseSizeLabel.stringValue = @"2";
            self.workSizeOverride.state = NSOffState;
            self.vectorOverride.state = NSOffState;
            self.quietOutput.state = NSOnState;
            self.debugOutput.state = NSOffState;
        }
        
        
        NSAlert *configAlert = [[NSAlert alloc] init];
        [configAlert addButtonWithTitle:@"I understand"];
        
        [configAlert setMessageText:@"Settings changed"];
        NSString *configInfo = @"Your settings have been set to 'safe' recommended defaults that will allow you to use your computer while mining. Intensity is the key value that affects your mining speed, and needs to be higher for LTC mining. Click apply to save these settings.";
        [configAlert setInformativeText:configInfo];
        
        configInfo = nil;
        
        [configAlert setAlertStyle:NSWarningAlertStyle];
        //        returnCode: (NSInteger)returnCode
        
        [configAlert beginSheetModalForWindow:self.bfgOptionsWindow modalDelegate:self didEndSelector:nil contextInfo:nil];

    }
    
    else{
    NSAlert *configAlert = [[NSAlert alloc] init];
    [configAlert addButtonWithTitle:@"I understand"];
    
    [configAlert setMessageText:@"Waaaaaah!"];
    NSString *configInfo = @"I couldn't detect your hardware. Please get in touch with a bug report.";
    [configAlert setInformativeText:configInfo];
    
    configInfo = nil;
    
    [configAlert setAlertStyle:NSWarningAlertStyle];
    //        returnCode: (NSInteger)returnCode
    
    [configAlert beginSheetModalForWindow:self.bfgOptionsWindow modalDelegate:self didEndSelector:nil contextInfo:nil];
    }
    
}



@end
