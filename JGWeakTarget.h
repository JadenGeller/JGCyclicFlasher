//
//  JGWeakTarget.h
//  JGCyclicFlasherExample
//
//  Created by Jaden Geller on 12/23/13.
//  Copyright (c) 2013 Jaden Geller. All rights reserved.
//

#import <Foundation/Foundation.h>

/** A class intended to for use as a proxy object to create a weak reference to the target in a target/selector callback. Initialize an instance of JGWeakTarger with the desired target and selector. Then, use the weakTarget and weakSelector property when creating a target/selector callback. JGWeakTarget will maintain a weak reference to the target and relay the recieved callbacks to the selector.
 
 @code
 
 JGWeakTarget *weakSelf = [JGWeakTarget weakTargetWithTarget:self selector:@selector(timerFired:)];
 [NSTimer scheduledTimerWithTimeInterval:10 target:weakSelf.weakTarget selector:weakSelf.weakSelector userInfo:nil repeats:YES];
 
 // NSTimer holds a weak reference to self, so the object can be deallocated despite the existance of the timer.
 // It is the object's job to cancel the timer upon deallocation.
 
 @endcode
 
 @see https://github.com/JadenGeller/JGWeakTarget for more information.
 
 */
@interface JGWeakTarget : NSObject

/** Target that must be used when creating a weak target/selector callback. Always returns a pointer to the current instance of the JGWeakTarget, which intercepts the callback and reroutes it to the weak reference target.
 
 @code
 
 [NSTimer scheduledTimerWithTimeInterval:10 target:weakSelf.weakTarget selector:weakSelf.weakSelector userInfo:nil repeats:YES];
 
 @endcode
 
 @see https://github.com/JadenGeller/JGWeakTarget for more information.
 
 */
@property (nonatomic, weak, readonly) id weakTarget;

/** Selector that must be used when creating a weak target/selector callback. Always returns @selector(relay:), which intercepts the callback and reroutes it to the weak reference target.
 
 @code
 
 [NSTimer scheduledTimerWithTimeInterval:10 target:weakSelf.weakTarget selector:weakSelf.weakSelector userInfo:nil repeats:YES];
 
 @endcode
 
 @see https://github.com/JadenGeller/JGWeakTarget for more information.
 
 */
@property (nonatomic, readonly) SEL weakSelector;

/** Pointer to the target object to which callback should be rerouted. This object is weakly refernced such that the target/selector callback behaves as usual except it does not prevent the object from being deallocated.
 
 @code
 
 weakSelf = [[JGWeakTarget alloc]init];
 weakSelf.target = myObject;
 
 @endcode
 
 @see https://github.com/JadenGeller/JGWeakTarget for more information.
 
 */
@property (nonatomic, weak) id target;

/** Selector of the target object to which callback should be rerouted.
 
 @code
 
 weakSelf = [[JGWeakTarget alloc]init];
 weakSelf.target = @selector(doStuff);
 
 @endcode
 
 @see https://github.com/JadenGeller/JGWeakTarget for more information.
 
 */
@property (nonatomic) SEL selector;


/** Initializes an instance of JGWeakTarget and sets the target and selector to the desired values.
 
 @param target A pointer to the target object that should be weakly referenced.
 @param selector The selector of the target object that should receive the callback.
 
 @return An instance of JGWeakTarget
 
 @see https://github.com/JadenGeller/JGWeakTarget for more information.
 
 */
-(id)initWithTarget:(id)target selector:(SEL)selector;

/** Returns an initialized instance of JGWeakTarget and sets the target and selector to the desired values.
 
 @param target A pointer to the target object that should be weakly referenced.
 @param selector The selector of the target object that should receive the callback.
 
 @return An instance of JGWeakTarget
 
 @see https://github.com/JadenGeller/JGWeakTarget for more information.
 
 */
+(JGWeakTarget*)weakTargetWithTarget:(id)target selector:(SEL)selector;

@end
