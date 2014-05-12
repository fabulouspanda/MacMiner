//
//  cgminerViewController.m
//  MacMiner
//
//  Created by Administrator on 01/05/2013.
//  Copyright (c) 2013 fabulouspanda. All rights reserved.
//

#import "cgminerViewController.h"
#import "AppDelegate.h"

@implementation cgminerViewController


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
- (IBAction)cgsliderChanged:(id)sender {
    
    int current = lroundf([self.cgworkSlider floatValue]);
    [self.cgworkSizeLabel setStringValue:[cgworkValues objectAtIndex:current]];
    
}
- (IBAction)cgvectorChanged:(id)sender {
    
    int current = lroundf([self.cgvectorSlide floatValue]);
    [self.cgvectorSizeLabel setStringValue:[cgvectorValues objectAtIndex:current]];
    
}



- (IBAction)cgstart:(id)sender
{
    if (cgsearchTaskIsRunning)
    {
        // change the button's title back for the next search
        [self.cgStartButton setTitle:@"Start"];
        // This stops the task and calls our callback (-processFinished)
        [cgTask stopTask];
        cgsearchTaskIsRunning=NO;
        
        // Release the memory for this wrapper object
        
        cgTask=nil;
        [self.cgrejectRead setStringValue:@""];
        
        AppDelegate *appDelegate = (AppDelegate *)[[NSApplication sharedApplication] delegate];
        appDelegate.cgReading.stringValue = @"";
        [appDelegate.cgReadBack setHidden:YES];
        [appDelegate.cgReading setHidden:YES];
        
        [[NSApp dockTile] display];
        
        return;
    }
    else
    {
        [self.cgStartButton setTitle:@"Stop"];
        // If the task is still sitting around from the last run, release it
        if (cgTask!=nil) {
            cgTask = nil;
        }
//
//        BOOL stackViewIsAvailable = (NSClassFromString(@"NSStackView")!=nil);
//        
//        if (stackViewIsAvailable) {
////            NSLog(@"10.9");
//
//        
//        NSString *filePath = @"/System/Library/Extensions/IOUSBFamily.kext";
//        bool b=[[NSFileManager defaultManager] fileExistsAtPath:filePath];
//
//        NSString *filePath2 = @"/System/Library/Extensions/SiLabsUSBDriver64.kext";
//        bool c=[[NSFileManager defaultManager] fileExistsAtPath:filePath2];
//
//        NSString *filePath3 = @"/System/Library/Extensions/FTDIUSBSerialDriver.kext";
//        bool d=[[NSFileManager defaultManager] fileExistsAtPath:filePath3];
//        
//        if (b == YES || c == YES || d == YES) {
//            NSAlert *driverAlert = [[NSAlert alloc] init];
//                        [driverAlert addButtonWithTitle:@"Show Instructions"];
//            [driverAlert addButtonWithTitle:@"Ignore problem drivers"];
//            
//            [driverAlert setMessageText:@"Driver problem detected"];
//            NSString *infoText = @"cgminer conflicts with the native Mac OS 10.9 and other USB Serial drivers. Please click below to see instructions for disabling the default driver.";
//
//            [driverAlert setInformativeText:infoText];
//            
//
//            [driverAlert setAlertStyle:NSWarningAlertStyle];
//            //        returnCode: (NSInteger)returnCode
//            int rCode = [driverAlert runModal];
//            if (rCode == NSAlertFirstButtonReturn) {
//                
//                if (b == YES) {
//                    NSString *bundlePath = [[NSBundle mainBundle] resourcePath];
//                    NSString *urlPath = [bundlePath stringByAppendingString:@"/driverfiles/Instructions.rtf"];
//                    NSURL* url = [NSURL fileURLWithPath:urlPath isDirectory:YES];
//                    
//                    NSArray *fileURLs = [NSArray arrayWithObjects:url, nil];
//                    [[NSWorkspace sharedWorkspace] activateFileViewerSelectingURLs:fileURLs];
//                }
//                
//            }
//            else {
////                NSLog(@"Ignore");
//            }
//            
////            [driverAlert beginSheetModalForWindow:self.cgWindow modalDelegate:self didEndSelector:nil contextInfo:nil];
//
//        }
//        }
//        else {
////            NSLog(@"not 10.9");
//        }
        
        
        AppDelegate *appDelegate = (AppDelegate *)[[NSApplication sharedApplication] delegate];
        appDelegate.cgReading.stringValue = @"";
        [appDelegate.cgReadBack setHidden:NO];
        [appDelegate.cgReading setHidden:NO];
        
        [[NSApp dockTile] display];

        NSString *bundlePath2 = [[NSBundle mainBundle] resourcePath];
        
        NSString *cgPath = [bundlePath2 stringByAppendingString:@"/cgminer/bin/cgminer"];
        
        
        //            NSString *cgPath = @"/Applications/MacMiner.app/Contents/Resources/cgminer/bin/cgminer";
        
        //        NSLog(poclbmPath);
        [self.cgOutputView setString:@""];
        NSString *startingText = @"Starting…";
        self.cgStatLabel.stringValue = startingText;
        startingText = nil;

        
        NSMutableArray *launchArray = [NSMutableArray arrayWithObjects: nil];

        
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        
        [prefs synchronize];
        
        //        NSString *mainPool = [prefs stringForKey:@"defaultPoolValue"];
        //        NSString *mainBTCUser = [prefs stringForKey:@"defaultBTCUser"];
        //        NSString *mainBTCPass = [prefs stringForKey:@"defaultBTCPass"];
 
//        NSString *cgdebugOutputOn = [prefs stringForKey:@"cgdebugOutput"];
//        NSString *cgquietOutputOn = [prefs stringForKey:@"cgquietOutput"];
        NSString *bonusOptions = [prefs stringForKey:@"cgOptionsValue"];

        
        [launchArray addObject:@"-T"];
        [launchArray addObject:@"--api-listen"];
        [launchArray addObject:@"--api-allow"];
        [launchArray addObject:@"R:0/0"];
        [launchArray addObject:@"--api-port"];
        [launchArray addObject:@"4048"];
        
        
        NSString *executableName = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleExecutable"];
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, YES);
        NSString *userpath = [paths objectAtIndex:0];
        userpath = [userpath stringByAppendingPathComponent:executableName];    // The file will go in this directory
        NSString *saveBTCConfigFilePath = [userpath stringByAppendingPathComponent:@"bfgurls.conf"];
//        NSString *saveLTCConfigFilePath = [userpath stringByAppendingPathComponent:@"ltcurls.conf"];
        
        [launchArray addObject:@"-c"];
        [launchArray addObject:saveBTCConfigFilePath];

        
        if ([bonusOptions isNotEqualTo:nil]) {
            NSArray *bonusStuff = [bonusOptions componentsSeparatedByString:@" "];
            if (bonusStuff.count >= 2) {
                [launchArray addObjectsFromArray:bonusStuff];
                bonusStuff = nil;
            }
        }
        
        
        cgTask=[[TaskWrapper alloc] initWithCommandPath:cgPath
                                               arguments:launchArray
                                             environment:nil
                                                delegate:self];
        
        // kick off the process asynchronously
        [cgTask startTask];
        
        
        BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:saveBTCConfigFilePath];
        if (fileExists) {
            NSString *btcConfig = [NSString stringWithContentsOfFile : saveBTCConfigFilePath encoding:NSUTF8StringEncoding error:nil];
            
            
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
                
                [startAlert setMessageText:@"cgminer has started"];
                NSString *infoText = @"The primary pool is set to ";
                infoText = [infoText stringByAppendingString:bfgURLValue];
                infoText = [infoText stringByAppendingString:@" and the user is set to "];
                infoText = [infoText stringByAppendingString:bfgUserValue];
                [startAlert setInformativeText:infoText];
                
                //            [[NSAlert init] alertWithMessageText:@"This app requires python pip. Click 'Install' and you will be asked your password so it can be installed, or click 'Quit' and install pip yourself before relaunching this app." defaultButton:@"Install" alternateButton:@"Quit" otherButton:nil informativeTextWithFormat:nil];
                //            NSAlertDefaultReturn = [self performSelector:@selector(installPip:)];
                [startAlert setAlertStyle:NSWarningAlertStyle];
                //        returnCode: (NSInteger)returnCode
                
                [startAlert beginSheetModalForWindow:self.cgWindow modalDelegate:self didEndSelector:nil contextInfo:nil];

            
            //            if ([ltcConfig rangeOfString:stringUser].location != NSNotFound) {

            }
            
            
        
        
        launchArray = nil;
        
          bonusOptions = nil;
        prefs = nil;
        cgPath = nil;
        
    }
    
}

