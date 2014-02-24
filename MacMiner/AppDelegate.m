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


        NSString *stringVersion = [NSString stringWithContentsOfURL:[NSURL URLWithString:@"http://downloads.fabulouspanda.co.uk/betav.html"]encoding:NSUTF8StringEncoding error:nil];


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
                            [[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:@"http://fabulouspanda.co.uk/macminer/"]];
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
            
        
    if ([hideVersion isEqualToString:@"1518"]) {

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
    NSString *stringVersion = [NSString stringWithContentsOfURL:[NSURL URLWithString:@"http://downloads.fabulouspanda.co.uk/betav.html"]encoding:NSUTF8StringEncoding error:nil];
    
    
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
                    [[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:@"http://fabulouspanda.co.uk/macminer/"]];
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
    [[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:@"http://fabulouspanda.co.uk/macminer/"]];
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
    [[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:@"http://fabulouspanda.co.uk/macminer/"]];
}

- (void)mobileCommands {
        [self performSelectorInBackground:@selector(mobileCommandsThread) withObject:nil];
}

-(void)mobileCommandsThread {
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    
    [prefs synchronize];
    //    self.asicAPIStorage2.string = [self.asicAPIStorage2.string stringByAppendingString:@"      trying to send data to MoMi     "];
    NSString *email = [prefs objectForKey:@"emailAddress"];
    NSString *appID = [prefs objectForKey:@"appID"];
    
    if (email != nil) {
        
    
    
    NSString *machineName = [[NSHost currentHost] localizedName];
    machineName = [machineName stringByReplacingOccurrencesOfString:@" " withString:@"_"];
    machineName = [machineName stringByReplacingOccurrencesOfString:@"-" withString:@"_"];
    
    NSCharacterSet *notAllowedChars = [[NSCharacterSet characterSetWithCharactersInString:@"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"] invertedSet];
    machineName = [[machineName componentsSeparatedByCharactersInSet:notAllowedChars] componentsJoinedByString:@""];
    
    if (machineName.length <= 1) {
        machineName = @"Mac";
    }

    
    if (self.allowMobileMinerControl.state == NSOnState) {
        
        
        //GET Request
        NSString *getString = [NSString stringWithFormat:@"http://mobileminer.azurewebsites.net/api/RemoteCommands?emailAddress=%@&applicationKey=%@&machineName=%@&apiKey=26efrOXrizmEF3", email, appID, machineName];
        
        
        NSMutableURLRequest *request2 = [[NSMutableURLRequest alloc] init];
        [request2 setHTTPMethod:@"GET"];
        [request2 setURL:[NSURL URLWithString:getString]];
        
        NSError *error = [[NSError alloc] init];
        NSHTTPURLResponse *responseCode = nil;
        
        NSData *oResponseData = [NSURLConnection sendSynchronousRequest:request2 returningResponse:&responseCode error:&error];
        
        if([responseCode statusCode] != 200){
        if([responseCode statusCode] != 0){
        if([responseCode statusCode] != 503){
            NSLog(@"Error getting %@, HTTP status code %li", getString, (long)[responseCode statusCode]);
            //            return nil;
        }
        }
        }
        
        NSString *responseString = [[NSString alloc] initWithData:oResponseData encoding:NSUTF8StringEncoding];
        if (responseString != nil) {
            
        
        if ([responseString rangeOfString:@"STOP"].location != NSNotFound) {
            self.mobileMinerStatus = @"STOP";
        }
        if ([responseString rangeOfString:@"START"].location != NSNotFound) {
            self.mobileMinerStatus = @"START";
        }
        if ([responseString rangeOfString:@"RESTART"].location != NSNotFound) {
            self.mobileMinerStatus = @"RESTART";
        }
        
        if ([responseString rangeOfString:@"Id"].location != NSNotFound) {
            
            
            
            NSString *idString = [self getDataBetweenFromString:responseString
                                                     leftString:@"Id" rightString:@"," leftOffset:4];
            
            
            NSString *deleteString = [NSString stringWithFormat:@"http://mobileminer.azurewebsites.net/api/RemoteCommands?emailAddress=%@&applicationKey=%@&machineName=%@&commandId=%@&apiKey=26efrOXrizmEF3", email, appID, machineName, idString];
            
            
            NSMutableURLRequest *request3 = [[NSMutableURLRequest alloc] init];
            [request3 setHTTPMethod:@"DELETE"];
            [request3 setURL:[NSURL URLWithString:deleteString]];
            
            NSError *error3 = [[NSError alloc] init];
            NSHTTPURLResponse *responseCode3 = nil;
            
            NSData *oResponseData3 = [NSURLConnection sendSynchronousRequest:request3 returningResponse:&responseCode3 error:&error3];
            
            if([responseCode3 statusCode] != 200){
                            if([responseCode3 statusCode] != 0){
        if([responseCode statusCode] != 503){
                NSLog(@"Error getting %@, HTTP status code %li", getString, (long)[responseCode statusCode]);
                //            return nil;
        }
                            }
            }
            else {
                //        NSLog(@"DELETE SUCCESS");
                //NSString *responseString3 = [[NSString alloc] initWithData:oResponseData3 encoding:NSUTF8StringEncoding];
                //            NSLog(responseString3);
            }
            
        }
        
    }
        //end control code
        
    }
        
    
    

    machineName = nil;
    }
    email = nil;
    appID = nil;
    prefs = nil;
}

