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

@interface ViewController : UIViewController

- (void)updateCounter:(NSString *)timeInterval;
- (void)updateButtons;
- (void)updateNextPlace:(Place)p;
- (void)updatePreviousPlace:(Place)p;

@end
