//
//  preferencesViewController.m
//  MacMiner
//
//  Created by Administrator on 28/04/2013.
//  Copyright (c) 2013 fabulouspanda. All rights reserved.
//

#import "preferencesViewController.h"
#import "AppDelegate.h"

@interface preferencesViewController ()

@end

@implementation preferencesViewController

@synthesize updateButton, prefWindow;

- (id)initWithCoder:(NSCoder *)aDecoder
{
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
            [prefs synchronize];
        NSString *updateButtonState = [prefs stringForKey:@"checkUpdates"];
    if ([updateButtonState isEqual: @"updateCheck"]) {
        updateButton.state = NSOnState;
    }
    if ([updateButtonState isEqual: @"no"]) {
        updateButton.state = NSOffState;
    }

    return self;
}

- (IBAction)updateAction:(id)sender {
    if (updateButton.state == NSOffState) {
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        NSString *updateMiner = @"updateCheck";
        // saving an NSString
        [prefs setObject:updateMiner forKey:@"checkUpdates"];
        
        [prefs synchronize];
    }
    else {
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        NSString *updateMiner = @"no";
        // saving an NSString
        [prefs setObject:updateMiner forKey:@"checkUpdates"];
        
        [prefs synchronize];
    }

}

- (IBAction)preferenceToggle:(id)sender {
    
    
    if ([prefWindow isVisible]) {
        [prefWindow orderOut:sender];
    }
    else
    {
        [prefWindow orderFront:sender];
    }
}


- (IBAction)clickUpdate:(id)sender {
NSLog(@"Checking for Updates");
NSURL *versionNumber = [NSURL URLWithString:@"http://fabulouspanda.co.uk/macminer/version102.txt"];
NSURL *versionURL = [NSURL URLWithString:@"http://fabulouspanda.co.uk/macminer/version.txt"];

NSString *currentVersion = [NSString stringWithContentsOfURL:versionNumber encoding:(NSUTF8StringEncoding) error:nil];
NSString *latestVersion = [NSString stringWithContentsOfURL:versionURL encoding:(NSUTF8StringEncoding) error:nil];

if (currentVersion != latestVersion) {
    NSLog(@"new version available");
    NSAlert * myAlert=[[NSAlert alloc] init];
    [myAlert setMessageText:@"A new version of MacMiner is available"];
    [myAlert addButtonWithTitle:@"Download"];
    [myAlert addButtonWithTitle:@"Ignore"];
    
    NSURL *macminer = [NSURL URLWithString:@"http://fabulouspanda.co.uk/macminer/"];
    switch ([myAlert runModal]) {
        case NSAlertFirstButtonReturn:
            //handle first button
            
            [[NSWorkspace sharedWorkspace] openURL:macminer];
            break;
        case NSAlertSecondButtonReturn:
            //handle second button
            break;
    }
}
if (currentVersion == latestVersion) {
        NSLog(@"no new version available");
        NSAlert * myAlert=[[NSAlert alloc] init];
        [myAlert setMessageText:@"You are up to date"];
        [myAlert addButtonWithTitle:@"Splendid"];
        
        switch ([myAlert runModal]) {
            case NSAlertFirstButtonReturn:
                //handle first button
                

                break;

    }
    
}

}

@end