- (void)mobilePost
{
//    [self performSelectorInBackground:@selector(mobilePostThread) withObject:nil];
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    
    [prefs synchronize];
    //    self.asicAPIStorage2.string = [self.asicAPIStorage2.string stringByAppendingString:@"      trying to send data to MoMi     "];
    NSString *email = [prefs objectForKey:@"emailAddress"];
    NSString *appID = [prefs objectForKey:@"appID"];
    
    if (email != nil) {
        
    
    NSString *machineName = [[NSHost currentHost] localizedName];
    machineName = [machineName stringByReplacingOccurrencesOfString:@" " withString:@"_"];
    machineName = [machineName stringByReplacingOccurrencesOfString:@"-" withString:@"_"];
    
    NSCharacterSet *notAllowedChars = [[NSCharacterSet characterSetWithCharactersInString:@"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"] invertedSet];
    machineName = [[machineName componentsSeparatedByCharactersInSet:notAllowedChars] componentsJoinedByString:@""];
    
    if (machineName.length <= 1) {
        machineName = @"Mac";
    }
    
    
    if (email.length >= 5) {
        
        
        
        
        
        NSString *prepost = @"";
        
        prepost = [NSString stringWithFormat:[self.mobileMinerDataArray componentsJoinedByString:@","]];
        if (prepost.length >= 30) {
            
            
            
            NSString *post1 = [prepost stringByAppendingString:@"]"];
            NSString *post = [@"[" stringByAppendingString:post1];
            
            //    NSLog(post);
            //            self.asicAPIStorage2.string = [self.asicAPIStorage2.string stringByAppendingString:@"    POST formed:    "];
            //        self.asicAPIStorage2.string = [self.asicAPIStorage2.string stringByAppendingString:post];
            
            NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
            
            NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[postData length]];
            
            
            NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
            
            NSString *urlString = @"";
            
            if (self.disableHttpsButton.state == NSOffState) {
                urlString = nil;
                urlString = [NSString stringWithFormat:@"https://mobileminer.azurewebsites.net/api/MiningStatisticsInput?emailAddress=%@&applicationKey=%@&machineName=%@&apiKey=26efrOXrizmEF3", email, appID, machineName];
            }
            
            if (self.disableHttpsButton.state == NSOnState) {
                urlString = nil;
                urlString = [NSString stringWithFormat:@"http://mobileminer.azurewebsites.net/api/MiningStatisticsInput?emailAddress=%@&applicationKey=%@&machineName=%@&apiKey=26efrOXrizmEF3", email, appID, machineName];
            }
            
            
            [request setURL:[NSURL URLWithString:urlString]];
            [request setHTTPMethod:@"POST"];
            [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
            [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
            [request setHTTPBody:postData];
            
            
            
            NSURLConnection *theConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
            
            
            
            
            //            self.asicAPIStorage2.string = [self.asicAPIStorage2.string stringByAppendingString:@"    DATA SENT     "];
            post1 = nil;
            post = nil;
            postData = nil;
            postLength = nil;
            request = nil;
            urlString = nil;
            theConnection = nil;
            
        }
        prepost = nil;
    }

    machineName = nil;
    }
    email = nil;
    appID = nil;
    prefs = nil;
    
}

- (void)mobilePostThread {
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    
    [prefs synchronize];
    //    self.asicAPIStorage2.string = [self.asicAPIStorage2.string stringByAppendingString:@"      trying to send data to MoMi     "];
    NSString *email = [prefs objectForKey:@"emailAddress"];
    NSString *appID = [prefs objectForKey:@"appID"];
    
    NSString *machineName = [[NSHost currentHost] localizedName];
    machineName = [machineName stringByReplacingOccurrencesOfString:@" " withString:@"_"];
    machineName = [machineName stringByReplacingOccurrencesOfString:@"-" withString:@"_"];
        machineName = [machineName stringByReplacingOccurrencesOfString:@"'" withString:@"_"];
        machineName = [machineName stringByReplacingOccurrencesOfString:@"\"" withString:@"_"];
        machineName = [machineName stringByReplacingOccurrencesOfString:@"’" withString:@"_"];
    
    NSCharacterSet *notAllowedChars = [[NSCharacterSet characterSetWithCharactersInString:@"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"] invertedSet];
    machineName = [[machineName componentsSeparatedByCharactersInSet:notAllowedChars] componentsJoinedByString:@""];
    
    
    if (machineName.length <= 1) {
        machineName = @"Mac";
        
        
        
    }
    
    
    if (email.length >= 5) {
        
        
        
        
        
        NSString *prepost = @"";

            prepost = [NSString stringWithFormat:[self.mobileMinerDataArray componentsJoinedByString:@","]];
        if (prepost.length >= 30) {
            
            
            
            NSString *post1 = [prepost stringByAppendingString:@"]"];
            NSString *post = [@"[" stringByAppendingString:post1];
            
            //    NSLog(post);
            //            self.asicAPIStorage2.string = [self.asicAPIStorage2.string stringByAppendingString:@"    POST formed:    "];
            //        self.asicAPIStorage2.string = [self.asicAPIStorage2.string stringByAppendingString:post];
            
            NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
            
            NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[postData length]];
            
            
            NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
            
            NSString *urlString = @"";
            
            if (self.disableHttpsButton.state == NSOffState) {
                urlString = nil;
                urlString = [NSString stringWithFormat:@"https://mobileminer.azurewebsites.net/api/MiningStatisticsInput?emailAddress=%@&applicationKey=%@&machineName=%@&apiKey=26efrOXrizmEF3", email, appID, machineName];
            }
            
            if (self.disableHttpsButton.state == NSOnState) {
                urlString = nil;
                urlString = [NSString stringWithFormat:@"http://mobileminer.azurewebsites.net/api/MiningStatisticsInput?emailAddress=%@&applicationKey=%@&machineName=%@&apiKey=26efrOXrizmEF3", email, appID, machineName];
            }
            
            
            [request setURL:[NSURL URLWithString:urlString]];
            [request setHTTPMethod:@"POST"];
            [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
            [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
            [request setHTTPBody:postData];
            
            
            
            NSURLConnection *theConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
            
            
            
            
            //            self.asicAPIStorage2.string = [self.asicAPIStorage2.string stringByAppendingString:@"    DATA SENT     "];
            post1 = nil;
            post = nil;
            postData = nil;
            postLength = nil;
            request = nil;
            urlString = nil;
            theConnection = nil;
            
        }
        prepost = nil;
     }
    email = nil;
    appID = nil;
    prefs = nil;
    machineName = nil;
    
    

    
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
    
    [prefs setObject:@"1518" forKey:@"hideVersion"];
    
    [prefs synchronize];
    
            [self.releaseNotes orderOut:sender];
    
    prefs = nil;
    
    
    
}

- (NSString *)getDataBetweenFromString:(NSString *)data leftString:(NSString *)leftData rightString:(NSString *)rightData leftOffset:(NSInteger)leftPos;
{
    if ([leftData isNotEqualTo:nil]) {
        NSInteger left, right;
        
        NSScanner *scanner=[NSScanner scannerWithString:data];
        [scanner scanUpToString:leftData intoString: nil];
        left = [scanner scanLocation];
        [scanner setScanLocation:left + leftPos];
        [scanner scanUpToString:rightData intoString: nil];
        right = [scanner scanLocation] + 1;
        left += leftPos;
        self.foundData = [data substringWithRange: NSMakeRange(left, (right - left) - 1)];
        
        return self.foundData;
        
        self.foundData = nil;
        scanner = nil;
        leftData = nil;
        rightData = nil;
    }
    else return nil;
}

- (IBAction)checkForUpdates:(id)sender {
    NSString *stringVersion = [NSString stringWithContentsOfURL:[NSURL URLWithString:@"http://downloads.fabulouspanda.co.uk/betav.html"]encoding:NSUTF8StringEncoding error:nil];
    
    
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
                [[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:@"http://fabulouspanda.co.uk/macminer/"]];
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
