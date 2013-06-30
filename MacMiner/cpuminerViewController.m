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

@synthesize cpuOutputView, cpuRememberButton, cpuStartButton, cpuStatLabel, cpuView, cpuWindow, cpuHashLabel, cpuDebugOutput, cpuOptionsWindow, cpuQuietOutput, cpuScrypt, cpuThreads, cpuManualOptions, cpuOptionsButton, tempsLabel;

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:(NSCoder *)aDecoder];
    if (self) {
        // Initialization code here.
        //            NSLog(@"startup");
        //        AppDelegate *appDelegate = (AppDelegate *)[[NSApplication sharedApplication] delegate];
        
        
        
        cpuOutputView.delegate = self;
        cpuStatLabel.delegate = self;
        
        
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
        [cpuStartButton setTitle:@"Start"];
        // This stops the task and calls our callback (-processFinished)
        [cpuTask stopTask];
        findRunning=NO;
        [cpuHashLabel setStringValue:@"0"];
        // Release the memory for this wrapper object
        
        cpuTask=nil;
        

        
        return;
    }
    else
    {
        [cpuStartButton setTitle:@"Stop"];
        // If the task is still sitting around from the last run, release it
        if (cpuTask!=nil) {
            cpuTask = nil;
        }
        
        
        

        
        
        
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
        NSString *saveLTCConfigFilePath = [userpath stringByAppendingPathComponent:@"ltcurls.conf"];
        

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

        NSString *cpuQuietV = [prefs stringForKey:@"cpuQuietOutput"];
        NSString *cpuDebugV = [prefs stringForKey:@"cpuDebugOutput"];
        NSString *cpuOptionsV = [prefs stringForKey:@"cpuOptionsValue"];
        
        

        NSMutableArray *cpuLaunchArray = [NSMutableArray arrayWithObjects: nil];
        
        if ([cpuThreadsV isNotEqualTo:@""]) {
            [cpuLaunchArray addObject:@"-t"];
            [cpuLaunchArray addObject:cpuThreadsV];
        }

            [cpuLaunchArray addObject:@"-o"];
            [cpuLaunchArray addObject:mainLTCPool];
            [cpuLaunchArray addObject:@"-u"];
            [cpuLaunchArray addObject:mainLTCUser];
            [cpuLaunchArray addObject:@"-p"];
            [cpuLaunchArray addObject:mainLTCPass];

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

        
        NSString *bundlePath = [[NSBundle mainBundle] resourcePath];
        NSString *cpuPath = [bundlePath stringByDeletingLastPathComponent];
        
        cpuPath = [cpuPath stringByAppendingString:@"/Resources/minerd"];
        //        NSLog(cpuPath);
        [self.cpuOutputView setString:@""];
        NSString *startingText = @"Starting…";
        self.cpuStatLabel.stringValue = startingText;

        cpuTask = [[TaskWrapper alloc] initWithCommandPath:cpuPath
                                                 arguments:cpuLaunchArray
                                               environment:nil
                                                  delegate:self];
        // kick off the process asynchronously

        [cpuTask startTask];
        
        BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:saveLTCConfigFilePath];
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
                
                [startAlert setMessageText:@"bfgminer has started"];
                NSString *infoText = @"The primary pool is set to ";
                infoText = [infoText stringByAppendingString:bfgURLValue];
                infoText = [infoText stringByAppendingString:@" and the user is set to "];
                infoText = [infoText stringByAppendingString:bfgUserValue];
                [startAlert setInformativeText:infoText];

                [startAlert setAlertStyle:NSWarningAlertStyle];

                
                [startAlert beginSheetModalForWindow:cpuWindow modalDelegate:self didEndSelector:nil contextInfo:nil];
                
            }
            
            
        
        
    }
    
}


