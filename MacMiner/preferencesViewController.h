//
//  preferencesViewController.h
//  MacMiner
//
//  Created by Administrator on 28/04/2013.
//  Copyright (c) 2013 fabulouspanda. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Cocoa/Cocoa.h>



@interface preferencesViewController : NSViewController <NSWindowDelegate, NSTextFieldDelegate>


@property (nonatomic, strong) IBOutlet NSWindow *prefWindow;
@property (nonatomic, strong) IBOutlet NSView *prefView;
@property (nonatomic, strong) IBOutlet NSView *prefView2;
@property (nonatomic, strong) IBOutlet NSView *prefView3;

@property (nonatomic, weak) IBOutlet NSTextField *charCount;
@property (nonatomic, weak) IBOutlet NSTextField *emailAddress;
@property (nonatomic, weak) IBOutlet NSTextField *appID;
@property (nonatomic, weak) IBOutlet NSButton *scrollButton;
@property (nonatomic, weak) IBOutlet NSButton *dockButton;
@property (nonatomic, weak) IBOutlet NSButton *speechButton;
@property (nonatomic, weak) IBOutlet NSButton *fpgaAsicButton;
@property (nonatomic, weak) IBOutlet NSButton *bfgButton;
@property (nonatomic, weak) IBOutlet NSButton *cgButton;
@property (nonatomic, weak) IBOutlet NSButton *cpuButton;
@property (nonatomic, weak) IBOutlet NSButton *commandButton;
@property (nonatomic, weak) IBOutlet NSButton *httpButton;

@property (nonatomic, weak) IBOutlet NSButton *updateButton;

// Pool settings
@property (nonatomic, weak) IBOutlet NSPopUpButton *popUpCoin;
@property (nonatomic, weak) IBOutlet NSComboBox *poolComboBox;
@property (nonatomic, weak) IBOutlet NSTextField *userNameField;
@property (nonatomic, weak) IBOutlet NSTextField *passwordField;

-(IBAction)preferenceToggle:(id)sender;

-(IBAction)textDidChange:(id)sender;

@end
