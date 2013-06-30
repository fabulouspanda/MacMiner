//
//  mainViewController.m
//  MacMiner
//
//  Created by Administrator on 02/04/2013.
//  Copyright (c) 2013 fabulouspanda. All rights reserved.
//

#import "mainViewController.h"
#import "AppDelegate.h"
//#import "NSFileManager+DirectoryLocations.h"

@interface mainViewController ()

@end

@implementation mainViewController

@synthesize mainView, poolView, userView, passView, optionsView, outputView, startButton, statLabel, rememberButton, pocAcceptRead, pocRejectRead, pocSpeedRead, window;

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:(NSCoder *)aDecoder];
    if (self) {
        // Initialization code here.

        
        poolView.delegate = self;
        userView.delegate = self;
        passView.delegate = self;
        optionsView.delegate = self;

        outputView.delegate = self;
        statLabel.delegate = self;
        

        
    }

    
 
    return self;
}


- (IBAction)start:(id)sender
{
    if (findRunning)
    {
        // change the button's title back for the next search
        [startButton setTitle:@"Start"];
        // This stops the task and calls our callback (-processFinished)
        [searchTask stopTask];
        findRunning=NO;

        // Release the memory for this wrapper object
        
        searchTask=nil;
        return;
    }
    else
    {
            [startButton setTitle:@"Stop"];
        // If the task is still sitting around from the last run, release it
        if (searchTask!=nil) {
            searchTask = nil;
        }
        // Let's allocate memory for and initialize a new TaskWrapper object, passing
        // in ourselves as the controller for this TaskWrapper object, the path
        // to the command-line tool, and the contents of the text field that
        // displays what the user wants to search on
        
//        AppDelegate *appDelegate = (AppDelegate *)[[NSApplication sharedApplication] delegate];
        
        
        NSString *userplus = [userView.stringValue stringByAppendingString:@":"];
        NSString *userpass = [userplus stringByAppendingString:passView.stringValue];
        NSString *userpassplus = [userpass stringByAppendingString:@"@"];
        NSString *finalNecessities = [userpassplus stringByAppendingString:poolView.stringValue];
        
        NSString *bundlePath = [[NSBundle mainBundle] resourcePath];
        NSString *poclbmPath = [bundlePath stringByDeletingLastPathComponent];

        poclbmPath = [poclbmPath stringByAppendingString:@"/Resources/poclbm.app/Contents/MacOS/poclbm"];

            [self.outputView setString:@""];
        NSString *startingText = @"Starting…";

        
        NSMutableArray *launchArray = [NSMutableArray arrayWithObjects: nil];
        if ([optionsView.stringValue isNotEqualTo:@""]) {
            NSArray *deviceItems = [optionsView.stringValue componentsSeparatedByString:@" "];
            [launchArray addObjectsFromArray:deviceItems];
            deviceItems = nil;
        }
        [launchArray addObject:finalNecessities];


       searchTask =[[TaskWrapper alloc] initWithCommandPath:poclbmPath
                                        arguments:launchArray
                                      environment:nil
                                         delegate:self];
        
        // kick off the process asynchronously

        [searchTask startTask];
        
        
        if (rememberButton.state == NSOnState) {
            
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        
        // saving an NSString
        [prefs setObject:userView.stringValue forKey:@"userValue"];
        [prefs setObject:passView.stringValue forKey:@"passValue"];
        [prefs setObject:poolView.stringValue forKey:@"poolValue"];
        [prefs setObject:optionsView.stringValue forKey:@"optionsValue"];
        
        // This is suggested to synch prefs, but is not needed (I didn't put it in my tut)
        [prefs synchronize];
            
            prefs = nil;
        }
        
        userpass = nil;
        userplus = nil;
        userpassplus = nil;
        finalNecessities = nil;
        bundlePath = nil;
        poclbmPath = nil;
        startingText = nil;
        launchArray = nil;


    }
  
  }
  


