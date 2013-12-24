//
//  JGFlashView.h
//  Flash
//
//  Created by Jaden Geller on 12/21/13.
//  Copyright (c) 2013 Jaden Geller. All rights reserved.
//

#import <UIKit/UIKit.h>

/** A class intended to simplifies the process of creating short cyclic framed animations (with respect to the screen's refresh rate). Unlike CADisplayLink, JGCyclicFlasher is block based and contains conveniences for more easily creating complex animations.
 
 @see CADisplayLink
 @see https://github.com/JadenGeller/JGCyclicFlasher for more information.
 
 */
@interface JGCyclicFlasher : NSObject

/** Boolean value specifying whether the the cyclic flasher is currently animating and calling the block. Used as a setter, the animation can be paused and resumed.
 
 @code
 
 cyclicFlasher.flashing = YES // starts block callbacks as specified by interval
 
 @endcode
 
 @see https://github.com/JadenGeller/JGCyclicFlasher for more information.
 
 */
@property (nonatomic) BOOL flashing;

/** Specifies the number of frames before the callback for each state. The cyclic flasher follows each interval in the flashInterval sequentually and then repeats. The flash interval can be set to a new NSArray of NSNumber objects. The array must contain at least one NSNumber, and each NSNumber must represent a positive integer. Note that, upon deallocation, JGCyclicFlasher automatically stops flashing as its corresponding CADisplayLink is removed for the run loop.
 
 @code
 
 cyclicFlasherA.flashInterval = @[@10,@2] // interval of 10 frames followed by 2 frames
 cyclicFlasherB.flashInterval = @[@1]     // interval of 1 single frame

 @endcode
 
 @see https://github.com/JadenGeller/JGCyclicFlasher for more information.
 
 */
@property (nonatomic) NSArray *flashInterval;

/** Indicates how many times the flash interval repeats before the entire animation repeats. Used to keep track of current repition count during animation block for use in more complex animations. If the animation repeats when the flash interval repeats, the animation is a single cycle animation and the cycle variable in the block callback can be ignored. Default value is @[@1], or a 1 frame flash interval.
 
 @code
 
 cyclicFlasherA.numberOfCycles = 1 // cyclic count is irrelevant
 cyclicFlasherA.numberOfCycles = 3 // counts three cycles and then repeats
 
 @endcode
 
 @see https://github.com/JadenGeller/JGCyclicFlasher for more information.
 
 */

@property (nonatomic) NSUInteger numberOfCycles;

/** Specifies the callback for the cyclic flasher after each flash interval. In this block should all the animation logic be implemented. The animation block recieves two arguments: the current state and the current cycle. The current state is an integer representing the current flash interval. In essenece, it is the index of the flash interval array that is currently animating. The current cycle is an integer from 0 to numberOfCycles-1 that represents the repeat index. This can be used to easily modify the animation in a repetitive pattern. Default value is 1 cycle.
 
 @code
 
 self.flasher.flashUpdate = ^(NSUInteger state, NSUInteger cycle) {
    // apply animation logic here
 };
 
 @endcode
 
 @see https://github.com/JadenGeller/JGCyclicFlasher for more information.
 
 */
@property (nonatomic, copy) void (^flashUpdate)(NSUInteger state, NSUInteger cycle);

/** Initializes an instance of JGCyclicFlasher and sets the flashInterval, numberOfCycles, and flashUpdate properties to the desired values.
 
 @param flashInterval An NSArray representing the desired flash interval.
 @param numberOfCycles An NSUInteger representing the desired number of cycles.
 @param flashUpdate A callback block that applies the animation based on current state and cycle values.
 
 @return An instance of JGCyclicFlasher
 
 @see https://github.com/JadenGeller/JGCyclicFlasher for more information.
 
 */
+(JGCyclicFlasher*)flasherWithFlashInterval:(NSArray*)flashInterval numberOfCycles:(NSUInteger)numberOfCycles flashUpdate:(void(^)(NSUInteger state, NSUInteger cycle))flashUpdate;

@end
