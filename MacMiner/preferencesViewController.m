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



- (id)initWithCoder:(NSCoder *)aDecoder
{
    
//    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
//    
//    [prefs synchronize];
//    
//    self.charCount.stringValue = [prefs stringForKey:@"logLength" ];
//
//    if ([prefs stringForKey:@"bitcoinPool"] != nil && [prefs stringForKey:@"scryptPool"] != nil && [prefs stringForKey:@"vertcoinPool"] != nil && [prefs stringForKey:@"quarkcoinPool"] != nil) {
//        [self.prefWindow orderFront:nil];
//    }
//    
//    prefs = nil;
    return self;
}

-(void)awakeFromNib {
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    
    [prefs synchronize];
    
            AppDelegate *appDelegate = (AppDelegate *)[[NSApplication sharedApplication] delegate];
    
    NSString *hideVersion = @"";
    if ([prefs stringForKey:@"hideVersion"] != nil) {
        
            hideVersion = [prefs stringForKey:@"hideVersion"];

    if ([hideVersion isEqualToString:@"1518"]) {
        
    }
    else {
        [appDelegate.releaseNotes orderFront:nil];
    }
        
    }
    else {
        [appDelegate.releaseNotes orderFront:nil];
    }
    
    
    if ([prefs stringForKey:@"checkUpdates"] != nil) {
        self.updateButton.state = NSOffState;
    }
    
    if ([prefs stringForKey:@"logLength"] != nil) {
        
    
    NSString *logLength = [prefs stringForKey:@"logLength" ];
    if (logLength) {
    self.charCount.stringValue = logLength;
    }
    }
                        if ([prefs stringForKey:@"bitcoinPool"] != nil) {
    NSString *bitcoinPool = [prefs stringForKey:@"bitcoinPool"];
    NSString *bitcoinPoolUser = [prefs stringForKey:@"bitcoinPoolUser"];
    NSString *bitcoinPoolPassword = [prefs stringForKey:@"bitcoinPoolPassword"];
    
    if (bitcoinPoolUser && bitcoinPoolPassword && bitcoinPool) {
    self.poolComboBox.stringValue = bitcoinPool;
    self.userNameField.stringValue = bitcoinPoolUser;
    self.passwordField.stringValue = bitcoinPoolPassword;
    }
                            
                        }
    
    
    if ([prefs stringForKey:@"bitcoinPool"] == nil && [prefs stringForKey:@"scryptPool"] == nil && [prefs stringForKey:@"vertcoinPool"] == nil && [prefs stringForKey:@"quarkcoinPool"] == nil && [prefs stringForKey:@"maxcoinPool"] == nil) {
        [self.prefWindow orderFront:nil];
        [self.prefView setHidden:YES];
        [self.prefView2 setHidden:YES];
        [self.prefView3 setHidden:NO];
    }
    
    prefs = nil;
}


