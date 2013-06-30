//
//  bfgConfigFileViewController.h
//  MacMiner
//
//  Created by Administrator on 02/06/2013.
//  Copyright (c) 2013 fabulouspanda. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface bfgConfigFileViewController : NSViewController <NSWindowDelegate, NSTextFieldDelegate> {
    
    NSWindow *configEditWindow;
    
    NSButton *saveConfigFile;
    NSButton *cancelConfig;
    NSButton *revertConfig;
    
    NSSegmentedControl *btcLTCSegmentedControl;
    
    NSTextView *bfgConfigText;
    
}

@property (nonatomic, strong) IBOutlet NSWindow *configEditWindow;

@property (nonatomic, strong) IBOutlet NSButton *saveConfigFile;
@property (nonatomic, strong) IBOutlet NSButton *cancelConfig;
@property (nonatomic, strong) IBOutlet NSButton *revertConfig;

@property (nonatomic, strong) IBOutlet NSSegmentedControl *btcLTCSegmentedControl;

@property (nonatomic, strong) IBOutlet NSTextView *bfgConfigText;

- (IBAction)bfgConfigEditToggled:(id)sender;

- (IBAction)bfgConfigSaveText:(id)sender;

- (IBAction)bfgLTCConfigGetText:(id)sender;

@end
