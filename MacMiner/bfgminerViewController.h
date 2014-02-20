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

    


}


@property (nonatomic, strong) IBOutlet NSWindow *bfgWindow;
@property (nonatomic, weak) IBOutlet NSView *bfgView;

@property (nonatomic, weak) IBOutlet NSTextField *bfgOptionsView;

@property (nonatomic, strong) IBOutlet NSTextView *bfgOutputView;
@property (nonatomic, weak) IBOutlet NSButton *bfgStartButton;
@property (nonatomic, weak) IBOutlet NSTextField *bfgStatLabel;

@property (nonatomic, weak) IBOutlet NSButton *bfgPopoverTriggerButton;
@property (nonatomic, weak) IBOutlet NSPopover *bfgPopover;

@property (nonatomic, strong) IBOutlet NSPanel *bfgOptionsWindow;
@property (nonatomic, weak) IBOutlet NSButton *openOptions;
@property (nonatomic, weak) IBOutlet NSSlider *intenseSlider;
@property (nonatomic, weak) IBOutlet NSSlider *workSlider;
@property (nonatomic, weak) IBOutlet NSTextField *workSizeLabel;
@property (nonatomic, weak) IBOutlet NSTextField *vectorSizeLabel;
@property (nonatomic, weak) IBOutlet NSTextField *intenseSizeLabel;
@property (nonatomic, weak) IBOutlet NSTextField *bfgCpuThreads;

@property (readwrite, assign) int sliderValue;
@property (nonatomic, weak) IBOutlet NSSlider *vectorSlide;

@property (nonatomic, weak) IBOutlet NSTextField *speedRead;
@property (nonatomic, weak) IBOutlet NSTextField *acceptRead;
@property (nonatomic, weak) IBOutlet NSTextField *rejectRead;
@property (nonatomic, weak) IBOutlet NSTextField *hashRead;

@property (nonatomic, weak) IBOutlet NSButton *dynamicIntensity;
@property (nonatomic, weak) IBOutlet NSButton *workSizeOverride;
@property (nonatomic, weak) IBOutlet NSButton *vectorOverride;
@property (nonatomic, weak) IBOutlet NSButton *disableGPU;
@property (nonatomic, weak) IBOutlet NSButton *useScrypt;
@property (nonatomic, weak) IBOutlet NSButton *debugOutput;
@property (nonatomic, weak) IBOutlet NSButton *quietOutput;

@property (nonatomic, weak) IBOutlet NSTextField *bfgThreadConc;
@property (nonatomic, weak) IBOutlet NSTextField *bfgShaders;
@property (nonatomic, weak) IBOutlet NSTextField *bfgLookupGap;

@property (nonatomic, weak) NSString *intensityValue;
@property (nonatomic, weak) NSString *worksizeValue;
@property (nonatomic, weak) NSString *vectorValue;
@property (nonatomic, weak) NSString *noGPU;
@property (nonatomic, weak) NSString *onScrypt;
@property (nonatomic, weak) NSString *debugOutputOn;
@property (nonatomic, weak) NSString *quietOutputOn;
@property (nonatomic, weak) NSString *bonusOptions;
@property (nonatomic, weak) NSString *threadConc;
@property (nonatomic, weak) NSString *shaders;
@property (nonatomic, weak) NSString *lookupGap;

@property (nonatomic, weak) NSString *executableName;
@property (nonatomic, weak) NSArray *paths;
@property (nonatomic, weak) NSString *userpath;
@property (nonatomic, weak) NSString *userpath2;    // The file will go in this directory
@property (nonatomic, weak) NSString *saveBTCConfigFilePath;
@property (nonatomic, weak) NSString *saveLTCConfigFilePath;

@property (nonatomic, strong) NSAlert *restartMessage;

@property(strong) NSSpeechSynthesizer *speechSynth;

@property (nonatomic, weak) IBOutlet NSPopUpButton *chooseGPUAlgo;


- (IBAction)start:(id)sender;

- (void)stopBFG;

- (IBAction)bfgMinerToggle:(id)sender;

- (void)bfgMinerToggled:(id)sender;

- (IBAction)sliderChanged:(id)sender;
    
- (IBAction)vectorChanged:(id)sender;

- (IBAction)setRecommendedBFGValues:(id)sender;

@end
