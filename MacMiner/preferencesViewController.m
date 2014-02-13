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
    
//    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
//    
//    [prefs synchronize];
//    
//    self.charCount.stringValue = [prefs objectForKey:@"logLength" ];
//
//    if ([prefs objectForKey:@"bitcoinPool"] != nil && [prefs objectForKey:@"scryptPool"] != nil && [prefs objectForKey:@"vertcoinPool"] != nil && [prefs objectForKey:@"quarkcoinPool"] != nil) {
//        [self.prefWindow orderFront:nil];
//    }
//    
//    prefs = nil;
    return self;
}

-(void)awakeFromNib {
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    
    [prefs synchronize];
    
    NSString *logLength = [prefs objectForKey:@"logLength" ];
    if (logLength) {
    self.charCount.stringValue = logLength;
    }
    
    NSString *bitcoinPool = [prefs objectForKey:@"bitcoinPool"];
    NSString *bitcoinPoolUser = [prefs objectForKey:@"bitcoinPoolUser"];
    NSString *bitcoinPoolPassword = [prefs objectForKey:@"bitcoinPoolPassword"];
    
    if (bitcoinPoolUser && bitcoinPoolPassword && bitcoinPool) {
    self.poolComboBox.stringValue = bitcoinPool;
    self.userNameField.stringValue = bitcoinPoolUser;
    self.passwordField.stringValue = bitcoinPoolPassword;
    }
    
    if ([prefs objectForKey:@"bitcoinPool"] == nil && [prefs objectForKey:@"scryptPool"] == nil && [prefs objectForKey:@"vertcoinPool"] == nil && [prefs objectForKey:@"quarkcoinPool"] == nil) {
        [self.prefWindow orderFront:nil];
        [self.prefView setHidden:YES];
        [self.prefView2 setHidden:YES];
        [self.prefView3 setHidden:NO];
    }
    
    prefs = nil;
}


