//
//  AppDelegate.m
//  MacMiner
//
//  Created by Administrator on 02/04/2013.
//  Copyright (c) 2013 fabulouspanda. All rights reserved.
//

#import "AppDelegate.h"
#import "bfgminerViewController.h"


@implementation AppDelegate

@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize managedObjectContext = _managedObjectContext;


-(void)applicationWillFinishLaunching:(NSNotification *)notification {
    
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    
    NSUInteger flags = ([NSEvent modifierFlags] & NSDeviceIndependentModifierFlagsMask);
    
    BOOL isOptionPressed = (flags == NSAlternateKeyMask);
    
    if (isOptionPressed) {
        NSString *appDomain = [[NSBundle mainBundle] bundleIdentifier];
        [[NSUserDefaults standardUserDefaults] removePersistentDomainForName:appDomain];

                NSLog(@"defaults unset");
    }
//    
//    // Insert code here to initialize your application
//    if (NSAlternateKeyMask) {
//        // Do something based on the alt/option key being pressed
//        NSLog(@"alt");
//    } else if (NSCommandKeyMask){
//        // Do something based on the command key being pressed
//        NSLog(@"command");
//    }
//    else {
//        NSLog(@"no");
//    }
//
    
    self.machineName = [[NSHost currentHost] localizedName];
    self.machineName = [self.machineName stringByReplacingOccurrencesOfString:@" " withString:@"_"];
    self.machineName = [self.machineName stringByReplacingOccurrencesOfString:@"-" withString:@"_"];
    self.machineName = [self.machineName stringByReplacingOccurrencesOfString:@"'" withString:@"_"];
    self.machineName = [self.machineName stringByReplacingOccurrencesOfString:@"\"" withString:@"_"];
    self.machineName = [self.machineName stringByReplacingOccurrencesOfString:@"’" withString:@"_"];
    
    NSCharacterSet *notAllowedChars = [[NSCharacterSet characterSetWithCharactersInString:@"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"] invertedSet];
    self.machineName = [[self.machineName componentsSeparatedByCharactersInSet:notAllowedChars] componentsJoinedByString:@""];
    
    
    if (self.machineName.length <= 1) {
        self.machineName = @"Mac";
        
        
    }
    
    self.outputMathString = [[NSMutableString alloc] init];
    [self.outputMathString setString:@""];
    
    if ([[NSProcessInfo processInfo] respondsToSelector:@selector(beginActivityWithOptions:reason:)]) {
        self.activity = [[NSProcessInfo processInfo] beginActivityWithOptions:0x00FFFFFF reason:@"receiving API messages"];
    }
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    
    [prefs synchronize];
    
    if ([prefs objectForKey:@"checkUpdates"]) {
        
    }
    else {


        NSString *stringVersion = [NSString stringWithContentsOfURL:[NSURL URLWithString:@"http://downloads.fabulouspanda.co.uk/betav.txt"]encoding:NSUTF8StringEncoding error:nil];


    if (stringVersion) {
        
    
        NSDictionary *infoDict = [[NSBundle mainBundle] infoDictionary];
        //        NSString *appVersion = [infoDict objectForKey:@"CFBundleShortVersionString"]; // example: 1.0.0
        NSNumber *buildNumber = [infoDict objectForKey:@"CFBundleVersion"];
        NSString *checkString = [NSString stringWithFormat:@"%@", buildNumber];
            if (checkString.length >= 2) {
        
        if ([checkString rangeOfString:stringVersion].location == NSNotFound) {
        
                BOOL notificationCenterIsAvailable = (NSClassFromString(@"NSUserNotificationCenter")!=nil);
            
                if (notificationCenterIsAvailable) {
                    
                            [[NSUserNotificationCenter defaultUserNotificationCenter] setDelegate:self];
            
            NSUserNotification *notification = [[NSUserNotification alloc] init];
            [notification setTitle:@"Update Available"];
            NSString *messageText = [NSString stringWithFormat:@"You have version %@, %@ is available", checkString, stringVersion];
            [notification setInformativeText:messageText];
            [notification setSoundName:NSUserNotificationDefaultSoundName];
            
            
            NSUserNotificationCenter *center = [NSUserNotificationCenter defaultUserNotificationCenter];
            [center scheduleNotification: notification];
            
        }
                else {
                    NSString *question = NSLocalizedString(@"An update is available", @"Quit without stop error question message");
                    NSString *info = NSLocalizedString(@"Get it now?", @"Quit without saves error question info");
                    NSString *updateButton = NSLocalizedString(@"Update", @"button title");
                    NSString *cancelButton = NSLocalizedString(@"Not now", @"button title");
                    NSAlert *alert = [[NSAlert alloc] init];
                    [alert setMessageText:question];
                    [alert setInformativeText:info];
                    [alert addButtonWithTitle:updateButton];
                    [alert addButtonWithTitle:cancelButton];
                    
                    NSInteger answer = [alert runModal];
                    
                    if (answer == NSAlertFirstButtonReturn) {
                            [[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:@"http://macminer.fabulouspanda.com/"]];
                        return;
                    }
                    if (answer == NSAlertSecondButtonReturn) {
                        return;
                    }

                }
        
    }
        else {
            [self performSelectorInBackground:@selector(updateThread) withObject:nil];
        }
        infoDict = nil;
        buildNumber = nil;
        checkString = nil;
    }
    }
    
    
    [[NSApp dockTile] setContentView:self.dockView];

        [[NSApp dockTile] display];
    


    
    NSString *hideVersion = [prefs objectForKey:@"hideVersion"];
    
        if (hideVersion) {
            
        
    if ([hideVersion isEqualToString:@"1530"]) {

    }
        else {
                 [self.releaseNotes orderFront:nil];
        }
        
        }
        else {
            [self.releaseNotes orderFront:nil];
        }
    stringVersion = nil;
        
    }
    
    prefs = nil;
    

    
}

