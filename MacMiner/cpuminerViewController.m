//
//  cpuminerViewController.m
//  MacMiner
//
//  Created by Administrator on 01/05/2013.
//  Copyright (c) 2013 fabulouspanda. All rights reserved.
//

#import "cpuminerViewController.h"

@implementation cpuminerViewController

@synthesize cpuPoolView, cpuOutputView, cpuPassView, cpuPopover, cpuPopoverTriggerButton, cpuRememberButton, cpuStartButton, cpuStatLabel, cpuUserView, cpuView, cpuWindow;

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:(NSCoder *)aDecoder];
    if (self) {
        // Initialization code here.
        //            NSLog(@"startup");
        //        AppDelegate *appDelegate = (AppDelegate *)[[NSApplication sharedApplication] delegate];
        
        cpuPoolView.delegate = self;
        cpuUserView.delegate = self;
        cpuPassView.delegate = self;
        
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

- (BOOL)buttonIsPressed
{
    return self.cpuPopoverTriggerButton.intValue == 1;
}

- (IBAction)togglePopover:(id)sender
{
    if (self.buttonIsPressed) {
        [self.cpuPopover showRelativeToRect:[cpuPopoverTriggerButton bounds]
                                  ofView:cpuPopoverTriggerButton
                           preferredEdge:NSMaxYEdge];
    } else {
        [self.cpuPopover close];
    }
}


- (IBAction)start:(id)sender
{
    if (findRunning)
    {
        // change the button's title back for the next search
        [cpuStartButton setTitle:@"Start"];
        // This stops the task and calls our callback (-processFinished)
        [cpuTask stopProcess];
        findRunning=NO;
        
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
            
        NSString *cpuUrl = @"--url=";
            NSString *poolplus = [cpuUrl stringByAppendingString:cpuPoolView.stringValue];
        NSString *userBase = @"--userpass=";
            NSString *userBasePlus = [userBase stringByAppendingString:cpuUserView.stringValue];
            NSString *userBasePlusPlus = [userBasePlus stringByAppendingString:@":"];
            NSString *userpass = [userBasePlusPlus stringByAppendingString:cpuPassView.stringValue];
            
            NSString *bundlePath = [[NSBundle mainBundle] resourcePath];
            NSString *cpuPath = [bundlePath stringByDeletingLastPathComponent];

            cpuPath = [cpuPath stringByAppendingString:@"/Resources/minerd"];
            //        NSLog(cpuPath);
            [self.cpuOutputView setString:@""];
            NSString *startingText = @"Starting…";
            self.cpuStatLabel.stringValue = startingText;
            //            self.outputView.string = [self.outputView.string stringByAppendingString:cpuPath];
            //            self.outputView.string = [self.outputView.string stringByAppendingString:finalNecessities];
            cpuTask=[[TaskWrapper alloc] initWithController:self arguments:[NSArray arrayWithObjects:cpuPath, cpuPath, poolplus, userpass, nil]];
            // kick off the process asynchronously
            //        [cpuTask setLaunchPath: @"/sbin/ping"];
            [cpuTask startProcess];
            
            
            if (cpuRememberButton.state == NSOnState) {
                
                NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
                
                // saving an NSString
                [prefs setObject:cpuUserView.stringValue forKey:@"cpuUserValue"];
                [prefs setObject:cpuPassView.stringValue forKey:@"cpuPassValue"];
                [prefs setObject:cpuPoolView.stringValue forKey:@"cpuPoolValue"];
                
                [prefs synchronize];
            }
            
            
        }
        
    }
    


// This callback is implemented as part of conforming to the ProcessController protocol.
// It will be called whenever there is output from the TaskWrapper.
- (void)appendOutput:(NSString *)output
{
    NSString *bfgOutput = @"accepted:";
    if ([output rangeOfString:bfgOutput].location != NSNotFound) {
        
        // Substring found...
        self.cpuStatLabel.stringValue = output;
    }
    else {
        
        NSString *poolString = @"MH/s)] [Rej:";
        NSRange result = [output rangeOfString:poolString];
        if (result.length >0){
            output = [[output componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]] componentsJoinedByString:@" "];
            NSMutableCharacterSet *_space = [NSMutableCharacterSet characterSetWithCharactersInString:@" "];
            output = [output stringByTrimmingCharactersInSet:_space];
            output = [output stringByReplacingOccurrencesOfString:cpuPoolView.stringValue withString:@""];
            self.cpuStatLabel.stringValue = output;
        }
        else
            //    AppDelegate *appDelegate = (AppDelegate *)[[NSApplication sharedApplication] delegate];
            // add the string (a chunk of the results from locate) to the NSTextView's
            // backing store, in the form of an attributed string
            self.cpuOutputView.string = [self.cpuOutputView.string stringByAppendingString:output];
        
        if (self.cpuOutputView.string.length >= 1000) {
            [self.cpuOutputView setEditable:true];
            [self.cpuOutputView setSelectedRange:NSMakeRange(0,100)];
            [self.cpuOutputView delete:nil];
            [self.cpuOutputView setEditable:false];
        }
        
        /*    [[appDelegate.pingReport textStorage] appendAttributedString: [[NSAttributedString alloc]
         initWithString: output]];
         */
        
        // setup a selector to be called the next time through the event loop to scroll
        // the view to the just pasted text.  We don't want to scroll right now,
        // because of a bug in Mac OS X version 10.1 that causes scrolling in the context
        // of a text storage update to starve the app of events
        [self performSelector:@selector(scrollToVisible:) withObject:nil afterDelay:0.0];
    }
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
- (void)processStarted
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
- (void)processFinished
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
    [cpuTask stopProcess];
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

    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    
    // getting an NSString
    NSString *cpuPoolString = [prefs stringForKey:@"cpuPoolValue"];
    NSString *cpuUserString = [prefs stringForKey:@"cpuUserValue"];
    NSString *cpuPassString = [prefs stringForKey:@"cpuPassValue"];
    
    if (cpuPoolString != nil) {
        [cpuPoolView setStringValue:cpuPoolString];
    }
    if (cpuUserString != nil) {
        [cpuUserView setStringValue:cpuUserString];
    }
    if (cpuPassString != nil) {
        [cpuPassView setStringValue:cpuPassString];
    }
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

@end