-(IBAction)preferenceToggle:(id)sender {
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    
    [prefs synchronize];
    
    if ([self.prefWindow isVisible]) {

        
        
        [prefs setObject:self.charCount.stringValue forKey:@"logLength"];


        if (self.fpgaAsicButton.state == NSOnState) {

            [prefs setObject:@"start" forKey:@"startAsic"];
            

        }
        if (self.fpgaAsicButton.state == NSOffState) {
            
            [prefs setObject:nil forKey:@"startAsic"];
            
        }
        if (self.bfgButton.state == NSOnState) {
            
            [prefs setObject:@"start" forKey:@"startBfg"];
            
        }
        if (self.bfgButton.state == NSOffState) {
            
            [prefs setObject:nil forKey:@"startBfg"];

        }
        if (self.cgButton.state == NSOnState) {
            
            [prefs setObject:@"start" forKey:@"startCg"];
            
        }
        if (self.cgButton.state == NSOffState) {
            
            [prefs setObject:nil forKey:@"startCg"];
            
        }
        if (self.cpuButton.state == NSOnState) {
            
            [prefs setObject:@"start" forKey:@"startCpu"];
            
        }
        if (self.cpuButton.state == NSOffState) {
            
            [prefs setObject:nil forKey:@"startCpu"];
            
        }
        
        if (self.dockButton.state == NSOffState) {
            
            [prefs setObject:@"hide" forKey:@"showDockReading"];
            
        }
        if (self.dockButton.state == NSOnState) {
            
            [prefs setObject:nil forKey:@"showDockReading"];
            
        }
        if (self.scrollButton.state == NSOffState) {
            
            [prefs setObject:@"hide" forKey:@"scrollLog"];
            
        }
        if (self.scrollButton.state == NSOnState) {
            
            [prefs setObject:nil forKey:@"scrollLog"];
            
        }
        
        if (self.emailAddress.stringValue.length >= 5) {
            
            [prefs setObject:self.emailAddress.stringValue forKey:@"emailAddress"];
            
        }
        if (self.appID.stringValue.length >= 5) {
            
            [prefs setObject:self.appID.stringValue forKey:@"appID"];
            
        }
                [self.prefWindow orderOut:sender];
    }
    else
    {

        
        if ([prefs stringForKey:@"logLength"] != nil) {
        self.charCount.stringValue = [prefs stringForKey:@"logLength" ];
        }
        
        if ([prefs stringForKey:@"scrollLog"] != nil) {
                        self.scrollButton.state = NSOffState;
        }
        if ([prefs stringForKey:@"showDockReading"] != nil) {
            self.dockButton.state = NSOffState;
        }
        
        
        if ([prefs stringForKey:@"startAsic"] != nil) {
            self.fpgaAsicButton.state = NSOnState;
        }
        else {
            self.fpgaAsicButton.state = NSOffState;
        }
        if ([prefs stringForKey:@"startBfg"] != nil) {
            self.bfgButton.state = NSOnState;
        }
        else {
            self.bfgButton.state = NSOffState;
        }
        if ([prefs stringForKey:@"startCg"] != nil) {
            self.cgButton.state = NSOnState;
        }
        else {
            self.cgButton.state = NSOffState;
        }
        if ([prefs stringForKey:@"startCpu"] != nil) {
            self.cpuButton.state = NSOnState;
        }
        else {
            self.cpuButton.state = NSOffState;
        }
        
        if ([prefs stringForKey:@"emailAddress"] != nil) {
        self.emailAddress.stringValue = [prefs stringForKey:@"emailAddress"];
        }
                if ([prefs stringForKey:@"appID"] != nil) {
        self.appID.stringValue = [prefs stringForKey:@"appID"];
                }
        
        [self.prefWindow orderFront:sender];
        
    }
                [prefs synchronize];
    
            prefs = nil;
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
        
        [prefs setObject:nil forKey:@"showDockReading"];
        
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
        
        [prefs setObject:nil forKey:@"enableSpeech"];
        
        [prefs synchronize];
    }
}

