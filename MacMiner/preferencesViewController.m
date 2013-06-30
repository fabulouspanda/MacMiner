//
//  preferencesViewController.m
//  MacMiner
//
//  Created by Administrator on 28/04/2013.
//  Copyright (c) 2013 fabulouspanda. All rights reserved.
//

#import "preferencesViewController.h"


@interface preferencesViewController ()

@end

@implementation preferencesViewController

@synthesize prefWindow, charCount, scrollButton, dockButton;

- (id)initWithCoder:(NSCoder *)aDecoder
{

    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    
    [prefs synchronize];
    
    charCount.stringValue = [prefs objectForKey:@"logLength" ];
    
    prefs = nil;
    return self;
}


-(IBAction)preferenceToggle:(id)sender {

    
    if ([prefWindow isVisible]) {

        [prefWindow orderOut:sender];
        
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        
        [prefs setObject:charCount.stringValue forKey:@"logLength"];
        
        [prefs synchronize];
        
        prefs = nil;

        if (dockButton.state == NSOffState) {
            NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
            
            [prefs setObject:@"hide" forKey:@"showDockReading"];
            
            [prefs synchronize];
            prefs = nil;
        }
        if (dockButton.state == NSOnState) {
            NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
            
            [prefs setObject:@" " forKey:@"showDockReading"];
            
            [prefs synchronize];
            prefs = nil;
        }
        if (scrollButton.state == NSOffState) {
            NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
            
            [prefs setObject:@"hide" forKey:@"scrollLog"];
            
            [prefs synchronize];
            prefs = nil;
        }
        if (scrollButton.state == NSOnState) {
            NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
            
            [prefs setObject:@" " forKey:@"scrollLog"];
            
            [prefs synchronize];
            prefs = nil;
        }
        
    }
    else
    {
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        
        [prefs synchronize];
        
        if(![[NSUserDefaults standardUserDefaults] objectForKey:@"logLength"]) {
                        [prefs setObject:@"" forKey:@"logLength"];
        }
        if(![[NSUserDefaults standardUserDefaults] objectForKey:@"scrollLog"]) {
            [prefs setObject:@"" forKey:@"scrollLog"];
        }
        if(![[NSUserDefaults standardUserDefaults] objectForKey:@"showDockReading"]) {
            [prefs setObject:@"" forKey:@"showDockReading"];
        }
        
        charCount.stringValue = [prefs objectForKey:@"logLength" ];
        
        if ([[prefs objectForKey:@"scrollLog"] isEqual: @"hide"]) {
                        scrollButton.state = NSOffState;
        }
        if ([[prefs objectForKey:@"showDockReading"] isEqual: @"hide"]) {
            dockButton.state = NSOffState;
        }

        prefs = nil;
        
        [prefWindow orderFront:sender];
        
    }
}

-(IBAction)textDidChange:(id)sender {
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    
    [prefs setObject:charCount.stringValue forKey:@"logLength"];
    
    [prefs synchronize];
    
    prefs = nil;
}

- (IBAction)scrollLogOption:(id)sender {
    if (scrollButton.state == NSOffState) {
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        
        [prefs setObject:@"hide" forKey:@"scrollLog"];
        
        [prefs synchronize];
    }
    if (scrollButton.state == NSOnState) {
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        
        [prefs setObject:@" " forKey:@"scrollLog"];
        
        [prefs synchronize];
    }
}



@end
