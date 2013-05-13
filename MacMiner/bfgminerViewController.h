//
//  bfgminerViewController.h
//  MacMiner
//
//  Created by Administrator on 01/05/2013.
//  Copyright (c) 2013 fabulouspanda. All rights reserved.
//
#import <Cocoa/Cocoa.h>
#import <Foundation/Foundation.h>
#import "TaskWrapper.h"

@interface bfgminerViewController : NSViewController <NSWindowDelegate, TaskWrapperController, NSTextViewDelegate, NSTextFieldDelegate, NSPopoverDelegate>{
    NSWindow *bfgWindow;
    NSView *bfgView;
    NSTextField *bfgPoolView;
    NSTextField *bfgUserView;
    NSSecureTextField *bfgPassView;
    NSTextField *bfgOptionsView;
    
    NSTextView *bfgOutputView;
    NSButton *bfgStartButton;
    BOOL findRunning;
    TaskWrapper *bfgTask;
    NSTextField *bfgStatLabel;
    
    NSButton *bfgPopoverTriggerButton;
    NSPopover *bfgPopover;
    
    NSButton *bfgRememberButton;
    
    NSTextField *speedRead;
    NSTextField *acceptRead;
    NSTextField *rejectRead;
}

@property (nonatomic, strong) IBOutlet NSWindow *bfgWindow;
@property (nonatomic, strong) IBOutlet NSView *bfgView;
@property (nonatomic, strong) IBOutlet NSTextField *bfgPoolView;
@property (nonatomic, strong) IBOutlet NSTextField *bfgUserView;
@property (nonatomic, strong) IBOutlet NSSecureTextField *bfgPassView;
@property (nonatomic, strong) IBOutlet NSTextField *bfgOptionsView;

@property (nonatomic, strong) IBOutlet NSTextView *bfgOutputView;
@property (nonatomic, strong) IBOutlet NSButton *bfgStartButton;
@property (nonatomic, strong) IBOutlet NSTextField *bfgStatLabel;

@property (nonatomic, strong) IBOutlet NSButton *bfgPopoverTriggerButton;
@property (nonatomic, strong) IBOutlet NSPopover *bfgPopover;

@property (nonatomic, strong) IBOutlet NSButton *bfgRememberButton;

@property (nonatomic, strong) IBOutlet NSTextField *speedRead;
@property (nonatomic, strong) IBOutlet NSTextField *acceptRead;
@property (nonatomic, strong) IBOutlet NSTextField *rejectRead;


- (IBAction)start:(id)sender;

- (IBAction)bfgMinerToggle:(id)sender;

@end
