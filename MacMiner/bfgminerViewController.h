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
#import "TaskWrapperDelegate.h"

@interface bfgminerViewController : NSViewController <NSWindowDelegate, TaskWrapperDelegate, NSTextViewDelegate, NSTextFieldDelegate>{
    NSWindow *bfgWindow;
    NSView *bfgView;

    NSTextField *bfgOptionsView;
    
    NSTextView *bfgOutputView;
    NSButton *bfgStartButton;
    BOOL findRunning;
	BOOL searchTaskIsRunning;
    TaskWrapper *bfgTask;
    NSTextField *bfgStatLabel;
    
    NSButton *bfgRememberButton;
    
    NSTextField *speedRead;
    NSTextField *acceptRead;
    NSTextField *rejectRead;
    NSTextField *hashRead;
    
    NSPanel *bfgOptionsWindow;
    NSButton *openOptions;
    NSSlider *intenseSlider;
    NSSlider *workSlider;
    NSTextField *workSizeLabel;
        NSTextField *vectorSizeLabel;
        NSTextField *intenseSizeLabel;
    NSArray *workValues;
        NSArray *vectorValues;
    int sliderValue;
    NSSlider *vectorSlide;
    
    NSButton *dynamicIntensity;
    NSButton *workSizeOverride;
    NSButton *vectorOverride;
    NSButton *disableGPU;
    NSButton *useScrypt;
    NSButton *debugOutput;
    NSButton *quietOutput;
    
NSTextField *bfgThreadConc;
NSTextField *bfgShaders;
NSTextField *bfgLookupGap;

}

@property (nonatomic, strong) IBOutlet NSWindow *bfgWindow;
@property (nonatomic, strong) IBOutlet NSView *bfgView;

@property (nonatomic, strong) IBOutlet NSTextField *bfgOptionsView;

@property (nonatomic, strong) IBOutlet NSTextView *bfgOutputView;
@property (nonatomic, strong) IBOutlet NSButton *bfgStartButton;
@property (nonatomic, strong) IBOutlet NSTextField *bfgStatLabel;

@property (nonatomic, strong) IBOutlet NSButton *bfgRememberButton;

@property (nonatomic, strong) IBOutlet NSTextField *speedRead;
@property (nonatomic, strong) IBOutlet NSTextField *acceptRead;
@property (nonatomic, strong) IBOutlet NSTextField *rejectRead;
@property (nonatomic, strong) IBOutlet NSTextField *hashRead;

@property (nonatomic, strong) IBOutlet NSPanel *bfgOptionsWindow;
@property (nonatomic, strong) IBOutlet NSButton *openOptions;
@property (nonatomic, strong) IBOutlet NSSlider *intenseSlider;
@property (nonatomic, strong) IBOutlet NSSlider *workSlider;
@property (nonatomic, strong) IBOutlet NSTextField *workSizeLabel;
@property (nonatomic, strong) IBOutlet NSTextField *vectorSizeLabel;
@property (nonatomic, strong) IBOutlet NSTextField *intenseSizeLabel;

@property (readwrite, assign) int sliderValue;
@property (nonatomic, strong) IBOutlet NSSlider *vectorSlide;

@property (nonatomic, strong) IBOutlet NSButton *dynamicIntensity;
@property (nonatomic, strong) IBOutlet NSButton *workSizeOverride;
@property (nonatomic, strong) IBOutlet NSButton *vectorOverride;
@property (nonatomic, strong) IBOutlet NSButton *disableGPU;
@property (nonatomic, strong) IBOutlet NSButton *useScrypt;
@property (nonatomic, strong) IBOutlet NSButton *debugOutput;
@property (nonatomic, strong) IBOutlet NSButton *quietOutput;

@property (nonatomic, strong) IBOutlet NSTextField *bfgThreadConc;
@property (nonatomic, strong) IBOutlet NSTextField *bfgShaders;
@property (nonatomic, strong) IBOutlet NSTextField *bfgLookupGap;



- (IBAction)start:(id)sender;

- (IBAction)stopBFG:(id)sender;

- (IBAction)bfgMinerToggle:(id)sender;

- (void)bfgMinerToggled:(id)sender;

- (IBAction)sliderChanged:(id)sender;
    
- (IBAction)vectorChanged:(id)sender;

@end
