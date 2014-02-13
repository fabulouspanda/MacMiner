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
        

}

@property (nonatomic, strong) IBOutlet NSWindow *cpuWindow;
@property (nonatomic, weak) IBOutlet NSView *cpuView;

@property (nonatomic, strong) IBOutlet NSTextView *cpuOutputView;
@property (nonatomic, weak) IBOutlet NSButton *cpuStartButton;
@property (nonatomic, weak) IBOutlet NSTextField *cpuStatLabel;
@property (nonatomic, weak) IBOutlet NSTextField *cpuHashLabel;


@property (nonatomic, strong) IBOutlet NSPanel *cpuOptionsWindow;
@property (nonatomic, weak) IBOutlet NSTextField *cpuThreads;
@property (nonatomic, weak) IBOutlet NSButton *cpuDebugOutput;
@property (nonatomic, weak) IBOutlet NSButton *cpuQuietOutput;

@property (nonatomic, weak) IBOutlet NSTextField *cpuManualOptions;

@property (nonatomic, weak) IBOutlet NSButton *cpuOptionsButton;

@property (nonatomic, weak) IBOutlet NSTextField *tempsLabel;

@property (nonatomic, weak) IBOutlet NSPopUpButton *chooseAlgo;

@property(strong) NSSpeechSynthesizer *speechSynth;


- (IBAction)start:(id)sender;

- (IBAction)cpuMinerToggle:(id)sender;

- (IBAction)cpuOptionsToggle:(id)sender;

- (IBAction)cpuOptionsApply:(id)sender;





@end