// This callback is implemented as part of conforming to the ProcessController protocol.
// It will be called whenever there is output from the TaskWrapper.
- (void)taskWrapper:(TaskWrapper *)taskWrapper didProduceOutput:(NSString *)output
{
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    
    [prefs synchronize];
    
    NSString *speechSetting = [prefs objectForKey:@"enableSpeech"];
    if (speechSetting != nil) {
        
    }

    
   else if ([output rangeOfString:@"auth failed"].location != NSNotFound) {
        _speechSynth = [[NSSpeechSynthesizer alloc] initWithVoice:nil];
        [self.speechSynth startSpeakingString:@"Authorisation Failed"];
    }
    
    if ([self.cgspeedRead.stringValue isNotEqualTo:@"0"]) {
        self.cgspeedRead.tag = 1;
    }
    if (speechSetting != nil) {
        
    }
    else if ([self.cgspeedRead.stringValue isEqual: @"0"] && self.cgspeedRead.tag == 1) {
        _speechSynth = [[NSSpeechSynthesizer alloc] initWithVoice:nil];
        [self.speechSynth startSpeakingString:@"Mining Stopped"];
    }
    
    speechSetting = nil;
    prefs = nil;
    
    NSString *unknownMessage = @"Unknown stratum msg";
    NSString *apiOutput = @"5s):";
    NSString *khOutput = @"Kh";
    NSString *mhOutput = @"Mh";
    NSString *ghOutput = @"Gh";
    if ([output rangeOfString:apiOutput].location != NSNotFound) {
        NSString *numberString = [self getDataBetweenFromString:output
                                                     leftString:@"5s" rightString:@"(" leftOffset:4];

        NSCharacterSet *alpha = [NSMutableCharacterSet letterCharacterSet];
        self.cgspeedRead.stringValue = [[numberString componentsSeparatedByCharactersInSet:alpha]
                                      componentsJoinedByString:@""];

        alpha = nil;
        numberString = nil;
//        NSString *acceptString = [self getDataBetweenFromString:output
//                                                     leftString:@"A:" rightString:@"R" leftOffset:0];
//        self.cgacceptRead.stringValue = [acceptString stringByReplacingOccurrencesOfString:@"A:" withString:@"Accepted: "];
//        acceptString = nil;
//        NSString *rejectString = [self getDataBetweenFromString:output
//                                                     leftString:@"R:" rightString:@"H" leftOffset:0];
//        self.cgrejectRead.stringValue = [rejectString stringByReplacingOccurrencesOfString:@"R:" withString:@"Rejected: "];
//        rejectString = nil;
        
        if ([output rangeOfString:khOutput].location != NSNotFound) {
            self.cghashRead.stringValue = @"Kh";
        }
        if ([output rangeOfString:mhOutput].location != NSNotFound) {
            self.cghashRead.stringValue = @"Mh";
        }
        if ([output rangeOfString:ghOutput].location != NSNotFound) {
            self.cghashRead.stringValue = @"Gh";
        }
        
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        
        [prefs synchronize];
        
        if ([[prefs objectForKey:@"showDockReading"] isNotEqualTo:@"hide"]) {
            
            
            AppDelegate *appDelegate = (AppDelegate *)[[NSApplication sharedApplication] delegate];
            appDelegate.cgReading.stringValue = [self.cgspeedRead.stringValue stringByAppendingString:self.cghashRead.stringValue];
            [appDelegate.cgReading setHidden:NO];
            [appDelegate.cgReading setHidden:NO];

            [[NSApp dockTile] display];
        }
        if ([[prefs objectForKey:@"showDockReading"] isEqualTo:@"hide"]) {
            AppDelegate *appDelegate = (AppDelegate *)[[NSApplication sharedApplication] delegate];
            [appDelegate.cgReadBack setHidden:YES];
            [appDelegate.cgReading setHidden:YES];

            [[NSApp dockTile] display];
        }
        prefs = nil;
        
    }
//    else
        //    AppDelegate *appDelegate = (AppDelegate *)[[NSApplication sharedApplication] delegate];
        // add the string (a chunk of the results from locate) to the NSTextView's
        // backing store, in the form of an attributed string
        
        
        if ([output rangeOfString:unknownMessage].location != NSNotFound) {
            output = nil;
        }
        else {

            NSString *newCGOutput = [self.cgOutputView.string stringByAppendingString:output];
            self.cgOutputView.string = newCGOutput;
            newCGOutput = nil;
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    
    [prefs synchronize];
    
    NSString *logLength = [prefs objectForKey:@"logLength" ];
    if (logLength.intValue <= 1) {
        logLength = @"5000";
    }
    
    if (self.cgOutputView.string.length >= logLength.intValue) {
        [self.cgOutputView setEditable:true];
        [self.cgOutputView setSelectedRange:NSMakeRange(0,1000)];
        [self.cgOutputView delete:nil];
        [self.cgOutputView setEditable:false];
    }

    
    // setup a selector to be called the next time through the event loop to scroll
    // the view to the just pasted text.  We don't want to scroll right now,
    // because of a bug in Mac OS X version 10.1 that causes scrolling in the context
    // of a text storage update to starve the app of events
    
            if ([[prefs objectForKey:@"scrollLog"] isNotEqualTo:@"hide"]) {
    
    [self performSelector:@selector(scrollToVisible:) withObject:nil afterDelay:0.0];
                
            }
           
            prefs = nil;
            logLength = nil;
            
        }
    
    apiOutput = nil;
    khOutput = nil;
    mhOutput = nil;
    ghOutput = nil;

    unknownMessage = nil;
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
    [self.cgOutputView scrollRangeToVisible:NSMakeRange([[self.cgOutputView string] length], 0)];
}

