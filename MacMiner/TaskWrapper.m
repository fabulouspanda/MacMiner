//
//  TaskWrapper.m
//  MacMiner
//
//  Created by Administrator on 02/04/2013.
//  Copyright (c) 2013 fabulouspanda. All rights reserved.
//

#import "TaskWrapper.h"

@interface TaskWrapper ()


@end


@implementation TaskWrapper

// Do basic initialization
- (id)initWithController:(id <TaskWrapperController>)cont arguments:(NSArray *)args
{
    self = [super init];
    controller = cont;
    arguments = args;
    
    return self;
}

- (void) startProcess {
    //    AppDelegate *appDelegate = (AppDelegate *)[[NSApplication sharedApplication] delegate];
    NSLog(@"startPressed");
    //    NSLog(@"%@", appDelegate.pingAddress.stringValue);
    //    NSString *testText = appDelegate.pingAddress.stringValue;
    
    [controller processStarted];
    
    task = [[NSTask alloc]init];
    

//        [task setStandardInput: [NSPipe pipe]];
    [task setStandardOutput: [NSPipe pipe]];
    [task setStandardError: [task standardOutput]];
    [task setLaunchPath: [arguments objectAtIndex:0]];
    [task setCurrentDirectoryPath: [arguments objectAtIndex:1]];

    [task setArguments: [arguments subarrayWithRange: NSMakeRange (2, ([arguments count] - 2))]];
    
    //    taskOutputFile = [[self createTmpFile] retain];
    //    NSFileHandle* taskOutput = [NSFileHandle fileHandleForWritingAtPath:taskOutputFile];
    
    
    
    // Here we register as an observer of the NSFileHandleReadCompletionNotification, which lets
    // us know when there is data waiting for us to grab it in the task's file handle (the pipe
    // to which we connected stdout and stderr above).  -getData: will be called when there
    // is data waiting.  The reason we need to do this is because if the file handle gets
    // filled up, the task will block waiting to send data and we'll never get anywhere.
    // So we have to keep reading data from the file handle as we go.
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(getData:)
                                                 name: NSFileHandleReadCompletionNotification
                                               object: [[task standardOutput] fileHandleForReading]];
    // We tell the file handle to go ahead and read in the background asynchronously, and notify
    // us via the callback registered above when we signed up as an observer.  The file handle will
    // send a NSFileHandleReadCompletionNotification when it has data that is available.
    [[[task standardOutput] fileHandleForReading] readInBackgroundAndNotify];
    
    NSLog(@"tasklaunch");
    [task launch];
    
    
}

- (void) stopProcess
{
    
    //        AppDelegate *appDelegate = (AppDelegate *)[[NSApplication sharedApplication] delegate];
    /*    // we tell the controller that we finished, via the callback, and then blow away our connection
     // to the controller.  NSTasks are one-shot (not for reuse), so we might as well be too.
     [controller processFinished];
     controller = nil;*/
    NSData *data;
    
    // It is important to clean up after ourselves so that we don't leave potentially deallocated
    // objects as observers in the notification center; this can lead to crashes.
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NSFileHandleReadCompletionNotification object: [[task standardOutput] fileHandleForReading]];
    
    // Make sure the task has actually stopped!
    [task terminate];
    NSLog(@"task terminated");
    
    while ((data = [[[task standardOutput] fileHandleForReading] availableData]) && [data length])
    {
        [controller appendOutput: [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]];
//        NSLog(@"controlappend");
        /*       NSString *dataString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
         appDelegate.pingReport.string = [appDelegate.pingReport.string stringByAppendingString:dataString];
         NSLog(dataString);*/
    }
    
    // we tell the controller that we finished, via the callback, and then blow away our connection
    // to the controller.  NSTasks are one-shot (not for reuse), so we might as well be too.
    [controller processFinished];
    controller = nil;
}

// This method is called asynchronously when data is available from the task's file handle.
// We just pass the data along to the controller as an NSString.
- (void) getData: (NSNotification *)aNotification
{
//    NSLog(@"getdata");
    //            AppDelegate *appDelegate = (AppDelegate *)[[NSApplication sharedApplication] delegate];
    NSData *data = [[aNotification userInfo] objectForKey:NSFileHandleNotificationDataItem];
    // If the length of the data is zero, then the task is basically over - there is nothing
    // more to get from the handle so we may as well shut down.
    if ([data length])
    {
        // Send the data on to the controller; we can't just use +stringWithUTF8String: here
        // because -[data bytes] is not necessarily a properly terminated string.
        // -initWithData:encoding: on the other hand checks -[data length]
//        NSLog(@"controlappend");
        [controller appendOutput: [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]];
//        NSLog([[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
    } else {
        // We're finished here
        [self stopProcess];
        NSLog(@"finished");
    }
    
    // we need to schedule the file handle go read more data in the background again.
    [[aNotification object] readInBackgroundAndNotify];
}

@end