- (void)updateThread {
      updateTimer = [NSTimer scheduledTimerWithTimeInterval:86400. target:self selector:@selector(timedcheckforUpdates) userInfo:nil repeats:YES];
}

- (void)timedcheckforUpdates {
    NSString *stringVersion = [NSString stringWithContentsOfURL:[NSURL URLWithString:@"http://downloads.fabulouspanda.co.uk/betav.txt"]encoding:NSUTF8StringEncoding error:nil];
    
    
    if (stringVersion) {
        
        
        NSDictionary *infoDict = [[NSBundle mainBundle] infoDictionary];
        //        NSString *appVersion = [infoDict objectForKey:@"CFBundleShortVersionString"]; // example: 1.0.0
        NSNumber *buildNumber = [infoDict objectForKey:@"CFBundleVersion"];
        NSString *checkString = [NSString stringWithFormat:@"%@", buildNumber];
        
            if (checkString.length >= 2) {
        
        if ([checkString rangeOfString:stringVersion].location == NSNotFound) {
            
            BOOL notificationCenterIsAvailable = (NSClassFromString(@"NSUserNotificationCenter")!=nil);
            
            if (notificationCenterIsAvailable) {
                
                [[NSUserNotificationCenter defaultUserNotificationCenter] setDelegate:self];
                
                NSUserNotification *notification = [[NSUserNotification alloc] init];
                [notification setTitle:@"Update Available"];
                NSString *messageText = [NSString stringWithFormat:@"You have version %@, %@ is available", checkString, stringVersion];
                [notification setInformativeText:messageText];
                [notification setSoundName:NSUserNotificationDefaultSoundName];
                
                
                NSUserNotificationCenter *center = [NSUserNotificationCenter defaultUserNotificationCenter];
                [center scheduleNotification: notification];
                
            }
            else {
                NSString *question = NSLocalizedString(@"An update is available", @"Quit without stop error question message");
                NSString *info = NSLocalizedString(@"Get it now?", @"Quit without saves error question info");
                NSString *updateButton = NSLocalizedString(@"Update", @"button title");
                NSString *cancelButton = NSLocalizedString(@"Not now", @"button title");
                NSAlert *alert = [[NSAlert alloc] init];
                [alert setMessageText:question];
                [alert setInformativeText:info];
                [alert addButtonWithTitle:updateButton];
                [alert addButtonWithTitle:cancelButton];
                
                NSInteger answer = [alert runModal];
                
                if (answer == NSAlertFirstButtonReturn) {
                    [[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:@"http://macminer.fabulouspanda.com/"]];
                    return;
                }
                if (answer == NSAlertSecondButtonReturn) {
                    return;
                }
                
            }
        }
        }
    }
}

