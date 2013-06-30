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

@synthesize cgOutputView, cgRememberButton, cgStartButton, cgStatLabel, cgView, cgWindow, cgOptionsView, cgspeedRead, cgacceptRead, cgrejectRead, cgsliderValue, cgintenseSlider, cgOptionsWindow, cgopenOptions, cgworkSlider, cgworkSizeLabel, cgvectorOverride, cgvectorSlide, cgdebugOutput, cgdisableGPU, cgdynamicIntensity, cguseScrypt, cgquietOutput, cgworkSizeOverride, cgvectorSizeLabel, cgintenseSizeLabel, cghashRead, cgLookupGap, cgShaders, cgThreadConc;
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
    
    int current = lroundf([cgworkSlider floatValue]);
    [cgworkSizeLabel setStringValue:[cgworkValues objectAtIndex:current]];
    
}
- (IBAction)cgvectorChanged:(id)sender {
    
    int current = lroundf([cgvectorSlide floatValue]);
    [cgvectorSizeLabel setStringValue:[cgvectorValues objectAtIndex:current]];
    
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


- (IBAction)cgstart:(id)sender
{
    if (cgsearchTaskIsRunning)
    {
        // change the button's title back for the next search
        [cgStartButton setTitle:@"Start"];
        // This stops the task and calls our callback (-processFinished)
        [cgTask stopTask];
        cgsearchTaskIsRunning=NO;
        
        // Release the memory for this wrapper object
        
        cgTask=nil;
        [cgrejectRead setStringValue:@""];

        
        return;
    }
    else
    {
        [cgStartButton setTitle:@"Stop"];
        // If the task is still sitting around from the last run, release it
        if (cgTask!=nil) {
            cgTask = nil;
        }
        
        

        
        // Let's allocate memory for and initialize a new TaskWrapper object, passing
        // in ourselves as the controller for this TaskWrapper object, the path
        // to the command-line tool, and the contents of the text field that
        // displays what the user wants to search on
        
        //        AppDelegate *appDelegate = (AppDelegate *)[[NSApplication sharedApplication] delegate];
        /*
         NSString *oString = @"-o";
         NSString *poolString = [oString stringByAppendingString:cgPoolView.stringValue];
         NSString *uString = @"-u";
         NSString *userString = [uString stringByAppendingString:cgUserView.stringValue];
         NSString *pString = @"-p";
         NSString *passString = [pString stringByAppendingString:cgPassView.stringValue];
         */
        /*
         if ([cgOptionsView.stringValue isEqual: @""]) {
         [cgOptionsView setStringValue:@"-q"];
         }
         NSString *optionsString = cgOptionsView.stringValue;
         */
        
        NSString *bundlePath2 = [[NSBundle mainBundle] resourcePath];
        
        NSString *cgPath = [bundlePath2 stringByAppendingString:@"/cgminer/bin/cgminer"];
        
        
        //            NSString *cgPath = @"/Applications/MacMiner.app/Contents/Resources/cgminer/bin/cgminer";
        
        //        NSLog(poclbmPath);
        [self.cgOutputView setString:@""];
        NSString *startingText = @"Starting…";
        self.cgStatLabel.stringValue = startingText;
        startingText = nil;
        //            self.outputView.string = [self.outputView.string stringByAppendingString:poclbmPath];
        //            self.outputView.string = [self.outputView.string stringByAppendingString:finalNecessities];
        
        NSMutableArray *launchArray = [NSMutableArray arrayWithObjects: nil];
        
        /*      if ([cgOptionsView.stringValue isNotEqualTo:@""]) {
         NSArray *deviceItems = [cgOptionsView.stringValue componentsSeparatedByString:@" "];
         [launchArray addObjectsFromArray:deviceItems];
         
         } */
        
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        
        [prefs synchronize];
        
        //        NSString *mainPool = [prefs stringForKey:@"defaultPoolValue"];
        //        NSString *mainBTCUser = [prefs stringForKey:@"defaultBTCUser"];
        //        NSString *mainBTCPass = [prefs stringForKey:@"defaultBTCPass"];
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
        if ([cgdebugOutputOn isNotEqualTo:nil]) {
            [launchArray addObject:cgdebugOutputOn];
        }
        if ([cgquietOutputOn isNotEqualTo:nil]) {
            [launchArray addObject:cgquietOutputOn];
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
        
//                NSString *testString = [launchArray componentsJoinedByString:@" "];
//                NSLog(testString);
        
        cgTask=[[TaskWrapper alloc] initWithCommandPath:cgPath
                                               arguments:launchArray
                                             environment:nil
                                                delegate:self];
        
        // kick off the process asynchronously
        [cgTask startTask];
        
        
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

                
                [startAlert beginSheetModalForWindow:cgWindow modalDelegate:self didEndSelector:nil contextInfo:nil];
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

                
                [startAlert beginSheetModalForWindow:cgWindow modalDelegate:self didEndSelector:nil contextInfo:nil];
                
            }
            
            
        }
        
        launchArray = nil;
        
        intensityValue = nil;
        worksizeValue = nil;
        vectorValue = nil;
        noGPU = nil;
        onScrypt = nil;
        cgdebugOutputOn = nil;
        cgquietOutputOn = nil;
        bonusOptions = nil;
        prefs = nil;
        cgPath = nil;

        
    }
    
}

