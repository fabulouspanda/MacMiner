//
//  cgminerViewController.h
//  MacMiner
//
//  Created by Administrator on 01/05/2013.
//  Copyright (c) 2013 fabulouspanda. All rights reserved.
//
#import <Cocoa/Cocoa.h>
#import <Foundation/Foundation.h>
#import "TaskWrapper.h"
#import "TaskWrapperDelegate.h"
#import "taskTwoWrapper.h"
#import "taskTwoWrapperDelegate.h"
#import "taskThreeWrapper.h"
#import "taskThreeWrapperDelegate.h"

@interface cgminerViewController : NSViewController <NSWindowDelegate, TaskWrapperDelegate, taskTwoWrapperDelegate, taskThreeWrapperDelegate, NSTextViewDelegate, NSTextFieldDelegate, NSPopoverDelegate>{

    
    BOOL cgfindRunning;
	BOOL cgsearchTaskIsRunning;
    TaskWrapper *cgTask;
    BOOL findTwoRunning;
    BOOL findThreeRunning;
    taskTwoWrapper *apiTask;
    taskThreeWrapper *apiNetworkTask;

    
    NSArray *cgworkValues;
    NSArray *cgvectorValues;
     
}

@property (nonatomic, strong) IBOutlet NSWindow *cgWindow;
@property (nonatomic, weak) IBOutlet NSView *cgView;

@property (nonatomic, weak) IBOutlet NSTextField *cgOptionsView;

@property (nonatomic, strong) IBOutlet NSTextView *cgOutputView;
@property (nonatomic, weak) IBOutlet NSButton *cgStartButton;
@property (nonatomic, weak) IBOutlet NSTextField *cgStatLabel;

@property (nonatomic, weak) IBOutlet NSButton *cgPopoverTriggerButton;
@property (nonatomic, weak) IBOutlet NSPopover *cgPopover;



@property (nonatomic, weak) IBOutlet NSTextField *cgspeedRead;
@property (nonatomic, weak) IBOutlet NSTextField *cgacceptRead;
@property (nonatomic, weak) IBOutlet NSTextField *cgrejectRead;
@property (nonatomic, weak) IBOutlet NSTextField *cghashRead;

@property (nonatomic, strong) IBOutlet NSPanel *cgOptionsWindow;
@property (nonatomic, weak) IBOutlet NSButton *cgopenOptions;
@property (nonatomic, weak) IBOutlet NSSlider *cgintenseSlider;
@property (nonatomic, weak) IBOutlet NSSlider *cgworkSlider;
@property (nonatomic, weak) IBOutlet NSTextField *cgworkSizeLabel;
@property (nonatomic, weak) IBOutlet NSTextField *cgvectorSizeLabel;
@property (nonatomic, weak) IBOutlet NSTextField *cgintenseSizeLabel;

@property (readwrite, assign) int cgsliderValue;
@property (nonatomic, weak) IBOutlet NSSlider *cgvectorSlide;

@property (nonatomic, weak) IBOutlet NSButton *cgdynamicIntensity;
@property (nonatomic, weak) IBOutlet NSButton *cgworkSizeOverride;
@property (nonatomic, weak) IBOutlet NSButton *cgvectorOverride;
@property (nonatomic, weak) IBOutlet NSButton *cgdisableGPU;
@property (nonatomic, weak) IBOutlet NSButton *cguseScrypt;
@property (nonatomic, weak) IBOutlet NSButton *cgdebugOutput;
@property (nonatomic, weak) IBOutlet NSButton *cgquietOutput;

@property (nonatomic, weak) IBOutlet NSTextField *cgThreadConc;
@property (nonatomic, weak) IBOutlet NSTextField *cgShaders;
@property (nonatomic, weak) IBOutlet NSTextField *cgLookupGap;

@property (nonatomic, strong) IBOutlet NSView *cgdockReading;

@property(strong) NSSpeechSynthesizer *speechSynth;


- (IBAction)cgstart:(id)sender;

- (IBAction)cgMinerToggle:(id)sender;

- (void)cgMinerToggled:(id)sender;

- (IBAction)cgsliderChanged:(id)sender;

- (IBAction)cgvectorChanged:(id)sender;

- (IBAction)optionsToggle:(id)sender;

- (IBAction)cgoptionsApply:(id)sender;

@end
