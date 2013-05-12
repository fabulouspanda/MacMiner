//
//  asicMinerViewController.h
//  MacMiner
//
//  Created by Administrator on 01/05/2013.
//  Copyright (c) 2013 fabulouspanda. All rights reserved.
//
#import <Cocoa/Cocoa.h>
#import <Foundation/Foundation.h>
#import "TaskWrapper.h"


@interface asicMiner : NSViewController <NSWindowDelegate, TaskWrapperController, NSTextViewDelegate, NSTextFieldDelegate, NSPopoverDelegate>{
    NSWindow *asicWindow;
    NSView *asicView;
    NSTextField *asicPoolView;
    NSTextField *asicUserView;
    NSSecureTextField *asicPassView;
    NSTextField *asicOptionsView;
    
    NSTextView *asicOutputView;
    NSButton *asicStartButton;
    BOOL findRunning;
    TaskWrapper *asicTask;
    NSTextField *asicStatLabel;
    
    NSButton *asicPopoverTriggerButton;
    NSPopover *asicPopover;
    
    NSButton *asicRememberButton;
    
    NSTimer *toggleTimer;
    
    NSTextFieldCell *megaHashLabel;
        NSTextFieldCell *acceptLabel;
            NSTextFieldCell *rejectLabel;
    NSTextFieldCell *tempsLabel;
}

@property (nonatomic, strong) IBOutlet NSWindow *asicWindow;
@property (nonatomic, strong) IBOutlet NSView *asicView;
@property (nonatomic, strong) IBOutlet NSTextField *asicPoolView;
@property (nonatomic, strong) IBOutlet NSTextField *asicUserView;
@property (nonatomic, strong) IBOutlet NSSecureTextField *asicPassView;
@property (nonatomic, strong) IBOutlet NSTextField *asicOptionsView;

@property (nonatomic, strong) IBOutlet NSTextView *asicOutputView;
@property (nonatomic, strong) IBOutlet NSButton *asicStartButton;
@property (nonatomic, strong) IBOutlet NSTextField *asicStatLabel;

@property (nonatomic, strong) IBOutlet NSButton *asicPopoverTriggerButton;
@property (nonatomic, strong) IBOutlet NSPopover *asicPopover;

@property (nonatomic, strong) IBOutlet NSButton *asicRememberButton;

@property (nonatomic, strong) IBOutlet NSTextFieldCell *megaHashLabel;
@property (nonatomic, strong) IBOutlet NSTextFieldCell *acceptLabel;
@property (nonatomic, strong) IBOutlet NSTextFieldCell *rejecttLabel;
@property (nonatomic, strong) IBOutlet NSTextFieldCell *tempsLabel;

- (IBAction)start:(id)sender;

- (IBAction)asicMinerToggle:(id)sender;

- (IBAction)stopToggling:(id)sender;

- (void)startToggling;

- (void)stopToggling;

//- (IBAction)runProcessAsAdministrator:(id)sender;

@end
