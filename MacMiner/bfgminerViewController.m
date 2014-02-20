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

@synthesize acceptRead, bfgCpuThreads, bfgLookupGap, bfgOptionsView, bfgOptionsWindow, bfgOutputView, bfgPopover, bfgPopoverTriggerButton, bfgShaders, bfgStartButton, bfgStatLabel, bfgThreadConc, bfgView, bfgWindow, bonusOptions, chooseGPUAlgo, debugOutput, debugOutputOn, disableGPU, dynamicIntensity, executableName, hashRead, intenseSizeLabel, intenseSlider, intensityValue, lookupGap, noGPU, onScrypt, openOptions, paths, quietOutput, quietOutputOn, rejectRead, restartMessage, saveBTCConfigFilePath, saveLTCConfigFilePath, shaders, sliderValue, speedRead, threadConc, userpath, userpath2, useScrypt, vectorOverride, vectorSizeLabel, vectorSlide, vectorValue, workSizeLabel, workSizeOverride, worksizeValue, workSlider;

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
    
    int current = lroundf([workSlider floatValue]);
    [workSizeLabel setStringValue:[workValues objectAtIndex:current]];
    
}
- (IBAction)vectorChanged:(id)sender {
    
    int current = lroundf([vectorSlide floatValue]);
    [vectorSizeLabel setStringValue:[vectorValues objectAtIndex:current]];
    
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
    [bfgStartButton setTitle:@"Start"];
    // This stops the task and calls our callback (-processFinished)
    [bfgTask stopTask];
    searchTaskIsRunning=NO;
            speedRead.tag = 0;

    // Release the memory for this wrapper object
    
    bfgTask=nil;
    [rejectRead setStringValue:@""];
    return;
    

}

