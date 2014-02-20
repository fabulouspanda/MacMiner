// Based on Apple's "Moriarity" sample code at
// <http://developer.apple.com/library/mac/#samplecode/Moriarity/Introduction/Intro.html>
// See the accompanying LICENSE.txt for Apple's original terms of use.

#import "TaskWrapper.h"



@implementation TaskWrapper

@synthesize commandPath = _commandPath;

- (id)initWithCommandPath:(NSString *)pathToCommand
				arguments:(NSArray *)commandArguments
			  environment:(NSDictionary *)env
				 delegate:(id <TaskWrapperDelegate>)aDelegate;
{
	self = [super init];
	if (self)
	{
		_taskDelegate = aDelegate;
		_commandPath = [pathToCommand copy];
		_commandArguments = [commandArguments copy];
		_environment = [env copy];
	}
	
	return self;
}

- (void)dealloc
{
	[self stopTask];  // Besides ensuring the task is stopped, this disconnects weak references.
	
	_commandPath = nil;
	_commandArguments = nil;
	_environment = nil;
	_task = nil;
	
//	super = nil;
}

- (void)startTask
{
	// Notify the delegate that we are starting.
	if ([(id)_taskDelegate respondsToSelector:@selector(taskWrapperWillStartTask:)])
	{
		[_taskDelegate taskWrapperWillStartTask:self];
	}
	
	// Instantiate the NSTask that will run the specified command.
	_task = [[NSTask alloc] init];
	
	// The output of stdout and stderr is sent to a pipe so that we can catch it later
	// and send it to the delegate. We don't do anything with stdin, so there is no
	// way to interactively send input to the task.
	[_task setStandardOutput:[NSPipe pipe]];
	[_task setStandardError:[_task standardOutput]];
	[_task setLaunchPath:_commandPath];
	[_task setArguments:_commandArguments];
	
	if (_environment)
	{
		[_task setEnvironment:_environment];
	}
	
	// Register to be notified when there is data waiting in the task's file handle (the pipe
	// to which we connected stdout and stderr above). We do this because if the file handle gets
	// filled up, the task will block waiting to send data and we'll never get anywhere.
	// So we have to keep reading data from the file handle as we go.
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(_taskDidProduceOutput:)
												 name:NSFileHandleReadCompletionNotification
											   object:[[_task standardOutput] fileHandleForReading]];
	
	// Tell the file handle to read in the background asynchronously. The file handle will
	// send a NSFileHandleReadCompletionNotification (which we just registered to observe)
	// when it has data available.
	[[[_task standardOutput] fileHandleForReading] readInBackgroundAndNotify];
	
	// Launch the task asynchronously.
	[_task launch];

}

// Notifies the delegate that there is data.
- (void)_sendDataToDelegate:(NSData *)data
{
	if ([data length] && [(id)_taskDelegate respondsToSelector:@selector(taskWrapper:didProduceOutput:)])
	{
		NSString *outputString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
		
		[_taskDelegate taskWrapper:self didProduceOutput:outputString];
	}
}

- (void)stopTask
{
	// Disconnect the notification center's weak reference to us.
	[[NSNotificationCenter defaultCenter] removeObserver:self name:NSFileHandleReadCompletionNotification object:[[_task standardOutput] fileHandleForReading]];
	
	// Make sure the task has actually stopped.
	[_task terminate];
	
	// Drain any remaining output data the task generates.
//	NSData *data;
//	while ((data = [[[_task standardOutput] fileHandleForReading] availableData]) && [data length])
//	{
//		// Notify the delegate that there is data.
//		[self _sendDataToDelegate:data];
//	}
	
	// Notify the delegate that the task finished.
	if ([(id)_taskDelegate respondsToSelector:@selector(taskWrapper:didFinishTaskWithStatus:)])
	{
		NSInteger taskStatus = ([_task isRunning] ? -9999 : [_task terminationStatus]);
		
		[_taskDelegate taskWrapper:self didFinishTaskWithStatus:taskStatus];
	};
	
	// Disconnect our weak reference to the delegate.
	_taskDelegate = nil;
}

// Called asynchronously when data is available from the task's file handle.
// [aNotification object] is the file handle.
- (void)_taskDidProduceOutput:(NSNotification *)aNotification
{
	NSData *data = [[aNotification userInfo] objectForKey:NSFileHandleNotificationDataItem];
	
	if ([data length])
	{
		// Notify the delegate that there is data.
		[self _sendDataToDelegate:data];
		
		// [agl] Moved this readInBackgroundAndNotify up here from a few lines down.
		// Schedule the file handle to read more data.
		[[aNotification object] readInBackgroundAndNotify];
	}
	else
	{
		// There is no more data to get from the file handle, so shut down.
		// This will in turn notify the delegate.
		[self stopTask];
	}
	
    // [agl] Seems to me this should be in the if-block above -- am I wrong?
    //	// Schedule the file handle to read more data.
    //	[[aNotification object] readInBackgroundAndNotify];
}

- (NSString *)expandedCommand
{
	return [NSString stringWithFormat:@"%@ %@",
			_commandPath,
			[_commandArguments componentsJoinedByString:@" "]];
}

@end

