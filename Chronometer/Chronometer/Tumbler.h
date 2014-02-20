//
//  Tumbler.h
//  Chronometer
//
//  Created by Matthew Breton & Ian McClure on 2/14/14.
//
//

#import <UIKit/UIKit.h>
@class ViewController;

typedef enum {
    kZero, kOne, kTwo, kThree, kFour, kFive, kSix, kSeven, kEight , kNine
} Digit;

typedef enum {
    k10hour, k1hour, k10min, k1min, k10sec, k1sec
} Place;

@interface Tumbler : UIView
@property Digit digit;
@property Place place;

- (id)initWithFrame:(CGRect)frame;
- (id)initWithFrame:(CGRect)frame Digit:(Digit)d Place:(Place)p ViewController:(ViewController*)v;
- (void)increment;
- (void)decrement;
- (void)updateDigit:(Digit)d;
- (void)animation:(Digit)d;

@end
