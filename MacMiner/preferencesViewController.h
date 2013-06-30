//
//  preferencesViewController.h
//  MacMiner
//
//  Created by Administrator on 28/04/2013.
//  Copyright (c) 2013 fabulouspanda. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Cocoa/Cocoa.h>



@interface preferencesViewController : NSViewController <NSWindowDelegate, NSTextFieldDelegate>{

    NSWindow *prefWindow;
    
    NSTextField *charCount;
    NSButton *scrollButton;
    NSButton *dockButton;
}


@property (nonatomic, strong) IBOutlet NSWindow *prefWindow;
@property (nonatomic, strong) IBOutlet NSTextField *charCount;
@property (nonatomic, strong) IBOutlet NSButton *scrollButton;
@property (nonatomic, strong) IBOutlet NSButton *dockButton;

-(IBAction)preferenceToggle:(id)sender;

-(IBAction)textDidChange:(id)sender;

@end
