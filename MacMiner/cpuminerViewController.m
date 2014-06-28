//
//  cpuminerViewController.m
//  MacMiner
//
//  Created by Administrator on 01/05/2013.
//  Copyright (c) 2013 fabulouspanda. All rights reserved.
//

#import "cpuminerViewController.h"
#import "AppDelegate.h"

@implementation cpuminerViewController

//io_connect_t conn;



- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:(NSCoder *)aDecoder];
    if (self) {
        // Initialization code here.
        //            NSLog(@"startup");
        //        AppDelegate *appDelegate = (AppDelegate *)[[NSApplication sharedApplication] delegate];
        
        
        
        self.cpuOutputView.delegate = self;
        self.cpuStatLabel.delegate = self;

        

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

- (IBAction)cpuDisplayHelp:(id)sender
{
    [[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:@"http://fabulouspanda.co.uk/macminer/docs/"]];
}


- (IBAction)start:(id)sender
{
    if (findRunning)
    {
        // change the button's title back for the next search
        [self.cpuStartButton setTitle:@"Start"];
        // This stops the task and calls our callback (-processFinished)
        [cpuTask stopTask];
        findRunning=NO;
        self.cpuHashLabel.tag = 0;
        [self.cpuHashLabel setStringValue:@"0"];
        // Release the memory for this wrapper object
        
        cpuTask=nil;
        
        AppDelegate *appDelegate = (AppDelegate *)[[NSApplication sharedApplication] delegate];
        appDelegate.cpuReading.stringValue = @"";
        [appDelegate.cpuReadBack setHidden:YES];
        [appDelegate.cpuReading setHidden:YES];
        
        [[NSApp dockTile] display];
        
        return;
    }
    else
    {
        [self.cpuStartButton setTitle:@"Stop"];
        // If the task is still sitting around from the last run, release it
        if (cpuTask!=nil) {
            cpuTask = nil;
        }
        
        
        
        AppDelegate *appDelegate = (AppDelegate *)[[NSApplication sharedApplication] delegate];
        appDelegate.cpuReading.stringValue = @"";
        [appDelegate.cpuReadBack setHidden:NO];
        [appDelegate.cpuReading setHidden:NO];
        
        [[NSApp dockTile] display];
        
        
        
        // Let's allocate memory for and initialize a new TaskWrapper object, passing
        // in ourselves as the controller for this TaskWrapper object, the path
        // to the command-line tool, and the contents of the text field that
        // displays what the user wants to search on
        
        
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        
        [prefs synchronize];
        
        
        NSString *mainLTCPool = [prefs stringForKey:@"defaultLTCPoolValue"];
        NSString *mainLTCUser = [prefs stringForKey:@"defaultLTCUser"];
        NSString *mainLTCPass = [prefs stringForKey:@"defaultLTCPass"];
        
        
        NSString *executableName = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleExecutable"];
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, YES);
        NSString *userpath = [paths objectAtIndex:0];
        userpath = [userpath stringByAppendingPathComponent:executableName];    // The file will go in this directory
        NSString *saveLTCConfigFilePath = @"";
        
        if (self.chooseAlgo.indexOfSelectedItem == 0) {
        saveLTCConfigFilePath = [userpath stringByAppendingPathComponent:@"ltcurls.conf"];
        }
        if (self.chooseAlgo.indexOfSelectedItem == 1) {
        saveLTCConfigFilePath = [userpath stringByAppendingPathComponent:@"vtcurls.conf"];
        }
        if (self.chooseAlgo.indexOfSelectedItem == 2) {
        saveLTCConfigFilePath = [userpath stringByAppendingPathComponent:@"qrkurls.conf"];
        }
        if (self.chooseAlgo.indexOfSelectedItem == 3) {
        saveLTCConfigFilePath = [userpath stringByAppendingPathComponent:@"bfgurls.conf"];
        }
        if (self.chooseAlgo.indexOfSelectedItem == 4) {
            saveLTCConfigFilePath = [userpath stringByAppendingPathComponent:@"maxurls.conf"];
        }
        if (self.chooseAlgo.indexOfSelectedItem == 5) {
            saveLTCConfigFilePath = [userpath stringByAppendingPathComponent:@"ltcurls.conf"];
        }
        if (self.chooseAlgo.indexOfSelectedItem == 6) {
            saveLTCConfigFilePath = [userpath stringByAppendingPathComponent:@"x11urls.conf"];
        }

        BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:saveLTCConfigFilePath];
        if (fileExists) {

            
        NSString *stringUser = [[NSString alloc] initWithContentsOfFile:saveLTCConfigFilePath encoding:NSUTF8StringEncoding error:nil];
        
        
            NSString *userFind = @"user";
            if ([stringUser rangeOfString:userFind].location != NSNotFound) {
                NSString *foundURLString = [self getDataBetweenFromString:stringUser
                                                                leftString:@"url" rightString:@"," leftOffset:8];
                NSString *URLClean = foundURLString;
                mainLTCPool = [URLClean stringByReplacingOccurrencesOfString:@"\"" withString:@""];
                NSString *foundUserString = [self getDataBetweenFromString:stringUser
                                                                leftString:@"user" rightString:@"," leftOffset:8];
                NSString *stepClean = foundUserString;
                mainLTCUser = [stepClean stringByReplacingOccurrencesOfString:@"\"" withString:@""];
                
                NSString *foundPassString = [self getDataBetweenFromString:stringUser
                                                                leftString:@"pass" rightString:@"\"" leftOffset:9];
                NSString *passClean = foundPassString;
                mainLTCPass = [passClean stringByReplacingOccurrencesOfString:@"\"" withString:@""];
        }


        
        NSString *cpuThreadsV = [prefs stringForKey:@"cpuThreadsValue"];
//        NSString *cpuScryptV = [prefs stringForKey:@"cpuUseScryptValue"];
        NSString *cpuQuietV = [prefs stringForKey:@"cpuQuietOutput"];
        NSString *cpuDebugV = [prefs stringForKey:@"cpuDebugOutput"];
        NSString *cpuOptionsV = [prefs stringForKey:@"cpuOptionsValue"];


        

        NSMutableArray *cpuLaunchArray = [NSMutableArray arrayWithObjects: nil];
        
        if ([cpuThreadsV isNotEqualTo:@""]) {
            [cpuLaunchArray addObject:@"-t"];
            [cpuLaunchArray addObject:cpuThreadsV];
        }

        
        if (self.chooseAlgo.indexOfSelectedItem == 0) {
            [cpuLaunchArray addObject:@"-a"];
            [cpuLaunchArray addObject:@"scrypt"];
            [cpuLaunchArray addObject:@"-o"];
            [cpuLaunchArray addObject:mainLTCPool];
            [cpuLaunchArray addObject:@"-u"];
            [cpuLaunchArray addObject:mainLTCUser];
            [cpuLaunchArray addObject:@"-p"];
            [cpuLaunchArray addObject:mainLTCPass];
        }
        if (self.chooseAlgo.indexOfSelectedItem == 1) {
            [cpuLaunchArray addObject:@"-o"];
            [cpuLaunchArray addObject:mainLTCPool];
            [cpuLaunchArray addObject:@"-u"];
            [cpuLaunchArray addObject:mainLTCUser];
            [cpuLaunchArray addObject:@"-p"];
            [cpuLaunchArray addObject:mainLTCPass];
        }
        if (self.chooseAlgo.indexOfSelectedItem == 2) {
            [cpuLaunchArray addObject:@"--algo=quark"];
//            [cpuLaunchArray addObject:@"quark"];
            [cpuLaunchArray addObject:@"-o"];
            [cpuLaunchArray addObject:mainLTCPool];
            [cpuLaunchArray addObject:@"-u"];
            [cpuLaunchArray addObject:mainLTCUser];
            [cpuLaunchArray addObject:@"-p"];
            [cpuLaunchArray addObject:mainLTCPass];
        }
        if (self.chooseAlgo.indexOfSelectedItem == 3) {
            [cpuLaunchArray addObject:@"-a"];
            [cpuLaunchArray addObject:@"sha256d"];
            [cpuLaunchArray addObject:@"-o"];
            [cpuLaunchArray addObject:mainLTCPool];
            [cpuLaunchArray addObject:@"-u"];
            [cpuLaunchArray addObject:mainLTCUser];
            [cpuLaunchArray addObject:@"-p"];
            [cpuLaunchArray addObject:mainLTCPass];
        }
        if (self.chooseAlgo.indexOfSelectedItem == 4) {
            [cpuLaunchArray addObject:@"--algo=keccak"];
            [cpuLaunchArray addObject:@"-o"];
            [cpuLaunchArray addObject:mainLTCPool];
            [cpuLaunchArray addObject:@"-u"];
            [cpuLaunchArray addObject:mainLTCUser];
            [cpuLaunchArray addObject:@"-p"];
            [cpuLaunchArray addObject:mainLTCPass];
        }
            if (self.chooseAlgo.indexOfSelectedItem == 5) {
                [cpuLaunchArray addObject:@"-a"];
                [cpuLaunchArray addObject:@"scrypt"];
                [cpuLaunchArray addObject:@"-o"];
                [cpuLaunchArray addObject:mainLTCPool];
                [cpuLaunchArray addObject:@"-u"];
                [cpuLaunchArray addObject:mainLTCUser];
                [cpuLaunchArray addObject:@"-p"];
                [cpuLaunchArray addObject:mainLTCPass];
            }
            if (self.chooseAlgo.indexOfSelectedItem == 6) {
                [cpuLaunchArray addObject:@"-a"];
                [cpuLaunchArray addObject:@"x11"];
                [cpuLaunchArray addObject:@"-o"];
                [cpuLaunchArray addObject:mainLTCPool];
                [cpuLaunchArray addObject:@"-u"];
                [cpuLaunchArray addObject:mainLTCUser];
                [cpuLaunchArray addObject:@"-p"];
                [cpuLaunchArray addObject:mainLTCPass];
            }


        if ([cpuQuietV isNotEqualTo:nil]) {
            [cpuLaunchArray addObject:@"-q"];
        }
        if ([cpuDebugV isNotEqualTo:nil]) {
            [cpuLaunchArray addObject:@"-D"];
        }
        
        
        if ([cpuOptionsV isNotEqualTo:nil]) {
            NSArray *cpuBonusStuff = [cpuOptionsV componentsSeparatedByString:@" "];
            if (cpuBonusStuff.count >= 2) {
                [cpuLaunchArray addObjectsFromArray:cpuBonusStuff];
                cpuBonusStuff = nil;
            }
        }
        //        NSString *logit = [cpuLaunchArray componentsJoinedByString:@" "];
        //        NSLog(logit);
        
        NSString *bundlePath = [[NSBundle mainBundle] resourcePath];
        NSString *cpuPath = [bundlePath stringByDeletingLastPathComponent];
        
            if (self.chooseAlgo.indexOfSelectedItem == 1) {
                cpuPath = [cpuPath stringByAppendingString:@"/Resources/bin/minerd"];
            }
            else if (self.chooseAlgo.indexOfSelectedItem == 4) {
                cpuPath = [cpuPath stringByAppendingString:@"/Resources/maxcoincpu/bin/minerd"];
            }
            else if (self.chooseAlgo.indexOfSelectedItem == 5) {
                cpuPath = [cpuPath stringByAppendingString:@"/Resources/gridseedcpu4/bin/minerd"];
            }
            else if (self.chooseAlgo.indexOfSelectedItem == 6) {
                cpuPath = [cpuPath stringByAppendingString:@"/Resources/gridseedcpu4/bin/minerd"];
            }
            else {
                cpuPath = [cpuPath stringByAppendingString:@"/Resources/x11cpuminer/bin/minerd"];
            }
        //        NSLog(cpuPath);
        [self.cpuOutputView setString:@""];
        NSString *startingText = @"Starting…";
        self.cpuStatLabel.stringValue = startingText;
        //            self.outputView.string = [self.outputView.string stringByAppendingString:cpuPath];
        //            self.outputView.string = [self.outputView.string stringByAppendingString:finalNecessities];
        //            cpuTask=[[TaskWrapper alloc] initWithController:self arguments:[NSArray arrayWithObjects:cpuPath, cpuPath, poolplus, userpass, nil]];
        cpuTask = [[TaskWrapper alloc] initWithCommandPath:cpuPath
                                                 arguments:cpuLaunchArray
                                               environment:nil
                                                  delegate:self];
        // kick off the process asynchronously
        //        [cpuTask setLaunchPath: @"/sbin/ping"];
        [cpuTask startTask];
        }

        if (fileExists) {

            NSString *ltcConfig = [NSString stringWithContentsOfFile : saveLTCConfigFilePath encoding:NSUTF8StringEncoding error:nil];
            
            
 

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
                
                [startAlert setMessageText:@"cpuminer has started"];
                NSString *infoText = [@"The primary pool is set to " stringByAppendingString:bfgURLValue];

                NSString *infoText2 = [infoText stringByAppendingString:@" and the user is set to "];
                NSString *infoText3 = [infoText2 stringByAppendingString:bfgUserValue];
                [startAlert setInformativeText:infoText3];
            infoText = nil;
            infoText2 = nil;
            infoText3 = nil;
                //            [[NSAlert init] alertWithMessageText:@"This app requires python pip. Click 'Install' and you will be asked your password so it can be installed, or click 'Quit' and install pip yourself before relaunching this app." defaultButton:@"Install" alternateButton:@"Quit" otherButton:nil informativeTextWithFormat:nil];
                //            NSAlertDefaultReturn = [self performSelector:@selector(installPip:)];
                [startAlert setAlertStyle:NSWarningAlertStyle];
                //        returnCode: (NSInteger)returnCode
                
                [startAlert beginSheetModalForWindow:self.cpuWindow modalDelegate:self didEndSelector:nil contextInfo:nil];
                
            }
            
            
        
        
    }
    
}


