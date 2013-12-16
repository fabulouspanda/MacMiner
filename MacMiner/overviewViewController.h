//
//  overviewViewController.h
//  MacMiner
//
//  Created by Administrator on 30/07/2013.
//  Copyright (c) 2013 fabulouspanda. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface overviewViewController : NSViewController <NSTableViewDataSource, NSTableViewDelegate, NSWindowDelegate>


@property (nonatomic, strong) IBOutlet NSTableView *overviewTableView;
@property (nonatomic, strong) IBOutlet NSTextView *theReturnValueTextField;
@property (nonatomic, strong) IBOutlet NSWindow *apiWindow;

@end