// A callback that gets called when a TaskWrapper is launched, allowing us to do any setup
// that is needed from the app side.  This method is implemented as a part of conforming
// to the ProcessController protocol.
- (void)taskWrapperWillStartTask:(TaskWrapper *)taskWrapper
{
    //    AppDelegate *appDelegate = (AppDelegate *)[[NSApplication sharedApplication] delegate];
    cgsearchTaskIsRunning=YES;
    // clear the results
    //    [self.outputView setString:@""];
    // change the "Start" button to say "Stop"
    [self.cgStartButton setTitle:@"Stop"];
}

// A callback that gets called when a TaskWrapper is completed, allowing us to do any cleanup
// that is needed from the app side.  This method is implemented as a part of conforming
// to the ProcessController protocol.
- (void)taskWrapper:(TaskWrapper *)taskWrapper didFinishTaskWithStatus:(int)terminationStatus
{
    
    AppDelegate *appDelegate = (AppDelegate *)[[NSApplication sharedApplication] delegate];
    
    [appDelegate.cgReadBack setHidden:YES];
    [appDelegate.cgReading setHidden:YES];
    
    cgsearchTaskIsRunning=NO;
    // change the button's title back for the next search
    [self.cgStartButton setTitle:@"Start"];
}

// If the user closes the search window, let's just quit
-(BOOL)windowShouldClose:(id)sender
{
    [cgTask stopTask];
    cgsearchTaskIsRunning = NO;
    cgTask = nil;
    //    [NSApp terminate:nil];
    [self.cgStatLabel setStringValue:@""];
    return YES;
}

