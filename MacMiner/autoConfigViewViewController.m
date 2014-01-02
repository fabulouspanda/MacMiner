//
//  autoConfigViewViewController.m
//  MacMiner
//
//  Created by Administrator on 23/05/2013.
//  Copyright (c) 2013 fabulouspanda. All rights reserved.
//

#import "autoConfigViewViewController.h"



@implementation autoConfigViewViewController



- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:(NSCoder *)aDecoder];
    if (self) {
        // Initialization code here.
        /*           NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
         [prefs synchronize];
         NSString *configString = [prefs stringForKey:@"autoConfig"];
         if ([configString isEqualToString:@"skip"]) {
         //            [self skipThis:(id)nil];
         [introWindow orderOut:self];
         //            [self.introPanel orderOut:self];
         //            [self autoConfigToggled:(id)self];
         //            NSLog(@"skippedthis");
         }
         */
    }
    
    return self;
}

- (void)awakeFromNib
{
    
    
    
    NSString *executableName = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleExecutable"];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, YES);
    NSString *userpath = [paths objectAtIndex:0];
    userpath = [userpath stringByAppendingPathComponent:executableName];    // The file will go in this directory
    NSString *openBTCConfigFilePath = [userpath stringByAppendingPathComponent:@"bfgurls.conf"];
    NSString *openLTCConfigFilePath = [userpath stringByAppendingPathComponent:@"ltcurls.conf"];
    
    BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:openBTCConfigFilePath];
    if (fileExists) {
        NSString *btcConfig = [NSString stringWithContentsOfFile : openBTCConfigFilePath encoding:NSUTF8StringEncoding error:nil];
        NSString *ltcConfig = [NSString stringWithContentsOfFile : openLTCConfigFilePath encoding:NSUTF8StringEncoding error:nil];
        
        if ([btcConfig rangeOfString:@"user"].location != NSNotFound) {
            NSString *numberString = [self getDataBetweenFromString:btcConfig
                                                         leftString:@"url" rightString:@"," leftOffset:8];
            NSString *setupURLValue = [numberString stringByReplacingOccurrencesOfString:@"\"" withString:@""];
            numberString = nil;
            NSString *acceptString = [self getDataBetweenFromString:btcConfig
                                                         leftString:@"user" rightString:@"," leftOffset:9];
            NSString *setupUserValue = [acceptString stringByReplacingOccurrencesOfString:@"\"" withString:@""];
            acceptString = nil;
            NSString *rejectString = [self getDataBetweenFromString:btcConfig
                                                         leftString:@"pass" rightString:@"}" leftOffset:9];
            NSString *passString = [self getDataBetweenFromString:btcConfig
                                                         leftString:@"pass" rightString:@"," leftOffset:9];
            if (rejectString.length >= passString.length) {
                rejectString = passString;

            }
            rejectString = [rejectString stringByReplacingOccurrencesOfString:@"\"" withString:@""];
            rejectString = [rejectString stringByReplacingOccurrencesOfString:@"\n	" withString:@""];
            NSString *setupPassValue = [rejectString stringByReplacingOccurrencesOfString:@"	}" withString:@""];
            rejectString = nil;
            passString = nil;
            
            self.poolBoox.stringValue = setupURLValue;
            NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
            [prefs synchronize];
            
            
            NSString *defaultBitcoin = [prefs objectForKey:@"defaultBTC"];

            if (defaultBitcoin.length >=26) {
                        self.userNameTextField.stringValue = defaultBitcoin;
            }
            
            self.btcuserNameTextField.stringValue = setupUserValue;
            self.btcpassWordTextField.stringValue = setupPassValue;
            
            setupURLValue = nil;
            setupUserValue = nil;
            setupPassValue = nil;
            
        }
        else if ([btcConfig rangeOfString:@"quota"].location != NSNotFound) {
            NSString *numberString = [self getDataBetweenFromString:btcConfig
                                                         leftString:@"quota" rightString:@"," leftOffset:8];
            NSString *setupURLValue = [numberString stringByReplacingOccurrencesOfString:@"\"" withString:@""];
            numberString = nil;
            NSString *acceptString = [self getDataBetweenFromString:btcConfig
                                                         leftString:@"user" rightString:@"," leftOffset:9];
            NSString *setupUserValue = [acceptString stringByReplacingOccurrencesOfString:@"\"" withString:@""];
            acceptString = nil;
            NSString *rejectString = [self getDataBetweenFromString:btcConfig
                                                         leftString:@"pass" rightString:@"}" leftOffset:9];
            NSString *passString = [self getDataBetweenFromString:btcConfig
                                                       leftString:@"pass" rightString:@"," leftOffset:9];
            if (rejectString.length >= passString.length) {
                rejectString = passString;
                
            }
            rejectString = [rejectString stringByReplacingOccurrencesOfString:@"\"" withString:@""];
            rejectString = [rejectString stringByReplacingOccurrencesOfString:@"\n	" withString:@""];
            NSString *setupPassValue = [rejectString stringByReplacingOccurrencesOfString:@"	}" withString:@""];
            rejectString = nil;
            passString = nil;
            
            self.poolBoox.stringValue = setupURLValue;
            NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
            [prefs synchronize];
            
            
            NSString *defaultBitcoin = [prefs objectForKey:@"defaultBTC"];
            
            if (defaultBitcoin.length >=26) {
                self.userNameTextField.stringValue = defaultBitcoin;
            }
            
            self.btcuserNameTextField.stringValue = setupUserValue;
            self.btcpassWordTextField.stringValue = setupPassValue;
            
            setupURLValue = nil;
            setupUserValue = nil;
            setupPassValue = nil;
        }
        
        if ([ltcConfig rangeOfString:@"user"].location != NSNotFound) {
            NSString *ltcURLData = [self getDataBetweenFromString:ltcConfig
                                                       leftString:@"url" rightString:@"," leftOffset:8];
            NSString *setupLTCURLValue = [ltcURLData stringByReplacingOccurrencesOfString:@"\"" withString:@""];
            ltcURLData = nil;
            NSString *ltcUserData = [self getDataBetweenFromString:ltcConfig
                                                        leftString:@"user" rightString:@"," leftOffset:9];
            NSString *setupLTCUserValue = [ltcUserData stringByReplacingOccurrencesOfString:@"\"" withString:@""];
            ltcUserData = nil;
            NSString *ltcPassData = [self getDataBetweenFromString:ltcConfig
                                                        leftString:@"pass" rightString:@"}" leftOffset:9];
            ltcPassData = [ltcPassData stringByReplacingOccurrencesOfString:@"\"" withString:@""];
            ltcPassData = [ltcPassData stringByReplacingOccurrencesOfString:@"\n	" withString:@""];
            NSString *setupLTCPassValue = [ltcPassData stringByReplacingOccurrencesOfString:@"	}" withString:@""];
            ltcPassData = nil;
            
            self.ltcpoolBoox.stringValue = setupLTCURLValue;
            self.passWordTextField.stringValue = setupLTCUserValue;
            self.ltcuserNameTextField.stringValue = setupLTCUserValue;
            self.ltcpassWordTextField.stringValue = setupLTCPassValue;
            
            setupLTCURLValue = nil;
            setupLTCUserValue = nil;
            setupLTCPassValue = nil;
            
        }
        else if ([ltcConfig rangeOfString:@"quota"].location != NSNotFound) {
            NSString *ltcURLData = [self getDataBetweenFromString:ltcConfig
                                                       leftString:@"quota" rightString:@"," leftOffset:8];
            NSString *setupLTCURLValue = [ltcURLData stringByReplacingOccurrencesOfString:@"\"" withString:@""];
            ltcURLData = nil;
            NSString *ltcUserData = [self getDataBetweenFromString:ltcConfig
                                                        leftString:@"user" rightString:@"," leftOffset:9];
            NSString *setupLTCUserValue = [ltcUserData stringByReplacingOccurrencesOfString:@"\"" withString:@""];
            ltcUserData = nil;
            NSString *ltcPassData = [self getDataBetweenFromString:ltcConfig
                                                        leftString:@"pass" rightString:@"}" leftOffset:9];
            ltcPassData = [ltcPassData stringByReplacingOccurrencesOfString:@"\"" withString:@""];
            ltcPassData = [ltcPassData stringByReplacingOccurrencesOfString:@"\n	" withString:@""];
            NSString *setupLTCPassValue = [ltcPassData stringByReplacingOccurrencesOfString:@"	}" withString:@""];
            ltcPassData = nil;
            
            self.ltcpoolBoox.stringValue = setupLTCURLValue;
            self.passWordTextField.stringValue = setupLTCUserValue;
            self.ltcuserNameTextField.stringValue = setupLTCUserValue;
            self.ltcpassWordTextField.stringValue = setupLTCPassValue;
            
            setupLTCURLValue = nil;
            setupLTCUserValue = nil;
            setupLTCPassValue = nil;
            
        }
        

    }

    executableName = nil;
    paths = nil;
    userpath = nil;
    openBTCConfigFilePath = nil;
    openLTCConfigFilePath = nil;
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    [prefs synchronize];
    
    NSString *configString = [prefs stringForKey:@"autoConfig"];
    if ([configString isEqualToString:@"skip"]) {
        //            [self skipThis:(id)nil];
        [self.introPanel orderOut:self];
        //            [self.introPanel orderOut:self];
        //            [self autoConfigToggled:(id)self];

        [self closeWindow];
    }
    else {
        //            [self skipThis:(id)nil];
        [self.introPanel orderFrontRegardless];
        //            [self.introPanel orderOut:self];
        //            [self autoConfigToggled:(id)self];
        
        
    }
    prefs = nil;
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

