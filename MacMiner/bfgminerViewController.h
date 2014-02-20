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


@interface bfgminerViewController : NSWindowController <NSWindowDelegate, TaskWrapperDelegate, NSTextViewDelegate, NSTextFieldDelegate, NSPopoverDelegate>{

    BOOL findRunning;
	BOOL searchTaskIsRunning;
    TaskWrapper *bfgTask;

    
    NSArray *workValues;
        NSArray *vectorValues;

    
NSWindow *bfgWindow;
NSView *bfgView;
    
NSTextField *bfgOptionsView;
    
NSTextView *bfgOutputView;
NSButton *bfgStartButton;
NSTextField *bfgStatLabel;
    
NSButton *bfgPopoverTriggerButton;
NSPopover *bfgPopover;
    
NSPanel *bfgOptionsWindow;
NSButton *openOptions;
NSSlider *intenseSlider;
NSSlider *workSlider;
NSTextField *workSizeLabel;
NSTextField *vectorSizeLabel;
NSTextField *intenseSizeLabel;
NSTextField *bfgCpuThreads;
    
int sliderValue;
NSSlider *vectorSlide;
    
NSTextField *speedRead;
NSTextField *acceptRead;
NSTextField *rejectRead;
NSTextField *hashRead;
    
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
    
NSString *intensityValue;
NSString *worksizeValue;
NSString *vectorValue;
NSString *noGPU;
NSString *onScrypt;
NSString *debugOutputOn;
NSString *quietOutputOn;
NSString *bonusOptions;
NSString *threadConc;
NSString *shaders;
NSString *lookupGap;
    
NSString *executableName;
NSArray *paths;
NSString *userpath;
NSString *userpath2;    // The file will go in this directory
NSString *saveBTCConfigFilePath;
NSString *saveLTCConfigFilePath;
    
NSAlert *restartMessage;
    

    
IBOutlet NSPopUpButton *chooseGPUAlgo;

}


@property (nonatomic, strong) IBOutlet NSWindow *bfgWindow;
@property (nonatomic, strong) IBOutlet NSView *bfgView;

@property (nonatomic, strong) IBOutlet NSTextField *bfgOptionsView;

@property (nonatomic, strong) IBOutlet NSTextView *bfgOutputView;
@property (nonatomic, strong) IBOutlet NSButton *bfgStartButton;
@property (nonatomic, strong) IBOutlet NSTextField *bfgStatLabel;

@property (nonatomic, strong) IBOutlet NSButton *bfgPopoverTriggerButton;
@property (nonatomic, strong) IBOutlet NSPopover *bfgPopover;

@property (nonatomic, strong) IBOutlet NSPanel *bfgOptionsWindow;
@property (nonatomic, strong) IBOutlet NSButton *openOptions;
@property (nonatomic, strong) IBOutlet NSSlider *intenseSlider;
@property (nonatomic, strong) IBOutlet NSSlider *workSlider;
@property (nonatomic, strong) IBOutlet NSTextField *workSizeLabel;
@property (nonatomic, strong) IBOutlet NSTextField *vectorSizeLabel;
@property (nonatomic, strong) IBOutlet NSTextField *intenseSizeLabel;
@property (nonatomic, strong) IBOutlet NSTextField *bfgCpuThreads;

@property (readwrite, assign) int sliderValue;
@property (nonatomic, strong) IBOutlet NSSlider *vectorSlide;

@property (nonatomic, strong) IBOutlet NSTextField *speedRead;
@property (nonatomic, strong) IBOutlet NSTextField *acceptRead;
@property (nonatomic, strong) IBOutlet NSTextField *rejectRead;
@property (nonatomic, strong) IBOutlet NSTextField *hashRead;

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

@property (nonatomic, strong) NSString *intensityValue;
@property (nonatomic, strong) NSString *worksizeValue;
@property (nonatomic, strong) NSString *vectorValue;
@property (nonatomic, strong) NSString *noGPU;
@property (nonatomic, strong) NSString *onScrypt;
@property (nonatomic, strong) NSString *debugOutputOn;
@property (nonatomic, strong) NSString *quietOutputOn;
@property (nonatomic, strong) NSString *bonusOptions;
@property (nonatomic, strong) NSString *threadConc;
@property (nonatomic, strong) NSString *shaders;
@property (nonatomic, strong) NSString *lookupGap;

@property (nonatomic, strong) NSString *executableName;
@property (nonatomic, strong) NSArray *paths;
@property (nonatomic, strong) NSString *userpath;
@property (nonatomic, strong) NSString *userpath2;    // The file will go in this directory
@property (nonatomic, strong) NSString *saveBTCConfigFilePath;
@property (nonatomic, strong) NSString *saveLTCConfigFilePath;

@property (nonatomic, strong) NSAlert *restartMessage;



@property (nonatomic, strong) IBOutlet NSPopUpButton *chooseGPUAlgo;


- (IBAction)start:(id)sender;

- (void)stopBFG;

- (IBAction)bfgMinerToggle:(id)sender;

- (void)bfgMinerToggled:(id)sender;

- (IBAction)sliderChanged:(id)sender;
    
- (IBAction)vectorChanged:(id)sender;

- (IBAction)setRecommendedBFGValues:(id)sender;

@end
