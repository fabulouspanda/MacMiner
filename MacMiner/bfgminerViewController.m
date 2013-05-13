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

@synthesize bfgPoolView, bfgOutputView, bfgPassView, bfgPopover, bfgPopoverTriggerButton, bfgRememberButton, bfgStartButton, bfgStatLabel, bfgUserView, bfgView, bfgWindow, bfgOptionsView, speedRead, acceptRead, rejectRead;

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:(NSCoder *)aDecoder];
    if (self) {
        // Initialization code here.
        //            NSLog(@"startup");
        //        AppDelegate *appDelegate = (AppDelegate *)[[NSApplication sharedApplication] delegate];
        
        bfgPoolView.delegate = self;
        bfgUserView.delegate = self;
        bfgPassView.delegate = self;
        
        bfgOutputView.delegate = self;
        bfgStatLabel.delegate = self;
        bfgOptionsView.delegate = self;
        
        
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
    return self.bfgPopoverTriggerButton.intValue == 1;
}

- (IBAction)togglePopover:(id)sender
{
    if (self.buttonIsPressed) {
        [self.bfgPopover showRelativeToRect:[bfgPopoverTriggerButton bounds]
                                     ofView:bfgPopoverTriggerButton
                              preferredEdge:NSMaxYEdge];
    } else {
        [self.bfgPopover close];
    }
}

- (IBAction)start:(id)sender
{
    if (findRunning)
    {
        // change the button's title back for the next search
        [bfgStartButton setTitle:@"Start"];
        // This stops the task and calls our callback (-processFinished)
        [bfgTask stopProcess];
        findRunning=NO;
        
        // Release the memory for this wrapper object
        
        bfgTask=nil;
        [bfgStatLabel setStringValue:@""];
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
        
        //        AppDelegate *appDelegate = (AppDelegate *)[[NSApplication sharedApplication] delegate];

            NSString *oString = @"-o";
            NSString *poolString = [oString stringByAppendingString:bfgPoolView.stringValue];
            NSString *uString = @"-u";
            NSString *userString = [uString stringByAppendingString:bfgUserView.stringValue];
            NSString *pString = @"-p";
            NSString *passString = [pString stringByAppendingString:bfgPassView.stringValue];
            
            /*
            if ([bfgOptionsView.stringValue isEqual: @""]) {
                [bfgOptionsView setStringValue:@"-q"];
            }
            NSString *optionsString = bfgOptionsView.stringValue;
            */
            
            NSString *bfgPath = @"/Applications/MacMiner.app/Contents/Resources/bfgminer/bin/bfgminer";
            //        NSLog(poclbmPath);
            [self.bfgOutputView setString:@""];
            NSString *startingText = @"Starting…";
            self.bfgStatLabel.stringValue = startingText;
            //            self.outputView.string = [self.outputView.string stringByAppendingString:poclbmPath];
            //            self.outputView.string = [self.outputView.string stringByAppendingString:finalNecessities];
        
        NSMutableArray *launchArray = [NSMutableArray arrayWithObjects:bfgPath, bfgPath, nil];
        if ([bfgOptionsView.stringValue isNotEqualTo:@""]) {
            NSArray *deviceItems = [bfgOptionsView.stringValue componentsSeparatedByString:@" "];
            [launchArray addObjectsFromArray:deviceItems];

        }
        [launchArray addObject:poolString];
        [launchArray addObject:userString];
        [launchArray addObject:passString];

        NSString *testString = [launchArray componentsJoinedByString:@" "];
        NSLog(testString);
        
            bfgTask=[[TaskWrapper alloc] initWithController:self arguments:launchArray];
            // kick off the process asynchronously
            //        [bfgTask setLaunchPath: @"/sbin/ping"];
            [bfgTask startProcess];
            
            
            if (bfgRememberButton.state == NSOnState) {
                
                NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
                
                // saving an NSString
                [prefs setObject:bfgUserView.stringValue forKey:@"bfgUserValue"];
                [prefs setObject:bfgPassView.stringValue forKey:@"bfgPassValue"];
                [prefs setObject:bfgPoolView.stringValue forKey:@"bfgPoolValue"];
                [prefs setObject:bfgOptionsView.stringValue forKey:@"bfgOptionsValue"];
                
                
                [prefs synchronize];
            }

        
    }
    
}

// This callback is implemented as part of conforming to the ProcessController protocol.
// It will be called whenever there is output from the TaskWrapper.
- (void)appendOutput:(NSString *)output
{
    NSString *apiOutput = @"5s:";
    if ([output rangeOfString:apiOutput].location != NSNotFound) {
        NSString *numberString = [self getDataBetweenFromString:output
                                                     leftString:@"5s" rightString:@" " leftOffset:0];
        speedRead.stringValue = [numberString stringByReplacingOccurrencesOfString:@"5s:" withString:@""];
        NSString *acceptString = [self getDataBetweenFromString:output
                                                     leftString:@"A:" rightString:@" " leftOffset:0];
        acceptRead.stringValue = [acceptString stringByReplacingOccurrencesOfString:@"A:" withString:@"Accepted: "];
        NSString *rejectString = [self getDataBetweenFromString:output
                                                     leftString:@"R:" rightString:@" " leftOffset:0];
        rejectRead.stringValue = [rejectString stringByReplacingOccurrencesOfString:@"R:" withString:@"Rejected: "];
        
        
    }
            //    AppDelegate *appDelegate = (AppDelegate *)[[NSApplication sharedApplication] delegate];
            // add the string (a chunk of the results from locate) to the NSTextView's
            // backing store, in the form of an attributed string
            self.bfgOutputView.string = [self.bfgOutputView.string stringByAppendingString:output];
        
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
    [self.bfgOutputView scrollRangeToVisible:NSMakeRange([[self.bfgOutputView string] length], 0)];
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
    [bfgStartButton setTitle:@"Stop"];
}

// A callback that gets called when a TaskWrapper is completed, allowing us to do any cleanup
// that is needed from the app side.  This method is implemented as a part of conforming
// to the ProcessController protocol.
- (void)processFinished
{
    findRunning=NO;
    // change the button's title back for the next search
    [bfgStartButton setTitle:@"Start"];
}

// If the user closes the search window, let's just quit
-(BOOL)windowShouldClose:(id)sender
{
    [bfgTask stopProcess];
    findRunning = NO;
    bfgTask = nil;
    //    [NSApp terminate:nil];
    [bfgStatLabel setStringValue:@""];
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
    bfgTask=nil;
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
    NSString *bfgPoolString = [prefs stringForKey:@"bfgPoolValue"];
    NSString *bfgUserString = [prefs stringForKey:@"bfgUserValue"];
    NSString *bfgPassString = [prefs stringForKey:@"bfgPassValue"];
    NSString *bfgOptionsString = [prefs stringForKey:@"bfgOptionsValue"];
    
    if (bfgPoolString != nil) {
        [bfgPoolView setStringValue:bfgPoolString];
    }
    if (bfgUserString != nil) {
        [bfgUserView setStringValue:bfgUserString];
    }
    if (bfgPassString != nil) {
        [bfgPassView setStringValue:bfgPassString];
    }
    if (bfgOptionsString != nil) {
        [bfgOptionsView setStringValue:bfgOptionsString];
    }
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


@end
