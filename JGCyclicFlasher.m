//
//  JGFlashView.m
//  Flash
//
//  Created by Jaden Geller on 12/21/13.
//  Copyright (c) 2013 Jaden Geller. All rights reserved.
//

#import "JGCyclicFlasher.h"

@interface JGCyclicFlasher ()

@property (nonatomic) CADisplayLink *displayLink;

@property (nonatomic) NSUInteger intervalCounter; //counts refreshes
@property (nonatomic) NSUInteger indexCounter; //holds current flashInterval array index
@property (nonatomic) NSUInteger cycleCounter;

@property (nonatomic, readonly) NSUInteger currentIntervalLength;

@end

@implementation JGCyclicFlasher

@synthesize flashInterval = _flashInterval;

-(id)init{
    if (self = [super init]) {
        _numberOfCycles = 1; //default value
    }
    return self;
}

+(JGCyclicFlasher*)flasherWithFlashInterval:(NSArray*)flashInterval numberOfCycles:(NSUInteger)numberOfCycles flashUpdate:(void(^)(NSUInteger state, NSUInteger cycle))flashUpdate{
    JGCyclicFlasher *flasher = [[JGCyclicFlasher alloc]init];
    flasher.flashInterval = flashInterval;
    flasher.flashUpdate = flashUpdate;
    flasher.numberOfCycles = numberOfCycles;
    return flasher;
}

+(JGCyclicFlasher*)flasherWithNumberOfCycles:(NSUInteger)numberOfCycles flashUpdate:(void(^)(NSUInteger state, NSUInteger cycle))flashUpdate{
    return [JGCyclicFlasher flasherWithFlashInterval:@[@1] numberOfCycles:numberOfCycles flashUpdate:flashUpdate];
}

-(CADisplayLink*)displayLink{
    if (!_displayLink) {
        _displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(refresh:)];
        [_displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
    }
    return _displayLink;
}

-(void)setFlashing:(BOOL)flashing{
    self.displayLink.paused = !flashing;
}

-(void)setFlashInterval:(NSArray *)flashInterval{
    //Ensure that flashInterval is valid
    if (!flashInterval || flashInterval.count == 0) {
        [NSException raise:@"Invalid flash interval" format:@"Flash interval array must include a non-zero number of NSNumber integers"];
    }
    else {
        for (NSNumber *num in flashInterval){
            if (![num isKindOfClass:[NSNumber class]] || CFNumberIsFloatType((CFNumberRef)num) || num.integerValue <= 0) {
                [NSException raise:@"Invalid flash interval" format:@"Flash interval must only contain positive, non-zero integer NSNumber objects"];
            }
        }
        _flashInterval = flashInterval;
        
        //Reset counters to prevent exceptions
        _intervalCounter = 0;
        _indexCounter = 0;
    }
}

-(void)setNumberOfCycles:(NSUInteger)numberOfCycles{
    if (numberOfCycles > 0) _numberOfCycles = numberOfCycles;
    else [NSException raise:@"Invalid number of cycles" format:@"Number of cycles must be a positive integer"];
}

-(NSArray*)flashInterval{
    if (!_flashInterval) _flashInterval = @[@1]; //default flash interval
    return _flashInterval;
}

-(void)refresh:(CADisplayLink*)displayLink{
    if (self.intervalCounter == 0) {
        self.flashUpdate(self.indexCounter, self.cycleCounter);
    }
    self.intervalCounter++;
}

-(void)setIndexCounter:(NSUInteger)indexCounter{
    _indexCounter = indexCounter % self.flashInterval.count;
    
    //Increment flash interval array index on counter rollover
    if (_indexCounter == 0) {
        self.cycleCounter++;
    }
}

-(void)setIntervalCounter:(NSUInteger)intervalCounter{
    _intervalCounter = intervalCounter % self.currentIntervalLength;
    
    //Increment flash interval array index on counter rollover
    if (_intervalCounter == 0) {
        self.indexCounter++;
    }
}

-(void)setCycleCounter:(NSUInteger)cycleCounter{
    _cycleCounter = cycleCounter % self.numberOfCycles;
}

-(NSUInteger)currentIntervalLength{
    return [[self.flashInterval objectAtIndex:self.indexCounter] unsignedIntegerValue];
}

-(void)dealloc{
    [self.displayLink removeFromRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
}

@end
