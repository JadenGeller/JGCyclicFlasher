//
//  JGWeakTarget.m
//  JGCyclicFlasherExample
//
//  Created by Jaden Geller on 12/23/13.
//  Copyright (c) 2013 Jaden Geller. All rights reserved.
//

#import "JGWeakTarget.h"

@implementation JGWeakTarget

-(id)initWithTarget:(id)target selector:(SEL)selector{
    if (self = [super init]) {
        _target = target;
        _selector = selector;
    }
    return self;
}

+(JGWeakTarget*)weakTargetWithTarget:(id)target selector:(SEL)selector{
    return [[JGWeakTarget alloc]initWithTarget:target selector:selector];
}

#pragma mark - Reroute Callback to Weak Target

//Relays the selector callback to the intended target and selector
-(void)relay:(id)object{
    IMP method = [self.target methodForSelector:self.selector];
    void (*relay)(id, SEL, id) = (void *)method;
    relay(self.target, self.selector, object);
}

#pragma mark - Weak Target/Selector Getter

-(SEL)weakSelector{
    return @selector(relay:);
}

-(id)weakTarget{
    return self;
}

@end