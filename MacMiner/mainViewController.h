//
//  mainViewController.h
//  MacMiner
//
//  Created by Administrator on 02/04/2013.
//  Copyright (c) 2013 fabulouspanda. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "TaskWrapper.h"

@interface mainViewController : NSViewController <TaskWrapperController, NSTextViewDelegate, NSTextFieldDelegate, NSPopoverDelegate>{
    NSView *mainView;
    NSTextField *poolView;
        NSTextField *userView;
    NSSecureTextField *passView;
        NSTextField *optionsView;

    NSTextField *vectorView;
    NSTextView *outputView;
    NSButton *startButton;
    BOOL findRunning;
    TaskWrapper *searchTask;
    NSTextField *statLabel;
    
    NSButton *popoverTriggerButton;
    NSPopover *popover;
}

@property (nonatomic, strong) IBOutlet NSView *mainView;
@property (nonatomic, strong) IBOutlet NSTextField *poolView;
@property (nonatomic, strong) IBOutlet NSTextField *userView;
@property (nonatomic, strong) IBOutlet NSSecureTextField *passView;
@property (nonatomic, strong) IBOutlet NSTextField *optionsView;

@property (nonatomic, strong) IBOutlet NSTextField *vectorView;
@property (nonatomic, strong) IBOutlet NSTextView *outputView;
@property (nonatomic, strong) IBOutlet NSButton *startButton;
@property (nonatomic, strong) IBOutlet NSTextField *statLabel;

@property (nonatomic, strong) IBOutlet NSButton *popoverTriggerButton;
@property (nonatomic, strong) IBOutlet NSPopover *popover;

- (void)launchstart:(id)sender;
//- (void)alertDidEnd:(NSAlert *)pipAlert returnCode:(NSInteger)returnCode contextInfo:(void *)contextInfo;


- (IBAction)start:(id)sender;

@end
