JGCyclicFlasher
===============

JGCyclicFlasher simplifies the process of creating very short repeating animations with intervals as short as a single screen refresh. Unlike CADisplayLink, JGCyclicFlasher is block based and contains conveniences for more easily creating complex animations. A flashInterval can be set indicating the number of frames for which each state is displayed. In addition, JGCyclicFlasher can index the cycles to create more complicated state-dependent animations.

Example
===============

We will show an example in which the screen blinks red, the main color, for a long duration, then green, blue, and red again for short durations. Then, the process will cycle again for green and blue as the main color. Observe the construction of the JGCyclicFlasher object:

```
self.flasher = [JGCyclicFlasher flasherWithFlashInterval:@[@10,@2,@2,@2] numberOfCycles:3 flashUpdate:^(NSUInteger state, NSUInteger cycle) {
     NSInteger colorIndex = (state + cycle) % 3;
     switch (colorIndex) {
         case 0:
             self.view.backgroundColor = [UIColor redColor];
             break;
             
         case 1:
             self.view.backgroundColor = [UIColor greenColor];
             break;
             
         case 2:
             self.view.backgroundColor = [UIColor blueColor];
             break;
             
         default: // Will never happen because colorIndex is modulo 3
             break;
     }
}];

self.flasher.flashing = YES;
```

The JGCyclicFlasher is initialized with the flashInterval `@[@10,@2,@2,@2]`, which is an NSArray containing 4 NSNumbers. Each NSNumber indicates the duration of the framelength of each state. For example, state 0 lasts for 10 frames (or screen refreshes) and state 1, 2, and 3 last for 2 frames each. This interval specifies our long blink followed by 3 short blinks.

The next component of the constructor, the numberOfCycles, is initialized with an integer value of 3. This indicates that the interval will repeat 3 times--once with a cycle index of 0, then 1, then 2. This numberOfCycles value allows us to repeat the pattern for a long red blink, a long green blink, and a long blue blink.

The last parameter, flashUpdate, is a block function that is called at the beginning of each interval. In this block should all the animation logic be implemented. The animation block recieves two arguments: the current state and the current cycle. Using these arguments, we can implement complex animation patterns. In this case, we change the view's background color by using a switch statement that evaluates the current state via the function arguments. Obviously, much more complicated behavior can be implemented than the modification of a view's background color.

The last--and arguably one of the most important steps--is to set the flashing property to YES to start recieving callbacks to the flashUpdate block. The animation can also be paused by setting this property to NO. It is important to note that a running JGCyclicFlasher will still be deallocated if all of its references are destoryed.

