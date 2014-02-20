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


@interface cpuminerViewController : NSViewController <NSWindowDelegate, TaskWrapperDelegate, NSTextViewDelegate, NSTextFieldDelegate, NSPopoverDelegate> {

    BOOL findRunning;
    TaskWrapper *cpuTask;
    
NSWindow *cpuWindow;
NSView *cpuView;
    
NSTextView *cpuOutputView;
NSButton *cpuStartButton;
NSTextField *cpuStatLabel;
NSTextField *cpuHashLabel;
    
    
NSPanel *cpuOptionsWindow;
NSTextField *cpuThreads;
NSButton *cpuDebugOutput;
NSButton *cpuQuietOutput;
    
NSTextField *cpuManualOptions;
    
NSButton *cpuOptionsButton;
    
NSTextField *tempsLabel;
    
NSPopUpButton *chooseAlgo;
    


}

@property (nonatomic, strong) IBOutlet NSWindow *cpuWindow;
@property (nonatomic, strong) IBOutlet NSView *cpuView;

@property (nonatomic, strong) IBOutlet NSTextView *cpuOutputView;
@property (nonatomic, strong) IBOutlet NSButton *cpuStartButton;
@property (nonatomic, strong) IBOutlet NSTextField *cpuStatLabel;
@property (nonatomic, strong) IBOutlet NSTextField *cpuHashLabel;


@property (nonatomic, strong) IBOutlet NSPanel *cpuOptionsWindow;
@property (nonatomic, strong) IBOutlet NSTextField *cpuThreads;
@property (nonatomic, strong) IBOutlet NSButton *cpuDebugOutput;
@property (nonatomic, strong) IBOutlet NSButton *cpuQuietOutput;

@property (nonatomic, strong) IBOutlet NSTextField *cpuManualOptions;

@property (nonatomic, strong) IBOutlet NSButton *cpuOptionsButton;

@property (nonatomic, strong) IBOutlet NSTextField *tempsLabel;

@property (nonatomic, strong) IBOutlet NSPopUpButton *chooseAlgo;




- (IBAction)start:(id)sender;

- (IBAction)cpuMinerToggle:(id)sender;

- (IBAction)cpuOptionsToggle:(id)sender;

- (IBAction)cpuOptionsApply:(id)sender;





@end
