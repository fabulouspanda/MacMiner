//
//  bfgConfigFileViewController.h
//  MacMiner
//
//  Created by Administrator on 02/06/2013.
//  Copyright (c) 2013 fabulouspanda. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface bfgConfigFileViewController : NSViewController <NSWindowDelegate, NSTextFieldDelegate>


@property (nonatomic, strong) IBOutlet NSWindow *configEditWindow;

@property (nonatomic, weak) IBOutlet NSButton *saveConfigFile;
@property (nonatomic, weak) IBOutlet NSButton *cancelConfig;
@property (nonatomic, weak) IBOutlet NSButton *revertConfig;

@property (nonatomic, weak) IBOutlet NSSegmentedControl *btcLTCSegmentedControl;

@property (nonatomic, strong) IBOutlet NSTextView *bfgConfigText;

- (IBAction)bfgConfigEditToggled:(id)sender;

- (IBAction)bfgConfigSaveText:(id)sender;

- (IBAction)bfgLTCConfigGetText:(id)sender;

@end
