//
//  preferencesViewController.h
//  MacMiner
//
//  Created by Administrator on 28/04/2013.
//  Copyright (c) 2013 fabulouspanda. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Cocoa/Cocoa.h>



@interface preferencesViewController : NSViewController <NSWindowDelegate>{
    NSButton *updateButton;
    NSWindow *prefWindow;
}

@property (nonatomic, strong) IBOutlet NSButton *updateButton;
@property (nonatomic, strong) IBOutlet NSWindow *prefWindow;

- (IBAction)updateAction:(id)sender;
- (IBAction)preferenceToggle:(id)sender;

@end
