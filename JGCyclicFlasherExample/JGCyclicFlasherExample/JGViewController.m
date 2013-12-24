//
//  JGViewController.m
//  JGCyclicFlasherExample
//
//  Created by Jaden Geller on 12/23/13.
//

#import "JGViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "JGCyclicFlasher.h"

@interface JGViewController ()

@property (nonatomic) JGCyclicFlasher *flasher;

@end

@implementation JGViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Do any additional setup after loading the view, typically from a nib.
    [self exampleChanged:nil]; //default selection
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)exampleChanged:(id)sender {
    NSInteger button = sender?[(UISegmentedControl*)sender selectedSegmentIndex]:0;
    
    // Note: These examples include very rapid flashing of the screen. Do not view if this is likely to cause negative health effects.
    switch (button) {
            
        case 0: // Example 1 - Alternate between black and white with every screen refresh
        {
            self.flasher = [JGCyclicFlasher flasherWithFlashInterval:@[@1] numberOfCycles:2 flashUpdate:^(NSUInteger state, NSUInteger cycle) {
                self.view.backgroundColor = cycle?[UIColor blackColor]:[UIColor whiteColor];
                // Note: Example 1 may cause the screen of the iOS device to continue flickering after the app is left due to the way LCD screens operate. Don't worry, it will eventually stop!
            }];
            break;
        }
        case 1: // Example 2 - Alternate between red, green, and blue in a long/short/short/short pattern
        {
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
            break;
        }
        case 2: // Exampe 3 - Flashing colors in rainbow sequence; long dark color followed by short bright color
        {
            self.flasher = [JGCyclicFlasher flasherWithFlashInterval:@[@18,@5] numberOfCycles:20 flashUpdate:^(NSUInteger state, NSUInteger cycle) {
                float intensity = 0.8 + state*0.2;
                self.view.backgroundColor = [UIColor colorWithHue:5*cycle/100.0 saturation:intensity brightness:intensity alpha:1];
            }];
            break;
        }
        case 3: // Example 4 - Very similiar to Example 1, but with red and blue instead of black and white
        {
            self.flasher = [JGCyclicFlasher flasherWithFlashInterval:@[@1] numberOfCycles:2 flashUpdate:^(NSUInteger state, NSUInteger cycle) {
                self.view.backgroundColor = cycle?[UIColor redColor]:[UIColor blueColor];
            }];
            break;
        }
        default: // This case should never happen because there is only 3 segments
        {
            self.flasher = nil;
            break;
        }
    }
    // Starts animation
    self.flasher.flashing = YES;
}

@end