- (void)skipThis:(id)sender {
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    [prefs synchronize];
    
    [prefs setObject:@"skip" forKey:@"autoConfig"];
    
    [self.introPanel orderOut:sender];
    
    prefs = nil;
}


- (IBAction)skipAutoSetup:(id)sender {
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    
    // saving an NSString
    [prefs setObject:@"skip" forKey:@"autoConfig"];
    
    [prefs synchronize];
    
    
    [self.introPanel orderOut:sender];
    
    prefs = nil;
    
    
}

- (IBAction)saveAndStart:(id)sender {
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    
    
    // saving our settings
    [prefs setObject:self.userNameTextField.stringValue forKey:@"defaultBTC"];
    [prefs setObject:self.passWordTextField.stringValue forKey:@"defaultLTC"];
    
    [prefs setObject:self.poolBoox.stringValue forKey:@"defaultPoolValue"];
    [prefs setObject:self.btcuserNameTextField.stringValue forKey:@"defaultBTCUser"];
    [prefs setObject:self.btcpassWordTextField.stringValue forKey:@"defaultBTCPass"];
    
    if (self.btcuserNameTextField.stringValue == nil) {
        [prefs setObject:self.userNameTextField.stringValue forKey:@"defaultBTCUser"];
        [prefs setObject:self.userNameTextField.stringValue forKey:@"defaultBTCPass"];
    }
    
    [prefs setObject:self.ltcpoolBoox.stringValue forKey:@"defaultLTCPoolValue"];
    [prefs setObject:self.ltcuserNameTextField.stringValue forKey:@"defaultLTCUser"];
    [prefs setObject:self.ltcpassWordTextField.stringValue forKey:@"defaultLTCPass"];
    
    if (self.ltcuserNameTextField.stringValue == nil) {
        [prefs setObject:self.passWordTextField.stringValue forKey:@"defaultLTCUser"];
        [prefs setObject:self.passWordTextField.stringValue forKey:@"defaultLTCPass"];
    }
    
    
    [prefs setObject:@"skip" forKey:@"autoConfig"];
    
    [prefs synchronize];
    
    [self writeFile];
    
    //[NSTimer scheduledTimerWithTimeInterval:1. target:self selector:@selector(closeWindow) userInfo:nil repeats:NO];
    //    [self.introWindow orderOut:sender];
    
    prefs = nil;
    
    
}