- (IBAction)popUpButtonChanged:(id)sender {

    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    
    [prefs synchronize];
    
    //none selected?
    if (self.popUpCoin.indexOfSelectedItem == -1) {
        NSLog(@"Apparently, no coin type was selected. That's not right.");
    }
    
    //SHA256
    if (self.popUpCoin.indexOfSelectedItem == 0) {
        [self.poolComboBox removeAllItems];
        [self.poolComboBox setStringValue:@"http://pool.fabulouspanda.co.uk:9332"];
        [self.poolComboBox addItemWithObjectValue:@"http://pool.fabulouspanda.co.uk:9332"];
        [self.poolComboBox addItemWithObjectValue:@"http://stratum.triplemining.com:3334"];
        [self.poolComboBox addItemWithObjectValue:@"http://stratum.bitcoin.cz:3333"];
        
                    if ([prefs stringForKey:@"bitcoinPool"] != nil) {
        NSString *bitcoinPool = [prefs stringForKey:@"bitcoinPool"];
        NSString *bitcoinPoolUser = [prefs stringForKey:@"bitcoinPoolUser"];
        NSString *bitcoinPoolPassword = [prefs stringForKey:@"bitcoinPoolPassword"];

                    
        
                        if (bitcoinPoolUser != nil && bitcoinPoolPassword != nil && bitcoinPool != nil) {
        self.poolComboBox.stringValue = bitcoinPool;
        self.userNameField.stringValue = bitcoinPoolUser;
        self.passwordField.stringValue = bitcoinPoolPassword;
            }

        
        bitcoinPoolPassword = nil;
        bitcoinPool = nil;
        bitcoinPoolUser = nil;
                    }
                    else {
                        self.userNameField.stringValue = @"";
                        self.passwordField.stringValue = @"";
                    }
        
    }
    
    //Scrypt
    if (self.popUpCoin.indexOfSelectedItem == 1) {
        [self.poolComboBox removeAllItems];
        [self.poolComboBox setStringValue:@"http://buf.snicter.com:9327"];
        [self.poolComboBox addItemWithObjectValue:@"http://pool.fabulouspanda.co.uk:9327"];
        [self.poolComboBox addItemWithObjectValue:@"http://buf.snicter.com:9327"];
        [self.poolComboBox addItemWithObjectValue:@"spare.ozco.in:9333"];
        [self.poolComboBox addItemWithObjectValue:@"mine.pool-x.eu:9000"];
        [self.poolComboBox addItemWithObjectValue:@"www.ltcbox.net:3333"];
    
        if ([prefs stringForKey:@"scryptPool"] != nil) {
        
        NSString *bitcoinPool = [prefs stringForKey:@"scryptPool"];
        NSString *bitcoinPoolUser = [prefs stringForKey:@"scryptPoolUser"];
        NSString *bitcoinPoolPassword = [prefs stringForKey:@"scryptPoolPassword"];

        
                        if (bitcoinPoolUser != nil && bitcoinPoolPassword != nil && bitcoinPool != nil) {
        self.poolComboBox.stringValue = bitcoinPool;
        self.userNameField.stringValue = bitcoinPoolUser;
        self.passwordField.stringValue = bitcoinPoolPassword;
            }

        
        bitcoinPoolPassword = nil;
        bitcoinPool = nil;
        bitcoinPoolUser = nil;
        }
        else {
            self.userNameField.stringValue = @"";
            self.passwordField.stringValue = @"";
        }
    }
    
    //VertCoin Scrypt Adaptive-N
    if (self.popUpCoin.indexOfSelectedItem == 2) {
        [self.poolComboBox removeAllItems];
        [self.poolComboBox setStringValue:@"stratum+tcp://pool.verters.com"];
        [self.poolComboBox addItemWithObjectValue:@"stratum+tcp://pool.verters.com"];
        [self.poolComboBox addItemWithObjectValue:@"stratum+tcp://stratum.kilovolt.co.uk:3333"];
        [self.poolComboBox addItemWithObjectValue:@"http://buf.snicter.com:9327"];
        [self.poolComboBox addItemWithObjectValue:@"stratum+tcp://stratum.vertco.in:8080"];
        [self.poolComboBox addItemWithObjectValue:@"stratum+tcp://vert.bitcrush.info:3444"];
        [self.poolComboBox addItemWithObjectValue:@"37.153.96.115:9171"];
        
                            if ([prefs stringForKey:@"vertcoinPool"] != nil) {
                                
        NSString *bitcoinPool = [prefs stringForKey:@"vertcoinPool"];
        NSString *bitcoinPoolUser = [prefs stringForKey:@"vertcoinPoolUser"];
        NSString *bitcoinPoolPassword = [prefs stringForKey:@"vertcoinPoolPassword"];

        
                        if (bitcoinPoolUser != nil && bitcoinPoolPassword != nil && bitcoinPool != nil) {
        self.poolComboBox.stringValue = bitcoinPool;
        self.userNameField.stringValue = bitcoinPoolUser;
        self.passwordField.stringValue = bitcoinPoolPassword;
            }

        
        bitcoinPoolPassword = nil;
        bitcoinPool = nil;
        bitcoinPoolUser = nil;
                            }
                            else {
                                self.userNameField.stringValue = @"";
                                self.passwordField.stringValue = @"";
                            }
    }
    
    //QuarkCoin
    if (self.popUpCoin.indexOfSelectedItem == 3) {
        [self.poolComboBox removeAllItems];
        [self.poolComboBox setStringValue:@"stratum+tcp://qrk.suprnova.cc"];
        [self.poolComboBox addItemWithObjectValue:@"stratum+tcp://qrk.suprnova.cc"];
        [self.poolComboBox addItemWithObjectValue:@"http://p2pool.org:8372"];

        
                            if ([prefs stringForKey:@"quarkcoinPool"] != nil) {
                                
        NSString *bitcoinPool = [prefs stringForKey:@"quarkcoinPool"];
        NSString *bitcoinPoolUser = [prefs stringForKey:@"quarkcoinPoolUser"];
        NSString *bitcoinPoolPassword = [prefs stringForKey:@"quarkcoinPoolPassword"];
        
                        if (bitcoinPoolUser != nil && bitcoinPoolPassword != nil && bitcoinPool != nil) {
        self.poolComboBox.stringValue = bitcoinPool;
        self.userNameField.stringValue = bitcoinPoolUser;
        self.passwordField.stringValue = bitcoinPoolPassword;
            }

        
        bitcoinPoolPassword = nil;
        bitcoinPool = nil;
        bitcoinPoolUser = nil;
                            }
        
                            else {
                                self.userNameField.stringValue = @"";
                                self.passwordField.stringValue = @"";
                            }
        
    }
    
    //MaxCoin
    if (self.popUpCoin.indexOfSelectedItem == 4) {
        [self.poolComboBox removeAllItems];
        [self.poolComboBox setStringValue:@"stratum+tcp://stratum01.max-coin.net:3333"];
        [self.poolComboBox addItemWithObjectValue:@"stratum+tcp://stratum01.max-coin.net:3333"];
        
                            if ([prefs stringForKey:@"maxcoinPool"] != nil) {
        
        NSString *bitcoinPool = [prefs stringForKey:@"maxcoinPool"];
        NSString *bitcoinPoolUser = [prefs stringForKey:@"maxcoinPoolUser"];
        NSString *bitcoinPoolPassword = [prefs stringForKey:@"maxcoinPoolPassword"];
        
                        if (bitcoinPoolUser != nil && bitcoinPoolPassword != nil && bitcoinPool != nil) {
            self.poolComboBox.stringValue = bitcoinPool;
            self.userNameField.stringValue = bitcoinPoolUser;
            self.passwordField.stringValue = bitcoinPoolPassword;
        }

        
        bitcoinPoolPassword = nil;
        bitcoinPool = nil;
        bitcoinPoolUser = nil;
                            }
                            else {
                                self.userNameField.stringValue = @"";
                                self.passwordField.stringValue = @"";
                            }
    }
    
    prefs = nil;
    
    
    
}

