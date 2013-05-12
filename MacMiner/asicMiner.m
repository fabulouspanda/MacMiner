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

@synthesize asicPoolView, asicOutputView, asicPassView, asicRememberButton, asicStartButton, asicStatLabel, asicUserView, asicView, asicWindow, asicOptionsView, megaHashLabel, acceptLabel, asicPopover, asicPopoverTriggerButton, rejecttLabel, tempsLabel;

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:(NSCoder *)aDecoder];
    if (self) {
        // Initialization code here.
        //            NSLog(@"startup");
        //        AppDelegate *appDelegate = (AppDelegate *)[[NSApplication sharedApplication] delegate];
        
        asicPoolView.delegate = self;
        asicUserView.delegate = self;
        asicPassView.delegate = self;
        
        asicOutputView.delegate = self;
        asicStatLabel.delegate = self;
        asicOptionsView.delegate = self;
  
        
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

- (BOOL)buttonIsPressed
{
    return self.asicPopoverTriggerButton.intValue == 1;
}

- (IBAction)togglePopover:(id)sender
{
    if (self.buttonIsPressed) {
        [self.asicPopover showRelativeToRect:[asicPopoverTriggerButton bounds]
                                     ofView:asicPopoverTriggerButton
                              preferredEdge:NSMaxYEdge];
    } else {
        [self.asicPopover close];
    }
}


- (IBAction)start:(id)sender
{/*
    if (findRunning)
    {
        // change the button's title back for the next search
        [asicStartButton setTitle:@"Start"];
        // This stops the task and calls our callback (-processFinished)
        [asicTask stopProcess];
        findRunning=NO;
        
        // Release the memory for this wrapper object
        
        asicTask=nil;
        [asicStatLabel setStringValue:@""];
        return;
    }
    else
    {
        [asicStartButton setTitle:@"Stop"];
        // If the task is still sitting around from the last run, release it
        if (asicTask!=nil) {
            asicTask = nil;
        }
        // Let's allocate memory for and initialize a new TaskWrapper object, passing
        // in ourselves as the controller for this TaskWrapper object, the path
        // to the command-line tool, and the contents of the text field that
        // displays what the user wants to search on
        
        //        AppDelegate *appDelegate = (AppDelegate *)[[NSApplication sharedApplication] delegate];
        
        NSString *oString = @"-o";
        NSString *poolString = [oString stringByAppendingString:asicPoolView.stringValue];
        NSString *uString = @"-u";
        NSString *userString = [uString stringByAppendingString:asicUserView.stringValue];
        NSString *pString = @"-p";
        NSString *passString = [pString stringByAppendingString:asicPassView.stringValue];
        
        
        if ([asicOptionsView.stringValue isEqual: @""]) {
            [asicOptionsView setStringValue:@"-S /dev/cu.usbserial-FTWILFLM"];
        }
        NSString *optionsString = asicOptionsView.stringValue;
        
        

        NSString *launchPath = @"/usr/bin/sudo";
        NSString *asicPath = @"/Applications/MacMiner.app/Contents/Resources/asicminer/bin/bfgminer";
        //        NSLog(poclbmPath);
        [self.asicOutputView setString:@""];
        NSString *startingText = @"Starting…";
        self.asicStatLabel.stringValue = startingText;
        //            self.outputView.string = [self.outputView.string stringByAppendingString:poclbmPath];
        //            self.outputView.string = [self.outputView.string stringByAppendingString:finalNecessities];
//                NSLog(optionsString);
        asicTask=[[TaskWrapper alloc] initWithController:self arguments:[NSArray arrayWithObjects:launchPath, asicPath, poolString, userString, passString, optionsString, nil]];
        // kick off the process asynchronously
        //        [asicTask setLaunchPath: @"/sbin/ping"];
        [asicTask startProcess];


        
        
        if (asicRememberButton.state == NSOnState) {
            
            NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
            
            // saving an NSString
            [prefs setObject:asicUserView.stringValue forKey:@"asicUserValue"];
            [prefs setObject:asicPassView.stringValue forKey:@"asicPassValue"];
            [prefs setObject:asicPoolView.stringValue forKey:@"asicPoolValue"];
            [prefs setObject:asicOptionsView.stringValue forKey:@"asicOptionsValue"];
            
            
            [prefs synchronize];
        }
        
        
    }
    */



    NSString *oString = @"-o ";
    NSString *poolString = [oString stringByAppendingString:asicPoolView.stringValue];
    NSString *uString = @"-u ";
    NSString *userString = [uString stringByAppendingString:asicUserView.stringValue];
    NSString *pString = @"-p ";
    NSString *passString = [pString stringByAppendingString:asicPassView.stringValue];
    
    
    if ([asicOptionsView.stringValue isEqual: @""]) {
        [asicOptionsView setStringValue:@"-S /dev/cu.usbserial-FTWILFLM"];
    }
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
/*
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
            NSString *bundlePath = [[NSBundle mainBundle] resourcePath];
    NSString *apiPath = [bundlePath stringByDeletingLastPathComponent];
    
    apiPath = [apiPath stringByAppendingString:@"/Resources/apiaccess"];
    //        NSLog(cpuPath);
    [self.asicOutputView setString:@""];
    //    NSString *startingText = @"Starting…";
    //    self.asicStatLabel.stringValue = startingText;
    //            self.outputView.string = [self.outputView.string stringByAppendingString:cpuPath];
    //            self.outputView.string = [self.outputView.string stringByAppendingString:finalNecessities];
    asicTask=[[TaskWrapper alloc] initWithController:self arguments:[NSArray arrayWithObjects:apiPath, apiPath, @"devs", nil]];
    // kick off the process asynchronously
    //        [cpuTask setLaunchPath: @"/sbin/ping"];
    [asicTask startProcess];

}

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
}

- (void)startToggling
{
    if ([asicStartButton.title isEqual: @"Start"]) {


//            [asicStartButton setTitle:@"Stop"];
//    [self stopToggling:self];
    
    toggleTimer = [NSTimer scheduledTimerWithTimeInterval:3. target:self selector:@selector(toggleTimerFired:) userInfo:nil repeats:YES];
    }


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
- (void)appendOutput:(NSString *)output
{
    
    NSString *apiOutput = @"[MHS av]";
    if ([output rangeOfString:apiOutput].location != NSNotFound) {
    NSString *numberString = [self getDataBetweenFromString:output
                                                 leftString:@"[MHS av] => " rightString:@"]" leftOffset:11];
    megaHashLabel.stringValue = [numberString stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSString *acceptString = [self getDataBetweenFromString:output
                                                 leftString:@"Accepted=" rightString:@"," leftOffset:0];
    acceptLabel.stringValue = [acceptString stringByReplacingOccurrencesOfString:@"=" withString:@": "];
        NSString *rejectString = [self getDataBetweenFromString:output
                                                     leftString:@"Rejected=" rightString:@"," leftOffset:0];
        rejecttLabel.stringValue = [rejectString stringByReplacingOccurrencesOfString:@"=" withString:@": "];
        NSString *tempsString = [self getDataBetweenFromString:output
                                                     leftString:@"Temperature=" rightString:@",M" leftOffset:0];
        tempsLabel.stringValue = [tempsString stringByReplacingOccurrencesOfString:@"=" withString:@": "];
        

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
            self.asicOutputView.string = [self.asicOutputView.string stringByAppendingString:output];
        
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
- (void)processStarted
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
- (void)processFinished
{
    findRunning=NO;
    // change the button's title back for the next search
//    [asicStartButton setTitle:@"Start"];
}

// If the user closes the search window, let's just quit
-(BOOL)windowShouldClose:(id)sender
{
    [asicTask stopProcess];
    findRunning = NO;
    asicTask = nil;
    //    [NSApp terminate:nil];
    [asicStatLabel setStringValue:@""];
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
    asicTask=[[TaskWrapper alloc] initWithController:self arguments:[NSArray arrayWithObjects:apiPath, apiPath, @"quit", nil]];
    [asicTask startProcess];
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
    NSString *asicPoolString = [prefs stringForKey:@"asicPoolValue"];
    NSString *asicUserString = [prefs stringForKey:@"asicUserValue"];
    NSString *asicPassString = [prefs stringForKey:@"asicPassValue"];
    NSString *asicOptionsString = [prefs stringForKey:@"asicOptionsValue"];
    
    if (asicPoolString != nil) {
        [asicPoolView setStringValue:asicPoolString];
    }
    if (asicUserString != nil) {
        [asicUserView setStringValue:asicUserString];
    }
    if (asicPassString != nil) {
        [asicPassView setStringValue:asicPassString];
    }
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


@end
