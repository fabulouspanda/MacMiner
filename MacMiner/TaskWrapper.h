// Based on Apple's "Moriarity" sample code at
// <http://developer.apple.com/library/mac/#samplecode/Moriarity/Introduction/Intro.html>
// See the accompanying LICENSE.txt for Apple's original terms of use.

#import <Foundation/Foundation.h>
#import "TaskWrapperDelegate.h"

/*!
 * Wrapper around NSTask, with a delegate that provides hooks to various
 * points in the lifetime of the task. Evolved from the TaskWrapper class
 * in Apple's Moriarity sample code.
 *
 * There is a delegate method to receive output from the task's stdout
 * and stderr, but no way to interactively send input via stdin.
 *
 * TaskWrapper objects are one-shot, like NSTask. If you need to run
 * a task more than once, create new TaskWrapper instances.
 */
@interface TaskWrapper : NSObject
{
	id <TaskWrapperDelegate>_taskDelegate;
	NSString *_commandPath;
	NSArray *_commandArguments;
	NSDictionary *_environment;
	NSTask *_task;
}

@property (readonly) NSString *commandPath;

/*!
 * commandPath is the path to the executable to launch. env contains environment variables
 * you want the command to run with. env can be nil.
 */
- (id)initWithCommandPath:(NSString *)commandPath
				arguments:(NSArray *)args
			  environment:(NSDictionary *)env
				 delegate:(id <TaskWrapperDelegate>)aDelegate;

- (void)startTask;

- (void)stopTask;

/*!
 * Returns a string consisting of the command path followed by arguments. Doesn't do
 * any escaping, so you may not be able to paste this into Terminal and run it. But
 * can be useful for debugging/logging.
 */
- (NSString *)expandedCommand;

@end
