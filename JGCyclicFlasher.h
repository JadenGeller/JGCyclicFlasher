//
//  JGFlashView.h
//  Flash
//
//  Created by Jaden Geller on 12/21/13.
//  Copyright (c) 2013 Jaden Geller. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JGCyclicFlasher : NSObject

@property (nonatomic) BOOL flashing;
@property (nonatomic) NSArray *flashInterval;
@property (nonatomic, copy) void (^flashUpdate)(NSUInteger state, NSUInteger cycle);
@property (nonatomic) NSUInteger numberOfCycles;

+(JGCyclicFlasher*)flasherWithFlashInterval:(NSArray*)flashInterval numberOfCycles:(NSUInteger)numberOfCycles flashUpdate:(void(^)(NSUInteger state, NSUInteger cycle))flashUpdate;
+(JGCyclicFlasher*)flasherWithNumberOfCycles:(NSUInteger)numberOfCycles flashUpdate:(void(^)(NSUInteger state, NSUInteger cycle))flashUpdate;

@end
