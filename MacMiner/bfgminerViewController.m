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
        self.bfgStartButton.tag = 0;
        [self.bfgStartButton setTitle:@"Stop"];
        // If the task is still sitting around from the last run, release it
        if (bfgTask!=nil) {
            bfgTask = nil;
        }

        
        
NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        [prefs synchronize];
        
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

        NSString *bfgPath = @"";
        
        NSString *bundlePath2 = [[NSBundle mainBundle] resourcePath];
        
        
        if (self.chooseGPUAlgo.indexOfSelectedItem == 0) {
            bfgPath = [bundlePath2 stringByAppendingString:@"/bfgminer/bin/bfgminer"];
        }
        if (self.chooseGPUAlgo.indexOfSelectedItem == 1) {
            bfgPath = [bundlePath2 stringByAppendingString:@"/vertcgminer/bin/vertminer"];
        }
        if (self.chooseGPUAlgo.indexOfSelectedItem == 2) {
            bfgPath = [bundlePath2 stringByAppendingString:@"/bfgminer/bin/bfgminer"];
        }
        if (self.chooseGPUAlgo.indexOfSelectedItem == 3) {
            bfgPath = [bundlePath2 stringByAppendingString:@"/maxminer/bin/cgminer"];
        }
        
        
        
        
        [self.bfgOutputView setString:@""];
        NSString *startingText = @"Starting…";
        self.bfgStatLabel.stringValue = startingText;
        startingText = nil;
        
        
        NSMutableArray *launchArray = [NSMutableArray arrayWithObjects: @"--api-listen", @"--api-allow", @"R:0/0", @"--api-port", @"4052", nil];
        
        
        
        self.executableName = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleExecutable"];
        self.paths = NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, YES);
        self.userpath = [self.paths objectAtIndex:0];
        self.userpath2 = [self.userpath stringByAppendingPathComponent:self.executableName];    // The file will go in this directory
        self.saveBTCConfigFilePath = [self.userpath2 stringByAppendingPathComponent:@"bfgurls.conf"];
        self.saveLTCConfigFilePath = [self.userpath2 stringByAppendingPathComponent:@"ltcurls.conf"];
        NSString *saveLTCAdNConfigFilePath = [self.userpath2 stringByAppendingPathComponent:@"vtcurls.conf"];
        NSString *saveMaxConfigFilePath = [self.userpath2 stringByAppendingPathComponent:@"maxurls.conf"];
        self.userpath = nil;
        self.userpath2 = nil;
        self.paths = nil;
        self.executableName = nil;
        
        
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
        

        
        if ([self.debugOutputOn isNotEqualTo:nil]) {
            [launchArray addObject:self.debugOutputOn];
        }
        if ([self.quietOutputOn isNotEqualTo:nil]) {
            [launchArray addObject:self.quietOutputOn];
        }
        
        
        if (self.chooseGPUAlgo.indexOfSelectedItem == 0 || self.chooseGPUAlgo.indexOfSelectedItem == 2) {
            
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
            
        }
        
        if (self.chooseGPUAlgo.indexOfSelectedItem == 0) {
            [launchArray addObject:@"--scrypt"];
            [launchArray addObject:@"-c"];
            [launchArray addObject:self.saveLTCConfigFilePath];
            [launchArray addObject:@"-S"];
            [launchArray addObject:@"opencl:auto"];
        }
        if (self.chooseGPUAlgo.indexOfSelectedItem == 1) {
            [launchArray addObject:@"--scrypt-vert"];
            [launchArray addObject:@"-c"];
            [launchArray addObject:saveLTCAdNConfigFilePath];
        }
        if (self.chooseGPUAlgo.indexOfSelectedItem == 2) {
            [launchArray addObject:@"-c"];
            [launchArray addObject:self.saveBTCConfigFilePath];
            [launchArray addObject:@"-S"];
            [launchArray addObject:@"opencl:auto"];
        }
        if (self.chooseGPUAlgo.indexOfSelectedItem == 3) {
            [launchArray addObject:@"--keccak"];
            [launchArray addObject:@"-c"];
            [launchArray addObject:saveMaxConfigFilePath];
        }
        
        
        
        if ([self.bonusOptions isNotEqualTo:nil]) {
            NSArray *bonusStuff = [self.bonusOptions componentsSeparatedByString:@" "];
            if (bonusStuff.count >= 2) {
                [launchArray addObjectsFromArray:bonusStuff];
                bonusStuff = nil;
            }
        }
        
        
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
        BOOL ltcFileExists = [[NSFileManager defaultManager] fileExistsAtPath:self.saveLTCConfigFilePath];
        
        NSString *btcConfig = [NSString stringWithContentsOfFile : self.saveBTCConfigFilePath encoding:NSUTF8StringEncoding error:nil];
        NSString *ltcConfig = [NSString stringWithContentsOfFile : self.saveLTCConfigFilePath encoding:NSUTF8StringEncoding error:nil];
        
        if (fileExists) {
            if (self.chooseGPUAlgo.indexOfSelectedItem == 2) {
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
        }
        if (ltcFileExists) {
            
            //            if ([ltcConfig rangeOfString:stringUser].location != NSNotFound) {
            if (self.chooseGPUAlgo.indexOfSelectedItem == 0) {
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
    
        if ([prefs objectForKey:@"enableSpeech"] == nil) {


    
     if ([self.speedRead.stringValue isEqual: @"0"] && self.speedRead.tag == 1) {
        _speechSynth = [[NSSpeechSynthesizer alloc] initWithVoice:nil];
        [self.speechSynth startSpeakingString:@"Mining Stopped"];
    }
    
    
     if ([output rangeOfString:@"auth failed"].location != NSNotFound) {
        _speechSynth = [[NSSpeechSynthesizer alloc] initWithVoice:nil];
        [self.speechSynth startSpeakingString:@"Authorisation Failed"];
    }

        }
        
    
    
    if ([output rangeOfString:@"Invalid value passed to set intensity"].location != NSNotFound) {
        NSString *newOutput = [self.bfgOutputView.string stringByAppendingString:@"Please set an Intensity of 8 or higher"];
        
        self.bfgOutputView.string = newOutput;
        
        newOutput = nil;
    }
    
    

    prefs = nil;
    
    if ([output rangeOfString:@"5s"].location != NSNotFound) {
        NSString *numberString = [self getDataBetweenFromString:output
                                                     leftString:@"5s" rightString:@"a" leftOffset:3];
        numberString = [numberString stringByReplacingOccurrencesOfString:@":" withString:@""];
            numberString = [numberString stringByReplacingOccurrencesOfString:@"K" withString:@""];
        numberString = [numberString stringByReplacingOccurrencesOfString:@"(" withString:@""];
        numberString = [numberString stringByReplacingOccurrencesOfString:@"M" withString:@""];
        self.speedRead.stringValue = [numberString stringByReplacingOccurrencesOfString:@" " withString:@""];
        numberString = nil;
        NSString *acceptString = [self getDataBetweenFromString:output
                                                     leftString:@"A:" rightString:@"R" leftOffset:0];
        self.acceptRead.stringValue = [acceptString stringByReplacingOccurrencesOfString:@"A:" withString:@"Accepted: "];
        acceptString = nil;
        NSString *rejectString = [self getDataBetweenFromString:output
                                                     leftString:@"R:" rightString:@"H" leftOffset:0];
        rejectString = [rejectString stringByReplacingOccurrencesOfString:@"+0(none)" withString:@""];
        self.rejectRead.stringValue = [rejectString stringByReplacingOccurrencesOfString:@"R:" withString:@"Rejected: "];
        rejectString = nil;
        
            if ([output rangeOfString:@"kh"].location != NSNotFound) {
             self.hashRead.stringValue = @"Kh";
            }
        if ([output rangeOfString:@"Kh"].location != NSNotFound) {
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


        
                if ([prefs objectForKey:@"showDockReading"] != nil) {
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
    if ([output rangeOfString:@"20s"].location != NSNotFound) {
        NSString *numberString = [self getDataBetweenFromString:output
                                                     leftString:@"20s" rightString:@"a" leftOffset:3];
        numberString = [numberString stringByReplacingOccurrencesOfString:@":" withString:@""];
        numberString = [numberString stringByReplacingOccurrencesOfString:@"K" withString:@""];
        numberString = [numberString stringByReplacingOccurrencesOfString:@"(" withString:@""];
        numberString = [numberString stringByReplacingOccurrencesOfString:@"M" withString:@""];
        self.speedRead.stringValue = [numberString stringByReplacingOccurrencesOfString:@" " withString:@""];
        numberString = nil;
        NSString *acceptString = [self getDataBetweenFromString:output
                                                     leftString:@"A:" rightString:@"R" leftOffset:0];
        self.acceptRead.stringValue = [acceptString stringByReplacingOccurrencesOfString:@"A:" withString:@"Accepted: "];
        acceptString = nil;
        NSString *rejectString = [self getDataBetweenFromString:output
                                                     leftString:@"R:" rightString:@"H" leftOffset:0];
        rejectString = [rejectString stringByReplacingOccurrencesOfString:@"+0(none)" withString:@""];
        self.rejectRead.stringValue = [rejectString stringByReplacingOccurrencesOfString:@"R:" withString:@"Rejected: "];
        rejectString = nil;
        
        if ([output rangeOfString:@"kh"].location != NSNotFound) {
            self.hashRead.stringValue = @"Kh";
        }
        if ([output rangeOfString:@"Kh"].location != NSNotFound) {
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
        
        
        
        if ([prefs objectForKey:@"showDockReading"] != nil) {
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
    
        NSString *logLength = @"1";
        if ([prefs objectForKey:@"logLength"] != nil) {
            logLength = [prefs objectForKey:@"logLength" ];
        }
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

                        if ([prefs objectForKey:@"scrollLog"] != nil) {
        
                if ([[prefs objectForKey:@"scrollLog"] isNotEqualTo:@"hide"]) {
        [self performSelector:@selector(scrollToVisible:) withObject:nil afterDelay:0.0];
                }
        prefs = nil;
    }
                        else {
                                   [self performSelector:@selector(scrollToVisible:) withObject:nil afterDelay:0.0];
                        }
   
        
    }
 

    output = nil;


    }


- (NSString *)getDataBetweenFromString:(NSString *)data leftString:(NSString *)leftData rightString:(NSString *)rightData leftOffset:(NSInteger)leftPos;
{
    if (data.length <=3) {
        return @"string too short";
    }
    
    else if ([leftData isNotEqualTo:nil]) {
        NSInteger left, right;
        
        NSScanner *scanner=[NSScanner scannerWithString:data];
        [scanner scanUpToString:leftData intoString: nil];
        left = [scanner scanLocation];
        [scanner setScanLocation:left + leftPos];
        [scanner scanUpToString:rightData intoString: nil];
        right = [scanner scanLocation];
        left += leftPos;
        NSString *foundData = [data substringWithRange: NSMakeRange(left, (right - left) - 1)];
        
        return foundData;
        
        foundData = nil;
        scanner = nil;
        leftData = nil;
        rightData = nil;
    }
    else return @"left string is nil";
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
    AppDelegate *appDelegate = (AppDelegate *)[[NSApplication sharedApplication] delegate];
    
    [appDelegate.bfgReadBack setHidden:YES];
    [appDelegate.bfgReading setHidden:YES];
    
    searchTaskIsRunning=NO;
            self.speedRead.tag = 0;

    // change the button's title back for the next search
    [self.bfgStartButton setTitle:@"Start"];
    
    if (self.bfgStartButton.tag == 0) {
        
        [self performSelector:@selector(start:) withObject:nil afterDelay:10.0];
    
    self.restartMessage = [[NSAlert alloc] init];
    [self.restartMessage addButtonWithTitle:@"Umm… OK."];
    
    [self.restartMessage setMessageText:@"Settings changed"];
    
    NSDate * now = [NSDate date];
    NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
    [outputFormatter setDateFormat:@"HH:mm:ss"];
    NSString *newDateString = [outputFormatter stringFromDate:now];
    NSLog(@"newDateString %@", newDateString);
    outputFormatter = nil;
    NSString *restartMessageInfo = [NSString stringWithFormat:@"Your miner was restarted automatically after a sudden stop at %@.", newDateString];
    [self.restartMessage setInformativeText:restartMessageInfo];
    
    [self.restartMessage setAlertStyle:NSWarningAlertStyle];
    //        returnCode: (NSInteger)returnCode
    
    [self.restartMessage beginSheetModalForWindow:self.bfgWindow modalDelegate:self didEndSelector:nil contextInfo:nil];
            self.restartMessage = nil;
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
        
                                if ([prefs objectForKey:@"gpuAlgoChoice"] != nil) {
        if ([[prefs objectForKey:@"gpuAlgoChoice"]  isEqual: @"0"]) {
            [self.chooseGPUAlgo selectItemAtIndex:0];
        }
        if ([[prefs objectForKey:@"gpuAlgoChoice"]  isEqual: @"1"]) {
            [self.chooseGPUAlgo selectItemAtIndex:1];
        }
        if ([[prefs objectForKey:@"gpuAlgoChoice"]  isEqual: @"2"]) {
            [self.chooseGPUAlgo selectItemAtIndex:2];
        }
        if ([[prefs objectForKey:@"gpuAlgoChoice"]  isEqual: @"3"]) {
            [self.chooseGPUAlgo selectItemAtIndex:3];
        }
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
    
    if (self.chooseGPUAlgo.indexOfSelectedItem == 0) {
        [prefs setObject:@"0" forKey:@"gpuAlgoChoice"];
    }
    if (self.chooseGPUAlgo.indexOfSelectedItem == 1) {
        [prefs setObject:@"1" forKey:@"gpuAlgoChoice"];
    }
    if (self.chooseGPUAlgo.indexOfSelectedItem == 2) {
        [prefs setObject:@"2" forKey:@"gpuAlgoChoice"];
    }
    if (self.chooseGPUAlgo.indexOfSelectedItem == 3) {
        [prefs setObject:@"3" forKey:@"gpuAlgoChoice"];
    }

    
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
                        self.intenseSizeLabel.stringValue = @"4";
                        self.workSizeOverride.state = NSOnState;
                        self.workSizeLabel.stringValue = @"128";
                        self.vectorOverride.state = NSOffState;
                        self.quietOutput.state = NSOnState;
                        self.debugOutput.state = NSOffState;
                    }
            else
            self.dynamicIntensity.state = NSOffState;
            self.intenseSizeLabel.stringValue = @"4";
            self.workSizeOverride.state = NSOffState;
            self.vectorOverride.state = NSOffState;
            self.quietOutput.state = NSOnState;
            self.debugOutput.state = NSOffState;
        }
        if ([model_ns rangeOfString:@"Mini"].location != NSNotFound) {
            self.dynamicIntensity.state = NSOffState;
            self.intenseSizeLabel.stringValue = @"4";
            self.workSizeOverride.state = NSOffState;
            self.vectorOverride.state = NSOffState;
            self.quietOutput.state = NSOnState;
            self.debugOutput.state = NSOffState;
        }
        if ([model_ns rangeOfString:@"iMac"].location != NSNotFound) {
            
            if ([model_ns rangeOfString:@"iMac12,1"].location != NSNotFound || [model_ns rangeOfString:@"iMac12,2"].location != NSNotFound) {
                self.dynamicIntensity.state = NSOffState;
                self.intenseSizeLabel.stringValue = @"4";
                self.workSizeOverride.state = NSOnState;
                self.workSizeLabel.stringValue = @"128";
                self.vectorOverride.state = NSOffState;
                self.quietOutput.state = NSOnState;
                self.debugOutput.state = NSOffState;
            }
            else
            self.dynamicIntensity.state = NSOffState;
            self.intenseSizeLabel.stringValue = @"4";
            self.workSizeOverride.state = NSOffState;
            self.vectorOverride.state = NSOffState;
            self.quietOutput.state = NSOnState;
            self.debugOutput.state = NSOffState;
        }
        
        
        NSAlert *configAlert = [[NSAlert alloc] init];
        [configAlert addButtonWithTitle:@"I understand"];
        
        [configAlert setMessageText:@"Settings changed"];
        NSString *configInfo = @"Your settings have been set to 'safe' recommended defaults that will allow you to use your computer while mining. Intensity is the key value that affects your mining speed, and needs to be higher for Scrypt mining. Click apply to save these settings.";
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

-(void)awakeFromNib
{
    
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    
    [prefs synchronize];
    
    
    if ([prefs objectForKey:@"gpuAlgoChoice"] != nil) {
        if ([[prefs objectForKey:@"gpuAlgoChoice"]  isEqual: @"0"]) {
            [self.chooseGPUAlgo selectItemAtIndex:0];
        }
        if ([[prefs objectForKey:@"gpuAlgoChoice"]  isEqual: @"1"]) {
            [self.chooseGPUAlgo selectItemAtIndex:1];
        }
        if ([[prefs objectForKey:@"gpuAlgoChoice"]  isEqual: @"2"]) {
            [self.chooseGPUAlgo selectItemAtIndex:2];
        }
        if ([[prefs objectForKey:@"gpuAlgoChoice"]  isEqual: @"3"]) {
            [self.chooseGPUAlgo selectItemAtIndex:3];
        }
    }
    
    if ([prefs objectForKey:@"startBfg"] == nil && [prefs objectForKey:@"startAsic"] == nil && [prefs objectForKey:@"startCg"] == nil && [prefs objectForKey:@"startCpu"] == nil) {
                            [self.bfgWindow orderFront:nil];
    }
    
    
    if ([prefs objectForKey:@"startBfg"] != nil) {
        
    
    if ([[prefs objectForKey:@"startBfg"] isEqualToString:@"start"]) {
        
                    [self.bfgWindow orderFront:nil];
        
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
        
        
        NSString *bfgPath = @"";
        
        NSString *bundlePath2 = [[NSBundle mainBundle] resourcePath];
        
        
        if (self.chooseGPUAlgo.indexOfSelectedItem == 0) {
            bfgPath = [bundlePath2 stringByAppendingString:@"/bfgminer/bin/bfgminer"];
        }
        if (self.chooseGPUAlgo.indexOfSelectedItem == 1) {
            bfgPath = [bundlePath2 stringByAppendingString:@"/vertcgminer/bin/vertminer"];
        }
        if (self.chooseGPUAlgo.indexOfSelectedItem == 2) {
            bfgPath = [bundlePath2 stringByAppendingString:@"/bfgminer/bin/bfgminer"];
        }
        if (self.chooseGPUAlgo.indexOfSelectedItem == 3) {
            bfgPath = [bundlePath2 stringByAppendingString:@"/maxminer/bin/cgminer"];
        }
        
        
        
        
        [self.bfgOutputView setString:@""];
        NSString *startingText = @"Starting…";
        self.bfgStatLabel.stringValue = startingText;
        startingText = nil;
        
        
        NSMutableArray *launchArray = [NSMutableArray arrayWithObjects: @"--api-listen", @"--api-allow", @"R:0/0", @"--api-port", @"4052", nil];
        
    
        
        self.executableName = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleExecutable"];
        self.paths = NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, YES);
        self.userpath = [self.paths objectAtIndex:0];
        self.userpath2 = [self.userpath stringByAppendingPathComponent:self.executableName];    // The file will go in this directory
        self.saveBTCConfigFilePath = [self.userpath2 stringByAppendingPathComponent:@"bfgurls.conf"];
        self.saveLTCConfigFilePath = [self.userpath2 stringByAppendingPathComponent:@"ltcurls.conf"];
        NSString *saveLTCAdNConfigFilePath = [self.userpath2 stringByAppendingPathComponent:@"vtcurls.conf"];
        NSString *saveMaxConfigFilePath = [self.userpath2 stringByAppendingPathComponent:@"maxurls.conf"];
        self.userpath = nil;
        self.userpath2 = nil;
        self.paths = nil;
        self.executableName = nil;
        
        
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
        
        
        if ([self.debugOutputOn isNotEqualTo:nil]) {
            [launchArray addObject:self.debugOutputOn];
        }
        if ([self.quietOutputOn isNotEqualTo:nil]) {
            [launchArray addObject:self.quietOutputOn];
        }
        
        
        if (self.chooseGPUAlgo.indexOfSelectedItem == 0 || self.chooseGPUAlgo.indexOfSelectedItem == 2) {

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
            
        }
        
        if (self.chooseGPUAlgo.indexOfSelectedItem == 0) {
            [launchArray addObject:@"--scrypt"];
            [launchArray addObject:@"-c"];
            [launchArray addObject:self.saveLTCConfigFilePath];
            [launchArray addObject:@"-S"];
            [launchArray addObject:@"opencl:auto"];
        }
        if (self.chooseGPUAlgo.indexOfSelectedItem == 1) {
            [launchArray addObject:@"--scrypt-vert"];
            [launchArray addObject:@"-c"];
            [launchArray addObject:saveLTCAdNConfigFilePath];
        }
        if (self.chooseGPUAlgo.indexOfSelectedItem == 2) {
            [launchArray addObject:@"-c"];
            [launchArray addObject:self.saveBTCConfigFilePath];
            [launchArray addObject:@"-S"];
            [launchArray addObject:@"opencl:auto"];
        }
        if (self.chooseGPUAlgo.indexOfSelectedItem == 3) {
            [launchArray addObject:@"--keccak"];
            [launchArray addObject:@"-c"];
            [launchArray addObject:saveMaxConfigFilePath];
        }
        
        
        
        if ([self.bonusOptions isNotEqualTo:nil]) {
            NSArray *bonusStuff = [self.bonusOptions componentsSeparatedByString:@" "];
            if (bonusStuff.count >= 2) {
                [launchArray addObjectsFromArray:bonusStuff];
                bonusStuff = nil;
            }
        }
        
        
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
                BOOL ltcFileExists = [[NSFileManager defaultManager] fileExistsAtPath:self.saveLTCConfigFilePath];

            NSString *btcConfig = [NSString stringWithContentsOfFile : self.saveBTCConfigFilePath encoding:NSUTF8StringEncoding error:nil];
            NSString *ltcConfig = [NSString stringWithContentsOfFile : self.saveLTCConfigFilePath encoding:NSUTF8StringEncoding error:nil];
            
          if (fileExists) {
        if (self.chooseGPUAlgo.indexOfSelectedItem == 2) {
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
          }
                if (ltcFileExists) {
        
            //            if ([ltcConfig rangeOfString:stringUser].location != NSNotFound) {
        if (self.chooseGPUAlgo.indexOfSelectedItem == 0) {
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
        
        bfgPath = nil;
        self.saveBTCConfigFilePath = nil;
        self.saveLTCConfigFilePath = nil;
    }
        
    }
    
    prefs = nil;
 
}



@end