- (void) userNotificationCenter: (NSUserNotificationCenter *) center didActivateNotification: (NSUserNotification *) notification
	{

 if ([notification activationType] == NSUserNotificationActivationTypeContentsClicked)
        	    {
    [[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:@"http://macminer.fabulouspanda.com/"]];
        }
    }

- (BOOL)userNotificationCenter:(NSUserNotificationCenter *)center shouldPresentNotification:(NSUserNotification *)notification{
    return YES;
}

// Returns the directory the application uses to store the Core Data store file. This code uses a directory named "fabulouspanda.MacMiner" in the user's Application Support directory.
- (NSURL *)applicationFilesDirectory
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSURL *appSupportURL = [[fileManager URLsForDirectory:NSApplicationSupportDirectory inDomains:NSUserDomainMask] lastObject];
    return [appSupportURL URLByAppendingPathComponent:@"fabulouspanda.MacMiner"];
}

// Creates if necessary and returns the managed object model for the application.
- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel) {
        return _managedObjectModel;
    }
	
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"MacMiner" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

// Returns the persistent store coordinator for the application. This implementation creates and return a coordinator, having added the store for the application to it. (The directory for the store is created, if necessary.)
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator) {
        return _persistentStoreCoordinator;
    }
    
    NSManagedObjectModel *mom = [self managedObjectModel];
    if (!mom) {
        NSLog(@"%@:%@ No model to generate a store from", [self class], NSStringFromSelector(_cmd));
        return nil;
    }
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSURL *applicationFilesDirectory = [self applicationFilesDirectory];
    NSError *error = nil;
    
    NSDictionary *properties = [applicationFilesDirectory resourceValuesForKeys:@[NSURLIsDirectoryKey] error:&error];
    
    if (!properties) {
        BOOL ok = NO;
        if ([error code] == NSFileReadNoSuchFileError) {
            ok = [fileManager createDirectoryAtPath:[applicationFilesDirectory path] withIntermediateDirectories:YES attributes:nil error:&error];
        }
        if (!ok) {
            [[NSApplication sharedApplication] presentError:error];
            return nil;
        }
    }/*  else {
        if (![properties[NSURLIsDirectoryKey] boolValue]) {
            // Customize and localize this error.
            NSString *failureDescription = [NSString stringWithFormat:@"Expected a folder to store application data, found a file (%@).", [applicationFilesDirectory path]];
            
            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
            [dict setValue:failureDescription forKey:NSLocalizedDescriptionKey];
            error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:101 userInfo:dict];
            
            [[NSApplication sharedApplication] presentError:error];
            return nil;
        }
    }*/
    
    NSURL *url = [applicationFilesDirectory URLByAppendingPathComponent:@"MacMiner.storedata"];
    NSPersistentStoreCoordinator *coordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:mom];
    if (![coordinator addPersistentStoreWithType:NSXMLStoreType configuration:nil URL:url options:nil error:&error]) {
        [[NSApplication sharedApplication] presentError:error];
        return nil;
    }
    _persistentStoreCoordinator = coordinator;
    
    return _persistentStoreCoordinator;
}
 

// Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.) 
- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        [dict setValue:@"Failed to initialize the store" forKey:NSLocalizedDescriptionKey];
        [dict setValue:@"There was an error building up the data file." forKey:NSLocalizedFailureReasonErrorKey];
        NSError *error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        [[NSApplication sharedApplication] presentError:error];
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] init];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];

    return _managedObjectContext;
}

// Returns the NSUndoManager for the application. In this case, the manager returned is that of the managed object context for the application.
- (NSUndoManager *)windowWillReturnUndoManager:(NSWindow *)window
{
    return [[self managedObjectContext] undoManager];
}

// Performs the save action for the application, which is to send the save: message to the application's managed object context. Any encountered errors are presented to the user.
- (IBAction)saveAction:(id)sender
{
    NSError *error = nil;
    
    if (![[self managedObjectContext] commitEditing]) {
        NSLog(@"%@:%@ unable to commit editing before saving", [self class], NSStringFromSelector(_cmd));
    }
    
    if (![[self managedObjectContext] save:&error]) {
        [[NSApplication sharedApplication] presentError:error];
    }
}