// when first launched, this routine is called when all objects are created
// and initialized.  It's a chance for us to set things up before the user gets
// control of the UI.
-(void)viewDidLoad
{
    
    cgsearchTaskIsRunning=NO;
    cgTask=nil;
    
    
    
    cgworkValues = [[NSArray alloc] initWithObjects:@"64",@"128",@"256",@"512",@"1024",nil];
    
    [self.cgworkSlider setNumberOfTickMarks:[cgworkValues count]];
    [self.cgworkSlider setMinValue:0];
    [self.cgworkSlider setMaxValue:[cgworkValues count]-1];
    [self.cgworkSlider setAllowsTickMarkValuesOnly:YES];
    [self.cgworkSlider setEnabled:YES];
    [self.cgworkSlider setContinuous:YES];
    
    [self.cgworkSizeLabel setStringValue:[cgworkValues objectAtIndex:0]];
    [self.cgworkSlider setIntValue:0];
    
    cgvectorValues = [[NSArray alloc] initWithObjects:@"1",@"2",@"4",nil];
    
    [self.cgvectorSlide setNumberOfTickMarks:[cgvectorValues count]];
    [self.cgvectorSlide setMinValue:0];
    [self.cgvectorSlide setMaxValue:[cgvectorValues count]-1];
    [self.cgvectorSlide setAllowsTickMarkValuesOnly:YES];
    [self.cgvectorSlide setEnabled:YES];
    [self.cgvectorSlide setContinuous:YES];
    
    [self.cgvectorSizeLabel setStringValue:[cgvectorValues objectAtIndex:0]];
    [self.cgvectorSlide setIntValue:0];
    
    
    
    //    [[NSApp dockTile] setContentView:cgdockReading];
    //    [[NSApp dockTile] display];
    
}