- (IBAction)start:(id)sender
{
    if (searchTaskIsRunning)
    {
                bfgStartButton.tag = 1;
        // change the button's title back for the next search
        [bfgStartButton setTitle:@"Start"];
        // This stops the task and calls our callback (-processFinished)
        [bfgTask stopTask];
        searchTaskIsRunning=NO;
                speedRead.tag = 0;

        
        // Release the memory for this wrapper object
        
        bfgTask=nil;
        [rejectRead setStringValue:@""];
        
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
        bfgStartButton.tag = 0;
        [bfgStartButton setTitle:@"Stop"];
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
        
        
        if (chooseGPUAlgo.indexOfSelectedItem == 0) {
            bfgPath = [bundlePath2 stringByAppendingString:@"/bfgminer/bin/bfgminer"];
        }
        if (chooseGPUAlgo.indexOfSelectedItem == 1) {
            bfgPath = [bundlePath2 stringByAppendingString:@"/vertcgminer/bin/vertminer"];
        }
        if (chooseGPUAlgo.indexOfSelectedItem == 2) {
            bfgPath = [bundlePath2 stringByAppendingString:@"/bfgminer/bin/bfgminer"];
        }
        if (chooseGPUAlgo.indexOfSelectedItem == 3) {
            bfgPath = [bundlePath2 stringByAppendingString:@"/maxminer/bin/cgminer"];
        }
        
        
        
        
        [bfgOutputView setString:@""];
        NSString *startingText = @"Starting…";
        bfgStatLabel.stringValue = startingText;
        startingText = nil;
        
        
        NSMutableArray *launchArray = [NSMutableArray arrayWithObjects: @"--api-listen", @"--api-allow", @"R:0/0", @"--api-port", @"4052", nil];
        
        
        
        executableName = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleExecutable"];
        paths = NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, YES);
        userpath = [paths objectAtIndex:0];
        userpath2 = [userpath stringByAppendingPathComponent:executableName];    // The file will go in this directory
        saveBTCConfigFilePath = [userpath2 stringByAppendingPathComponent:@"bfgurls.conf"];
        saveLTCConfigFilePath = [userpath2 stringByAppendingPathComponent:@"ltcurls.conf"];
        NSString *saveLTCAdNConfigFilePath = [userpath2 stringByAppendingPathComponent:@"vtcurls.conf"];
        NSString *saveMaxConfigFilePath = [userpath2 stringByAppendingPathComponent:@"maxurls.conf"];
        userpath = nil;
        userpath2 = nil;
        paths = nil;
        executableName = nil;
        
        
        intensityValue = [prefs stringForKey:@"intenseValue"];
        worksizeValue = [prefs stringForKey:@"worksizeValue"];
        vectorValue = [prefs stringForKey:@"vectorValue"];
        noGPU = [prefs stringForKey:@"disableGPU"];
        onScrypt = [prefs stringForKey:@"useScrypt"];
        debugOutputOn = [prefs stringForKey:@"debugOutput"];
        quietOutputOn = [prefs stringForKey:@"quietOutput"];
        bonusOptions = [prefs stringForKey:@"bfgOptionsValue"];
        threadConc = [prefs stringForKey:@"bfgThreadConc"];
        shaders = [prefs stringForKey:@"bfgShaders"];
        lookupGap = [prefs stringForKey:@"bfgLookupGap"];
        
        
        
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
        

        
        if ([debugOutputOn isNotEqualTo:nil]) {
            [launchArray addObject:debugOutputOn];
        }
        if ([quietOutputOn isNotEqualTo:nil]) {
            [launchArray addObject:quietOutputOn];
        }
        
        
        if (chooseGPUAlgo.indexOfSelectedItem == 0 || chooseGPUAlgo.indexOfSelectedItem == 2) {
            
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
            
        }
        
        if (chooseGPUAlgo.indexOfSelectedItem == 0) {
            [launchArray addObject:@"--scrypt"];
            [launchArray addObject:@"-c"];
            [launchArray addObject:saveLTCConfigFilePath];
            [launchArray addObject:@"-S"];
            [launchArray addObject:@"opencl:auto"];
        }
        if (chooseGPUAlgo.indexOfSelectedItem == 1) {
            [launchArray addObject:@"--scrypt-vert"];
            [launchArray addObject:@"-c"];
            [launchArray addObject:saveLTCAdNConfigFilePath];
        }
        if (chooseGPUAlgo.indexOfSelectedItem == 2) {
            [launchArray addObject:@"-c"];
            [launchArray addObject:saveBTCConfigFilePath];
            [launchArray addObject:@"-S"];
            [launchArray addObject:@"opencl:auto"];
        }
        if (chooseGPUAlgo.indexOfSelectedItem == 3) {
            [launchArray addObject:@"--keccak"];
            [launchArray addObject:@"-c"];
            [launchArray addObject:saveMaxConfigFilePath];
        }
        
        
        
        if ([bonusOptions isNotEqualTo:nil]) {
            NSArray *bonusStuff = [bonusOptions componentsSeparatedByString:@" "];
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
        
        lookupGap = nil;
        shaders = nil;
        threadConc = nil;
        
        
        BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:saveBTCConfigFilePath];
        BOOL fileExists2 = [[NSFileManager defaultManager] fileExistsAtPath:saveLTCConfigFilePath];
        if (fileExists && fileExists2) {
            NSString *btcConfig = [NSString stringWithContentsOfFile : saveBTCConfigFilePath encoding:NSUTF8StringEncoding error:nil];
            NSString *ltcConfig = [NSString stringWithContentsOfFile : saveLTCConfigFilePath encoding:NSUTF8StringEncoding error:nil];
            

        if (chooseGPUAlgo.indexOfSelectedItem == 2) {
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
                
                [startAlert setMessageText:@"GPU Miner has started"];
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
                        
                        [startAlert beginSheetModalForWindow:bfgWindow modalDelegate:self didEndSelector:nil contextInfo:nil];
            }
            
//            if ([ltcConfig rangeOfString:stringUser].location != NSNotFound) {
        if (chooseGPUAlgo.indexOfSelectedItem == 0) {
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
                        
                        [startAlert setMessageText:@"GPU Miner has started"];
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
        saveBTCConfigFilePath = nil;
        saveLTCConfigFilePath = nil;

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
    
    if ([speedRead.stringValue isNotEqualTo:@"0"]) {
        speedRead.tag = 1;
    }
    
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    
    [prefs synchronize];
     
    if ([output rangeOfString:@"Invalid value passed to set intensity"].location != NSNotFound) {
        NSString *newOutput = [bfgOutputView.string stringByAppendingString:@"Please set an Intensity of 8 or higher"];
        
        bfgOutputView.string = newOutput;
        
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
        speedRead.stringValue = [numberString stringByReplacingOccurrencesOfString:@" " withString:@""];
        numberString = nil;
        NSString *acceptString = [self getDataBetweenFromString:output
                                                     leftString:@"A:" rightString:@"R" leftOffset:0];
        acceptRead.stringValue = [acceptString stringByReplacingOccurrencesOfString:@"A:" withString:@"Accepted: "];
        acceptString = nil;
        NSString *rejectString = [self getDataBetweenFromString:output
                                                     leftString:@"R:" rightString:@"H" leftOffset:0];
        rejectString = [rejectString stringByReplacingOccurrencesOfString:@"+0(none)" withString:@""];
        rejectRead.stringValue = [rejectString stringByReplacingOccurrencesOfString:@"R:" withString:@"Rejected: "];
        rejectString = nil;
        
            if ([output rangeOfString:@"kh"].location != NSNotFound) {
             hashRead.stringValue = @"Kh";
            }
        if ([output rangeOfString:@"Kh"].location != NSNotFound) {
            hashRead.stringValue = @"Kh";
        }
        if ([output rangeOfString:@"Mh"].location != NSNotFound) {
            hashRead.stringValue = @"Mh";
        }
        if ([output rangeOfString:@"Gh"].location != NSNotFound) {
            hashRead.stringValue = @"Gh";
        }

        
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        
        [prefs synchronize];

                if ([prefs objectForKey:@"showDockReading"]) {
        
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
                    appDelegate.bfgReading.stringValue = [speedRead.stringValue stringByAppendingString:hashRead.stringValue];
                    [appDelegate.bfgReadBack setHidden:NO];
                    [appDelegate.bfgReading setHidden:NO];
                    [[NSApp dockTile] display];
                    appDelegate = nil;
                }

                }
        else
        {
            AppDelegate *appDelegate = (AppDelegate *)[[NSApplication sharedApplication] delegate];
            appDelegate.bfgReading.stringValue = [speedRead.stringValue stringByAppendingString:hashRead.stringValue];
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
       
       NSString *newOutput = [bfgOutputView.string stringByAppendingString:output];

            bfgOutputView.string = newOutput;
        
        newOutput = nil;
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    
    [prefs synchronize];
    
        NSString *logLength = @"1";
        if ([prefs objectForKey:@"logLength"]) {
            logLength = [prefs objectForKey:@"logLength" ];
        }
        if (logLength.intValue <= 1) {
            logLength = @"5000";
        }
    if (bfgOutputView.string.length >= logLength.intValue) {
        [bfgOutputView setEditable:true];
        [bfgOutputView setSelectedRange:NSMakeRange(0,1000)];
        [bfgOutputView delete:nil];
        [bfgOutputView setEditable:false];
        logLength = nil;
    }

        
        // setup a selector to be called the next time through the event loop to scroll
        // the view to the just pasted text.  We don't want to scroll right now,
        // because of a bug in Mac OS X version 10.1 that causes scrolling in the context
        // of a text storage update to starve the app of events

                        if ([prefs objectForKey:@"scrollLog"]) {
        
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
    [bfgOutputView scrollRangeToVisible:NSMakeRange([[bfgOutputView string] length], 0)];
}

// A callback that gets called when a TaskWrapper is launched, allowing us to do any setup
// that is needed from the app side.  This method is implemented as a part of conforming
// to the ProcessController protocol.
- (void)taskWrapperWillStartTask:(TaskWrapper *)taskWrapper
{
    //    AppDelegate *appDelegate = (AppDelegate *)[[NSApplication sharedApplication] delegate];
    searchTaskIsRunning=YES;

    // clear the results
    //    [outputView setString:@""];
    // change the "Start" button to say "Stop"
    [bfgStartButton setTitle:@"Stop"];
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
            speedRead.tag = 0;

    // change the button's title back for the next search
    [bfgStartButton setTitle:@"Start"];
    
    if (bfgStartButton.tag == 0) {
        
        [self performSelector:@selector(start:) withObject:nil afterDelay:10.0];
    
    restartMessage = [[NSAlert alloc] init];
    [restartMessage addButtonWithTitle:@"Umm… OK."];
    
    [restartMessage setMessageText:@"Settings changed"];
    
    NSDate * now = [NSDate date];
    NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
    [outputFormatter setDateFormat:@"HH:mm:ss"];
    NSString *newDateString = [outputFormatter stringFromDate:now];
    NSLog(@"newDateString %@", newDateString);
    outputFormatter = nil;
    NSString *restartMessageInfo = [NSString stringWithFormat:@"Your miner was restarted automatically after a sudden stop at %@.", newDateString];
    [restartMessage setInformativeText:restartMessageInfo];
    
    [restartMessage setAlertStyle:NSWarningAlertStyle];
    //        returnCode: (NSInteger)returnCode
    
    [restartMessage beginSheetModalForWindow:bfgWindow modalDelegate:self didEndSelector:nil contextInfo:nil];
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
        bfgStatLabel.tag = 0;
            speedRead.tag = 0;
    bfgTask=nil;
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
        NSString *cpuThreads = [prefs stringForKey:@"bfgCpuThreads"];


        if ([cpuThreads isNotEqualTo:nil]) {
            bfgCpuThreads.stringValue = cpuThreads;
        }
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
        
                                if ([prefs objectForKey:@"gpuAlgoChoice"]) {
        if ([[prefs objectForKey:@"gpuAlgoChoice"]  isEqual: @"0"]) {
            [chooseGPUAlgo selectItemAtIndex:0];
        }
        if ([[prefs objectForKey:@"gpuAlgoChoice"]  isEqual: @"1"]) {
            [chooseGPUAlgo selectItemAtIndex:1];
        }
        if ([[prefs objectForKey:@"gpuAlgoChoice"]  isEqual: @"2"]) {
            [chooseGPUAlgo selectItemAtIndex:2];
        }
        if ([[prefs objectForKey:@"gpuAlgoChoice"]  isEqual: @"3"]) {
            [chooseGPUAlgo selectItemAtIndex:3];
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
    else {
        [prefs setObject:nil forKey:@"bfgThreadConc"];
    }
    if (bfgShaders.stringValue.length >= 1) {
        [prefs setObject:bfgShaders.stringValue forKey:@"bfgShaders"];
    }
    else {
        [prefs setObject:nil forKey:@"bfgShaders"];
    }
    if (bfgLookupGap.stringValue.length >= 1) {
        [prefs setObject:bfgLookupGap.stringValue forKey:@"bfgLookupGap"];
    }
    else {
        [prefs setObject:nil forKey:@"bfgLookupGap"];
    }
    
    [prefs setObject:bfgOptionsView.stringValue forKey:@"bfgOptionsValue"];
    
    [prefs synchronize];

        [openOptions setState:NSOffState];
        [bfgOptionsWindow orderOut:sender];
    
    if (chooseGPUAlgo.indexOfSelectedItem == 0) {
        [prefs setObject:@"0" forKey:@"gpuAlgoChoice"];
    }
    if (chooseGPUAlgo.indexOfSelectedItem == 1) {
        [prefs setObject:@"1" forKey:@"gpuAlgoChoice"];
    }
    if (chooseGPUAlgo.indexOfSelectedItem == 2) {
        [prefs setObject:@"2" forKey:@"gpuAlgoChoice"];
    }
    if (chooseGPUAlgo.indexOfSelectedItem == 3) {
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
            dynamicIntensity.state = NSOffState;
            intenseSizeLabel.stringValue = @"4";
            workSizeOverride.state = NSOffState;
            vectorOverride.state = NSOffState;
            quietOutput.state = NSOnState;
            debugOutput.state = NSOffState;
        }
        if ([model_ns rangeOfString:@"MacBook"].location != NSNotFound) {

                    if ([model_ns rangeOfString:@"MacBookPro8,2"].location != NSNotFound || [model_ns rangeOfString:@"MacBookPro8,3"].location != NSNotFound) {
                        dynamicIntensity.state = NSOffState;
                        intenseSizeLabel.stringValue = @"4";
                        workSizeOverride.state = NSOnState;
                        workSizeLabel.stringValue = @"128";
                        vectorOverride.state = NSOffState;
                        quietOutput.state = NSOnState;
                        debugOutput.state = NSOffState;
                    }
            else
            dynamicIntensity.state = NSOffState;
            intenseSizeLabel.stringValue = @"4";
            workSizeOverride.state = NSOffState;
            vectorOverride.state = NSOffState;
            quietOutput.state = NSOnState;
            debugOutput.state = NSOffState;
        }
        if ([model_ns rangeOfString:@"Mini"].location != NSNotFound) {
            dynamicIntensity.state = NSOffState;
            intenseSizeLabel.stringValue = @"4";
            workSizeOverride.state = NSOffState;
            vectorOverride.state = NSOffState;
            quietOutput.state = NSOnState;
            debugOutput.state = NSOffState;
        }
        if ([model_ns rangeOfString:@"iMac"].location != NSNotFound) {
            
            if ([model_ns rangeOfString:@"iMac12,1"].location != NSNotFound || [model_ns rangeOfString:@"iMac12,2"].location != NSNotFound) {
                dynamicIntensity.state = NSOffState;
                intenseSizeLabel.stringValue = @"4";
                workSizeOverride.state = NSOnState;
                workSizeLabel.stringValue = @"128";
                vectorOverride.state = NSOffState;
                quietOutput.state = NSOnState;
                debugOutput.state = NSOffState;
            }
            else
            dynamicIntensity.state = NSOffState;
            intenseSizeLabel.stringValue = @"4";
            workSizeOverride.state = NSOffState;
            vectorOverride.state = NSOffState;
            quietOutput.state = NSOnState;
            debugOutput.state = NSOffState;
        }
        
        
        NSAlert *configAlert = [[NSAlert alloc] init];
        [configAlert addButtonWithTitle:@"I understand"];
        
        [configAlert setMessageText:@"Settings changed"];
        NSString *configInfo = @"Your settings have been set to 'safe' recommended defaults that will allow you to use your computer while mining. Intensity is the key value that affects your mining speed, and needs to be higher for Scrypt mining. Click apply to save these settings.";
        [configAlert setInformativeText:configInfo];
        
        configInfo = nil;
        
        [configAlert setAlertStyle:NSWarningAlertStyle];
        //        returnCode: (NSInteger)returnCode
        
        [configAlert beginSheetModalForWindow:bfgOptionsWindow modalDelegate:self didEndSelector:nil contextInfo:nil];

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
    
    [configAlert beginSheetModalForWindow:bfgOptionsWindow modalDelegate:self didEndSelector:nil contextInfo:nil];
    }
    
}

-(void)awakeFromNib
{
    
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    
    [prefs synchronize];
    
    
    if ([prefs objectForKey:@"gpuAlgoChoice"]) {
        if ([[prefs objectForKey:@"gpuAlgoChoice"]  isEqual: @"0"]) {
            [chooseGPUAlgo selectItemAtIndex:0];
        }
        if ([[prefs objectForKey:@"gpuAlgoChoice"]  isEqual: @"1"]) {
            [chooseGPUAlgo selectItemAtIndex:1];
        }
        if ([[prefs objectForKey:@"gpuAlgoChoice"]  isEqual: @"2"]) {
            [chooseGPUAlgo selectItemAtIndex:2];
        }
        if ([[prefs objectForKey:@"gpuAlgoChoice"]  isEqual: @"3"]) {
            [chooseGPUAlgo selectItemAtIndex:3];
        }
    }
    
    if ([prefs objectForKey:@"startBfg"] == nil && [prefs objectForKey:@"startAsic"] == nil && [prefs objectForKey:@"startCg"] == nil && [prefs objectForKey:@"startCpu"] == nil) {
                            [bfgWindow orderFront:nil];
    }
    
    
    if ([prefs objectForKey:@"startBfg"]) {
        
    
    if ([[prefs objectForKey:@"startBfg"] isEqualToString:@"start"]) {
        
                    [bfgWindow orderFront:nil];
        
        [bfgStartButton setTitle:@"Stop"];
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
        
        
        if (chooseGPUAlgo.indexOfSelectedItem == 0) {
            bfgPath = [bundlePath2 stringByAppendingString:@"/bfgminer/bin/bfgminer"];
        }
        if (chooseGPUAlgo.indexOfSelectedItem == 1) {
            bfgPath = [bundlePath2 stringByAppendingString:@"/vertcgminer/bin/vertminer"];
        }
        if (chooseGPUAlgo.indexOfSelectedItem == 2) {
            bfgPath = [bundlePath2 stringByAppendingString:@"/bfgminer/bin/bfgminer"];
        }
        if (chooseGPUAlgo.indexOfSelectedItem == 3) {
            bfgPath = [bundlePath2 stringByAppendingString:@"/maxminer/bin/cgminer"];
        }
        
        
        
        
        [bfgOutputView setString:@""];
        NSString *startingText = @"Starting…";
        bfgStatLabel.stringValue = startingText;
        startingText = nil;
        
        
        NSMutableArray *launchArray = [NSMutableArray arrayWithObjects: @"--api-listen", @"--api-allow", @"R:0/0", @"--api-port", @"4052", nil];
        
    
        
        executableName = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleExecutable"];
        paths = NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, YES);
        userpath = [paths objectAtIndex:0];
        userpath2 = [userpath stringByAppendingPathComponent:executableName];    // The file will go in this directory
        saveBTCConfigFilePath = [userpath2 stringByAppendingPathComponent:@"bfgurls.conf"];
        saveLTCConfigFilePath = [userpath2 stringByAppendingPathComponent:@"ltcurls.conf"];
        NSString *saveLTCAdNConfigFilePath = [userpath2 stringByAppendingPathComponent:@"vtcurls.conf"];
        NSString *saveMaxConfigFilePath = [userpath2 stringByAppendingPathComponent:@"maxurls.conf"];
        userpath = nil;
        userpath2 = nil;
        paths = nil;
        executableName = nil;
        
        
        intensityValue = [prefs stringForKey:@"intenseValue"];
        worksizeValue = [prefs stringForKey:@"worksizeValue"];
        vectorValue = [prefs stringForKey:@"vectorValue"];
        noGPU = [prefs stringForKey:@"disableGPU"];
        onScrypt = [prefs stringForKey:@"useScrypt"];
        debugOutputOn = [prefs stringForKey:@"debugOutput"];
        quietOutputOn = [prefs stringForKey:@"quietOutput"];
        bonusOptions = [prefs stringForKey:@"bfgOptionsValue"];
        threadConc = [prefs stringForKey:@"bfgThreadConc"];
        shaders = [prefs stringForKey:@"bfgShaders"];
        lookupGap = [prefs stringForKey:@"bfgLookupGap"];
        
        
        
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
        
        
        if ([debugOutputOn isNotEqualTo:nil]) {
            [launchArray addObject:debugOutputOn];
        }
        if ([quietOutputOn isNotEqualTo:nil]) {
            [launchArray addObject:quietOutputOn];
        }
        
        
        if (chooseGPUAlgo.indexOfSelectedItem == 0 || chooseGPUAlgo.indexOfSelectedItem == 2) {

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
            
        }
        
        if (chooseGPUAlgo.indexOfSelectedItem == 0) {
            [launchArray addObject:@"--scrypt"];
            [launchArray addObject:@"-c"];
            [launchArray addObject:saveLTCConfigFilePath];
            [launchArray addObject:@"-S"];
            [launchArray addObject:@"opencl:auto"];
        }
        if (chooseGPUAlgo.indexOfSelectedItem == 1) {
            [launchArray addObject:@"--scrypt-vert"];
            [launchArray addObject:@"-c"];
            [launchArray addObject:saveLTCAdNConfigFilePath];
        }
        if (chooseGPUAlgo.indexOfSelectedItem == 2) {
            [launchArray addObject:@"-c"];
            [launchArray addObject:saveBTCConfigFilePath];
            [launchArray addObject:@"-S"];
            [launchArray addObject:@"opencl:auto"];
        }
        if (chooseGPUAlgo.indexOfSelectedItem == 3) {
            [launchArray addObject:@"--keccak"];
            [launchArray addObject:@"-c"];
            [launchArray addObject:saveMaxConfigFilePath];
        }
        
        
        
        if ([bonusOptions isNotEqualTo:nil]) {
            NSArray *bonusStuff = [bonusOptions componentsSeparatedByString:@" "];
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
        
        lookupGap = nil;
        shaders = nil;
        threadConc = nil;
        
        
        BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:saveBTCConfigFilePath];
        if (fileExists) {
            NSString *btcConfig = [NSString stringWithContentsOfFile : saveBTCConfigFilePath encoding:NSUTF8StringEncoding error:nil];
            NSString *ltcConfig = [NSString stringWithContentsOfFile : saveLTCConfigFilePath encoding:NSUTF8StringEncoding error:nil];
            
            
        if (chooseGPUAlgo.indexOfSelectedItem == 2) {
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
                
                [startAlert beginSheetModalForWindow:bfgWindow modalDelegate:self didEndSelector:nil contextInfo:nil];
            }
            
            //            if ([ltcConfig rangeOfString:stringUser].location != NSNotFound) {
        if (chooseGPUAlgo.indexOfSelectedItem == 0) {
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
        
        bfgPath = nil;
        saveBTCConfigFilePath = nil;
        saveLTCConfigFilePath = nil;
    }
        
    }
    
    prefs = nil;
 
}



@end
