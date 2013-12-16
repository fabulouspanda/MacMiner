//
//  autoConfigViewViewController.h
//  MacMiner
//
//  Created by Administrator on 23/05/2013.
//  Copyright (c) 2013 fabulouspanda. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <Foundation/Foundation.h>

@interface autoConfigViewViewController : NSViewController <NSTextFieldDelegate, NSWindowDelegate, NSTextViewDelegate, NSPopoverDelegate, NSComboBoxDelegate>


@property (nonatomic, strong) IBOutlet NSPanel *introPanel;

@property (nonatomic, weak) IBOutlet  NSComboBox *poolBoox;
@property (nonatomic, weak) IBOutlet  NSComboBox *ltcpoolBoox;
@property (nonatomic, weak) IBOutlet NSTextField *userNameTextField;
@property (nonatomic, weak) IBOutlet NSTextField *passWordTextField;
@property (nonatomic, weak) IBOutlet NSTextField *btcuserNameTextField;
@property (nonatomic, weak) IBOutlet NSTextField *btcpassWordTextField;
@property (nonatomic, weak) IBOutlet NSTextField *ltcuserNameTextField;
@property (nonatomic, weak) IBOutlet NSTextField *ltcpassWordTextField;

@property (nonatomic, weak) IBOutlet    NSTextField *enterPool;

@property (nonatomic, weak) IBOutlet NSButton *skipSetupButton;
@property (nonatomic, weak) IBOutlet NSButton *saveAndStartButton;
@property (nonatomic, weak) IBOutlet    NSButton *helpInfoButton;

@property (nonatomic, weak) IBOutlet NSButton *setupPopoverTriggerButton;
@property (nonatomic, weak) IBOutlet NSPopover *setupPopover;


- (NSString *)getDataBetweenFromString:(NSString *)data leftString:(NSString *)leftData rightString:(NSString *)rightData leftOffset:(NSInteger)leftPos;

@end
