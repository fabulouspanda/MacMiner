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



- (id)initWithCoder:(NSCoder *)aDecoder
{

    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    
    [prefs synchronize];
    
    self.charCount.stringValue = [prefs objectForKey:@"logLength" ];
    
    prefs = nil;
    return self;
}


-(IBAction)preferenceToggle:(id)sender {

    
    if ([self.prefWindow isVisible]) {

        
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        
        [prefs setObject:self.charCount.stringValue forKey:@"logLength"];
        
        [prefs synchronize];
        
        prefs = nil;

        if (self.dockButton.state == NSOffState) {
            NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
            
            [prefs setObject:@"hide" forKey:@"showDockReading"];
            
            [prefs synchronize];
            prefs = nil;
        }
        if (self.dockButton.state == NSOnState) {
            NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
            
            [prefs setObject:@" " forKey:@"showDockReading"];
            
            [prefs synchronize];
            prefs = nil;
        }
        if (self.scrollButton.state == NSOffState) {
            NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
            
            [prefs setObject:@"hide" forKey:@"scrollLog"];
            
            [prefs synchronize];
            prefs = nil;
        }
        if (self.scrollButton.state == NSOnState) {
            NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
            
            [prefs setObject:@" " forKey:@"scrollLog"];
            
            [prefs synchronize];
            prefs = nil;
        }
        
        if (self.emailAddress.stringValue.length >= 5) {
            NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
            
            [prefs setObject:self.emailAddress.stringValue forKey:@"emailAddress"];
            
            [prefs synchronize];
            prefs = nil;
        }
        if (self.appID.stringValue.length >= 5) {
            NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
            
            [prefs setObject:self.appID.stringValue forKey:@"appID"];
            
            [prefs synchronize];
            prefs = nil;
        }
                [self.prefWindow orderOut:sender];
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
        if(![[NSUserDefaults standardUserDefaults] objectForKey:@"emailAddress"]) {
            [prefs setObject:@"" forKey:@"emailAddress"];
        }
        if(![[NSUserDefaults standardUserDefaults] objectForKey:@"appID"]) {
            [prefs setObject:@"" forKey:@"appID"];
        }
        
        
        self.charCount.stringValue = [prefs objectForKey:@"logLength" ];
        
        if ([[prefs objectForKey:@"scrollLog"] isEqual: @"hide"]) {
                        self.scrollButton.state = NSOffState;
        }
        if ([[prefs objectForKey:@"showDockReading"] isEqual: @"hide"]) {
            self.dockButton.state = NSOffState;
        }
        
        self.emailAddress.stringValue = [prefs objectForKey:@"emailAddress"];
        self.appID.stringValue = [prefs objectForKey:@"appID"];

        prefs = nil;
        
        [self.prefWindow orderFront:sender];
        
    }
}

-(IBAction)textDidChange:(id)sender {
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    
    [prefs setObject:self.charCount.stringValue forKey:@"logLength"];
    
    [prefs synchronize];
    
    prefs = nil;
}

-(IBAction)textDidChangeEmail:(id)sender {
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    
    [prefs setObject:self.emailAddress.stringValue forKey:@"emailAddress"];
    
    [prefs synchronize];
    
    prefs = nil;
}

-(IBAction)textDidChangeAppKey:(id)sender {
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    
    [prefs setObject:self.appID.stringValue forKey:@"appID"];
    
    [prefs synchronize];
    
    prefs = nil;
}

- (IBAction)scrollLogOption:(id)sender {
    if (self.scrollButton.state == NSOffState) {
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        
        [prefs setObject:@"hide" forKey:@"scrollLog"];
        
        [prefs synchronize];
    }
    if (self.scrollButton.state == NSOnState) {
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        
        [prefs setObject:@" " forKey:@"scrollLog"];
        
        [prefs synchronize];
    }
}

- (IBAction)dockReadingsOption:(id)sender {
    if (self.dockButton.state == NSOffState) {
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        
        [prefs setObject:@"hide" forKey:@"showDockReading"];
        
        [prefs synchronize];
    }
    if (self.dockButton.state == NSOnState) {
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        
        [prefs setObject:@" " forKey:@"showDockReading"];
        
        [prefs synchronize];
    }
}

- (IBAction)speechOption:(id)sender {
    if (self.speechButton.state == NSOffState) {
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        
        [prefs setObject:@"silence" forKey:@"enableSpeech"];
        
        [prefs synchronize];
    }
    if (self.speechButton.state == NSOnState) {
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        
        [prefs setObject:@" " forKey:@"enableSpeech"];
        
        [prefs synchronize];
    }
}

- (IBAction)mobileMiner:(id)sender {
    [self.prefView setHidden:YES];
        [self.prefView2 setHidden:NO];
}

- (IBAction)showGeneral:(id)sender {
    [self.prefView setHidden:NO];
    [self.prefView2 setHidden:YES];
}

@end