-(IBAction)preferenceToggle:(id)sender {

    
    if ([self.prefWindow isVisible]) {

        
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        
        
        [prefs setObject:self.charCount.stringValue forKey:@"logLength"];
        
        [prefs synchronize];
        
        prefs = nil;

        if (self.fpgaAsicButton.state == NSOnState) {
            NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
            
            [prefs setObject:@"start" forKey:@"startAsic"];
            
            [prefs synchronize];
            prefs = nil;
        }
        if (self.fpgaAsicButton.state == NSOffState) {
            NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
            
            [prefs setObject:nil forKey:@"startAsic"];
            
            [prefs synchronize];
            prefs = nil;
        }
        if (self.bfgButton.state == NSOnState) {
            NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
            
            [prefs setObject:@"start" forKey:@"startBfg"];
            
            [prefs synchronize];
            prefs = nil;
        }
        if (self.bfgButton.state == NSOffState) {
            NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
            
            [prefs setObject:nil forKey:@"startBfg"];
            
            [prefs synchronize];
            prefs = nil;
        }
        if (self.cgButton.state == NSOnState) {
            NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
            
            [prefs setObject:@"start" forKey:@"startCg"];
            
            [prefs synchronize];
            prefs = nil;
        }
        if (self.cgButton.state == NSOffState) {
            NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
            
            [prefs setObject:nil forKey:@"startCg"];
            
            [prefs synchronize];
            prefs = nil;
        }
        if (self.cpuButton.state == NSOnState) {
            NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
            
            [prefs setObject:@"start" forKey:@"startCpu"];
            
            [prefs synchronize];
            prefs = nil;
        }
        if (self.cpuButton.state == NSOffState) {
            NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
            
            [prefs setObject:nil forKey:@"startCpu"];
            
            [prefs synchronize];
            prefs = nil;
        }
        
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
        
        
        if ([[prefs objectForKey:@"startAsic"] isEqualToString:@"start"]) {
            self.fpgaAsicButton.state = NSOnState;
        }
        else {
            self.fpgaAsicButton.state = NSOffState;
        }
        if ([[prefs objectForKey:@"startBfg"] isEqualToString:@"start"]) {
            self.bfgButton.state = NSOnState;
        }
        else {
            self.bfgButton.state = NSOffState;
        }
        if ([[prefs objectForKey:@"startCg"] isEqualToString:@"start"]) {
            self.cgButton.state = NSOnState;
        }
        else {
            self.cgButton.state = NSOffState;
        }
        if ([[prefs objectForKey:@"startCpu"] isEqualToString:@"start"]) {
            self.cpuButton.state = NSOnState;
        }
        else {
            self.cpuButton.state = NSOffState;
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

- (IBAction)popUpButtonChanged:(id)sender {

    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    
    [prefs synchronize];
    
    //none selected?
    if (self.popUpCoin.indexOfSelectedItem == -1) {
        NSLog(@"You're bugging me out, man! Apparently, no coin type was selected.");
    }
    
    //SHA256
    if (self.popUpCoin.indexOfSelectedItem == 0) {
        [self.poolComboBox removeAllItems];
        [self.poolComboBox setStringValue:@"http://pool.fabulouspanda.co.uk:9332"];
        [self.poolComboBox addItemWithObjectValue:@"http://pool.fabulouspanda.co.uk:9332"];
        [self.poolComboBox addItemWithObjectValue:@"http://stratum.triplemining.com:3334"];
        
        NSString *bitcoinPool = [prefs objectForKey:@"bitcoinPool"];
        NSString *bitcoinPoolUser = [prefs objectForKey:@"bitcoinPoolUser"];
        NSString *bitcoinPoolPassword = [prefs objectForKey:@"bitcoinPoolPassword"];
        
            if (bitcoinPoolUser && bitcoinPoolPassword && bitcoinPool) {
        self.poolComboBox.stringValue = bitcoinPool;
        self.userNameField.stringValue = bitcoinPoolUser;
        self.passwordField.stringValue = bitcoinPoolPassword;
            }
            else {
                self.userNameField.stringValue = @"";
                self.passwordField.stringValue = @"";
            }
        
        bitcoinPoolPassword = nil;
        bitcoinPool = nil;
        bitcoinPoolUser = nil;
        
    }
    
    //Scrypt
    if (self.popUpCoin.indexOfSelectedItem == 1) {
        [self.poolComboBox removeAllItems];
        [self.poolComboBox setStringValue:@"http://pool.fabulouspanda.co.uk:9327"];
        [self.poolComboBox addItemWithObjectValue:@"http://pool.fabulouspanda.co.uk:9327"];
        
        NSString *bitcoinPool = [prefs objectForKey:@"scryptPool"];
        NSString *bitcoinPoolUser = [prefs objectForKey:@"scryptPoolUser"];
        NSString *bitcoinPoolPassword = [prefs objectForKey:@"scryptPoolPassword"];
        
            if (bitcoinPoolUser && bitcoinPoolPassword && bitcoinPool) {
        self.poolComboBox.stringValue = bitcoinPool;
        self.userNameField.stringValue = bitcoinPoolUser;
        self.passwordField.stringValue = bitcoinPoolPassword;
            }
            else {
                self.userNameField.stringValue = @"";
                self.passwordField.stringValue = @"";
            }
        
        bitcoinPoolPassword = nil;
        bitcoinPool = nil;
        bitcoinPoolUser = nil;

    }
    
    //VertCoin
    if (self.popUpCoin.indexOfSelectedItem == 2) {
        [self.poolComboBox removeAllItems];
        
        NSString *bitcoinPool = [prefs objectForKey:@"vertcoinPool"];
        NSString *bitcoinPoolUser = [prefs objectForKey:@"vertcoinPoolUser"];
        NSString *bitcoinPoolPassword = [prefs objectForKey:@"vertcoinPoolPassword"];
        
            if (bitcoinPoolUser && bitcoinPoolPassword && bitcoinPool) {
        self.poolComboBox.stringValue = bitcoinPool;
        self.userNameField.stringValue = bitcoinPoolUser;
        self.passwordField.stringValue = bitcoinPoolPassword;
            }
            else {
                self.userNameField.stringValue = @"";
                self.passwordField.stringValue = @"";
            }
        
        bitcoinPoolPassword = nil;
        bitcoinPool = nil;
        bitcoinPoolUser = nil;
        
    }
    
    //QuarkCoin
    if (self.popUpCoin.indexOfSelectedItem == 3) {
        [self.poolComboBox removeAllItems];
        
        NSString *bitcoinPool = [prefs objectForKey:@"quarkcoinPool"];
        NSString *bitcoinPoolUser = [prefs objectForKey:@"quarkcoinPoolUser"];
        NSString *bitcoinPoolPassword = [prefs objectForKey:@"quarkcoinPoolPassword"];
        
            if (bitcoinPoolUser && bitcoinPoolPassword && bitcoinPool) {
        self.poolComboBox.stringValue = bitcoinPool;
        self.userNameField.stringValue = bitcoinPoolUser;
        self.passwordField.stringValue = bitcoinPoolPassword;
            }
            else {
                self.userNameField.stringValue = @"";
                self.passwordField.stringValue = @"";
            }
        
        bitcoinPoolPassword = nil;
        bitcoinPool = nil;
        bitcoinPoolUser = nil;
        
    }
    
    prefs = nil;
    
}

- (IBAction)savePool:(id)sender {
    
            NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];

    //none selected?
    if (self.popUpCoin.indexOfSelectedItem == -1) {
        NSLog(@"You're bugging me out, man! Apparently, no coin type was selected.");
    }

    //SHA256
    if (self.popUpCoin.indexOfSelectedItem == 0) {
                [prefs setObject:self.poolComboBox.stringValue forKey:@"bitcoinPool"];
                [prefs setObject:self.userNameField.stringValue forKey:@"bitcoinPoolUser"];
                [prefs setObject:self.passwordField.stringValue forKey:@"bitcoinPoolPassword"];
        

        
        //    Write BTC pools to config file
        NSString *bundleConfigPath = [[NSBundle mainBundle] resourcePath];
        
        
        NSString *configFilePath = [bundleConfigPath stringByAppendingPathComponent:@"nobackup.conf"];
        NSString *executableName = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleExecutable"];
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, YES);
        NSString *userpath = [paths objectAtIndex:0];
        userpath = [userpath stringByAppendingPathComponent:executableName];    // The file will go in this directory
        
        NSString *bfgFileText = nil;
        
        if (self.userNameField.stringValue.length >= 1) {
            
            
            bfgFileText = [NSString stringWithContentsOfFile:configFilePath encoding:NSUTF8StringEncoding error:nil];
            
            bfgFileText = [bfgFileText stringByReplacingOccurrencesOfString:@"http://pool.fabulouspanda.co.uk:9332" withString:self.poolComboBox.stringValue];
                bfgFileText = [bfgFileText stringByReplacingOccurrencesOfString:@"user1" withString:self.userNameField.stringValue];
                bfgFileText = [bfgFileText stringByReplacingOccurrencesOfString:@"pass1" withString:self.passwordField.stringValue];

        }
        
        
        NSString *saveBTCFilePath = [userpath stringByAppendingPathComponent:@"bfgurls.conf"];
        
        NSFileManager *fileManager = [[NSFileManager alloc] init];
        if ([fileManager fileExistsAtPath:userpath] == NO) {
            [fileManager createDirectoryAtPath:userpath withIntermediateDirectories:YES attributes:nil error:nil];
            [fileManager copyItemAtPath:configFilePath toPath:saveBTCFilePath error:NULL];
        }
        
        
        NSData *fileContents = [bfgFileText dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
        
        
        [fileManager createFileAtPath:saveBTCFilePath contents:fileContents attributes:nil];

    }
    
    //Scrypt
    if (self.popUpCoin.indexOfSelectedItem == 1) {
        [prefs setObject:self.poolComboBox.stringValue forKey:@"scryptPool"];
        [prefs setObject:self.userNameField.stringValue forKey:@"scryptPoolUser"];
        [prefs setObject:self.passwordField.stringValue forKey:@"scryptPoolPassword"];
        
        //    Write LTC pools to config file
        NSString *bundleConfigPath = [[NSBundle mainBundle] resourcePath];
        
        
        NSString *ltcFilePath = [bundleConfigPath stringByAppendingPathComponent:@"litebackup.conf"];
        NSString *executableName = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleExecutable"];
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, YES);
        NSString *userpath = [paths objectAtIndex:0];
        userpath = [userpath stringByAppendingPathComponent:executableName];    // The file will go in this directory
        
        NSString *ltcFileText = nil;
        
        if (self.userNameField.stringValue.length >= 1) {
            
            
            ltcFileText = [NSString stringWithContentsOfFile:ltcFilePath encoding:NSUTF8StringEncoding error:nil];
            
            ltcFileText = [ltcFileText stringByReplacingOccurrencesOfString:@"http://pool.fabulouspanda.co.uk:9327" withString:self.poolComboBox.stringValue];
            ltcFileText = [ltcFileText stringByReplacingOccurrencesOfString:@"user1" withString:self.userNameField.stringValue];
            ltcFileText = [ltcFileText stringByReplacingOccurrencesOfString:@"pass1" withString:self.passwordField.stringValue];
            
        }
        
        
        NSString *saveLTCFilePath = [userpath stringByAppendingPathComponent:@"ltcurls.conf"];
        
        NSFileManager *fileManager = [[NSFileManager alloc] init];
        if ([fileManager fileExistsAtPath:userpath] == NO) {
            [fileManager createDirectoryAtPath:userpath withIntermediateDirectories:YES attributes:nil error:nil];
            [fileManager copyItemAtPath:ltcFilePath toPath:saveLTCFilePath error:NULL];
        }
        
        
        NSData *fileContents = [ltcFileText dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
        
        
        [fileManager createFileAtPath:saveLTCFilePath contents:fileContents attributes:nil];
    }
    
    //VertCoin
    if (self.popUpCoin.indexOfSelectedItem == 2) {
        [prefs setObject:self.poolComboBox.stringValue forKey:@"vertcoinPool"];
        [prefs setObject:self.userNameField.stringValue forKey:@"vertcoinPoolUser"];
        [prefs setObject:self.passwordField.stringValue forKey:@"vertcoinPoolPassword"];
        
        //    Write VTC pools to config file
        NSString *bundleConfigPath = [[NSBundle mainBundle] resourcePath];
        
        
        NSString *vtcFilePath = [bundleConfigPath stringByAppendingPathComponent:@"litebackup.conf"];
        NSString *executableName = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleExecutable"];
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, YES);
        NSString *userpath = [paths objectAtIndex:0];
        userpath = [userpath stringByAppendingPathComponent:executableName];    // The file will go in this directory
        
        NSString *vtcFileText = nil;
        
        if (self.userNameField.stringValue.length >= 1) {
            
            
            vtcFileText = [NSString stringWithContentsOfFile:vtcFilePath encoding:NSUTF8StringEncoding error:nil];
            
            vtcFileText = [vtcFileText stringByReplacingOccurrencesOfString:@"http://pool.fabulouspanda.co.uk:9327" withString:self.poolComboBox.stringValue];
            vtcFileText = [vtcFileText stringByReplacingOccurrencesOfString:@"user1" withString:self.userNameField.stringValue];
            vtcFileText = [vtcFileText stringByReplacingOccurrencesOfString:@"pass1" withString:self.passwordField.stringValue];
            
        }
        
        
        NSString *saveVTCFilePath = [userpath stringByAppendingPathComponent:@"vtcurls.conf"];
        
        NSFileManager *fileManager = [[NSFileManager alloc] init];
        if ([fileManager fileExistsAtPath:userpath] == NO) {
            [fileManager createDirectoryAtPath:userpath withIntermediateDirectories:YES attributes:nil error:nil];
            [fileManager copyItemAtPath:vtcFilePath toPath:saveVTCFilePath error:NULL];
        }
        
        
        NSData *fileContents = [vtcFileText dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
        
        
        [fileManager createFileAtPath:saveVTCFilePath contents:fileContents attributes:nil];
        
    }
    
    //QuarkCoin
    if (self.popUpCoin.indexOfSelectedItem == 3) {
        [prefs setObject:self.poolComboBox.stringValue forKey:@"quarkcoinPool"];
        [prefs setObject:self.userNameField.stringValue forKey:@"quarkcoinPoolUser"];
        [prefs setObject:self.passwordField.stringValue forKey:@"quarkcoinPoolPassword"];
        
        //    Write QRK pools to config file
        NSString *bundleConfigPath = [[NSBundle mainBundle] resourcePath];
        
        
        NSString *ltcFilePath = [bundleConfigPath stringByAppendingPathComponent:@"litebackup.conf"];
        NSString *executableName = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleExecutable"];
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, YES);
        NSString *userpath = [paths objectAtIndex:0];
        userpath = [userpath stringByAppendingPathComponent:executableName];    // The file will go in this directory
        
        NSString *qrkFileText = nil;
        
        if (self.userNameField.stringValue.length >= 1) {
            
            
            qrkFileText = [NSString stringWithContentsOfFile:ltcFilePath encoding:NSUTF8StringEncoding error:nil];
            
            qrkFileText = [qrkFileText stringByReplacingOccurrencesOfString:@"http://pool.fabulouspanda.co.uk:9327" withString:self.poolComboBox.stringValue];
            qrkFileText = [qrkFileText stringByReplacingOccurrencesOfString:@"user1" withString:self.userNameField.stringValue];
            qrkFileText = [qrkFileText stringByReplacingOccurrencesOfString:@"pass1" withString:self.passwordField.stringValue];
            
        }
        
        
        NSString *saveQRKFilePath = [userpath stringByAppendingPathComponent:@"qrkurls.conf"];
        
        NSFileManager *fileManager = [[NSFileManager alloc] init];
        if ([fileManager fileExistsAtPath:userpath] == NO) {
            [fileManager createDirectoryAtPath:userpath withIntermediateDirectories:YES attributes:nil error:nil];
            [fileManager copyItemAtPath:ltcFilePath toPath:saveQRKFilePath error:NULL];
        }
        
        
        NSData *fileContents = [qrkFileText dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
        
        
        [fileManager createFileAtPath:saveQRKFilePath contents:fileContents attributes:nil];
        
    }
    
    [prefs synchronize];
    
    prefs = nil;
    
}

- (IBAction)showPool:(id)sender {
    [self.prefView setHidden:YES];
    [self.prefView2 setHidden:YES];
    [self.prefView3 setHidden:NO];
}

- (IBAction)mobileMiner:(id)sender {
    [self.prefView setHidden:YES];
    [self.prefView3 setHidden:YES];
        [self.prefView2 setHidden:NO];
}

- (IBAction)showGeneral:(id)sender {
    [self.prefView setHidden:NO];
    [self.prefView2 setHidden:YES];
    [self.prefView3 setHidden:YES];
}


@end
