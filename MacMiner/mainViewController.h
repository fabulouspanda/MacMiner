//
//  mainViewController.h
//  MacMiner
//
//  Created by Administrator on 02/04/2013.
//  Copyright (c) 2013 fabulouspanda. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "TaskWrapper.h"
#import "TaskWrapperDelegate.h"

@interface mainViewController : NSViewController <NSWindowDelegate, TaskWrapperDelegate, NSTextViewDelegate, NSTextFieldDelegate>{
    
    NSWindow *window;
    
    NSView *mainView;
    NSTextField *poolView;
        NSTextField *userView;
    NSSecureTextField *passView;
        NSTextField *optionsView;

    NSTextView *outputView;
    NSButton *startButton;
    BOOL findRunning;
    TaskWrapper *searchTask;
    NSTextField *statLabel;
    
    NSButton *rememberButton;
    
    NSTextField *pocSpeedRead;
    NSTextField *pocAcceptRead;
    NSTextField *pocRejectRead;
    
}

@property (nonatomic, strong) IBOutlet NSWindow *window;

@property (nonatomic, strong) IBOutlet NSView *mainView;
@property (nonatomic, strong) IBOutlet NSTextField *poolView;
@property (nonatomic, strong) IBOutlet NSTextField *userView;
@property (nonatomic, strong) IBOutlet NSSecureTextField *passView;
@property (nonatomic, strong) IBOutlet NSTextField *optionsView;

@property (nonatomic, strong) IBOutlet NSTextView *outputView;
@property (nonatomic, strong) IBOutlet NSButton *startButton;
@property (nonatomic, strong) IBOutlet NSTextField *statLabel;


@property (nonatomic, strong) IBOutlet NSButton *rememberButton;

@property (nonatomic, strong) IBOutlet NSTextField *pocSpeedRead;
@property (nonatomic, strong) IBOutlet NSTextField *pocAcceptRead;
@property (nonatomic, strong) IBOutlet NSTextField *pocRejectRead;



- (IBAction)start:(id)sender;

- (IBAction)macMinerToggle:(id)sender;

@end