- (IBAction)cgMinerToggle:(id)sender {
    
    if ([self.cgWindow isVisible]) {
        [self.cgWindow orderOut:sender];
    }
    else
    {
        [self.cgWindow orderFront:sender];
    }
}

- (void)cgMinerToggled:(id)sender {
    
    if ([self.cgWindow isVisible]) {
        [self.cgWindow orderOut:sender];
    }
    else
    {
        [self.cgWindow orderFront:sender];
    }
}

- (IBAction)optionsToggle:(id)sender {
    
    if ([self.cgOptionsWindow isVisible]) {
        [self.cgopenOptions setState:NSOffState];
        [self.cgOptionsWindow orderOut:sender];
    }
    else
    {
        [self.cgopenOptions setState:NSOnState];
        [self.cgOptionsWindow orderFront:sender];
        
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        
        [prefs synchronize];
        
        
        NSString *intensityValue = [prefs stringForKey:@"cgintenseValue"];
        NSString *worksizeValue = [prefs stringForKey:@"cgworksizeValue"];
        NSString *vectorValue = [prefs stringForKey:@"cgvectorValue"];
        NSString *noGPU = [prefs stringForKey:@"cgdisableGPU"];
        NSString *onScrypt = [prefs stringForKey:@"cguseScrypt"];
        NSString *cgdebugOutputOn = [prefs stringForKey:@"cgdebugOutput"];
        NSString *cgquietOutputOn = [prefs stringForKey:@"cgquietOutput"];
        NSString *bonusOptions = [prefs stringForKey:@"cgOptionsValue"];
        NSString *threadConc = [prefs stringForKey:@"cgThreadConc"];
        NSString *shaders = [prefs stringForKey:@"cgShaders"];
        NSString *lookupGap = [prefs stringForKey:@"cgLookupGap"];
        
        
        
        if ([intensityValue isNotEqualTo:nil]) {
            self.cgintenseSizeLabel.stringValue = intensityValue;
            self.cgdynamicIntensity.state = NSOffState;
        }
        if ([worksizeValue isNotEqualTo:nil]) {
            self.cgworkSizeLabel.stringValue = worksizeValue;
            self.cgworkSizeOverride.state = NSOnState;
        }
        if ([vectorValue isNotEqualTo:nil]) {
            self.cgvectorSizeLabel.stringValue = vectorValue;
            self.cgvectorOverride.state = NSOnState;
        }
        if ([noGPU isNotEqualTo:nil]) {
            self.cgdisableGPU.state = NSOnState;
        }
        if ([onScrypt isNotEqualTo:nil]) {
            self.cguseScrypt.state = NSOnState;
        }
        if ([cgdebugOutputOn isNotEqualTo:nil]) {
            self.cgdebugOutput.state = NSOnState;
        }
        if ([cgquietOutputOn isNotEqualTo:nil]) {
            self.cgquietOutput.state = NSOnState;
        }
        
        if ([bonusOptions isNotEqualTo:nil]) {
            self.cgOptionsView.stringValue = bonusOptions;
        }
        if (threadConc.length >= 1) {
            self.cgThreadConc.stringValue = threadConc;
        }
        if (shaders.length >= 1) {
            self.cgShaders.stringValue = shaders;
        }
        if (lookupGap.length >= 1) {
            self.cgLookupGap.stringValue = lookupGap;
        }
        
        intensityValue = nil;
        worksizeValue = nil;
        vectorValue = nil;
        noGPU = nil;
        onScrypt = nil;
        cgdebugOutputOn = nil;
        cgquietOutputOn = nil;
        bonusOptions = nil;
        threadConc = nil;
        shaders = nil;
        lookupGap = nil;
        
        prefs = nil;
        
    }
    
    
}


