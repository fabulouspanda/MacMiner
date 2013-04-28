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

@synthesize bfgButton, prefWindow;

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (bfgButton.state == NSOnState) {
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        NSString *bfgMiner = @"bfgminer";
        // saving an NSString
        [prefs setObject:bfgMiner forKey:@"whichMiner"];
        
        [prefs synchronize];
    }
    else {
        
    }
    return self;
}

- (IBAction)bfgAction:(id)sender {
    if (bfgButton.state == NSOnState) {
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        NSString *bfgMiner = @"bfgminer";
        // saving an NSString
        [prefs setObject:bfgMiner forKey:@"whichMiner"];
        
        [prefs synchronize];
    }
    else {
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        NSString *bfgMiner = @"poclbm";
        // saving an NSString
        [prefs setObject:bfgMiner forKey:@"whichMiner"];
        
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
