//
//  AppDelegate.h
//  MacMiner
//
//  Created by Administrator on 02/04/2013.
//  Copyright (c) 2013 fabulouspanda. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <Sparkle/Sparkle.h>
#import "TaskWrapper.h"


@interface AppDelegate : NSObject <NSApplicationDelegate> {
//    TaskWrapper *searchTask;
    

    
    NSTextField *bfgReading;
    NSTextField *cgReading;
    NSTextField *cpuReading;
    NSImageView *bfgReadBack;
    NSImageView *cgReadBack;
    NSImageView *cpuReadBack;
}


//@property (assign) IBOutlet NSWindow *window;

@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;


- (IBAction)saveAction:(id)sender;



@end