// This callback is implemented as part of conforming to the ProcessController protocol.
// It will be called whenever there is output from the TaskWrapper.
- (void)taskWrapper:(TaskWrapper *)taskWrapper didProduceOutput:(NSString *)output
{
    
    if ([self.cpuHashLabel.stringValue isNotEqualTo:@"0"]) {
        self.cpuHashLabel.tag = 1;
    }
    if ([self.cpuHashLabel.stringValue isEqual: @"0"] && self.cpuHashLabel.tag == 1) {
        _speechSynth = [[NSSpeechSynthesizer alloc] initWithVoice:nil];
        [self.speechSynth startSpeakingString:@"Mining Stopped"];
    }
    
    NSString *apiOutput = @"accepted:";
    if ([output rangeOfString:apiOutput].location != NSNotFound) {
        
        NSString *numberString = [self getDataBetweenFromString:output
                                                     leftString:@"accepted" rightString:@"," leftOffset:0];
        NSString *step2 = [numberString stringByReplacingOccurrencesOfString:@"a" withString:@"A"];
        self.cpuStatLabel.stringValue = [step2 stringByReplacingOccurrencesOfString:@"/" withString:@" of "];
        
        NSString *rejectString = [self getDataBetweenFromString:output
                                                     leftString:@"," rightString:@"k" leftOffset:1];
        self.cpuHashLabel.stringValue = [rejectString stringByReplacingOccurrencesOfString:@" " withString:@""];
        

        
        apiOutput = nil;
        numberString = nil;
        step2 = nil;
        rejectString = nil;

        
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        
        [prefs synchronize];
        

            if ([prefs objectForKey:@"showDockReading"]) {
        if ([[prefs objectForKey:@"showDockReading"] isEqualTo:@"hide"]) {
            AppDelegate *appDelegate = (AppDelegate *)[[NSApplication sharedApplication] delegate];
            [appDelegate.cpuReadBack setHidden:YES];
            [appDelegate.cpuReading setHidden:YES];

            [[NSApp dockTile] display];
            appDelegate = nil;
        }
        else {
            AppDelegate *appDelegate = (AppDelegate *)[[NSApplication sharedApplication] delegate];
            appDelegate.cpuReading.stringValue = [self.cpuHashLabel.stringValue stringByAppendingString:@"Kh"];
            [appDelegate.cpuReading setHidden:NO];
            [appDelegate.cpuReadBack setHidden:NO];
            
            
            [[NSApp dockTile] display];
            appDelegate = nil;
        }
                
            }
            else { 
        AppDelegate *appDelegate = (AppDelegate *)[[NSApplication sharedApplication] delegate];
        appDelegate.cpuReading.stringValue = [self.cpuHashLabel.stringValue stringByAppendingString:@"Kh"];
                    [appDelegate.cpuReading setHidden:NO];
                    [appDelegate.cpuReadBack setHidden:NO];


        [[NSApp dockTile] display];
                    appDelegate = nil;
                }
        prefs = nil;
    }
    
    else {
        
        // add the string (a chunk of the results from locate) to the NSTextView's
        // backing store, in the form of an attributed string
        
        
        
        NSString *newCPUOutput = [self.cpuOutputView.string stringByAppendingString:output];
        
    self.cpuOutputView.string = newCPUOutput;
        
        newCPUOutput = nil;
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    
    [prefs synchronize];
    
    NSString *logLength = @"1";
            if ([prefs objectForKey:@"logLength"]) {
        logLength = [prefs objectForKey:@"logLength" ];
            }
    if (logLength.intValue <= 1) {
        logLength = @"5000";
    }
    
    //limit log length
    if (self.cpuOutputView.string.length >= logLength.intValue) {
        [self.cpuOutputView setEditable:true];
        [self.cpuOutputView setSelectedRange:NSMakeRange(0,1000)];
        [self.cpuOutputView delete:nil];
        [self.cpuOutputView setEditable:false];
    }
    
    // setup a selector to be called the next time through the event loop to scroll
    // the view to the just pasted text.  We don't want to scroll right now,
    // because of a bug in Mac OS X version 10.1 that causes scrolling in the context
    // of a text storage update to starve the app of events
            if ([prefs objectForKey:@"scrollLog"]) {
                if ([[prefs objectForKey:@"scrollLog"] isNotEqualTo:@"hide"]) {
    [self performSelector:@selector(scrollToVisible:) withObject:nil afterDelay:0.0];
                }
            }
            else {
    [self performSelector:@selector(scrollToVisible:) withObject:nil afterDelay:0.0];
            }
        
        prefs = nil;
        logLength = nil;
        
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
    [self.cpuOutputView scrollRangeToVisible:NSMakeRange([[self.cpuOutputView string] length], 0)];
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
    [self.cpuStartButton setTitle:@"Stop"];
}

// A callback that gets called when a TaskWrapper is completed, allowing us to do any cleanup
// that is needed from the app side.  This method is implemented as a part of conforming
// to the ProcessController protocol.
- (void)taskWrapper:(TaskWrapper *)taskWrapper didFinishTaskWithStatus:(int)terminationStatus
{
    AppDelegate *appDelegate = (AppDelegate *)[[NSApplication sharedApplication] delegate];
    
    [appDelegate.cpuReadBack setHidden:YES];
    [appDelegate.cpuReading setHidden:YES];
    
    findRunning=NO;
    self.cpuHashLabel.tag = 0;
    // change the button's title back for the next search
    [self.cpuStartButton setTitle:@"Start"];
}

// If the user closes the window, let's just quit
-(BOOL)windowShouldClose:(id)sender
{
    //    [NSApp terminate:nil];
    cpuTask = nil;
    findRunning=NO;
    [cpuTask stopTask];
    return YES;
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
    cpuTask=nil;
    
    //    	locationSizeCache = [[NSMutableDictionary alloc] initWithCapacity:20];
    
    //    NSUserDefaults *defs = [NSUserDefaults standardUserDefaults];
    //    m = [[[XRGModule alloc] initWithName:@"Temperature" andReference:self] retain];
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    
    [prefs synchronize];
    
    if ([prefs objectForKey:@"cpuAlgoChoice"]) {
    
    if ([[prefs objectForKey:@"cpuAlgoChoice"]  isEqual: @"0"]) {
        [self.chooseAlgo selectItemAtIndex:0];
    }
    if ([[prefs objectForKey:@"cpuAlgoChoice"]  isEqual: @"1"]) {
                [self.chooseAlgo selectItemAtIndex:1];
    }
    if ([[prefs objectForKey:@"cpuAlgoChoice"]  isEqual: @"2"]) {
                [self.chooseAlgo selectItemAtIndex:2];
    }
    if ([[prefs objectForKey:@"cpuAlgoChoice"]  isEqual: @"3"]) {
                [self.chooseAlgo selectItemAtIndex:3];
    }
    if ([[prefs objectForKey:@"cpuAlgoChoice"]  isEqual: @"4"]) {
        [self.chooseAlgo selectItemAtIndex:4];
    }
        if ([[prefs objectForKey:@"cpuAlgoChoice"]  isEqual: @"5"]) {
            [self.chooseAlgo selectItemAtIndex:5];
        }
        if ([[prefs objectForKey:@"cpuAlgoChoice"]  isEqual: @"6"]) {
            [self.chooseAlgo selectItemAtIndex:6];
        }
    }
    
    if ([prefs objectForKey:@"startCpu"]) {
    if ([[prefs objectForKey:@"startCpu"] isEqualToString:@"start"]) {
        
                        [self.cpuWindow orderFront:nil];
        
        [self.cpuStartButton setTitle:@"Stop"];
        // If the task is still sitting around from the last run, release it
        if (cpuTask!=nil) {
            cpuTask = nil;
        }
        
        
        
        AppDelegate *appDelegate = (AppDelegate *)[[NSApplication sharedApplication] delegate];
        appDelegate.cpuReading.stringValue = @"";
        [appDelegate.cpuReadBack setHidden:NO];
        [appDelegate.cpuReading setHidden:NO];
        
        [[NSApp dockTile] display];
        
        
        
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        
        [prefs synchronize];
        
        
        NSString *mainLTCPool = @"";
        NSString *mainLTCUser = @"";
        NSString *mainLTCPass = @"";
        
        
        NSString *executableName = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleExecutable"];
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, YES);
        NSString *userpath = [paths objectAtIndex:0];
        userpath = [userpath stringByAppendingPathComponent:executableName];    // The file will go in this directory
        NSString *saveLTCConfigFilePath = @"";
        
        if (self.chooseAlgo.indexOfSelectedItem == 0) {
            saveLTCConfigFilePath = [userpath stringByAppendingPathComponent:@"ltcurls.conf"];
        }
        if (self.chooseAlgo.indexOfSelectedItem == 1) {
            saveLTCConfigFilePath = [userpath stringByAppendingPathComponent:@"vtcurls.conf"];
        }
        if (self.chooseAlgo.indexOfSelectedItem == 2) {
            saveLTCConfigFilePath = [userpath stringByAppendingPathComponent:@"qrkurls.conf"];
        }
        if (self.chooseAlgo.indexOfSelectedItem == 3) {
            saveLTCConfigFilePath = [userpath stringByAppendingPathComponent:@"bfgurls.conf"];
        }
        if (self.chooseAlgo.indexOfSelectedItem == 4) {
            saveLTCConfigFilePath = [userpath stringByAppendingPathComponent:@"maxurls.conf"];
        }
        if (self.chooseAlgo.indexOfSelectedItem == 5) {
            saveLTCConfigFilePath = [userpath stringByAppendingPathComponent:@"ltcurls.conf"];
        }
        if (self.chooseAlgo.indexOfSelectedItem == 6) {
            saveLTCConfigFilePath = [userpath stringByAppendingPathComponent:@"x11urls.conf"];
        }
        
        BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:saveLTCConfigFilePath];
        if (fileExists) {
            
        NSString *stringUser = [[NSString alloc] initWithContentsOfFile:saveLTCConfigFilePath encoding:NSUTF8StringEncoding error:nil];
        
        NSString *userFind = @"user";
        if ([stringUser rangeOfString:userFind].location != NSNotFound) {
            NSString *foundURLString = [self getDataBetweenFromString:stringUser
                                                           leftString:@"url" rightString:@"," leftOffset:8];
            NSString *URLClean = foundURLString;
            mainLTCPool = [URLClean stringByReplacingOccurrencesOfString:@"\"" withString:@""];
            NSString *foundUserString = [self getDataBetweenFromString:stringUser
                                                            leftString:@"user" rightString:@"," leftOffset:8];
            NSString *stepClean = foundUserString;
            mainLTCUser = [stepClean stringByReplacingOccurrencesOfString:@"\"" withString:@""];
            
            NSString *foundPassString = [self getDataBetweenFromString:stringUser
                                                            leftString:@"pass" rightString:@"\"" leftOffset:9];
            NSString *passClean = foundPassString;
            mainLTCPass = [passClean stringByReplacingOccurrencesOfString:@"\"" withString:@""];
        }
        
        
        
        NSString *cpuThreadsV = [prefs stringForKey:@"cpuThreadsValue"];
        //        NSString *cpuScryptV = [prefs stringForKey:@"cpuUseScryptValue"];
        NSString *cpuQuietV = [prefs stringForKey:@"cpuQuietOutput"];
        NSString *cpuDebugV = [prefs stringForKey:@"cpuDebugOutput"];
        NSString *cpuOptionsV = [prefs stringForKey:@"cpuOptionsValue"];
        
        
        
        
        NSMutableArray *cpuLaunchArray = [NSMutableArray arrayWithObjects: nil];
        
        if ([cpuThreadsV isNotEqualTo:@""]) {
            [cpuLaunchArray addObject:@"-t"];
            [cpuLaunchArray addObject:cpuThreadsV];
        }
        
        
        if (self.chooseAlgo.indexOfSelectedItem == 0) {
            [cpuLaunchArray addObject:@"-a"];
            [cpuLaunchArray addObject:@"scrypt"];
            [cpuLaunchArray addObject:@"-o"];
            [cpuLaunchArray addObject:mainLTCPool];
            [cpuLaunchArray addObject:@"-u"];
            [cpuLaunchArray addObject:mainLTCUser];
            [cpuLaunchArray addObject:@"-p"];
            [cpuLaunchArray addObject:mainLTCPass];
        }//VertCoin:
        if (self.chooseAlgo.indexOfSelectedItem == 1) {
            [cpuLaunchArray addObject:@"-o"];
            [cpuLaunchArray addObject:mainLTCPool];
            [cpuLaunchArray addObject:@"-u"];
            [cpuLaunchArray addObject:mainLTCUser];
            [cpuLaunchArray addObject:@"-p"];
            [cpuLaunchArray addObject:mainLTCPass];
        }
        if (self.chooseAlgo.indexOfSelectedItem == 2) {
            [cpuLaunchArray addObject:@"--algo=quark"];
            //            [cpuLaunchArray addObject:@"quark"];
            [cpuLaunchArray addObject:@"-o"];
            [cpuLaunchArray addObject:mainLTCPool];
            [cpuLaunchArray addObject:@"-u"];
            [cpuLaunchArray addObject:mainLTCUser];
            [cpuLaunchArray addObject:@"-p"];
            [cpuLaunchArray addObject:mainLTCPass];
        }
        if (self.chooseAlgo.indexOfSelectedItem == 3) {
            [cpuLaunchArray addObject:@"-a"];
            [cpuLaunchArray addObject:@"sha256d"];
            [cpuLaunchArray addObject:@"-o"];
            [cpuLaunchArray addObject:mainLTCPool];
            [cpuLaunchArray addObject:@"-u"];
            [cpuLaunchArray addObject:mainLTCUser];
            [cpuLaunchArray addObject:@"-p"];
            [cpuLaunchArray addObject:mainLTCPass];
        }
        if (self.chooseAlgo.indexOfSelectedItem == 4) {
            [cpuLaunchArray addObject:@"--algo=keccak"];
            [cpuLaunchArray addObject:@"-o"];
            [cpuLaunchArray addObject:mainLTCPool];
            [cpuLaunchArray addObject:@"-u"];
            [cpuLaunchArray addObject:mainLTCUser];
            [cpuLaunchArray addObject:@"-p"];
            [cpuLaunchArray addObject:mainLTCPass];
        }
            //Gridseed
            if (self.chooseAlgo.indexOfSelectedItem == 5) {
                [cpuLaunchArray addObject:@"-a"];
                [cpuLaunchArray addObject:@"scrypt"];
                [cpuLaunchArray addObject:@"-o"];
                [cpuLaunchArray addObject:mainLTCPool];
                [cpuLaunchArray addObject:@"-u"];
                [cpuLaunchArray addObject:mainLTCUser];
                [cpuLaunchArray addObject:@"-p"];
                [cpuLaunchArray addObject:mainLTCPass];
            }
            if (self.chooseAlgo.indexOfSelectedItem == 5) {
                [cpuLaunchArray addObject:@"-a"];
                [cpuLaunchArray addObject:@"x11"];
                [cpuLaunchArray addObject:@"-o"];
                [cpuLaunchArray addObject:mainLTCPool];
                [cpuLaunchArray addObject:@"-u"];
                [cpuLaunchArray addObject:mainLTCUser];
                [cpuLaunchArray addObject:@"-p"];
                [cpuLaunchArray addObject:mainLTCPass];
            }
        
        
        if ([cpuQuietV isNotEqualTo:nil]) {
            [cpuLaunchArray addObject:@"-q"];
        }
        if ([cpuDebugV isNotEqualTo:nil]) {
            [cpuLaunchArray addObject:@"-D"];
        }
        
        
        if ([cpuOptionsV isNotEqualTo:nil]) {
            NSArray *cpuBonusStuff = [cpuOptionsV componentsSeparatedByString:@" "];
            if (cpuBonusStuff.count >= 2) {
                [cpuLaunchArray addObjectsFromArray:cpuBonusStuff];
                cpuBonusStuff = nil;
            }
        }
        //        NSString *logit = [cpuLaunchArray componentsJoinedByString:@" "];
        //        NSLog(logit);
        
        NSString *bundlePath = [[NSBundle mainBundle] resourcePath];
        NSString *cpuPath = [bundlePath stringByDeletingLastPathComponent];
        
        if (self.chooseAlgo.indexOfSelectedItem == 1) {
            cpuPath = [cpuPath stringByAppendingString:@"/Resources/bin/minerd"];
        }
        else if (self.chooseAlgo.indexOfSelectedItem == 4) {
            cpuPath = [cpuPath stringByAppendingString:@"/Resources/maxcoincpu/bin/minerd"];
        }
        else if (self.chooseAlgo.indexOfSelectedItem == 5) {
            cpuPath = [cpuPath stringByAppendingString:@"/Resources/gridseedcpu4/bin/minerd"];
        }
        else if (self.chooseAlgo.indexOfSelectedItem == 6) {
            cpuPath = [cpuPath stringByAppendingString:@"/Resources/x11cpuminer/bin/minerd"];
        }
        else {
            cpuPath = [cpuPath stringByAppendingString:@"/Resources/pooler-minerd"];
        }

        //        NSLog(cpuPath);
        [self.cpuOutputView setString:@""];
        NSString *startingText = @"Starting…";
        self.cpuStatLabel.stringValue = startingText;
        
        
        cpuTask = [[TaskWrapper alloc] initWithCommandPath:cpuPath
                                                 arguments:cpuLaunchArray
                                               environment:nil
                                                  delegate:self];
        
        [cpuTask startTask];
        
        }
        
        if (fileExists) {
            
            NSString *ltcConfig = [NSString stringWithContentsOfFile : saveLTCConfigFilePath encoding:NSUTF8StringEncoding error:nil];
            
            
            
            
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
            
            [startAlert setMessageText:@"cpuminer has started"];
            NSString *infoText = [@"The primary pool is set to " stringByAppendingString:bfgURLValue];
            
            NSString *infoText2 = [infoText stringByAppendingString:@" and the user is set to "];
            NSString *infoText3 = [infoText2 stringByAppendingString:bfgUserValue];
            [startAlert setInformativeText:infoText3];
            infoText = nil;
            infoText2 = nil;
            infoText3 = nil;
            
            
            [startAlert setAlertStyle:NSWarningAlertStyle];
            //        returnCode: (NSInteger)returnCode
            
            [startAlert beginSheetModalForWindow:self.cpuWindow modalDelegate:self didEndSelector:nil contextInfo:nil];
            
        }
        
    }
        
    }
    prefs = nil;
}

