//
//  cpuminerViewController.h
//  MacMiner
//
//  Created by Administrator on 01/05/2013.
//  Copyright (c) 2013 fabulouspanda. All rights reserved.
//
#import <Cocoa/Cocoa.h>
#import <Foundation/Foundation.h>
#import "TaskWrapper.h"

@interface cpuminerViewController : NSViewController <NSWindowDelegate, TaskWrapperController, NSTextViewDelegate, NSTextFieldDelegate, NSPopoverDelegate> {
    NSWindow *cpuWindow;
    NSView *cpuView;
    NSTextField *cpuPoolView;
    NSTextField *cpuUserView;
    NSSecureTextField *cpuPassView;
    
    NSButton *startButton;

    BOOL findRunning;
    TaskWrapper *cpuTask;
    
    NSButton *cpuPopoverTriggerButton;
    NSPopover *cpuPopover;
    
    NSButton *cpuRememberButton;
}

@property (nonatomic, strong) IBOutlet NSWindow *cpuWindow;
@property (nonatomic, strong) IBOutlet NSView *cpuView;
@property (nonatomic, strong) IBOutlet NSTextField *cpuPoolView;
@property (nonatomic, strong) IBOutlet NSTextField *cpuUserView;
@property (nonatomic, strong) IBOutlet NSSecureTextField *cpuPassView;

@property (nonatomic, strong) IBOutlet NSTextView *cpuOutputView;
@property (nonatomic, strong) IBOutlet NSButton *cpuStartButton;
@property (nonatomic, strong) IBOutlet NSTextField *cpuStatLabel;

@property (nonatomic, strong) IBOutlet NSButton *cpuPopoverTriggerButton;
@property (nonatomic, strong) IBOutlet NSPopover *cpuPopover;

@property (nonatomic, strong) IBOutlet NSButton *cpuRememberButton;


- (IBAction)start:(id)sender;

- (IBAction)cpuMinerToggle:(id)sender;

@end
