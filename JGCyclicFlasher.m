//
//  JGFlashView.m
//  Flash
//
//  Created by Jaden Geller on 12/21/13.
//  Copyright (c) 2013 Jaden Geller. All rights reserved.
//

#import "JGCyclicFlasher.h"
#import "JGWeakTarget.h"

@interface JGCyclicFlasher ()

@property (nonatomic) CADisplayLink *displayLink; // Synchonizes callbacks with screen refresh rate

@property (nonatomic) NSUInteger frameCounter; // Counts displayLink callbacks
@property (nonatomic) NSUInteger indexCounter; // The current flashInterval array index
@property (nonatomic) NSUInteger cycleCounter; // The current cycle

@property (nonatomic, readonly) NSUInteger currentIntervalLength; // Frame count of current index in flashInterval

@end

@implementation JGCyclicFlasher

@synthesize flashInterval = _flashInterval;

-(id)init{
    if (self = [super init]) {
        _numberOfCycles = 1; // Default value
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

-(void)dealloc{
    // Stops CADisplayLink after deallocation
    [_displayLink removeFromRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
}

-(void)refresh:(CADisplayLink*)sender{
    if (self.frameCounter == 0) self.flashUpdate(self.indexCounter, self.cycleCounter); // Block callback
    self.frameCounter++; // Complex setter
}

#pragma mark - Property Setters

-(void)setFrameCounter:(NSUInteger)intervalCounter{
    _frameCounter = intervalCounter % self.currentIntervalLength; //modulo interval length
    
    //Increment flash interval array index on counter rollover
    if (_frameCounter == 0) {
        self.indexCounter++; // Complex setter
    }
}

-(void)setIndexCounter:(NSUInteger)indexCounter{
    _indexCounter = indexCounter % self.flashInterval.count; // modulo interval count
    
    //Increment cycle count on index rollover
    if (_indexCounter == 0) {
        self.cycleCounter++; // Complex setter
    }
}

-(void)setCycleCounter:(NSUInteger)cycleCounter{
    _cycleCounter = cycleCounter % self.numberOfCycles;
}

-(void)setFlashing:(BOOL)flashing{
    self.displayLink.paused = !flashing;
}

-(void)setFlashInterval:(NSArray *)flashInterval{
    // Ensure that flashInterval is valid
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
        
        // Reset counters to prevent exceptions
        _frameCounter = 0;
        _indexCounter = 0;
    }
}

-(void)setNumberOfCycles:(NSUInteger)numberOfCycles{
    // Ensure valid number of cycles
    if (numberOfCycles > 0) _numberOfCycles = numberOfCycles;
    else [NSException raise:@"Invalid number of cycles" format:@"Number of cycles must be a positive integer"];
}

#pragma mark - Property Getters

-(NSUInteger)currentIntervalLength{
    return [[self.flashInterval objectAtIndex:self.indexCounter] unsignedIntegerValue];
}

// Initializes CADisplayLink, sets it up, and adds it to run loop on first access
-(CADisplayLink*)displayLink{
    
    if (!_displayLink) { // Lazy initialization
        
        // Weak target ensures that CADisplayLink doesn't prevent JGCyclicFlasher deallocation
        JGWeakTarget *target = [JGWeakTarget weakTargetWithTarget:self selector:@selector(refresh:)];
        _displayLink = [CADisplayLink displayLinkWithTarget:target.weakTarget selector:target.weakSelector];
        [_displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
    }
    return _displayLink;
}

-(NSArray*)flashInterval{
    if (!_flashInterval) _flashInterval = @[@1]; //default flash interval
    return _flashInterval;
}

@end