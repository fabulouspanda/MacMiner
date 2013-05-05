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

@end
