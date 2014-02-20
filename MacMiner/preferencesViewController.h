//
//  preferencesViewController.h
//  MacMiner
//
//  Created by Administrator on 28/04/2013.
//  Copyright (c) 2013 fabulouspanda. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Cocoa/Cocoa.h>



@interface preferencesViewController : NSViewController <NSWindowDelegate, NSTextFieldDelegate> {
    
NSWindow *prefWindow;
NSView *prefView;
NSView *prefView2;
NSView *prefView3;
    
NSTextField *charCount;
NSTextField *emailAddress;
NSTextField *appID;
NSButton *scrollButton;
NSButton *dockButton;
NSButton *speechButton;
NSButton *fpgaAsicButton;
NSButton *bfgButton;
NSButton *cgButton;
NSButton *cpuButton;
NSButton *commandButton;
NSButton *httpButton;
    
NSButton *updateButton;
    
    // Pool settings
NSPopUpButton *popUpCoin;
NSComboBox *poolComboBox;
NSTextField *userNameField;
NSTextField *passwordField;
}


@property (nonatomic, strong) IBOutlet NSWindow *prefWindow;
@property (nonatomic, strong) IBOutlet NSView *prefView;
@property (nonatomic, strong) IBOutlet NSView *prefView2;
@property (nonatomic, strong) IBOutlet NSView *prefView3;

@property (nonatomic, strong) IBOutlet NSTextField *charCount;
@property (nonatomic, strong) IBOutlet NSTextField *emailAddress;
@property (nonatomic, strong) IBOutlet NSTextField *appID;
@property (nonatomic, strong) IBOutlet NSButton *scrollButton;
@property (nonatomic, strong) IBOutlet NSButton *dockButton;
@property (nonatomic, strong) IBOutlet NSButton *speechButton;
@property (nonatomic, strong) IBOutlet NSButton *fpgaAsicButton;
@property (nonatomic, strong) IBOutlet NSButton *bfgButton;
@property (nonatomic, strong) IBOutlet NSButton *cgButton;
@property (nonatomic, strong) IBOutlet NSButton *cpuButton;
@property (nonatomic, strong) IBOutlet NSButton *commandButton;
@property (nonatomic, strong) IBOutlet NSButton *httpButton;

@property (nonatomic, strong) IBOutlet NSButton *updateButton;

// Pool settings
@property (nonatomic, strong) IBOutlet NSPopUpButton *popUpCoin;
@property (nonatomic, strong) IBOutlet NSComboBox *poolComboBox;
@property (nonatomic, strong) IBOutlet NSTextField *userNameField;
@property (nonatomic, strong) IBOutlet NSTextField *passwordField;

-(IBAction)preferenceToggle:(id)sender;

-(IBAction)textDidChange:(id)sender;

@end
