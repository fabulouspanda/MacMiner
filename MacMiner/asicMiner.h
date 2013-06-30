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
#import "TaskWrapperDelegate.h"


@interface asicMiner : NSViewController <NSWindowDelegate, TaskWrapperDelegate, NSTextViewDelegate, NSTextFieldDelegate>{
    NSWindow *asicWindow;
    NSView *asicView;

    NSTextField *asicOptionsView;
    
    NSTextView *asicOutputView;
    NSButton *asicStartButton;
    BOOL findRunning;
    TaskWrapper *asicTask;
    
    NSTimer *toggleTimer;
    
    NSTextField *megaHashLabel;
        NSTextField *acceptLabel;
            NSTextField *rejectLabel;
    NSTextField *tempsLabel;
    
    NSPanel *asicOptionsWindow;
    NSButton *asicNoGpuButton;
    NSButton *asicQuietButton;
    NSButton *asicDebugButton;
    NSButton *asicOptionsButton;
    
    NSTextField *asicHashField;
    
    
}

@property (nonatomic, strong) IBOutlet NSWindow *asicWindow;
@property (nonatomic, strong) IBOutlet NSView *asicView;

@property (nonatomic, strong) IBOutlet NSTextField *asicOptionsView;

@property (nonatomic, strong) IBOutlet NSTextView *asicOutputView;
@property (nonatomic, strong) IBOutlet NSButton *asicStartButton;

@property (nonatomic, strong) IBOutlet NSTextField *megaHashLabel;
@property (nonatomic, strong) IBOutlet NSTextField *acceptLabel;
@property (nonatomic, strong) IBOutlet NSTextField *rejecttLabel;
@property (nonatomic, strong) IBOutlet NSTextField *tempsLabel;
@property (nonatomic, strong) IBOutlet NSPanel *asicOptionsWindow;
@property (nonatomic, strong) IBOutlet NSButton *asicNoGpuButton;
@property (nonatomic, strong) IBOutlet NSButton *asicQuietButton;
@property (nonatomic, strong) IBOutlet NSButton *asicDebugButton;
@property (nonatomic, strong) IBOutlet NSButton *asicOptionsButton;

@property (nonatomic, strong) IBOutlet NSTextField *asicHashField;

- (IBAction)start:(id)sender;

- (IBAction)asicMinerToggle:(id)sender;

- (IBAction)stopToggling:(id)sender;

- (void)startToggling;

- (void)stopToggling;

- (IBAction)optionsApply:(id)sender;

- (IBAction)optionsToggle:(id)sender;

- (void)toggleTimerFired:(NSTimer*)timer;

//- (IBAction)runProcessAsAdministrator:(id)sender;

@end