// This callback is implemented as part of conforming to the ProcessController protocol.
// It will be called whenever there is output from the TaskWrapper.
- (void)taskWrapper:(TaskWrapper *)taskWrapper didProduceOutput:(NSString *)output
{
    
    NSString *unknownMessage = @"Unknown stratum msg";
    NSString *apiOutput = @"5s):";
    NSString *khOutput = @"Kh";
    NSString *mhOutput = @"Mh";
    NSString *ghOutput = @"Gh";
    if ([output rangeOfString:apiOutput].location != NSNotFound) {
        NSString *numberString = [self getDataBetweenFromString:output
                                                     leftString:@"5s" rightString:@"(" leftOffset:4];

        NSCharacterSet *alpha = [NSMutableCharacterSet letterCharacterSet];
        cgspeedRead.stringValue = [[numberString componentsSeparatedByCharactersInSet:alpha]
                                      componentsJoinedByString:@""];

        alpha = nil;
        numberString = nil;
        NSString *acceptString = [self getDataBetweenFromString:output
                                                     leftString:@"A:" rightString:@"R" leftOffset:0];
        cgacceptRead.stringValue = [acceptString stringByReplacingOccurrencesOfString:@"A:" withString:@"Accepted: "];
        acceptString = nil;
        NSString *rejectString = [self getDataBetweenFromString:output
                                                     leftString:@"R:" rightString:@"H" leftOffset:0];
        cgrejectRead.stringValue = [rejectString stringByReplacingOccurrencesOfString:@"R:" withString:@"Rejected: "];
        rejectString = nil;
        
        if ([output rangeOfString:khOutput].location != NSNotFound) {
            cghashRead.stringValue = @"Kh";
        }
        if ([output rangeOfString:mhOutput].location != NSNotFound) {
            cghashRead.stringValue = @"Mh";
        }
        if ([output rangeOfString:ghOutput].location != NSNotFound) {
            cghashRead.stringValue = @"Gh";
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
            self.cgOutputView.string = [self.cgOutputView.string stringByAppendingString:output];
    
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
    apiOutput = nil;
    khOutput = nil;
    mhOutput = nil;
    ghOutput = nil;
    prefs = nil;
    logLength = nil;
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

    [self.cgOutputView scrollRangeToVisible:NSMakeRange([[self.cgOutputView string] length], 0)];
}

// A callback that gets called when a TaskWrapper is launched, allowing us to do any setup
// that is needed from the app side.  This method is implemented as a part of conforming
// to the ProcessController protocol.
- (void)taskWrapperWillStartTask:(TaskWrapper *)taskWrapper
{

    cgsearchTaskIsRunning=YES;
    // clear the results
    //    [self.outputView setString:@""];
    // change the "Start" button to say "Stop"
    [cgStartButton setTitle:@"Stop"];
}

// A callback that gets called when a TaskWrapper is completed, allowing us to do any cleanup
// that is needed from the app side.  This method is implemented as a part of conforming
// to the ProcessController protocol.
- (void)taskWrapper:(TaskWrapper *)taskWrapper didFinishTaskWithStatus:(int)terminationStatus
{
    cgsearchTaskIsRunning=NO;
    // change the button's title back for the next search
    [cgStartButton setTitle:@"Start"];
}

// If the user closes the search window, let's just quit
-(BOOL)windowShouldClose:(id)sender
{
    [cgTask stopTask];
    cgsearchTaskIsRunning = NO;
    cgTask = nil;
    //    [NSApp terminate:nil];
    [cgStatLabel setStringValue:@""];
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
    
    [cgworkSlider setNumberOfTickMarks:[cgworkValues count]];
    [cgworkSlider setMinValue:0];
    [cgworkSlider setMaxValue:[cgworkValues count]-1];
    [cgworkSlider setAllowsTickMarkValuesOnly:YES];
    [cgworkSlider setEnabled:YES];
    [cgworkSlider setContinuous:YES];
    
    [cgworkSizeLabel setStringValue:[cgworkValues objectAtIndex:0]];
    [cgworkSlider setIntValue:0];
    
    cgvectorValues = [[NSArray alloc] initWithObjects:@"1",@"2",@"4",nil];
    
    [cgvectorSlide setNumberOfTickMarks:[cgvectorValues count]];
    [cgvectorSlide setMinValue:0];
    [cgvectorSlide setMaxValue:[cgvectorValues count]-1];
    [cgvectorSlide setAllowsTickMarkValuesOnly:YES];
    [cgvectorSlide setEnabled:YES];
    [cgvectorSlide setContinuous:YES];
    
    [cgvectorSizeLabel setStringValue:[cgvectorValues objectAtIndex:0]];
    [cgvectorSlide setIntValue:0];
    
    
    
    
}

- (IBAction)cgMinerToggle:(id)sender {
    
    if ([cgWindow isVisible]) {
        [cgWindow orderOut:sender];
    }
    else
    {
        [cgWindow orderFront:sender];
    }
}

- (void)cgMinerToggled:(id)sender {
    
    if ([cgWindow isVisible]) {
        [cgWindow orderOut:sender];
    }
    else
    {
        [cgWindow orderFront:sender];
    }
}

- (IBAction)optionsToggle:(id)sender {
    
    if ([cgOptionsWindow isVisible]) {
        [cgopenOptions setState:NSOffState];
        [cgOptionsWindow orderOut:sender];
    }
    else
    {
        [cgopenOptions setState:NSOnState];
        [cgOptionsWindow orderFront:sender];
        
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
            cgintenseSizeLabel.stringValue = intensityValue;
            cgdynamicIntensity.state = NSOffState;
        }
        if ([worksizeValue isNotEqualTo:nil]) {
            cgworkSizeLabel.stringValue = worksizeValue;
            cgworkSizeOverride.state = NSOnState;
        }
        if ([vectorValue isNotEqualTo:nil]) {
            cgvectorSizeLabel.stringValue = vectorValue;
            cgvectorOverride.state = NSOnState;
        }
        if ([noGPU isNotEqualTo:nil]) {
            cgdisableGPU.state = NSOnState;
        }
        if ([onScrypt isNotEqualTo:nil]) {
            cguseScrypt.state = NSOnState;
        }
        if ([cgdebugOutputOn isNotEqualTo:nil]) {
            cgdebugOutput.state = NSOnState;
        }
        if ([cgquietOutputOn isNotEqualTo:nil]) {
            cgquietOutput.state = NSOnState;
        }
        
        if ([bonusOptions isNotEqualTo:nil]) {
            cgOptionsView.stringValue = bonusOptions;
        }
        if (threadConc.length >= 1) {
            cgThreadConc.stringValue = threadConc;
        }
        if (shaders.length >= 1) {
            cgShaders.stringValue = shaders;
        }
        if (lookupGap.length >= 1) {
            cgLookupGap.stringValue = lookupGap;
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
    if (cgdynamicIntensity.state == NSOffState) {
        [prefs setObject:cgintenseSizeLabel.stringValue forKey:@"cgintenseValue"];
    }
    else {
        [prefs setObject:nil forKey:@"cgintenseValue"];
    }
    if (cgworkSizeOverride.state == NSOnState) {
        [prefs setObject:cgworkSizeLabel.stringValue forKey:@"cgworksizeValue"];
    }
    else    {
        [prefs setObject:nil forKey:@"cgworksizeValue"];
    }
    if (cgvectorOverride.state == NSOnState) {
        [prefs setObject:cgvectorSizeLabel.stringValue forKey:@"cgvectorValue"];
    }
    else {
        [prefs setObject:nil forKey:@"cgvectorValue"];
    }
    if (cgdisableGPU.state == NSOnState) {
        [prefs setObject:@"-G" forKey:@"cgdisableGPU"];
    }
    else {
        [prefs setObject:nil forKey:@"cgdisableGPU"];
    }
    if (cguseScrypt.state == NSOnState) {
        [prefs setObject:@"--scrypt" forKey:@"cguseScrypt"];
    }
    else {
        [prefs setObject:nil forKey:@"cguseScrypt"];
    }
    if (cgdebugOutput.state == NSOnState) {
        [prefs setObject:@"-D" forKey:@"cgdebugOutput"];
    }
    else {
        [prefs setObject:nil forKey:@"cgdebugOutput"];
    }
    if (cgquietOutput.state == NSOnState) {
        [prefs setObject:@"-q" forKey:@"cgquietOutput"];
    }
    else {
        [prefs setObject:nil forKey:@"cgquietOutput"];
    }
    
    if (cgThreadConc.stringValue.length >= 1) {
        [prefs setObject:cgThreadConc.stringValue forKey:@"cgThreadConc"];
    }
    if (cgShaders.stringValue.length >= 1) {
        [prefs setObject:cgShaders.stringValue forKey:@"cgShaders"];
    }
    if (cgLookupGap.stringValue.length >= 1) {
        [prefs setObject:cgLookupGap.stringValue forKey:@"cgLookupGap"];
    }
    
    
    [prefs setObject:cgOptionsView.stringValue forKey:@"cgOptionsValue"];
    
    [prefs synchronize];
    
    [cgopenOptions setState:NSOffState];
    [cgOptionsWindow orderOut:sender];
 
    prefs = nil;
}


@end