- (NSApplicationTerminateReply)applicationShouldTerminate:(NSApplication *)sender
{
    // Save changes in the application's managed object context before the application terminates.
    
    
    
    if ([self.bfgReading isHidden] == NO || [self.cgReading isHidden] == NO || [self.cpuReading isHidden] == NO || [self.asicReading isHidden] == NO) {

        NSString *question = NSLocalizedString(@"Could not quit", @"Quit without stop error question message");
        NSString *info = NSLocalizedString(@"Please stop your miners before quitting", @"Quit without saves error question info");
        NSString *cancelButton = NSLocalizedString(@"OK", @"Cancel button title");
        NSAlert *alert = [[NSAlert alloc] init];
        [alert setMessageText:question];
        [alert setInformativeText:info];

        [alert addButtonWithTitle:cancelButton];
        
        NSInteger answer = [alert runModal];
        
        if (answer == NSAlertFirstButtonReturn) {
            return NSTerminateCancel;
        }

    }
    
    else {
    
    
            NSLog(@"I'm sploding!");

//    
// 
//    if (!_managedObjectContext) {
//        [bfgMiner stopBFG];
//        return NSTerminateNow;
//    }
//    
//    if (![[self managedObjectContext] commitEditing]) {
//        [bfgMiner stopBFG];
//        NSLog(@"%@:%@ unable to commit editing to terminate", [self class], NSStringFromSelector(_cmd));
//        return NSTerminateCancel;
//    }
//    
//    if (![[self managedObjectContext] hasChanges]) {
//        [bfgMiner stopBFG];
//        return NSTerminateNow;
//    }
//    
//    NSError *error = nil;
//    if (![[self managedObjectContext] save:&error]) {
//        [bfgMiner stopBFG];
//
//        // Customize this code block to include application-specific recovery steps.              
//        BOOL result = [sender presentError:error];
//        if (result) {
//            return NSTerminateCancel;
//        }
//
//        NSString *question = NSLocalizedString(@"Could not save changes while quitting. Quit anyway?", @"Quit without saves error question message");
//        NSString *info = NSLocalizedString(@"Quitting now will lose any changes you have made since the last successful save", @"Quit without saves error question info");
//        NSString *quitButton = NSLocalizedString(@"Quit anyway", @"Quit anyway button title");
//        NSString *cancelButton = NSLocalizedString(@"Cancel", @"Cancel button title");
//        NSAlert *alert = [[NSAlert alloc] init];
//        [alert setMessageText:question];
//        [alert setInformativeText:info];
//        [alert addButtonWithTitle:quitButton];
//        [alert addButtonWithTitle:cancelButton];
//
//        NSInteger answer = [alert runModal];
//        
//        if (answer == NSAlertAlternateReturn) {
//            return NSTerminateCancel;
//        }
//    }
//   [searchTask stopProcess];

    return NSTerminateNow;
    }
        return NSTerminateNow;
}

- (IBAction)displaySite:(id)sender
{
    [[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:@"http://macminer.fabulouspanda.com/macminer/"]];
}

- (IBAction)displayMeerkat:(id)sender
{
    [[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:@"https://geo.itunes.apple.com/app/uke-ukulele-tuner/id1382916607?mt=12&at=1000lnXM"]];
}

- (IBAction)displaySketchFighter:(id)sender
{
    [[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:@"https://itunes.apple.com/app/sketch-fighter/id1038895870?mt=8&at=1000lnXM"]];
}

- (IBAction)displayDeStijl:(id)sender
{
    [[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:@"https://itunes.apple.com/app/de-stijl-art-factory/id1260640861?mt=8&at=1000lnXM"]];
}


- (BOOL)theConnection:(NSURLConnection *)theConnection canAuthenticateAgainstProtectionSpace:(NSURLProtectionSpace *)protectionSpace {
    return [protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust];
}

- (void)theConnection:(NSURLConnection *)theConnection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge {
//    if ([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust])
//        if (... user allows connection despite bad certificate ...)
//            [challenge.sender useCredential:[NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust] forAuthenticationChallenge:challenge];
    
    [challenge.sender continueWithoutCredentialForAuthenticationChallenge:challenge];
}


