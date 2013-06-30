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
    NSWindow *cgWindow;
    NSView *cgView;

    NSTextField *cgOptionsView;
    
    NSTextView *cgOutputView;
    NSButton *cgStartButton;
    BOOL cgfindRunning;
	BOOL cgsearchTaskIsRunning;
    TaskWrapper *cgTask;
    NSTextField *cgStatLabel;
    
    NSButton *cgRememberButton;
    
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
    NSArray *cgworkValues;
    NSArray *cgvectorValues;
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

    
}

@property (nonatomic, strong) IBOutlet NSWindow *cgWindow;
@property (nonatomic, strong) IBOutlet NSView *cgView;

@property (nonatomic, strong) IBOutlet NSTextField *cgOptionsView;

@property (nonatomic, strong) IBOutlet NSTextView *cgOutputView;
@property (nonatomic, strong) IBOutlet NSButton *cgStartButton;
@property (nonatomic, strong) IBOutlet NSTextField *cgStatLabel;

@property (nonatomic, strong) IBOutlet NSButton *cgRememberButton;

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



- (IBAction)cgstart:(id)sender;

- (IBAction)cgMinerToggle:(id)sender;

- (void)cgMinerToggled:(id)sender;

- (IBAction)cgsliderChanged:(id)sender;

- (IBAction)cgvectorChanged:(id)sender;

- (IBAction)optionsToggle:(id)sender;

- (IBAction)cgoptionsApply:(id)sender;

@end