- (IBAction)savePool:(id)sender {
    
            NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];

    //none selected?
    if (self.popUpCoin.indexOfSelectedItem == -1) {
        NSLog(@"Apparently, no coin type was selected. That's not right.");
    }

    //SHA256
    if (self.popUpCoin.indexOfSelectedItem == 0) {
                [prefs setObject:self.poolComboBox.stringValue forKey:@"bitcoinPool"];
                [prefs setObject:self.userNameField.stringValue forKey:@"bitcoinPoolUser"];
                [prefs setObject:self.passwordField.stringValue forKey:@"bitcoinPoolPassword"];
                        [prefs setObject:self.poolComboBox.stringValue forKey:@"defaultPoolValue"];

        
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
                        [prefs setObject:self.poolComboBox.stringValue forKey:@"defaultLTCPoolValue"];
        
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
    
    //VertCoin Scrypt Adaptive-N
    if (self.popUpCoin.indexOfSelectedItem == 2) {
        [prefs setObject:self.poolComboBox.stringValue forKey:@"vertcoinPool"];
        [prefs setObject:self.userNameField.stringValue forKey:@"vertcoinPoolUser"];
        [prefs setObject:self.passwordField.stringValue forKey:@"vertcoinPoolPassword"];
                        [prefs setObject:self.poolComboBox.stringValue forKey:@"defaultVTCPoolValue"];
        
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
                                [prefs setObject:self.poolComboBox.stringValue forKey:@"defaultQRKPoolValue"];
        
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
    
    //MaxCoin
    if (self.popUpCoin.indexOfSelectedItem == 4) {
        [prefs setObject:self.poolComboBox.stringValue forKey:@"maxcoinPool"];
        [prefs setObject:self.userNameField.stringValue forKey:@"maxcoinPoolUser"];
        [prefs setObject:self.passwordField.stringValue forKey:@"maxcoinPoolPassword"];
                        [prefs setObject:self.poolComboBox.stringValue forKey:@"defaultMAXPoolValue"];
        
        //    Write QRK pools to config file
        NSString *bundleConfigPath = [[NSBundle mainBundle] resourcePath];
        
        
        NSString *ltcFilePath = [bundleConfigPath stringByAppendingPathComponent:@"litebackup.conf"];
        NSString *executableName = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleExecutable"];
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, YES);
        NSString *userpath = [paths objectAtIndex:0];
        userpath = [userpath stringByAppendingPathComponent:executableName];    // The file will go in this directory
        
        NSString *maxFileText = nil;
        
        if (self.userNameField.stringValue.length >= 1) {
            
            
            maxFileText = [NSString stringWithContentsOfFile:ltcFilePath encoding:NSUTF8StringEncoding error:nil];
            
            maxFileText = [maxFileText stringByReplacingOccurrencesOfString:@"http://pool.fabulouspanda.co.uk:9327" withString:self.poolComboBox.stringValue];
            maxFileText = [maxFileText stringByReplacingOccurrencesOfString:@"user1" withString:self.userNameField.stringValue];
            maxFileText = [maxFileText stringByReplacingOccurrencesOfString:@"pass1" withString:self.passwordField.stringValue];
            
        }
        
        
        NSString *saveMAXFilePath = [userpath stringByAppendingPathComponent:@"maxurls.conf"];
        
        NSFileManager *fileManager = [[NSFileManager alloc] init];
        if ([fileManager fileExistsAtPath:userpath] == NO) {
            [fileManager createDirectoryAtPath:userpath withIntermediateDirectories:YES attributes:nil error:nil];
            [fileManager copyItemAtPath:ltcFilePath toPath:saveMAXFilePath error:NULL];
        }
        
        
        NSData *fileContents = [maxFileText dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
        
        
        [fileManager createFileAtPath:saveMAXFilePath contents:fileContents attributes:nil];
        
    }
    
    [prefs synchronize];
    
    NSAlert * myAlert=[[NSAlert alloc] init];
    [myAlert setMessageText:@"Your pool has been saved."];
    [myAlert addButtonWithTitle:@"OK"];
    
    switch ([myAlert runModal]) {
        case NSAlertFirstButtonReturn:
            //handle first button
            
            //            [self closeWindow];
            
            break;
    }
    myAlert = nil;

    
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

- (IBAction)openPool:(id)sender {
[self.prefWindow orderFront:nil];
[self.prefView setHidden:YES];
[self.prefView2 setHidden:YES];
[self.prefView3 setHidden:NO];
}

- (IBAction)updateBox:(id)sender {
    if (self.updateButton.state == NSOnState) {
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        
        [prefs setObject:nil forKey:@"checkUpdates"];
        
        [prefs synchronize];
    }
    else {
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        
        [prefs setObject:@"nocheck" forKey:@"checkUpdates"];
        
        [prefs synchronize];
    }
}


@end
