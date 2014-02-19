//
//  ViewController.h
//  Chronometer
//
//  Created by Matthew Breton & Ian McClure on 2/14/14.
//
//

#import <UIKit/UIKit.h>

@class Chronometer;

@interface ViewController : UIViewController

- (void)updateCounter:(NSString *)timeInterval;
- (void)updateButtons;

@end
