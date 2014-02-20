//
//  autoConfigViewViewController.h
//  MacMiner
//
//  Created by Administrator on 23/05/2013.
//  Copyright (c) 2013 fabulouspanda. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <Foundation/Foundation.h>

@interface autoConfigViewViewController : NSViewController <NSTextFieldDelegate, NSWindowDelegate, NSTextViewDelegate, NSPopoverDelegate, NSComboBoxDelegate> {
    
NSPanel *introPanel;
    
 NSComboBox *poolBoox;
 NSComboBox *ltcpoolBoox;
NSTextField *userNameTextField;
NSTextField *passWordTextField;
NSTextField *btcuserNameTextField;
NSTextField *btcpassWordTextField;
NSTextField *ltcuserNameTextField;
NSTextField *ltcpassWordTextField;
    
   NSTextField *enterPool;
    
NSButton *skipSetupButton;
NSButton *saveAndStartButton;
   NSButton *helpInfoButton;
    
NSButton *setupPopoverTriggerButton;
NSPopover *setupPopover;
    
}


@property (nonatomic, strong) IBOutlet NSPanel *introPanel;

@property (nonatomic, strong) IBOutlet  NSComboBox *poolBoox;
@property (nonatomic, strong) IBOutlet  NSComboBox *ltcpoolBoox;
@property (nonatomic, strong) IBOutlet NSTextField *userNameTextField;
@property (nonatomic, strong) IBOutlet NSTextField *passWordTextField;
@property (nonatomic, strong) IBOutlet NSTextField *btcuserNameTextField;
@property (nonatomic, strong) IBOutlet NSTextField *btcpassWordTextField;
@property (nonatomic, strong) IBOutlet NSTextField *ltcuserNameTextField;
@property (nonatomic, strong) IBOutlet NSTextField *ltcpassWordTextField;

@property (nonatomic, strong) IBOutlet    NSTextField *enterPool;

@property (nonatomic, strong) IBOutlet NSButton *skipSetupButton;
@property (nonatomic, strong) IBOutlet NSButton *saveAndStartButton;
@property (nonatomic, strong) IBOutlet    NSButton *helpInfoButton;

@property (nonatomic, strong) IBOutlet NSButton *setupPopoverTriggerButton;
@property (nonatomic, strong) IBOutlet NSPopover *setupPopover;


- (NSString *)getDataBetweenFromString:(NSString *)data leftString:(NSString *)leftData rightString:(NSString *)rightData leftOffset:(NSInteger)leftPos;

@end