- (IBAction)cpuMinerToggle:(id)sender {
    
    
    if ([self.cpuWindow isVisible]) {
        [self.cpuWindow orderOut:sender];
    }
    else
    {
        [self.cpuWindow orderFront:sender];
    }
}

- (IBAction)cpuOptionsToggle:(id)sender {
    
    if ([self.cpuOptionsWindow isVisible]) {
        [self.cpuOptionsButton setState:NSOffState];
        [self.cpuOptionsWindow orderOut:sender];
    }
    else
    {
        [self.cpuOptionsButton setState:NSOnState];
        [self.cpuOptionsWindow orderFront:sender];
    }
}

- (IBAction)cpuOptionsApply:(id)sender {
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    if (self.cpuThreads.stringValue != nil) {
        [prefs setObject:self.cpuThreads.stringValue forKey:@"cpuThreadsValue"];
    }
    else {
        [prefs setObject:nil forKey:@"cpuThreadsValue"];
    }
    if (self.chooseAlgo.indexOfSelectedItem == 0) {
        [prefs setObject:@"0" forKey:@"cpuAlgoChoice"];
    }
    if (self.chooseAlgo.indexOfSelectedItem == 1) {
        [prefs setObject:@"1" forKey:@"cpuAlgoChoice"];
    }
    if (self.chooseAlgo.indexOfSelectedItem == 2) {
        [prefs setObject:@"2" forKey:@"cpuAlgoChoice"];
    }
    if (self.chooseAlgo.indexOfSelectedItem == 3) {
        [prefs setObject:@"3" forKey:@"cpuAlgoChoice"];
    }
    if (self.chooseAlgo.indexOfSelectedItem == 4) {
        [prefs setObject:@"4" forKey:@"cpuAlgoChoice"];
    }
    if (self.chooseAlgo.indexOfSelectedItem == 5) {
        [prefs setObject:@"5" forKey:@"cpuAlgoChoice"];
    }
    if (self.chooseAlgo.indexOfSelectedItem == 6) {
        [prefs setObject:@"6" forKey:@"cpuAlgoChoice"];
    }

    if (self.cpuQuietOutput.state == NSOnState) {
        [prefs setObject:@"-q" forKey:@"cpuQuietOutput"];
    }
    else {
        [prefs setObject:nil forKey:@"cpuQuietOutput"];
    }
    if (self.cpuDebugOutput.state == NSOnState) {
        [prefs setObject:@"-D" forKey:@"cpuDebugOutput"];
    }
    else {
        [prefs setObject:nil forKey:@"cpuDebugOutput"];
    }
    
    [prefs setObject:self.cpuManualOptions.stringValue forKey:@"cpuOptionsValue"];
    
    [prefs synchronize];
    
    [self.cpuOptionsButton setState:NSOffState];
    [self.cpuOptionsWindow orderOut:sender];
    
    prefs = nil;
    
}



@end
