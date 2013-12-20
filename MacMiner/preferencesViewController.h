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

@property (nonatomic, weak) IBOutlet NSTextField *charCount;
@property (nonatomic, weak) IBOutlet NSTextField *emailAddress;
@property (nonatomic, weak) IBOutlet NSTextField *appID;
@property (nonatomic, weak) IBOutlet NSButton *scrollButton;
@property (nonatomic, weak) IBOutlet NSButton *dockButton;
@property (nonatomic, weak) IBOutlet NSButton *speechButton;

-(IBAction)preferenceToggle:(id)sender;

-(IBAction)textDidChange:(id)sender;

@end
