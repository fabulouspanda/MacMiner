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


@interface asicMiner : NSViewController <NSWindowDelegate, TaskWrapperDelegate, taskTwoWrapperDelegate, NSTextViewDelegate, NSTextFieldDelegate, NSTableViewDelegate, NSAlertDelegate, NSURLConnectionDelegate>{

    
    BOOL findRunning;
    BOOL findTwoRunning;
    BOOL findThreeRunning;
    TaskWrapper *asicTask;
    taskTwoWrapper *apiTask;
    
    NSTimer *toggleTimer;
    
    NSTimer *loopTimer;
    
        NSTimer *timerTimer;
 
    
NSWindow *asicWindow;
NSView *asicView;
    
NSWindow *addNetworkedMinerWindow;
NSMutableArray *minerAddressesArray;
    
NSTextField *ipAddress;
NSTextField *portNumber;
    
NSTextField *asicOptionsView;
    
NSTextView *asicOutputView;
NSButton *asicStartButton;
    
    
NSTextField *megaHashLabel;
NSTextField *acceptLabel;
NSTextField *rejecttLabel;
NSTextField *tempsLabel;
    
NSPanel *asicOptionsWindow;
NSButton *asicNoGpuButton;
NSButton *asicQuietButton;
NSButton *asicDebugButton;
NSButton *asicOptionsButton;
    
NSButton *bflEnable;
NSButton *erupterEnable;
NSButton *bigpicEnable;
NSButton *antminerEnable;
NSButton *bitfuryEnable;
    
NSButton *saveMyLogFile;
    
NSTextField *asicThreadsField;
    
NSTextField *asicHashField;
    
NSTextView *asicAPIOutput;
NSTextView *asicAPIStorage;
NSTextView *asicAPIStorage2;
    
NSTableView *apiTableView;
NSMutableArray *apiDataArray;
NSMutableArray *apiDataObjectArray;
    
NSArrayController *apiTableViewController;
    
NSTextView *networkMinerData;
NSMutableArray *networkMinerArray;
    
NSString *noGPU;
NSString *debugOutputOn;
NSString *quietOutputOn;
NSString *bonusOptions;
    
NSString *logLength;
    
NSString *foundData;
    
NSString *numberString;
NSString *acceptString;
NSString *rejectString;
    
NSUserDefaults *prefs;
    

    
NSString *mobileMinerStatus;
    

    
}

@property (nonatomic, strong) IBOutlet NSWindow *asicWindow;
@property (nonatomic, strong) IBOutlet NSView *asicView;

@property (nonatomic, strong) IBOutlet NSWindow *addNetworkedMinerWindow;
@property (nonatomic, strong) IBOutlet NSMutableArray *minerAddressesArray;

@property (nonatomic, strong) IBOutlet NSTextField *ipAddress;
@property (nonatomic, strong) IBOutlet NSTextField *portNumber;

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

@property (nonatomic, strong) IBOutlet NSButton *bflEnable;
@property (nonatomic, strong) IBOutlet NSButton *erupterEnable;
@property (nonatomic, strong) IBOutlet NSButton *bigpicEnable;
@property (nonatomic, strong) IBOutlet NSButton *antminerEnable;
@property (nonatomic, strong) IBOutlet NSButton *bitfuryEnable;

@property (nonatomic, strong) IBOutlet NSButton *saveLogFile;

@property (nonatomic, strong) IBOutlet NSTextField *asicThreadsField;

@property (nonatomic, strong) IBOutlet NSTextField *asicHashField;

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



@property (nonatomic, strong) NSString *mobileMinerStatus;

- (IBAction)start:(id)sender;

- (IBAction)asicMinerToggle:(id)sender;

- (void)startToggling;

- (void)stopToggling;

- (IBAction)optionsApply:(id)sender;

- (IBAction)optionsToggle:(id)sender;

- (void)toggleTimerFired:(NSTimer*)timer;

-(void)stopAsicMiner;



@end