- (IBAction)hideVersionStuff:(id)sender
{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    
    [prefs setObject:@"1530" forKey:@"hideVersion"];
    
    [prefs synchronize];
    
            [self.releaseNotes orderOut:sender];
    
    prefs = nil;
    
    
    
}

- (NSString *)getDataBetweenFromString:(NSString *)data leftString:(NSString *)leftData rightString:(NSString *)rightData leftOffset:(NSInteger)leftPos;
{
    if (data.length <=3) {
        return @"string too short";
    }
    
    else if ([leftData isNotEqualTo:nil]) {
        NSInteger left, right;
        
        NSScanner *scanner=[NSScanner scannerWithString:data];
        [scanner scanUpToString:leftData intoString: nil];
        left = [scanner scanLocation];
        [scanner setScanLocation:left + leftPos];
        [scanner scanUpToString:rightData intoString: nil];
        right = [scanner scanLocation];
        left += leftPos;
        NSString *foundData = [data substringWithRange: NSMakeRange(left, (right - left) - 1)];
        
        return foundData;
        
        foundData = nil;
        scanner = nil;
        leftData = nil;
        rightData = nil;
    }
    else return @"left string is nil";
}

- (IBAction)checkForUpdates:(id)sender {
    NSString *stringVersion = [NSString stringWithContentsOfURL:[NSURL URLWithString:@"http://downloads.fabulouspanda.co.uk/betav.txt"]encoding:NSUTF8StringEncoding error:nil];
    
    
    NSDictionary *infoDict = [[NSBundle mainBundle] infoDictionary];
    //        NSString *appVersion = [infoDict objectForKey:@"CFBundleShortVersionString"]; // example: 1.0.0
    NSNumber *buildNumber = [infoDict objectForKey:@"CFBundleVersion"];
    NSString *checkString = [NSString stringWithFormat:@"%@", buildNumber];
    if (checkString.length >= 2) {
        
    
    if ([checkString rangeOfString:stringVersion].location == NSNotFound) {
        
        BOOL notificationCenterIsAvailable = (NSClassFromString(@"NSUserNotificationCenter")!=nil);
        
        if (notificationCenterIsAvailable) {
            
            [[NSUserNotificationCenter defaultUserNotificationCenter] setDelegate:self];
            
            NSUserNotification *notification = [[NSUserNotification alloc] init];
            [notification setTitle:@"Update Available"];
            NSString *messageText = [NSString stringWithFormat:@"You have version %@, %@ is available", checkString, stringVersion];
            [notification setInformativeText:messageText];
            [notification setSoundName:NSUserNotificationDefaultSoundName];
            
            
            NSUserNotificationCenter *center = [NSUserNotificationCenter defaultUserNotificationCenter];
            [center scheduleNotification: notification];
            
        }
        else {
            NSString *question = NSLocalizedString(@"An update is available", @"Quit without stop error question message");
            NSString *info = NSLocalizedString(@"Get it now?", @"Quit without saves error question info");
            NSString *updateButton = NSLocalizedString(@"Update", @"button title");
            NSString *cancelButton = NSLocalizedString(@"Not now", @"button title");
            NSAlert *alert = [[NSAlert alloc] init];
            [alert setMessageText:question];
            [alert setInformativeText:info];
            [alert addButtonWithTitle:updateButton];
            [alert addButtonWithTitle:cancelButton];
            
            NSInteger answer = [alert runModal];
            
            if (answer == NSAlertFirstButtonReturn) {
                [[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:@"http://macminer.fabulouspanda.com/macminer/"]];
                return;
            }
            if (answer == NSAlertSecondButtonReturn) {
                return;
            }
            
        }
        
    }
    else {
        NSString *question = NSLocalizedString(@"You are up to date", @"Quit without stop error question message");
        NSString *info = NSLocalizedString(@"Check back soon!", @"Quit without saves error question info");
        NSString *updateButton = NSLocalizedString(@"I see.", @"button title");

        NSAlert *alert = [[NSAlert alloc] init];
        [alert setMessageText:question];
        [alert setInformativeText:info];
        [alert addButtonWithTitle:updateButton];
        
        NSInteger answer = [alert runModal];
        
        if (answer == NSAlertFirstButtonReturn) {
            return;
        }

    }

    }
    
}

@end
