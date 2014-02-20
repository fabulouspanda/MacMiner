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

@synthesize bfgConfigText, btcLTCSegmentedControl, cancelConfig, configEditWindow, revertConfig, saveConfigFile;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Initialization code here.

    }
    
    return self;
}




- (IBAction)bfgConfigEditToggled:(id)sender {
    
    if ([configEditWindow isVisible]) {
        [configEditWindow orderOut:sender];
    }
    else
    {
        [configEditWindow orderFront:sender];

        NSString *executableName = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleExecutable"];
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, YES);
        NSString *userpath = [paths objectAtIndex:0];
        userpath = [userpath stringByAppendingPathComponent:executableName];    // The file will go in this directory
        NSString *saveBTCFilePath = [userpath stringByAppendingPathComponent:@"bfgurls.conf"];
        NSString *saveLTCFilePath = [userpath stringByAppendingPathComponent:@"ltcurls.conf"];

        if ([btcLTCSegmentedControl isSelectedForSegment:0]) {
            

            NSString *string = [[NSString alloc] initWithContentsOfFile:saveBTCFilePath encoding:NSUTF8StringEncoding error:nil];
            [bfgConfigText setString:string];
        }
        if ([btcLTCSegmentedControl isSelectedForSegment:1]) {
            NSString *string = [[NSString alloc] initWithContentsOfFile:saveLTCFilePath encoding:NSUTF8StringEncoding error:nil];
            [bfgConfigText setString:string];
        }
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
    
if ([btcLTCSegmentedControl isSelectedForSegment:0]) {
    NSString *string = [[NSString alloc] initWithContentsOfFile:saveBTCFilePath encoding:NSUTF8StringEncoding error:nil];
    [bfgConfigText setString:string];
}
    if ([btcLTCSegmentedControl isSelectedForSegment:1]) {
        NSString *string = [[NSString alloc] initWithContentsOfFile:saveLTCFilePath encoding:NSUTF8StringEncoding error:nil];
        [bfgConfigText setString:string];
    }
    
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
    
    NSString *bfgFileTextToSave = bfgConfigText.string;
    
        if ([btcLTCSegmentedControl isSelectedForSegment:0]) {
    
    [bfgFileTextToSave writeToFile:saveBTCFilePath
                  atomically:YES
                    encoding:NSUTF8StringEncoding
                       error:nil];
        }
        if ([btcLTCSegmentedControl isSelectedForSegment:1]) {
            
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
    
    
    if ([btcLTCSegmentedControl isSelectedForSegment:0]) {
        NSString *string = [[NSString alloc] initWithContentsOfFile:saveBTCFilePath encoding:NSUTF8StringEncoding error:nil];
        [bfgConfigText setString:string];
    }
        if ([btcLTCSegmentedControl isSelectedForSegment:1]) {
    NSString *string = [[NSString alloc] initWithContentsOfFile:saveLTCFilePath encoding:NSUTF8StringEncoding error:nil];
    [bfgConfigText setString:string];
        }
    executableName = nil;
    paths = nil;
    userpath = nil;
    saveBTCFilePath = nil;
    saveLTCFilePath = nil;
}

@end