- (void)writeFile {
    
    //    Write BTC pools
    NSString *bundleConfigPath = [[NSBundle mainBundle] resourcePath];
    
    
    NSString *bfgFilePath = [bundleConfigPath stringByAppendingPathComponent:@"bfgminer.conf"];
    NSString *noBackupFilePath = [bundleConfigPath stringByAppendingPathComponent:@"nobackup.conf"];
    NSString *executableName = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleExecutable"];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, YES);
    NSString *userpath = [paths objectAtIndex:0];
    userpath = [userpath stringByAppendingPathComponent:executableName];    // The file will go in this directory
    
    NSString *bfgFileText = nil;
    
    if (self.userNameTextField.stringValue.length >= 16) {

        
        bfgFileText = [NSString stringWithContentsOfFile:bfgFilePath encoding:NSUTF8StringEncoding error:nil];

        if ([self.poolBoox.stringValue isEqualToString:@"http://pool.fabulouspanda.co.uk:9332"]) {
            bfgFileText = [bfgFileText stringByReplacingOccurrencesOfString:@"user1" withString:self.userNameTextField.stringValue];
            bfgFileText = [bfgFileText stringByReplacingOccurrencesOfString:@"pass1" withString:self.userNameTextField.stringValue];
            bfgFileText = [bfgFileText stringByReplacingOccurrencesOfString:@"user2" withString:self.userNameTextField.stringValue];
            bfgFileText = [bfgFileText stringByReplacingOccurrencesOfString:@"pass2" withString:self.userNameTextField.stringValue];
        }
        else {
            bfgFileText = [bfgFileText stringByReplacingOccurrencesOfString:@"http://pool.fabulouspanda.co.uk:9332" withString:self.poolBoox.stringValue];
            bfgFileText = [bfgFileText stringByReplacingOccurrencesOfString:@"http://pool.hostv.pl:9332" withString:@"http://pool.fabulouspanda.co.uk:9332"];
            bfgFileText = [bfgFileText stringByReplacingOccurrencesOfString:@"user1" withString:self.btcuserNameTextField.stringValue];
            bfgFileText = [bfgFileText stringByReplacingOccurrencesOfString:@"pass1" withString:self.btcpassWordTextField.stringValue];
        }

        
    }
    else {
        bfgFileText = [NSString stringWithContentsOfFile:noBackupFilePath encoding:NSUTF8StringEncoding error:nil];
        

            bfgFileText = [bfgFileText stringByReplacingOccurrencesOfString:@"http://pool.fabulouspanda.co.uk:9332" withString:self.poolBoox.stringValue];
            bfgFileText = [bfgFileText stringByReplacingOccurrencesOfString:@"user1" withString:self.btcuserNameTextField.stringValue];
            bfgFileText = [bfgFileText stringByReplacingOccurrencesOfString:@"pass1" withString:self.btcpassWordTextField.stringValue];
        

    }
    
    
    NSString *saveBTCFilePath = [userpath stringByAppendingPathComponent:@"bfgurls.conf"];
    
    NSBundle *thisBundle = [NSBundle mainBundle];
    NSFileManager *fileManager = [[NSFileManager alloc] init];
    if ([fileManager fileExistsAtPath:userpath] == NO) {
        [fileManager createDirectoryAtPath:userpath withIntermediateDirectories:YES attributes:nil error:nil];
            [fileManager copyItemAtPath:bfgFilePath toPath:saveBTCFilePath error:NULL];
    }


    NSData *fileContents = [bfgFileText dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    
    
    [fileManager createFileAtPath:saveBTCFilePath contents:fileContents attributes:nil];
    
    
    
    //      Write LTC Pools
    
    NSString *ltcFileText = nil;
    
        if (self.passWordTextField.stringValue.length >= 16) {
    NSString *ltcFilePath = [bundleConfigPath stringByAppendingPathComponent:@"litecoin.conf"];
    ltcFileText = [NSString stringWithContentsOfFile:ltcFilePath encoding:NSUTF8StringEncoding error:nil];
    ltcFileText = [ltcFileText stringByReplacingOccurrencesOfString:@"user2" withString:self.passWordTextField.stringValue];
    ltcFileText = [ltcFileText stringByReplacingOccurrencesOfString:@"pass2" withString:self.passWordTextField.stringValue];
            
            if ([self.ltcpoolBoox.stringValue isEqualToString:@"http://pool.fabulouspanda.co.uk:9327"]) {
                ltcFileText = [ltcFileText stringByReplacingOccurrencesOfString:@"user1" withString:self.passWordTextField.stringValue];
                ltcFileText = [ltcFileText stringByReplacingOccurrencesOfString:@"pass1" withString:self.passWordTextField.stringValue];
            }
            else {
                ltcFileText = [ltcFileText stringByReplacingOccurrencesOfString:@"http://pool.fabulouspanda.co.uk:9327" withString:self.ltcpoolBoox.stringValue];
                ltcFileText = [ltcFileText stringByReplacingOccurrencesOfString:@"http://pool.hostv.pl:9327" withString:@"http://pool.fabulouspanda.co.uk:9327"];
                ltcFileText = [ltcFileText stringByReplacingOccurrencesOfString:@"user1" withString:self.ltcuserNameTextField.stringValue];
                ltcFileText = [ltcFileText stringByReplacingOccurrencesOfString:@"pass1" withString:self.ltcpassWordTextField.stringValue];
            }
            ltcFilePath = nil;
        }
        else {
            NSString *ltcFilePath = [bundleConfigPath stringByAppendingPathComponent:@"litebackup.conf"];
            ltcFileText = [NSString stringWithContentsOfFile:ltcFilePath encoding:NSUTF8StringEncoding error:nil];
            
            if ([self.ltcpoolBoox.stringValue isEqualToString:@"http://pool.fabulouspanda.co.uk:9327"]) {
                ltcFileText = [ltcFileText stringByReplacingOccurrencesOfString:@"user1" withString:self.passWordTextField.stringValue];
                ltcFileText = [ltcFileText stringByReplacingOccurrencesOfString:@"pass1" withString:self.passWordTextField.stringValue];
            }
            else {
                ltcFileText = [ltcFileText stringByReplacingOccurrencesOfString:@"user1" withString:self.ltcuserNameTextField.stringValue];
                ltcFileText = [ltcFileText stringByReplacingOccurrencesOfString:@"pass1" withString:self.ltcpassWordTextField.stringValue];
            }
ltcFilePath = nil;
        }
            
    
    NSString *ltcPath = [userpath stringByAppendingPathComponent:@"ltcurls.conf"];
    
        NSData *ltcFileContents = [ltcFileText dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    
        [fileManager createFileAtPath:ltcPath contents:ltcFileContents attributes:nil];
    
    
    
    
    //    Tell it's done

    bfgFileText = nil;

    bundleConfigPath = nil;
    
    NSAlert * myAlert=[[NSAlert alloc] init];
    [myAlert setMessageText:@"You are now configured!"];
    [myAlert addButtonWithTitle:@"Splendid"];
    
    switch ([myAlert runModal]) {
        case NSAlertFirstButtonReturn:
            //handle first button
            [self.introPanel orderOut:self];
            
            //            [self closeWindow];
            
            break;
    }
    myAlert = nil;
    bfgFilePath = nil;
    ltcFileText = nil;
    ltcPath = nil;
    userpath = nil;
    thisBundle = nil;
    executableName = nil;
    paths = nil;
    fileManager = nil;
    
}

- (void)closeWindow {
    
    [self.introPanel orderOut:self];
    
}

- (IBAction)setupDisplayHelp:(id)sender
{
    [[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:@"http://fabulouspanda.co.uk/macminer/docs/"]];
}

- (IBAction)autoConfigToggled:(id)sender {
    
    if ([self.introPanel isVisible]) {
        [self.introPanel orderOut:sender];
    }
    else
    {
        [self.introPanel orderFront:sender];
    }
}


@end