// This callback is implemented as part of conforming to the ProcessController protocol.
// It will be called whenever there is output from the TaskWrapper.
- (void)taskWrapper:(TaskWrapper *)taskWrapper didProduceOutput:(NSString *)output
{
    
    NSString *apiOutput = @"accepted:";
    if ([output rangeOfString:apiOutput].location != NSNotFound) {
        
        NSString *numberString = [self getDataBetweenFromString:output
                                                     leftString:@"accepted" rightString:@"," leftOffset:0];
        NSString *step2 = [numberString stringByReplacingOccurrencesOfString:@"a" withString:@"A"];
        cpuStatLabel.stringValue = [step2 stringByReplacingOccurrencesOfString:@"/" withString:@" of "];
        
        NSString *rejectString = [self getDataBetweenFromString:output
                                                     leftString:@"," rightString:@"k" leftOffset:1];
        cpuHashLabel.stringValue = [rejectString stringByReplacingOccurrencesOfString:@" " withString:@""];
        
        //        [self getTemps:(id)nil];
        
        apiOutput = nil;
        numberString = nil;
        step2 = nil;
        rejectString = nil;


    }
    
    else
        
        // add the string (a chunk of the results from locate) to the NSTextView's
        // backing store, in the form of an attributed string
        self.cpuOutputView.string = [self.cpuOutputView.string stringByAppendingString:output];
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    
    [prefs synchronize];
    
    NSString *logLength = [prefs objectForKey:@"logLength" ];
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
                if ([[prefs objectForKey:@"scrollLog"] isNotEqualTo:@"hide"]) {
    [self performSelector:@selector(scrollToVisible:) withObject:nil afterDelay:0.0];
                }
    output = nil;
    prefs = nil;
    logLength = nil;
    
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
    [cpuStartButton setTitle:@"Stop"];
}

// A callback that gets called when a TaskWrapper is completed, allowing us to do any cleanup
// that is needed from the app side.  This method is implemented as a part of conforming
// to the ProcessController protocol.
- (void)taskWrapper:(TaskWrapper *)taskWrapper didFinishTaskWithStatus:(int)terminationStatus
{
    findRunning=NO;
    // change the button's title back for the next search
    [cpuStartButton setTitle:@"Start"];
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
    
    
}

- (IBAction)cpuMinerToggle:(id)sender {
    
    
    if ([cpuWindow isVisible]) {
        [cpuWindow orderOut:sender];
    }
    else
    {
        [cpuWindow orderFront:sender];
    }
}

- (IBAction)cpuOptionsToggle:(id)sender {
    
    if ([cpuOptionsWindow isVisible]) {
        [cpuOptionsButton setState:NSOffState];
        [cpuOptionsWindow orderOut:sender];
    }
    else
    {
        [cpuOptionsButton setState:NSOnState];
        [cpuOptionsWindow orderFront:sender];
    }
}

- (IBAction)cpuOptionsApply:(id)sender {
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    if (cpuThreads.stringValue != nil) {
        [prefs setObject:cpuThreads.stringValue forKey:@"cpuThreadsValue"];
    }
    else {
        [prefs setObject:nil forKey:@"cpuThreadsValue"];
    }
    if (cpuScrypt.state == NSOnState) {
        [prefs setObject:@"--scrypt" forKey:@"cpuUseScryptValue"];
    }
    else    {
        [prefs setObject:nil forKey:@"cpuUseScryptValue"];
    }
    if (cpuQuietOutput.state == NSOnState) {
        [prefs setObject:@"-q" forKey:@"cpuQuietOutput"];
    }
    else {
        [prefs setObject:nil forKey:@"cpuQuietOutput"];
    }
    if (cpuDebugOutput.state == NSOnState) {
        [prefs setObject:@"-D" forKey:@"cpuDebugOutput"];
    }
    else {
        [prefs setObject:nil forKey:@"cpuDebugOutput"];
    }
    
    [prefs setObject:cpuManualOptions.stringValue forKey:@"cpuOptionsValue"];
    
    [prefs synchronize];
    
    [cpuOptionsButton setState:NSOffState];
    [cpuOptionsWindow orderOut:sender];
    
    prefs = nil;
    
}



@end
