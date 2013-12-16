// Based on Apple's "Moriarity" sample code at
// <http://developer.apple.com/library/mac/#samplecode/Moriarity/Introduction/Intro.html>
// See the accompanying LICENSE.txt for Apple's original terms of use.

#import <Foundation/Foundation.h>

@class taskTwoWrapper;

@protocol taskTwoWrapperDelegate

@optional

/*! Called before the task is launched. */
- (void)taskTwoWrapperWillStartTask:(taskTwoWrapper *)taskTwoWrapper;

/*! Called when output arrives from the task, from either stdout or stderr. */
- (void)taskTwoWrapper:(taskTwoWrapper *)taskTwoWrapper didProduceOutput:(NSString *)outputString;

/*!
 * Called when any of the following happens:
 *
 *	- The task ends.
 *	- There is no more data coming through the file handle.
 *	- The process object is released.
 */
- (void)taskTwoWrapper:(taskTwoWrapper *)taskTwoWrapper didFinishTaskWithStatus:(int)terminationStatus;

@end
