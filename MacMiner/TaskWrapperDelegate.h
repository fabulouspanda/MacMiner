// Based on Apple's "Moriarity" sample code at
// <http://developer.apple.com/library/mac/#samplecode/Moriarity/Introduction/Intro.html>
// See the accompanying LICENSE.txt for Apple's original terms of use.

#import <Foundation/Foundation.h>

@class TaskWrapper;

@protocol TaskWrapperDelegate

@optional

/*! Called before the task is launched. */
- (void)taskWrapperWillStartTask:(TaskWrapper *)taskWrapper;

/*! Called when output arrives from the task, from either stdout or stderr. */
- (void)taskWrapper:(TaskWrapper *)taskWrapper didProduceOutput:(NSString *)outputString;

/*!
 * Called when any of the following happens:
 *
 *	- The task ends.
 *	- There is no more data coming through the file handle.
 *	- The process object is released.
 */
- (void)taskWrapper:(TaskWrapper *)taskWrapper didFinishTaskWithStatus:(int)terminationStatus;

@end