// This callback is implemented as part of conforming to the ProcessController protocol.
// It will be called whenever there is output from the TaskWrapper.
- (void)taskWrapper:(TaskWrapper *)taskWrapper didProduceOutput:(NSString *)output
{
    
    NSString *poclbmOutput = @"MH/s)] [Rej:";
    if ([output rangeOfString:poclbmOutput].location != NSNotFound) {
        NSString *numberString = [self getDataBetweenFromString:output
                                                     leftString:@"[" rightString:@" " leftOffset:1];
        pocSpeedRead.stringValue = [numberString stringByReplacingOccurrencesOfString:@" " withString:@""];
        NSString *acceptString = [self getDataBetweenFromString:output
                                                     leftString:@"Rej:" rightString:@"(" leftOffset:0];
        NSString *acceptString2 = [self getDataBetweenFromString:acceptString
                                                     leftString:@"/" rightString:@" " leftOffset:0];
        pocAcceptRead.stringValue = [acceptString2 stringByReplacingOccurrencesOfString:@"/" withString:@"Accepted: "];
        NSString *rejectString = [self getDataBetweenFromString:output
                                                     leftString:@"Rej:" rightString:@"/" leftOffset:0];
        pocRejectRead.stringValue = [rejectString stringByReplacingOccurrencesOfString:@"Rej:" withString:@"Rejected: "];
        

        
        poclbmOutput = nil;
        numberString = nil;
        acceptString = nil;
        acceptString2 = nil;
        rejectString = nil;

    }

    self.outputView.string = [self.outputView.string stringByAppendingString:output];
        
        if (self.outputView.string.length >= 5000) {
            [self.outputView setEditable:true];
            [self.outputView setSelectedRange:NSMakeRange(0,1000)];
            [self.outputView delete:nil];
            [self.outputView setEditable:false];
        }
    

    
    // setup a selector to be called the next time through the event loop to scroll
    // the view to the just pasted text.  We don't want to scroll right now,
    // because of a bug in Mac OS X version 10.1 that causes scrolling in the context
    // of a text storage update to starve the app of events
    [self performSelector:@selector(scrollToVisible:) withObject:nil afterDelay:0.0];
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
}

// This routine is called after adding new results to the text view's backing store.
// We now need to scroll the NSScrollView in which the NSTextView sits to the part
// that we just added at the end
- (void)scrollToVisible:(id)ignore {
 //   AppDelegate *appDelegate = (AppDelegate *)[[NSApplication sharedApplication] delegate];
    [self.outputView scrollRangeToVisible:NSMakeRange([[self.outputView string] length], 0)];
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
    [startButton setTitle:@"Stop"];
}

// A callback that gets called when a TaskWrapper is completed, allowing us to do any cleanup
// that is needed from the app side.  This method is implemented as a part of conforming
// to the ProcessController protocol.
- (void)taskWrapper:(TaskWrapper *)taskWrapper didFinishTaskWithStatus:(int)terminationStatus
{
    findRunning=NO;
    // change the button's title back for the next search
    [startButton setTitle:@"Start"];
}

// If the user closes the search window, let's just quit
-(BOOL)windowShouldClose:(id)sender
{
    [searchTask stopTask];
    findRunning = NO;
    searchTask = nil;
//    [NSApp terminate:nil];
    return YES;
}



// when first launched, this routine is called when all objects are created
// and initialized.  It's a chance for us to set things up before the user gets
// control of the UI.
-(void)awakeFromNib
{
    findRunning=NO;
    searchTask=nil;
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    
    // getting an NSString
    NSString *poolString = [prefs stringForKey:@"poolValue"];
    NSString *userString = [prefs stringForKey:@"userValue"];
    NSString *passString = [prefs stringForKey:@"passValue"];
    NSString *optionsString = [prefs stringForKey:@"optionsValue"];

    if (poolString != nil) {
    [poolView setStringValue:poolString];
    }
    if (userString != nil) {
    [userView setStringValue:userString];
    }
    if (passString != nil) {
    [passView setStringValue:passString];
    }
    if (optionsString != nil) {
    [optionsView setStringValue:optionsString];
    }
    
    prefs = nil;
    


}

- (IBAction)macMinerToggle:(id)sender {

    
    if ([window isVisible]) {
        [window orderOut:sender];
    }
    else
    {
        [window orderFront:sender];
    }
}

@end
