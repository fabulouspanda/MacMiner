//
//  AppDelegate.h
//  MacMiner
//
//  Created by Administrator on 02/04/2013.
//  Copyright (c) 2013 fabulouspanda. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "TaskWrapper.h"


@interface AppDelegate : NSObject <NSApplicationDelegate, NSURLAuthenticationChallengeSender, NSURLConnectionDelegate, NSURLConnectionDataDelegate, NSURLConnectionDownloadDelegate, NSUserNotificationCenterDelegate> {

    NSTimer *updateTimer;
    
}


//@property (assign) IBOutlet NSWindow *window;

@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@property (strong, nonatomic) IBOutlet NSView *dockView;
@property (strong, nonatomic) IBOutlet NSTextField *bfgReading;
@property (strong, nonatomic) IBOutlet NSTextField *cgReading;
@property (strong, nonatomic) IBOutlet NSTextField *cpuReading;

@property (strong, nonatomic) IBOutlet NSImageView *bfgReadBack;
@property (strong, nonatomic) IBOutlet NSImageView *cgReadBack;
@property (strong, nonatomic) IBOutlet NSImageView *cpuReadBack;
@property (strong, nonatomic) IBOutlet NSImageView *asicReadBack;
@property (strong, nonatomic) IBOutlet NSTextField *asicReading;

@property (strong, nonatomic) NSString *bfgSettingString;
@property (strong, nonatomic) IBOutlet NSTextField *bfgSettingText;

@property (nonatomic, strong) NSMutableArray *mobileMinerDataArray;
@property (nonatomic, strong) IBOutlet NSArrayController *mobileMinerArrayController;

@property (nonatomic, strong) IBOutlet NSTextView *asicAPIStorage;
@property (nonatomic, strong) IBOutlet NSTextView *asicAPIStorage2;

@property (nonatomic, strong) IBOutlet NSButton *disableHttpsButton;

@property (nonatomic, strong) IBOutlet NSButton *allowMobileMinerControl;

@property (nonatomic, strong) IBOutlet NSButton *hideVersionStuff;

@property (nonatomic, strong) IBOutlet NSWindow *releaseNotes;

@property (nonatomic, strong) NSString *foundData;

@property (nonatomic, strong) NSString *mobileMinerStatus;

- (void)mobilePost;

- (void)mobileCommands;

- (void)updateThread;

- (void)checkforUpdates;

@end
