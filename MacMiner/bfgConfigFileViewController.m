//
//  bfgConfigFileViewController.m
//  MacMiner
//
//  Created by Administrator on 02/06/2013.
//  Copyright (c) 2013 fabulouspanda. All rights reserved.
//

#import "bfgConfigFileViewController.h"

@interface bfgConfigFileViewController ()

@end

@implementation bfgConfigFileViewController



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Initialization code here.
self.bfgConfigText.automaticQuoteSubstitutionEnabled = NO;
        self.bfgConfigText.automaticTextReplacementEnabled = NO;
        self.bfgConfigText.enabledTextCheckingTypes = 0;
    }
    
    return self;
}




- (IBAction)bfgConfigEditToggled:(id)sender {
    
    if ([self.configEditWindow isVisible]) {
        [self.configEditWindow orderOut:sender];
    }
    else
    {
        [self.configEditWindow orderFront:sender];

        NSString *executableName = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleExecutable"];
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, YES);
        NSString *userpath = [paths objectAtIndex:0];
        userpath = [userpath stringByAppendingPathComponent:executableName];    // The file will go in this directory
        NSString *saveBTCFilePath = [userpath stringByAppendingPathComponent:@"bfgurls.conf"];
        NSString *saveLTCFilePath = [userpath stringByAppendingPathComponent:@"ltcurls.conf"];

        if ([self.btcLTCSegmentedControl isSelectedForSegment:0]) {
            

            NSString *string = [[NSString alloc] initWithContentsOfFile:saveBTCFilePath encoding:NSUTF8StringEncoding error:nil];
            [self.bfgConfigText setString:string];
        }
        if ([self.btcLTCSegmentedControl isSelectedForSegment:1]) {
            NSString *string = [[NSString alloc] initWithContentsOfFile:saveLTCFilePath encoding:NSUTF8StringEncoding error:nil];
            [self.bfgConfigText setString:string];
        }
        self.bfgConfigText.automaticQuoteSubstitutionEnabled = NO;
        self.bfgConfigText.automaticTextReplacementEnabled = NO;
        self.bfgConfigText.enabledTextCheckingTypes = 0;
        executableName = nil;
        paths = nil;
        userpath = nil;
        saveBTCFilePath = nil;
        saveLTCFilePath = nil;
    }
}

- (IBAction)bfgConfigGetText:(id)sender {
    
    NSString *executableName = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleExecutable"];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, YES);
    NSString *userpath = [paths objectAtIndex:0];
    userpath = [userpath stringByAppendingPathComponent:executableName];    // The file will go in this directory
    NSString *saveBTCFilePath = [userpath stringByAppendingPathComponent:@"bfgurls.conf"];
    NSString *saveLTCFilePath = [userpath stringByAppendingPathComponent:@"ltcurls.conf"];
    
if ([self.btcLTCSegmentedControl isSelectedForSegment:0]) {
    NSString *string = [[NSString alloc] initWithContentsOfFile:saveBTCFilePath encoding:NSUTF8StringEncoding error:nil];
    [self.bfgConfigText setString:string];
}
    if ([self.btcLTCSegmentedControl isSelectedForSegment:1]) {
        NSString *string = [[NSString alloc] initWithContentsOfFile:saveLTCFilePath encoding:NSUTF8StringEncoding error:nil];
        [self.bfgConfigText setString:string];
    }
    self.bfgConfigText.automaticQuoteSubstitutionEnabled = NO;
    self.bfgConfigText.automaticTextReplacementEnabled = NO;
    self.bfgConfigText.enabledTextCheckingTypes = 0;
executableName = nil;
paths = nil;
userpath = nil;
saveBTCFilePath = nil;
saveLTCFilePath = nil;
}

- (IBAction)bfgConfigSaveText:(id)sender {
    
    NSString *executableName = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleExecutable"];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, YES);
    NSString *userpath = [paths objectAtIndex:0];
    userpath = [userpath stringByAppendingPathComponent:executableName];    // The file will go in this directory
    NSString *saveBTCFilePath = [userpath stringByAppendingPathComponent:@"bfgurls.conf"];
    NSString *saveLTCFilePath = [userpath stringByAppendingPathComponent:@"ltcurls.conf"];
    
    NSString *bfgFileTextToSave = self.bfgConfigText.string;
    
        if ([self.btcLTCSegmentedControl isSelectedForSegment:0]) {
    
    [bfgFileTextToSave writeToFile:saveBTCFilePath
                  atomically:YES
                    encoding:NSUTF8StringEncoding
                       error:nil];
        }
        if ([self.btcLTCSegmentedControl isSelectedForSegment:1]) {
            
            [bfgFileTextToSave writeToFile:saveLTCFilePath
                                atomically:YES
                                  encoding:NSUTF8StringEncoding
                                     error:nil];
        }
    executableName = nil;
    paths = nil;
    userpath = nil;
    saveBTCFilePath = nil;
    saveLTCFilePath = nil;
    
}

- (IBAction)bfgLTCConfigGetText:(id)sender {
    
    NSString *executableName = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleExecutable"];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, YES);
    NSString *userpath = [paths objectAtIndex:0];
    userpath = [userpath stringByAppendingPathComponent:executableName];    // The file will go in this directory
    NSString *saveBTCFilePath = [userpath stringByAppendingPathComponent:@"bfgurls.conf"];
    NSString *saveLTCFilePath = [userpath stringByAppendingPathComponent:@"ltcurls.conf"];
    
    
    if ([self.btcLTCSegmentedControl isSelectedForSegment:0]) {
        NSString *string = [[NSString alloc] initWithContentsOfFile:saveBTCFilePath encoding:NSUTF8StringEncoding error:nil];
        [self.bfgConfigText setString:string];
    }
        if ([self.btcLTCSegmentedControl isSelectedForSegment:1]) {
    NSString *string = [[NSString alloc] initWithContentsOfFile:saveLTCFilePath encoding:NSUTF8StringEncoding error:nil];
    [self.bfgConfigText setString:string];
        }
    self.bfgConfigText.automaticQuoteSubstitutionEnabled = NO;
    self.bfgConfigText.automaticTextReplacementEnabled = NO;
    self.bfgConfigText.enabledTextCheckingTypes = 0;
    executableName = nil;
    paths = nil;
    userpath = nil;
    saveBTCFilePath = nil;
    saveLTCFilePath = nil;
}

@end