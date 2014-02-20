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


@interface cgminerViewController : NSViewController <NSWindowDelegate, TaskWrapperDelegate, NSTextViewDelegate, NSTextFieldDelegate>{

    
    BOOL cgfindRunning;
	BOOL cgsearchTaskIsRunning;
    TaskWrapper *cgTask;

    
    NSArray *cgworkValues;
    NSArray *cgvectorValues;
    
NSWindow *cgWindow;
NSView *cgView;
    
NSTextField *cgOptionsView;
    
NSTextView *cgOutputView;
NSButton *cgStartButton;
NSTextField *cgStatLabel;
    
NSButton *cgPopoverTriggerButton;
NSPopover *cgPopover;
    
    
    
NSTextField *cgspeedRead;
NSTextField *cgacceptRead;
NSTextField *cgrejectRead;
NSTextField *cghashRead;
    
NSPanel *cgOptionsWindow;
NSButton *cgopenOptions;
NSSlider *cgintenseSlider;
NSSlider *cgworkSlider;
NSTextField *cgworkSizeLabel;
NSTextField *cgvectorSizeLabel;
NSTextField *cgintenseSizeLabel;
    
int cgsliderValue;
NSSlider *cgvectorSlide;
    
NSButton *cgdynamicIntensity;
NSButton *cgworkSizeOverride;
NSButton *cgvectorOverride;
NSButton *cgdisableGPU;
NSButton *cguseScrypt;
NSButton *cgdebugOutput;
NSButton *cgquietOutput;
    
NSTextField *cgThreadConc;
NSTextField *cgShaders;
NSTextField *cgLookupGap;
    
NSView *cgdockReading;
    

     
}

@property (nonatomic, strong) IBOutlet NSWindow *cgWindow;
@property (nonatomic, strong) IBOutlet NSView *cgView;

@property (nonatomic, strong) IBOutlet NSTextField *cgOptionsView;

@property (nonatomic, strong) IBOutlet NSTextView *cgOutputView;
@property (nonatomic, strong) IBOutlet NSButton *cgStartButton;
@property (nonatomic, strong) IBOutlet NSTextField *cgStatLabel;

@property (nonatomic, strong) IBOutlet NSButton *cgPopoverTriggerButton;
@property (nonatomic, strong) IBOutlet NSPopover *cgPopover;



@property (nonatomic, strong) IBOutlet NSTextField *cgspeedRead;
@property (nonatomic, strong) IBOutlet NSTextField *cgacceptRead;
@property (nonatomic, strong) IBOutlet NSTextField *cgrejectRead;
@property (nonatomic, strong) IBOutlet NSTextField *cghashRead;

@property (nonatomic, strong) IBOutlet NSPanel *cgOptionsWindow;
@property (nonatomic, strong) IBOutlet NSButton *cgopenOptions;
@property (nonatomic, strong) IBOutlet NSSlider *cgintenseSlider;
@property (nonatomic, strong) IBOutlet NSSlider *cgworkSlider;
@property (nonatomic, strong) IBOutlet NSTextField *cgworkSizeLabel;
@property (nonatomic, strong) IBOutlet NSTextField *cgvectorSizeLabel;
@property (nonatomic, strong) IBOutlet NSTextField *cgintenseSizeLabel;

@property (readwrite, assign) int cgsliderValue;
@property (nonatomic, strong) IBOutlet NSSlider *cgvectorSlide;

@property (nonatomic, strong) IBOutlet NSButton *cgdynamicIntensity;
@property (nonatomic, strong) IBOutlet NSButton *cgworkSizeOverride;
@property (nonatomic, strong) IBOutlet NSButton *cgvectorOverride;
@property (nonatomic, strong) IBOutlet NSButton *cgdisableGPU;
@property (nonatomic, strong) IBOutlet NSButton *cguseScrypt;
@property (nonatomic, strong) IBOutlet NSButton *cgdebugOutput;
@property (nonatomic, strong) IBOutlet NSButton *cgquietOutput;

@property (nonatomic, strong) IBOutlet NSTextField *cgThreadConc;
@property (nonatomic, strong) IBOutlet NSTextField *cgShaders;
@property (nonatomic, strong) IBOutlet NSTextField *cgLookupGap;

@property (nonatomic, strong) IBOutlet NSView *cgdockReading;




- (IBAction)cgstart:(id)sender;

- (IBAction)cgMinerToggle:(id)sender;

- (void)cgMinerToggled:(id)sender;

- (IBAction)cgsliderChanged:(id)sender;

- (IBAction)cgvectorChanged:(id)sender;

- (IBAction)optionsToggle:(id)sender;

- (IBAction)cgoptionsApply:(id)sender;

@end
