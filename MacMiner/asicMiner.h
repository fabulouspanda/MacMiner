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
#import "taskTwoWrapper.h"
#import "taskTwoWrapperDelegate.h"
#import "taskThreeWrapper.h"
#import "taskThreeWrapperDelegate.h"

@interface asicMiner : NSViewController <NSWindowDelegate, TaskWrapperDelegate, taskTwoWrapperDelegate, taskThreeWrapperDelegate, NSTextViewDelegate, NSTextFieldDelegate, NSTableViewDelegate>{

    
    BOOL findRunning;
    BOOL findTwoRunning;
    BOOL findThreeRunning;
    TaskWrapper *asicTask;
    taskTwoWrapper *apiTask;
    taskThreeWrapper *apiNetworkTask;
    
    NSTimer *toggleTimer;
    
    NSTimer *loopTimer;
 
    
    
}

@property (nonatomic, strong) IBOutlet NSWindow *asicWindow;
@property (nonatomic, weak) IBOutlet NSView *asicView;

@property (nonatomic, strong) IBOutlet NSWindow *addNetworkedMinerWindow;

@property (nonatomic, weak) IBOutlet NSTextField *ipAddress;
@property (nonatomic, weak) IBOutlet NSTextField *portNumber;

@property (nonatomic, weak) IBOutlet NSTextField *asicOptionsView;

@property (nonatomic, strong) IBOutlet NSTextView *asicOutputView;
@property (nonatomic, weak) IBOutlet NSButton *asicStartButton;


@property (nonatomic, weak) IBOutlet NSTextField *megaHashLabel;
@property (nonatomic, weak) IBOutlet NSTextField *acceptLabel;
@property (nonatomic, weak) IBOutlet NSTextField *rejecttLabel;
@property (nonatomic, weak) IBOutlet NSTextField *tempsLabel;

@property (nonatomic, strong) IBOutlet NSPanel *asicOptionsWindow;
@property (nonatomic, weak) IBOutlet NSButton *asicNoGpuButton;
@property (nonatomic, weak) IBOutlet NSButton *asicQuietButton;
@property (nonatomic, weak) IBOutlet NSButton *asicDebugButton;
@property (nonatomic, weak) IBOutlet NSButton *asicOptionsButton;

@property (nonatomic, weak) IBOutlet NSTextField *asicThreadsField;

@property (nonatomic, weak) IBOutlet NSTextField *asicHashField;

@property (nonatomic, strong) IBOutlet NSTextView *asicAPIOutput;
@property (nonatomic, strong) IBOutlet NSTextView *asicAPIStorage;
@property (nonatomic, strong) IBOutlet NSTextView *asicAPIStorage2;

@property (nonatomic, strong) IBOutlet NSTableView *apiTableView;
@property (nonatomic, strong) IBOutlet NSMutableArray *apiDataArray;
@property (nonatomic, strong) IBOutlet NSMutableArray *apiDataObjectArray;

@property (nonatomic, strong) IBOutlet NSArrayController *apiTableViewController;

@property (nonatomic, strong) IBOutlet NSTextView *networkMinerData;
@property (nonatomic, strong) NSMutableArray *networkMinerArray;

@property (nonatomic, strong) NSString *noGPU;
@property (nonatomic, strong) NSString *debugOutputOn;
@property (nonatomic, strong) NSString *quietOutputOn;
@property (nonatomic, strong) NSString *bonusOptions;

@property (nonatomic, strong) NSString *logLength;

@property (nonatomic, strong) NSString *foundData;

@property (nonatomic, strong) NSString *numberString;
@property (nonatomic, strong) NSString *acceptString;
@property (nonatomic, strong) NSString *rejectString;

@property (nonatomic, strong) NSUserDefaults *prefs;

@property(strong) NSSpeechSynthesizer *speechSynth;

- (IBAction)start:(id)sender;

- (IBAction)asicMinerToggle:(id)sender;

- (void)startToggling;

- (void)stopToggling;

- (IBAction)optionsApply:(id)sender;

- (IBAction)optionsToggle:(id)sender;

- (void)toggleTimerFired:(NSTimer*)timer;

-(void)stopAsicMiner;



@end