- (IBAction)cgoptionsApply:(id)sender {
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    if (self.cgdynamicIntensity.state == NSOffState) {
        [prefs setObject:self.cgintenseSizeLabel.stringValue forKey:@"cgintenseValue"];
    }
    else {
        [prefs setObject:nil forKey:@"cgintenseValue"];
    }
    if (self.cgworkSizeOverride.state == NSOnState) {
        [prefs setObject:self.cgworkSizeLabel.stringValue forKey:@"cgworksizeValue"];
    }
    else    {
        [prefs setObject:nil forKey:@"cgworksizeValue"];
    }
    if (self.cgvectorOverride.state == NSOnState) {
        [prefs setObject:self.cgvectorSizeLabel.stringValue forKey:@"cgvectorValue"];
    }
    else {
        [prefs setObject:nil forKey:@"cgvectorValue"];
    }
    if (self.cgdisableGPU.state == NSOnState) {
        [prefs setObject:@"-G" forKey:@"cgdisableGPU"];
    }
    else {
        [prefs setObject:nil forKey:@"cgdisableGPU"];
    }
    if (self.cguseScrypt.state == NSOnState) {
        [prefs setObject:@"--scrypt" forKey:@"cguseScrypt"];
    }
    else {
        [prefs setObject:nil forKey:@"cguseScrypt"];
    }
    if (self.cgdebugOutput.state == NSOnState) {
        [prefs setObject:@"-D" forKey:@"cgdebugOutput"];
    }
    else {
        [prefs setObject:nil forKey:@"cgdebugOutput"];
    }
    if (self.cgquietOutput.state == NSOnState) {
        [prefs setObject:@"-q" forKey:@"cgquietOutput"];
    }
    else {
        [prefs setObject:nil forKey:@"cgquietOutput"];
    }
    
    if (self.cgThreadConc.stringValue.length >= 1) {
        [prefs setObject:self.cgThreadConc.stringValue forKey:@"cgThreadConc"];
    }
    else {
        [prefs setObject:nil forKey:@"cgThreadConc"];
    }
    if (self.cgShaders.stringValue.length >= 1) {
        [prefs setObject:self.cgShaders.stringValue forKey:@"cgShaders"];
    }
    else {
        [prefs setObject:nil forKey:@"cgShaders"];
    }
    if (self.cgLookupGap.stringValue.length >= 1) {
        [prefs setObject:self.cgLookupGap.stringValue forKey:@"cgLookupGap"];
    }
    else {
        [prefs setObject:nil forKey:@"cgLookupGap"];
    }
    
    
    [prefs setObject:self.cgOptionsView.stringValue forKey:@"cgOptionsValue"];
    
    [prefs synchronize];
    
    [self.cgopenOptions setState:NSOffState];
    [self.cgOptionsWindow orderOut:sender];
 
    prefs = nil;
}

- (IBAction)cgDisplayHelp:(id)sender
{
    [[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:@"http://fabulouspanda.co.uk/macminer/docs/"]];
}

