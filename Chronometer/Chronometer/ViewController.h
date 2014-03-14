//
//  ViewController.h
//  Chronometer
//
//  Created by Matthew Breton & Ian McClure on 2/14/14.
//
//

#import <UIKit/UIKit.h>
#import "Tumbler.h"

@class Chronometer;

typedef enum {
    kInteractiveTimer,
    kSimpleTimer
}timerStyle;

@interface ViewController : UIViewController

@property timerStyle counterStyle;

- (void)presetButtonPressed:(id)sender;

- (void)updateCounter:(NSString *)timeInterval;
- (void)updateButtons;
- (void)updateNextPlace:(Place)p;
- (void)updatePreviousPlace:(Place)p;

- (void)updateTimeButton:(NSTimeInterval)interval;

@end
