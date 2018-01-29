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



//- (id)initWithCoder:(NSCoder *)aDecoder
//{
//    
////    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
////    
////    [prefs synchronize];
////    
////    self.charCount.stringValue = [prefs stringForKey:@"logLength" ];
////
////    if ([prefs stringForKey:@"bitcoinPool"] != nil && [prefs stringForKey:@"scryptPool"] != nil && [prefs stringForKey:@"vertcoinPool"] != nil && [prefs stringForKey:@"quarkcoinPool"] != nil) {
////        [self.prefWindow orderFront:nil];
////    }
////    
////    prefs = nil;
//    return self;
//}

-(void)awakeFromNib {
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    
    [prefs synchronize];
    
            AppDelegate *appDelegate = (AppDelegate *)[[NSApplication sharedApplication] delegate];
    
    NSString *hideVersion = @"";
    if ([prefs stringForKey:@"hideVersion"] != nil) {
        
            hideVersion = [prefs stringForKey:@"hideVersion"];

    if ([hideVersion isEqualToString:@"1525"]) {
        
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
        [self.poolComboBox setStringValue:@"http://stratum.mining.eligius.st:3334"];
        [self.poolComboBox addItemWithObjectValue:@"http://stratum.mining.eligius.st:3334"];
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
    
    //X11/Darkcoin
    if (self.popUpCoin.indexOfSelectedItem == 5) {
        [self.poolComboBox removeAllItems];
        
        if ([prefs stringForKey:@"x11Pool"] != nil) {
            
            NSString *bitcoinPool = [prefs stringForKey:@"x11Pool"];
            NSString *bitcoinPoolUser = [prefs stringForKey:@"x11PoolUser"];
            NSString *bitcoinPoolPassword = [prefs stringForKey:@"x11PoolPassword"];
            
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
    
    //XMR/Cryptonight
    if (self.popUpCoin.indexOfSelectedItem == 6) {
        [self.poolComboBox removeAllItems];
        
        if ([prefs stringForKey:@"XMRPool"] != nil) {
            
            NSString *bitcoinPool = [prefs stringForKey:@"XMRPool"];
            NSString *bitcoinPoolUser = [prefs stringForKey:@"XMRPoolUser"];
            NSString *bitcoinPoolPassword = [prefs stringForKey:@"XMRPoolPassword"];
            
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
    //credit
    if (self.popUpCoin.indexOfSelectedItem == 7) {
        [self.poolComboBox removeAllItems];
        
        if ([prefs stringForKey:@"creditPool"] != nil) {
            
            NSString *bitcoinPool = [prefs stringForKey:@"creditPool"];
            NSString *bitcoinPoolUser = [prefs stringForKey:@"creditPoolUser"];
            NSString *bitcoinPoolPassword = [prefs stringForKey:@"creditPoolPassword"];
            
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
    
    
    if (self.popUpCoin.indexOfSelectedItem == 8) {
        [self.poolComboBox removeAllItems];
        
        if ([prefs stringForKey:@"pascalPool"] != nil) {
            
            NSString *bitcoinPool = [prefs stringForKey:@"pascalPool"];
            NSString *bitcoinPoolUser = [prefs stringForKey:@"pascalPoolUser"];
            NSString *bitcoinPoolPassword = [prefs stringForKey:@"pascalPoolPassword"];
            
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
    if (self.popUpCoin.indexOfSelectedItem == 9) {
        [self.poolComboBox removeAllItems];
        
        if ([prefs stringForKey:@"x13Pool"] != nil) {
            
            NSString *bitcoinPool = [prefs stringForKey:@"x13Pool"];
            NSString *bitcoinPoolUser = [prefs stringForKey:@"x13PoolUser"];
            NSString *bitcoinPoolPassword = [prefs stringForKey:@"x13PoolPassword"];
            
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
    if (self.popUpCoin.indexOfSelectedItem == 10) {
        [self.poolComboBox removeAllItems];
        
        if ([prefs stringForKey:@"x14Pool"] != nil) {
            
            NSString *bitcoinPool = [prefs stringForKey:@"x14Pool"];
            NSString *bitcoinPoolUser = [prefs stringForKey:@"x14PoolUser"];
            NSString *bitcoinPoolPassword = [prefs stringForKey:@"x14PoolPassword"];
            
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
    if (self.popUpCoin.indexOfSelectedItem == 11) {
        [self.poolComboBox removeAllItems];
        
        if ([prefs stringForKey:@"x15Pool"] != nil) {
            
            NSString *bitcoinPool = [prefs stringForKey:@"x15Pool"];
            NSString *bitcoinPoolUser = [prefs stringForKey:@"x15PoolUser"];
            NSString *bitcoinPoolPassword = [prefs stringForKey:@"x15PoolPassword"];
            
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
    if (self.popUpCoin.indexOfSelectedItem == 12) {
        [self.poolComboBox removeAllItems];
        
        if ([prefs stringForKey:@"keccakPool"] != nil) {
            
            NSString *bitcoinPool = [prefs stringForKey:@"keccakPool"];
            NSString *bitcoinPoolUser = [prefs stringForKey:@"keccakPoolUser"];
            NSString *bitcoinPoolPassword = [prefs stringForKey:@"keccakPoolPassword"];
            
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
    if (self.popUpCoin.indexOfSelectedItem == 13) {
        [self.poolComboBox removeAllItems];
        
        if ([prefs stringForKey:@"twePool"] != nil) {
            
            NSString *bitcoinPool = [prefs stringForKey:@"twePool"];
            NSString *bitcoinPoolUser = [prefs stringForKey:@"twePoolUser"];
            NSString *bitcoinPoolPassword = [prefs stringForKey:@"twePoolPassword"];
            
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
    if (self.popUpCoin.indexOfSelectedItem == 14) {
        [self.poolComboBox removeAllItems];
        
        if ([prefs stringForKey:@"fuguePool"] != nil) {
            
            NSString *bitcoinPool = [prefs stringForKey:@"fuguePool"];
            NSString *bitcoinPoolUser = [prefs stringForKey:@"fuguePoolUser"];
            NSString *bitcoinPoolPassword = [prefs stringForKey:@"fuguePoolPassword"];
            
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
    if (self.popUpCoin.indexOfSelectedItem == 15) {
        [self.poolComboBox removeAllItems];
        
        if ([prefs stringForKey:@"nistPool"] != nil) {
            
            NSString *bitcoinPool = [prefs stringForKey:@"nistPool"];
            NSString *bitcoinPoolUser = [prefs stringForKey:@"nistPoolUser"];
            NSString *bitcoinPoolPassword = [prefs stringForKey:@"nistPoolPassword"];
            
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
    if (self.popUpCoin.indexOfSelectedItem == 16) {
        [self.poolComboBox removeAllItems];
        
        if ([prefs stringForKey:@"freshPool"] != nil) {
            
            NSString *bitcoinPool = [prefs stringForKey:@"freshPool"];
            NSString *bitcoinPoolUser = [prefs stringForKey:@"freshPoolUser"];
            NSString *bitcoinPoolPassword = [prefs stringForKey:@"freshPoolPassword"];
            
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
    if (self.popUpCoin.indexOfSelectedItem == 17) {
        [self.poolComboBox removeAllItems];
        
        if ([prefs stringForKey:@"whirlPool"] != nil) {
            
            NSString *bitcoinPool = [prefs stringForKey:@"whirlPool"];
            NSString *bitcoinPoolUser = [prefs stringForKey:@"whirlPoolUser"];
            NSString *bitcoinPoolPassword = [prefs stringForKey:@"whirlPoolPassword"];
            
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
    if (self.popUpCoin.indexOfSelectedItem == 18) {
        [self.poolComboBox removeAllItems];
        
        if ([prefs stringForKey:@"neoscryptPool"] != nil) {
            
            NSString *bitcoinPool = [prefs stringForKey:@"neoscryptPool"];
            NSString *bitcoinPoolUser = [prefs stringForKey:@"neoscryptPoolUser"];
            NSString *bitcoinPoolPassword = [prefs stringForKey:@"neoscryptPoolPassword"];
            
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
    if (self.popUpCoin.indexOfSelectedItem == 19) {
        [self.poolComboBox removeAllItems];
        
        if ([prefs stringForKey:@"whirlxPool"] != nil) {
            
            NSString *bitcoinPool = [prefs stringForKey:@"whirlxPool"];
            NSString *bitcoinPoolUser = [prefs stringForKey:@"whirlxPoolUser"];
            NSString *bitcoinPoolPassword = [prefs stringForKey:@"whirlxPoolPassword"];
            
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
    if (self.popUpCoin.indexOfSelectedItem == 20) {
        [self.poolComboBox removeAllItems];
        
        if ([prefs stringForKey:@"lyra2rePool"] != nil) {
            
            NSString *bitcoinPool = [prefs stringForKey:@"lyra2rePool"];
            NSString *bitcoinPoolUser = [prefs stringForKey:@"lyra2rePoolUser"];
            NSString *bitcoinPoolPassword = [prefs stringForKey:@"lyra2rePoolPassword"];
            
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
    if (self.popUpCoin.indexOfSelectedItem == 21) {
        [self.poolComboBox removeAllItems];
        
        if ([prefs stringForKey:@"lyra2rev2Pool"] != nil) {
            
            NSString *bitcoinPool = [prefs stringForKey:@"lyra2rev2Pool"];
            NSString *bitcoinPoolUser = [prefs stringForKey:@"lyra2rev2PoolUser"];
            NSString *bitcoinPoolPassword = [prefs stringForKey:@"lyra2rev2PoolPassword"];
            
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
    if (self.popUpCoin.indexOfSelectedItem == 22) {
        [self.poolComboBox removeAllItems];
        
        if ([prefs stringForKey:@"pluckPool"] != nil) {
            
            NSString *bitcoinPool = [prefs stringForKey:@"pluckPool"];
            NSString *bitcoinPoolUser = [prefs stringForKey:@"pluckPoolUser"];
            NSString *bitcoinPoolPassword = [prefs stringForKey:@"pluckPoolPassword"];
            
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
    if (self.popUpCoin.indexOfSelectedItem == 23) {
        [self.poolComboBox removeAllItems];
        
        if ([prefs stringForKey:@"yescryptPool"] != nil) {
            
            NSString *bitcoinPool = [prefs stringForKey:@"yescryptPool"];
            NSString *bitcoinPoolUser = [prefs stringForKey:@"yescryptPoolUser"];
            NSString *bitcoinPoolPassword = [prefs stringForKey:@"yescryptPoolPassword"];
            
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
    if (self.popUpCoin.indexOfSelectedItem == 24) {
        [self.poolComboBox removeAllItems];
        
        if ([prefs stringForKey:@"yescryptmultiPool"] != nil) {
            
            NSString *bitcoinPool = [prefs stringForKey:@"yescryptmultiPool"];
            NSString *bitcoinPoolUser = [prefs stringForKey:@"yescryptmultiPoolUser"];
            NSString *bitcoinPoolPassword = [prefs stringForKey:@"yescryptmultiPoolPassword"];
            
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
    if (self.popUpCoin.indexOfSelectedItem == 25) {
        [self.poolComboBox removeAllItems];
        
        if ([prefs stringForKey:@"blakecoinPool"] != nil) {
            
            NSString *bitcoinPool = [prefs stringForKey:@"blakecoinPool"];
            NSString *bitcoinPoolUser = [prefs stringForKey:@"blakecoinPoolUser"];
            NSString *bitcoinPoolPassword = [prefs stringForKey:@"blakecoinPoolPassword"];
            
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
    if (self.popUpCoin.indexOfSelectedItem == 26) {
        [self.poolComboBox removeAllItems];
        
        if ([prefs stringForKey:@"blakePool"] != nil) {
            
            NSString *bitcoinPool = [prefs stringForKey:@"blakePool"];
            NSString *bitcoinPoolUser = [prefs stringForKey:@"blakePoolUser"];
            NSString *bitcoinPoolPassword = [prefs stringForKey:@"blakePoolPassword"];
            
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
    if (self.popUpCoin.indexOfSelectedItem == 27) {
        [self.poolComboBox removeAllItems];
        
        if ([prefs stringForKey:@"siaPool"] != nil) {
            
            NSString *bitcoinPool = [prefs stringForKey:@"siaPool"];
            NSString *bitcoinPoolUser = [prefs stringForKey:@"siaPoolUser"];
            NSString *bitcoinPoolPassword = [prefs stringForKey:@"siaPoolPassword"];
            
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
    if (self.popUpCoin.indexOfSelectedItem == 28) {
        [self.poolComboBox removeAllItems];
        
        if ([prefs stringForKey:@"decredPool"] != nil) {
            
            NSString *bitcoinPool = [prefs stringForKey:@"decredPool"];
            NSString *bitcoinPoolUser = [prefs stringForKey:@"decredPoolUser"];
            NSString *bitcoinPoolPassword = [prefs stringForKey:@"decredPoolPassword"];
            
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
    if (self.popUpCoin.indexOfSelectedItem == 29) {
        [self.poolComboBox removeAllItems];
        
        if ([prefs stringForKey:@"vanillaPool"] != nil) {
            
            NSString *bitcoinPool = [prefs stringForKey:@"vanillaPool"];
            NSString *bitcoinPoolUser = [prefs stringForKey:@"vanillaPoolUser"];
            NSString *bitcoinPoolPassword = [prefs stringForKey:@"vanillaPoolPassword"];
            
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
    if (self.popUpCoin.indexOfSelectedItem == 30) {
        [self.poolComboBox removeAllItems];
        
        if ([prefs stringForKey:@"lbryPool"] != nil) {
            
            NSString *bitcoinPool = [prefs stringForKey:@"lbryPool"];
            NSString *bitcoinPoolUser = [prefs stringForKey:@"lbryPoolUser"];
            NSString *bitcoinPoolPassword = [prefs stringForKey:@"lbryPoolPassword"];
            
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
    if (self.popUpCoin.indexOfSelectedItem == 31) {
        [self.poolComboBox removeAllItems];
        
        if ([prefs stringForKey:@"sibPool"] != nil) {
            
            NSString *bitcoinPool = [prefs stringForKey:@"sibPool"];
            NSString *bitcoinPoolUser = [prefs stringForKey:@"sibPoolUser"];
            NSString *bitcoinPoolPassword = [prefs stringForKey:@"sibPoolPassword"];
            
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
    if (self.popUpCoin.indexOfSelectedItem == 32) {
        [self.poolComboBox removeAllItems];
        
        if ([prefs stringForKey:@"x17Pool"] != nil) {
            
            NSString *bitcoinPool = [prefs stringForKey:@"x17Pool"];
            NSString *bitcoinPoolUser = [prefs stringForKey:@"x17PoolUser"];
            NSString *bitcoinPoolPassword = [prefs stringForKey:@"x17PoolPassword"];
            
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
    
    if (self.popUpCoin.indexOfSelectedItem == 33) {
        [self.poolComboBox removeAllItems];
        
        if ([prefs stringForKey:@"xmrlightPool"] != nil) {
            
            NSString *bitcoinPool = [prefs stringForKey:@"xmrlightPool"];
            NSString *bitcoinPoolUser = [prefs stringForKey:@"xmrlightPoolUser"];
            NSString *bitcoinPoolPassword = [prefs stringForKey:@"xmrlightPoolPassword"];
            
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
    
    //x11
    if (self.popUpCoin.indexOfSelectedItem == 5) {
        [prefs setObject:self.poolComboBox.stringValue forKey:@"x11Pool"];
        [prefs setObject:self.userNameField.stringValue forKey:@"x11PoolUser"];
        [prefs setObject:self.passwordField.stringValue forKey:@"x11PoolPassword"];
        [prefs setObject:self.poolComboBox.stringValue forKey:@"defaultx11PoolValue"];
        
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
        
        
        NSString *saveMAXFilePath = [userpath stringByAppendingPathComponent:@"x11urls.conf"];
        
        NSFileManager *fileManager = [[NSFileManager alloc] init];
        if ([fileManager fileExistsAtPath:userpath] == NO) {
            [fileManager createDirectoryAtPath:userpath withIntermediateDirectories:YES attributes:nil error:nil];
            [fileManager copyItemAtPath:ltcFilePath toPath:saveMAXFilePath error:NULL];
        }
        
        
        NSData *fileContents = [maxFileText dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
        
        
        [fileManager createFileAtPath:saveMAXFilePath contents:fileContents attributes:nil];
        
    }
    
    //xmr
    if (self.popUpCoin.indexOfSelectedItem == 6) {
        [prefs setObject:self.poolComboBox.stringValue forKey:@"XMRPool"];
        [prefs setObject:self.userNameField.stringValue forKey:@"XMRPoolUser"];
        [prefs setObject:self.passwordField.stringValue forKey:@"XMRPoolPassword"];
        [prefs setObject:self.poolComboBox.stringValue forKey:@"defaultXMRPoolValue"];
        
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
        
        
        NSString *saveMAXFilePath = [userpath stringByAppendingPathComponent:@"xmrurls.conf"];
        
        NSFileManager *fileManager = [[NSFileManager alloc] init];
        if ([fileManager fileExistsAtPath:userpath] == NO) {
            [fileManager createDirectoryAtPath:userpath withIntermediateDirectories:YES attributes:nil error:nil];
            [fileManager copyItemAtPath:ltcFilePath toPath:saveMAXFilePath error:NULL];
        }
        
        
        NSData *fileContents = [maxFileText dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
        
        
        [fileManager createFileAtPath:saveMAXFilePath contents:fileContents attributes:nil];
        
    }
    
    //credits
    if (self.popUpCoin.indexOfSelectedItem == 7) {
        [prefs setObject:self.poolComboBox.stringValue forKey:@"CreditsPool"];
        [prefs setObject:self.userNameField.stringValue forKey:@"CreditsPoolUser"];
        [prefs setObject:self.passwordField.stringValue forKey:@"CreditsPoolPassword"];
        [prefs setObject:self.poolComboBox.stringValue forKey:@"defaultCreditsPoolValue"];
        
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
        
        
        NSString *saveFilePath = [userpath stringByAppendingPathComponent:@"creditsurls.conf"];
        
        NSFileManager *fileManager = [[NSFileManager alloc] init];
        if ([fileManager fileExistsAtPath:userpath] == NO) {
            [fileManager createDirectoryAtPath:userpath withIntermediateDirectories:YES attributes:nil error:nil];
            [fileManager copyItemAtPath:ltcFilePath toPath:saveFilePath error:NULL];
        }
        
        
        NSData *fileContents = [maxFileText dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
        
        
        [fileManager createFileAtPath:saveFilePath contents:fileContents attributes:nil];
        
    }
    
    //pascal
    if (self.popUpCoin.indexOfSelectedItem == 8) {
        [prefs setObject:self.poolComboBox.stringValue forKey:@"pascalPool"];
        [prefs setObject:self.userNameField.stringValue forKey:@"pascalPoolUser"];
        [prefs setObject:self.passwordField.stringValue forKey:@"pascalPoolPassword"];
        [prefs setObject:self.poolComboBox.stringValue forKey:@"defaultpascalPoolValue"];
        
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
        
        
        NSString *saveFilePath = [userpath stringByAppendingPathComponent:@"pascalurls.conf"];
        
        NSFileManager *fileManager = [[NSFileManager alloc] init];
        if ([fileManager fileExistsAtPath:userpath] == NO) {
            [fileManager createDirectoryAtPath:userpath withIntermediateDirectories:YES attributes:nil error:nil];
            [fileManager copyItemAtPath:ltcFilePath toPath:saveFilePath error:NULL];
        }
        
        
        NSData *fileContents = [maxFileText dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
        
        
        [fileManager createFileAtPath:saveFilePath contents:fileContents attributes:nil];
        
    }
 
    
    //x13
    if (self.popUpCoin.indexOfSelectedItem == 9) {
        [prefs setObject:self.poolComboBox.stringValue forKey:@"x13Pool"];
        [prefs setObject:self.userNameField.stringValue forKey:@"x13PoolUser"];
        [prefs setObject:self.passwordField.stringValue forKey:@"x13PoolPassword"];
        [prefs setObject:self.poolComboBox.stringValue forKey:@"defaultx13PoolValue"];
        
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
        
        
        NSString *saveFilePath = [userpath stringByAppendingPathComponent:@"x13urls.conf"];
        
        NSFileManager *fileManager = [[NSFileManager alloc] init];
        if ([fileManager fileExistsAtPath:userpath] == NO) {
            [fileManager createDirectoryAtPath:userpath withIntermediateDirectories:YES attributes:nil error:nil];
            [fileManager copyItemAtPath:ltcFilePath toPath:saveFilePath error:NULL];
        }
        
        
        NSData *fileContents = [maxFileText dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
        
        
        [fileManager createFileAtPath:saveFilePath contents:fileContents attributes:nil];
        
    }
    
    //x14
    if (self.popUpCoin.indexOfSelectedItem == 10) {
        [prefs setObject:self.poolComboBox.stringValue forKey:@"x14Pool"];
        [prefs setObject:self.userNameField.stringValue forKey:@"x14PoolUser"];
        [prefs setObject:self.passwordField.stringValue forKey:@"x14PoolPassword"];
        [prefs setObject:self.poolComboBox.stringValue forKey:@"defaultx14PoolValue"];
        
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
        
        
        NSString *saveFilePath = [userpath stringByAppendingPathComponent:@"x14urls.conf"];
        
        NSFileManager *fileManager = [[NSFileManager alloc] init];
        if ([fileManager fileExistsAtPath:userpath] == NO) {
            [fileManager createDirectoryAtPath:userpath withIntermediateDirectories:YES attributes:nil error:nil];
            [fileManager copyItemAtPath:ltcFilePath toPath:saveFilePath error:NULL];
        }
        
        
        NSData *fileContents = [maxFileText dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
        
        
        [fileManager createFileAtPath:saveFilePath contents:fileContents attributes:nil];
        
    }
    
    //x15
    if (self.popUpCoin.indexOfSelectedItem == 11) {
        [prefs setObject:self.poolComboBox.stringValue forKey:@"x15Pool"];
        [prefs setObject:self.userNameField.stringValue forKey:@"x15PoolUser"];
        [prefs setObject:self.passwordField.stringValue forKey:@"x15PoolPassword"];
        [prefs setObject:self.poolComboBox.stringValue forKey:@"defaultx15PoolValue"];
        
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
        
        
        NSString *saveFilePath = [userpath stringByAppendingPathComponent:@"x15urls.conf"];
        
        NSFileManager *fileManager = [[NSFileManager alloc] init];
        if ([fileManager fileExistsAtPath:userpath] == NO) {
            [fileManager createDirectoryAtPath:userpath withIntermediateDirectories:YES attributes:nil error:nil];
            [fileManager copyItemAtPath:ltcFilePath toPath:saveFilePath error:NULL];
        }
        
        
        NSData *fileContents = [maxFileText dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
        
        
        [fileManager createFileAtPath:saveFilePath contents:fileContents attributes:nil];
        
    }
    
    //keccak
    if (self.popUpCoin.indexOfSelectedItem == 12) {
        [prefs setObject:self.poolComboBox.stringValue forKey:@"keccakPool"];
        [prefs setObject:self.userNameField.stringValue forKey:@"keccakPoolUser"];
        [prefs setObject:self.passwordField.stringValue forKey:@"keccakPoolPassword"];
        [prefs setObject:self.poolComboBox.stringValue forKey:@"defaultkeccakPoolValue"];
        
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
        
        
        NSString *saveFilePath = [userpath stringByAppendingPathComponent:@"keccakurls.conf"];
        
        NSFileManager *fileManager = [[NSFileManager alloc] init];
        if ([fileManager fileExistsAtPath:userpath] == NO) {
            [fileManager createDirectoryAtPath:userpath withIntermediateDirectories:YES attributes:nil error:nil];
            [fileManager copyItemAtPath:ltcFilePath toPath:saveFilePath error:NULL];
        }
        
        
        NSData *fileContents = [maxFileText dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
        
        
        [fileManager createFileAtPath:saveFilePath contents:fileContents attributes:nil];
        
    }
    
    //twe
    if (self.popUpCoin.indexOfSelectedItem == 13) {
        [prefs setObject:self.poolComboBox.stringValue forKey:@"twePool"];
        [prefs setObject:self.userNameField.stringValue forKey:@"twePoolUser"];
        [prefs setObject:self.passwordField.stringValue forKey:@"twePoolPassword"];
        [prefs setObject:self.poolComboBox.stringValue forKey:@"defaulttwePoolValue"];
        
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
        
        
        NSString *saveFilePath = [userpath stringByAppendingPathComponent:@"tweurls.conf"];
        
        NSFileManager *fileManager = [[NSFileManager alloc] init];
        if ([fileManager fileExistsAtPath:userpath] == NO) {
            [fileManager createDirectoryAtPath:userpath withIntermediateDirectories:YES attributes:nil error:nil];
            [fileManager copyItemAtPath:ltcFilePath toPath:saveFilePath error:NULL];
        }
        
        
        NSData *fileContents = [maxFileText dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
        
        
        [fileManager createFileAtPath:saveFilePath contents:fileContents attributes:nil];
        
    }
    
    //fugue
    if (self.popUpCoin.indexOfSelectedItem == 14) {
        [prefs setObject:self.poolComboBox.stringValue forKey:@"fuguePool"];
        [prefs setObject:self.userNameField.stringValue forKey:@"fuguePoolUser"];
        [prefs setObject:self.passwordField.stringValue forKey:@"fuguePoolPassword"];
        [prefs setObject:self.poolComboBox.stringValue forKey:@"defaultfuguePoolValue"];
        
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
        
        
        NSString *saveFilePath = [userpath stringByAppendingPathComponent:@"fugueurls.conf"];
        
        NSFileManager *fileManager = [[NSFileManager alloc] init];
        if ([fileManager fileExistsAtPath:userpath] == NO) {
            [fileManager createDirectoryAtPath:userpath withIntermediateDirectories:YES attributes:nil error:nil];
            [fileManager copyItemAtPath:ltcFilePath toPath:saveFilePath error:NULL];
        }
        
        
        NSData *fileContents = [maxFileText dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
        
        
        [fileManager createFileAtPath:saveFilePath contents:fileContents attributes:nil];
        
    }
    
    //nist
    if (self.popUpCoin.indexOfSelectedItem == 15) {
        [prefs setObject:self.poolComboBox.stringValue forKey:@"nistPool"];
        [prefs setObject:self.userNameField.stringValue forKey:@"nistPoolUser"];
        [prefs setObject:self.passwordField.stringValue forKey:@"nistPoolPassword"];
        [prefs setObject:self.poolComboBox.stringValue forKey:@"defaultnistPoolValue"];
        
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
        
        
        NSString *saveFilePath = [userpath stringByAppendingPathComponent:@"nisturls.conf"];
        
        NSFileManager *fileManager = [[NSFileManager alloc] init];
        if ([fileManager fileExistsAtPath:userpath] == NO) {
            [fileManager createDirectoryAtPath:userpath withIntermediateDirectories:YES attributes:nil error:nil];
            [fileManager copyItemAtPath:ltcFilePath toPath:saveFilePath error:NULL];
        }
        
        
        NSData *fileContents = [maxFileText dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
        
        
        [fileManager createFileAtPath:saveFilePath contents:fileContents attributes:nil];
        
    }
    
    //fresh
    if (self.popUpCoin.indexOfSelectedItem == 16) {
        [prefs setObject:self.poolComboBox.stringValue forKey:@"freshPool"];
        [prefs setObject:self.userNameField.stringValue forKey:@"freshPoolUser"];
        [prefs setObject:self.passwordField.stringValue forKey:@"freshPoolPassword"];
        [prefs setObject:self.poolComboBox.stringValue forKey:@"defaultfreshPoolValue"];
        
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
        
        
        NSString *saveFilePath = [userpath stringByAppendingPathComponent:@"freshurls.conf"];
        
        NSFileManager *fileManager = [[NSFileManager alloc] init];
        if ([fileManager fileExistsAtPath:userpath] == NO) {
            [fileManager createDirectoryAtPath:userpath withIntermediateDirectories:YES attributes:nil error:nil];
            [fileManager copyItemAtPath:ltcFilePath toPath:saveFilePath error:NULL];
        }
        
        
        NSData *fileContents = [maxFileText dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
        
        
        [fileManager createFileAtPath:saveFilePath contents:fileContents attributes:nil];
        
    }
    
    //whirl
    if (self.popUpCoin.indexOfSelectedItem == 17) {
        [prefs setObject:self.poolComboBox.stringValue forKey:@"whirlPool"];
        [prefs setObject:self.userNameField.stringValue forKey:@"whirlPoolUser"];
        [prefs setObject:self.passwordField.stringValue forKey:@"whirlPoolPassword"];
        [prefs setObject:self.poolComboBox.stringValue forKey:@"defaultwhirlPoolValue"];
        
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
        
        
        NSString *saveFilePath = [userpath stringByAppendingPathComponent:@"whirlurls.conf"];
        
        NSFileManager *fileManager = [[NSFileManager alloc] init];
        if ([fileManager fileExistsAtPath:userpath] == NO) {
            [fileManager createDirectoryAtPath:userpath withIntermediateDirectories:YES attributes:nil error:nil];
            [fileManager copyItemAtPath:ltcFilePath toPath:saveFilePath error:NULL];
        }
        
        
        NSData *fileContents = [maxFileText dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
        
        
        [fileManager createFileAtPath:saveFilePath contents:fileContents attributes:nil];
        
    }
    
    //neoscrypt
    if (self.popUpCoin.indexOfSelectedItem == 18) {
        [prefs setObject:self.poolComboBox.stringValue forKey:@"neoscryptPool"];
        [prefs setObject:self.userNameField.stringValue forKey:@"neoscryptPoolUser"];
        [prefs setObject:self.passwordField.stringValue forKey:@"neoscryptPoolPassword"];
        [prefs setObject:self.poolComboBox.stringValue forKey:@"defaultneoscryptPoolValue"];
        
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
        
        
        NSString *saveFilePath = [userpath stringByAppendingPathComponent:@"neoscrypturls.conf"];
        
        NSFileManager *fileManager = [[NSFileManager alloc] init];
        if ([fileManager fileExistsAtPath:userpath] == NO) {
            [fileManager createDirectoryAtPath:userpath withIntermediateDirectories:YES attributes:nil error:nil];
            [fileManager copyItemAtPath:ltcFilePath toPath:saveFilePath error:NULL];
        }
        
        
        NSData *fileContents = [maxFileText dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
        
        
        [fileManager createFileAtPath:saveFilePath contents:fileContents attributes:nil];
        
    }
    
    //whirlx
    if (self.popUpCoin.indexOfSelectedItem == 19) {
        [prefs setObject:self.poolComboBox.stringValue forKey:@"whirlxPool"];
        [prefs setObject:self.userNameField.stringValue forKey:@"whirlxPoolUser"];
        [prefs setObject:self.passwordField.stringValue forKey:@"whirlxPoolPassword"];
        [prefs setObject:self.poolComboBox.stringValue forKey:@"defaultwhirlxPoolValue"];
        
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
        
        
        NSString *saveFilePath = [userpath stringByAppendingPathComponent:@"whirlxurls.conf"];
        
        NSFileManager *fileManager = [[NSFileManager alloc] init];
        if ([fileManager fileExistsAtPath:userpath] == NO) {
            [fileManager createDirectoryAtPath:userpath withIntermediateDirectories:YES attributes:nil error:nil];
            [fileManager copyItemAtPath:ltcFilePath toPath:saveFilePath error:NULL];
        }
        
        
        NSData *fileContents = [maxFileText dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
        
        
        [fileManager createFileAtPath:saveFilePath contents:fileContents attributes:nil];
        
    }
    
    //lyra2re
    if (self.popUpCoin.indexOfSelectedItem == 20) {
        [prefs setObject:self.poolComboBox.stringValue forKey:@"lyra2rePool"];
        [prefs setObject:self.userNameField.stringValue forKey:@"lyra2rePoolUser"];
        [prefs setObject:self.passwordField.stringValue forKey:@"lyra2rePoolPassword"];
        [prefs setObject:self.poolComboBox.stringValue forKey:@"defaultlyra2rePoolValue"];
        
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
        
        
        NSString *saveFilePath = [userpath stringByAppendingPathComponent:@"lyra2reurls.conf"];
        
        NSFileManager *fileManager = [[NSFileManager alloc] init];
        if ([fileManager fileExistsAtPath:userpath] == NO) {
            [fileManager createDirectoryAtPath:userpath withIntermediateDirectories:YES attributes:nil error:nil];
            [fileManager copyItemAtPath:ltcFilePath toPath:saveFilePath error:NULL];
        }
        
        
        NSData *fileContents = [maxFileText dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
        
        
        [fileManager createFileAtPath:saveFilePath contents:fileContents attributes:nil];
        
    }
    
    //lyra2rev2
    if (self.popUpCoin.indexOfSelectedItem == 21) {
        [prefs setObject:self.poolComboBox.stringValue forKey:@"lyra2rev2Pool"];
        [prefs setObject:self.userNameField.stringValue forKey:@"lyra2rev2PoolUser"];
        [prefs setObject:self.passwordField.stringValue forKey:@"lyra2rev2PoolPassword"];
        [prefs setObject:self.poolComboBox.stringValue forKey:@"defaultlyra2rev2PoolValue"];
        
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
        
        
        NSString *saveFilePath = [userpath stringByAppendingPathComponent:@"lyra2rev2urls.conf"];
        
        NSFileManager *fileManager = [[NSFileManager alloc] init];
        if ([fileManager fileExistsAtPath:userpath] == NO) {
            [fileManager createDirectoryAtPath:userpath withIntermediateDirectories:YES attributes:nil error:nil];
            [fileManager copyItemAtPath:ltcFilePath toPath:saveFilePath error:NULL];
        }
        
        
        NSData *fileContents = [maxFileText dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
        
        
        [fileManager createFileAtPath:saveFilePath contents:fileContents attributes:nil];
        
    }
    
    //pluck
    if (self.popUpCoin.indexOfSelectedItem == 22) {
        [prefs setObject:self.poolComboBox.stringValue forKey:@"pluckPool"];
        [prefs setObject:self.userNameField.stringValue forKey:@"pluckPoolUser"];
        [prefs setObject:self.passwordField.stringValue forKey:@"pluckPoolPassword"];
        [prefs setObject:self.poolComboBox.stringValue forKey:@"defaultpluckPoolValue"];
        
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
        
        
        NSString *saveFilePath = [userpath stringByAppendingPathComponent:@"pluckurls.conf"];
        
        NSFileManager *fileManager = [[NSFileManager alloc] init];
        if ([fileManager fileExistsAtPath:userpath] == NO) {
            [fileManager createDirectoryAtPath:userpath withIntermediateDirectories:YES attributes:nil error:nil];
            [fileManager copyItemAtPath:ltcFilePath toPath:saveFilePath error:NULL];
        }
        
        
        NSData *fileContents = [maxFileText dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
        
        
        [fileManager createFileAtPath:saveFilePath contents:fileContents attributes:nil];
        
    }
    
    //yescrypt
    if (self.popUpCoin.indexOfSelectedItem == 23) {
        [prefs setObject:self.poolComboBox.stringValue forKey:@"yescryptPool"];
        [prefs setObject:self.userNameField.stringValue forKey:@"yescryptPoolUser"];
        [prefs setObject:self.passwordField.stringValue forKey:@"yescryptPoolPassword"];
        [prefs setObject:self.poolComboBox.stringValue forKey:@"defaultyescryptPoolValue"];
        
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
        
        
        NSString *saveFilePath = [userpath stringByAppendingPathComponent:@"yescrypturls.conf"];
        
        NSFileManager *fileManager = [[NSFileManager alloc] init];
        if ([fileManager fileExistsAtPath:userpath] == NO) {
            [fileManager createDirectoryAtPath:userpath withIntermediateDirectories:YES attributes:nil error:nil];
            [fileManager copyItemAtPath:ltcFilePath toPath:saveFilePath error:NULL];
        }
        
        
        NSData *fileContents = [maxFileText dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
        
        
        [fileManager createFileAtPath:saveFilePath contents:fileContents attributes:nil];
        
    }
    
    //yescryptmulti
    if (self.popUpCoin.indexOfSelectedItem == 24) {
        [prefs setObject:self.poolComboBox.stringValue forKey:@"yescryptmultiPool"];
        [prefs setObject:self.userNameField.stringValue forKey:@"yescryptmultiPoolUser"];
        [prefs setObject:self.passwordField.stringValue forKey:@"yescryptmultiPoolPassword"];
        [prefs setObject:self.poolComboBox.stringValue forKey:@"defaultyescryptmultiPoolValue"];
        
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
        
        
        NSString *saveFilePath = [userpath stringByAppendingPathComponent:@"yescryptmultiurls.conf"];
        
        NSFileManager *fileManager = [[NSFileManager alloc] init];
        if ([fileManager fileExistsAtPath:userpath] == NO) {
            [fileManager createDirectoryAtPath:userpath withIntermediateDirectories:YES attributes:nil error:nil];
            [fileManager copyItemAtPath:ltcFilePath toPath:saveFilePath error:NULL];
        }
        
        
        NSData *fileContents = [maxFileText dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
        
        
        [fileManager createFileAtPath:saveFilePath contents:fileContents attributes:nil];
        
    }
    
    //blakecoin
    if (self.popUpCoin.indexOfSelectedItem == 25) {
        [prefs setObject:self.poolComboBox.stringValue forKey:@"blakecoinPool"];
        [prefs setObject:self.userNameField.stringValue forKey:@"blakecoinPoolUser"];
        [prefs setObject:self.passwordField.stringValue forKey:@"blakecoinPoolPassword"];
        [prefs setObject:self.poolComboBox.stringValue forKey:@"defaultblakecoinPoolValue"];
        
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
        
        
        NSString *saveFilePath = [userpath stringByAppendingPathComponent:@"blakecoinurls.conf"];
        
        NSFileManager *fileManager = [[NSFileManager alloc] init];
        if ([fileManager fileExistsAtPath:userpath] == NO) {
            [fileManager createDirectoryAtPath:userpath withIntermediateDirectories:YES attributes:nil error:nil];
            [fileManager copyItemAtPath:ltcFilePath toPath:saveFilePath error:NULL];
        }
        
        
        NSData *fileContents = [maxFileText dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
        
        
        [fileManager createFileAtPath:saveFilePath contents:fileContents attributes:nil];
        
    }
    
    //blake
    if (self.popUpCoin.indexOfSelectedItem == 26) {
        [prefs setObject:self.poolComboBox.stringValue forKey:@"blakePool"];
        [prefs setObject:self.userNameField.stringValue forKey:@"blakePoolUser"];
        [prefs setObject:self.passwordField.stringValue forKey:@"blakePoolPassword"];
        [prefs setObject:self.poolComboBox.stringValue forKey:@"defaultblakePoolValue"];
        
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
        
        
        NSString *saveFilePath = [userpath stringByAppendingPathComponent:@"blakeurls.conf"];
        
        NSFileManager *fileManager = [[NSFileManager alloc] init];
        if ([fileManager fileExistsAtPath:userpath] == NO) {
            [fileManager createDirectoryAtPath:userpath withIntermediateDirectories:YES attributes:nil error:nil];
            [fileManager copyItemAtPath:ltcFilePath toPath:saveFilePath error:NULL];
        }
        
        
        NSData *fileContents = [maxFileText dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
        
        
        [fileManager createFileAtPath:saveFilePath contents:fileContents attributes:nil];
        
    }
    
    //sia
    if (self.popUpCoin.indexOfSelectedItem == 27) {
        [prefs setObject:self.poolComboBox.stringValue forKey:@"siaPool"];
        [prefs setObject:self.userNameField.stringValue forKey:@"siaPoolUser"];
        [prefs setObject:self.passwordField.stringValue forKey:@"siaPoolPassword"];
        [prefs setObject:self.poolComboBox.stringValue forKey:@"defaultsiaPoolValue"];
        
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
        
        
        NSString *saveFilePath = [userpath stringByAppendingPathComponent:@"siaurls.conf"];
        
        NSFileManager *fileManager = [[NSFileManager alloc] init];
        if ([fileManager fileExistsAtPath:userpath] == NO) {
            [fileManager createDirectoryAtPath:userpath withIntermediateDirectories:YES attributes:nil error:nil];
            [fileManager copyItemAtPath:ltcFilePath toPath:saveFilePath error:NULL];
        }
        
        
        NSData *fileContents = [maxFileText dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
        
        
        [fileManager createFileAtPath:saveFilePath contents:fileContents attributes:nil];
        
    }
    
    //decred
    if (self.popUpCoin.indexOfSelectedItem == 28) {
        [prefs setObject:self.poolComboBox.stringValue forKey:@"decredPool"];
        [prefs setObject:self.userNameField.stringValue forKey:@"decredPoolUser"];
        [prefs setObject:self.passwordField.stringValue forKey:@"decredPoolPassword"];
        [prefs setObject:self.poolComboBox.stringValue forKey:@"defaultdecredPoolValue"];
        
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
        
        
        NSString *saveFilePath = [userpath stringByAppendingPathComponent:@"decredurls.conf"];
        
        NSFileManager *fileManager = [[NSFileManager alloc] init];
        if ([fileManager fileExistsAtPath:userpath] == NO) {
            [fileManager createDirectoryAtPath:userpath withIntermediateDirectories:YES attributes:nil error:nil];
            [fileManager copyItemAtPath:ltcFilePath toPath:saveFilePath error:NULL];
        }
        
        
        NSData *fileContents = [maxFileText dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
        
        
        [fileManager createFileAtPath:saveFilePath contents:fileContents attributes:nil];
        
    }
    
    //vanilla
    if (self.popUpCoin.indexOfSelectedItem == 29) {
        [prefs setObject:self.poolComboBox.stringValue forKey:@"vanillaPool"];
        [prefs setObject:self.userNameField.stringValue forKey:@"vanillaPoolUser"];
        [prefs setObject:self.passwordField.stringValue forKey:@"vanillaPoolPassword"];
        [prefs setObject:self.poolComboBox.stringValue forKey:@"defaultvanillaPoolValue"];
        
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
        
        
        NSString *saveFilePath = [userpath stringByAppendingPathComponent:@"vanillaurls.conf"];
        
        NSFileManager *fileManager = [[NSFileManager alloc] init];
        if ([fileManager fileExistsAtPath:userpath] == NO) {
            [fileManager createDirectoryAtPath:userpath withIntermediateDirectories:YES attributes:nil error:nil];
            [fileManager copyItemAtPath:ltcFilePath toPath:saveFilePath error:NULL];
        }
        
        
        NSData *fileContents = [maxFileText dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
        
        
        [fileManager createFileAtPath:saveFilePath contents:fileContents attributes:nil];
        
    }
    
    //lbry
    if (self.popUpCoin.indexOfSelectedItem == 30) {
        [prefs setObject:self.poolComboBox.stringValue forKey:@"lbryPool"];
        [prefs setObject:self.userNameField.stringValue forKey:@"lbryPoolUser"];
        [prefs setObject:self.passwordField.stringValue forKey:@"lbryPoolPassword"];
        [prefs setObject:self.poolComboBox.stringValue forKey:@"defaultlbryPoolValue"];
        
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
        
        
        NSString *saveFilePath = [userpath stringByAppendingPathComponent:@"lbryurls.conf"];
        
        NSFileManager *fileManager = [[NSFileManager alloc] init];
        if ([fileManager fileExistsAtPath:userpath] == NO) {
            [fileManager createDirectoryAtPath:userpath withIntermediateDirectories:YES attributes:nil error:nil];
            [fileManager copyItemAtPath:ltcFilePath toPath:saveFilePath error:NULL];
        }
        
        
        NSData *fileContents = [maxFileText dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
        
        
        [fileManager createFileAtPath:saveFilePath contents:fileContents attributes:nil];
        
    }
    
    //sib
    if (self.popUpCoin.indexOfSelectedItem == 31) {
        [prefs setObject:self.poolComboBox.stringValue forKey:@"sibPool"];
        [prefs setObject:self.userNameField.stringValue forKey:@"sibPoolUser"];
        [prefs setObject:self.passwordField.stringValue forKey:@"sibPoolPassword"];
        [prefs setObject:self.poolComboBox.stringValue forKey:@"defaultsibPoolValue"];
        
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
        
        
        NSString *saveFilePath = [userpath stringByAppendingPathComponent:@"siburls.conf"];
        
        NSFileManager *fileManager = [[NSFileManager alloc] init];
        if ([fileManager fileExistsAtPath:userpath] == NO) {
            [fileManager createDirectoryAtPath:userpath withIntermediateDirectories:YES attributes:nil error:nil];
            [fileManager copyItemAtPath:ltcFilePath toPath:saveFilePath error:NULL];
        }
        
        
        NSData *fileContents = [maxFileText dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
        
        
        [fileManager createFileAtPath:saveFilePath contents:fileContents attributes:nil];
        
    }
    
    //X17
    if (self.popUpCoin.indexOfSelectedItem == 32) {
        [prefs setObject:self.poolComboBox.stringValue forKey:@"x17Pool"];
        [prefs setObject:self.userNameField.stringValue forKey:@"x17PoolUser"];
        [prefs setObject:self.passwordField.stringValue forKey:@"x17PoolPassword"];
        [prefs setObject:self.poolComboBox.stringValue forKey:@"defaultx17PoolValue"];
        
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
        
        
        NSString *saveFilePath = [userpath stringByAppendingPathComponent:@"x17urls.conf"];
        
        NSFileManager *fileManager = [[NSFileManager alloc] init];
        if ([fileManager fileExistsAtPath:userpath] == NO) {
            [fileManager createDirectoryAtPath:userpath withIntermediateDirectories:YES attributes:nil error:nil];
            [fileManager copyItemAtPath:ltcFilePath toPath:saveFilePath error:NULL];
        }
        
        
        NSData *fileContents = [maxFileText dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
        
        
        [fileManager createFileAtPath:saveFilePath contents:fileContents attributes:nil];
        
    }
    
    //XMR-light
    if (self.popUpCoin.indexOfSelectedItem == 33) {
        [prefs setObject:self.poolComboBox.stringValue forKey:@"xmrlightPool"];
        [prefs setObject:self.userNameField.stringValue forKey:@"xmrlightPoolUser"];
        [prefs setObject:self.passwordField.stringValue forKey:@"xmrlightPassword"];
        [prefs setObject:self.poolComboBox.stringValue forKey:@"defaultxmrlightPoolValue"];
        
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
        
        
        NSString *saveFilePath = [userpath stringByAppendingPathComponent:@"xmrlighturls.conf"];
        
        NSFileManager *fileManager = [[NSFileManager alloc] init];
        if ([fileManager fileExistsAtPath:userpath] == NO) {
            [fileManager createDirectoryAtPath:userpath withIntermediateDirectories:YES attributes:nil error:nil];
            [fileManager copyItemAtPath:ltcFilePath toPath:saveFilePath error:NULL];
        }
        
        
        NSData *fileContents = [maxFileText dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
        
        
        [fileManager createFileAtPath:saveFilePath contents:fileContents attributes:nil];
        
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