-(void)awakeFromNib
{
    
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    
    [prefs synchronize];
    
    if ([[prefs objectForKey:@"startCg"] isEqualToString:@"start"]) {
        
                        [self.cgWindow orderFront:nil];
        
        [self.cgStartButton setTitle:@"Stop"];
        // If the task is still sitting around from the last run, release it
        if (cgTask!=nil) {
            cgTask = nil;
        }
   
        
        AppDelegate *appDelegate = (AppDelegate *)[[NSApplication sharedApplication] delegate];
        appDelegate.cgReading.stringValue = @"";
        [appDelegate.cgReadBack setHidden:NO];
        [appDelegate.cgReading setHidden:NO];
        
        [[NSApp dockTile] display];
        
        NSString *bundlePath2 = [[NSBundle mainBundle] resourcePath];
        
        NSString *cgPath = [bundlePath2 stringByAppendingString:@"/cgminer/bin/cgminer"];
        
        
        //            NSString *cgPath = @"/Applications/MacMiner.app/Contents/Resources/cgminer/bin/cgminer";
        
        //        NSLog(poclbmPath);
        [self.cgOutputView setString:@""];
        NSString *startingText = @"Starting…";
        self.cgStatLabel.stringValue = startingText;
        startingText = nil;
        
        
        NSMutableArray *launchArray = [NSMutableArray arrayWithObjects: nil];
        
        
        NSString *bonusOptions = [prefs stringForKey:@"cgOptionsValue"];
        
        
        [launchArray addObject:@"-T"];
        [launchArray addObject:@"--api-listen"];
        [launchArray addObject:@"--api-allow"];
        [launchArray addObject:@"R:0/0"];
        [launchArray addObject:@"--api-port"];
        [launchArray addObject:@"4048"];
        
        
        NSString *executableName = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleExecutable"];
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, YES);
        NSString *userpath = [paths objectAtIndex:0];
        userpath = [userpath stringByAppendingPathComponent:executableName];    // The file will go in this directory
        NSString *saveBTCConfigFilePath = [userpath stringByAppendingPathComponent:@"bfgurls.conf"];
        //        NSString *saveLTCConfigFilePath = [userpath stringByAppendingPathComponent:@"ltcurls.conf"];
        
        [launchArray addObject:@"-c"];
        [launchArray addObject:saveBTCConfigFilePath];
        
        
        if ([bonusOptions isNotEqualTo:nil]) {
            NSArray *bonusStuff = [bonusOptions componentsSeparatedByString:@" "];
            if (bonusStuff.count >= 2) {
                [launchArray addObjectsFromArray:bonusStuff];
                bonusStuff = nil;
            }
        }
        
        
        cgTask=[[TaskWrapper alloc] initWithCommandPath:cgPath
                                              arguments:launchArray
                                            environment:nil
                                               delegate:self];
        
        // kick off the process asynchronously
        [cgTask startTask];
        
        
        BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:saveBTCConfigFilePath];
        if (fileExists) {
            NSString *btcConfig = [NSString stringWithContentsOfFile : saveBTCConfigFilePath encoding:NSUTF8StringEncoding error:nil];
            
            
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
            
            [startAlert setMessageText:@"cgminer has started"];
            NSString *infoText = @"The primary pool is set to ";
            infoText = [infoText stringByAppendingString:bfgURLValue];
            infoText = [infoText stringByAppendingString:@" and the user is set to "];
            infoText = [infoText stringByAppendingString:bfgUserValue];
            [startAlert setInformativeText:infoText];
            
            //            [[NSAlert init] alertWithMessageText:@"This app requires python pip. Click 'Install' and you will be asked your password so it can be installed, or click 'Quit' and install pip yourself before relaunching this app." defaultButton:@"Install" alternateButton:@"Quit" otherButton:nil informativeTextWithFormat:nil];
            //            NSAlertDefaultReturn = [self performSelector:@selector(installPip:)];
            [startAlert setAlertStyle:NSWarningAlertStyle];
            //        returnCode: (NSInteger)returnCode
            
            [startAlert beginSheetModalForWindow:self.cgWindow modalDelegate:self didEndSelector:nil contextInfo:nil];
            
            
            //            if ([ltcConfig rangeOfString:stringUser].location != NSNotFound) {
            
        }
        
        
        
        
        launchArray = nil;
        
        bonusOptions = nil;
        cgPath = nil;
        
    }
    
    prefs = nil;

}


@end
