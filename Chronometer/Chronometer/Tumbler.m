//
//  Tumbler.m
//  Chronometer
//
//  Created by Matthew Breton & Ian McClure on 2/14/14.
//
//

#import "Tumbler.h"
#import "ViewController.h"
#import "ImageCache.h"

#define kTop YES
#define kBottom NO

@interface Tumbler () {
    Digit _digit;
    Place _place;
    ViewController *_viewController;
    UIImageView *_topImage;
    UIImageView *_bottomImage;
}

@end

@implementation Tumbler

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _digit = kZero;
        _place = k1sec;
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame Digit:(Digit)d Place:(Place)p ViewController:(ViewController*)v {
    if(self = [super initWithFrame:frame]){
        _digit = d;
        _place = p;
        _viewController = v;
        _topImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 4, 42, 33)];
        [_topImage setImage:[[ImageCache sharedImageCache] imageForTumbler:d half:kTop place:p]];
        
        _bottomImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 38, 42, 33)];
        [_bottomImage setImage:[[ImageCache sharedImageCache] imageForTumbler:d half:kBottom place:p]];
        
        [self addSubview:_topImage];
        [self addSubview:_bottomImage];
    }
    return self;
}

- (void)increment {
    if (_digit == kNine) {
        _digit = kZero;
        [_viewController updateNextPlace:_place];
    } else {
        _digit++;
    }
}

- (void)decrement {
    if (_digit == kZero) {
        _digit = kNine;
        [_viewController updatePreviousPlace:_place];
    } else {
        _digit--;
    }
}

- (void)updateDigit:(Digit)d {
    _digit = d;
}

- (void)animation:(Digit)d {
    //animate the tumbler flipping to Digit d.
    //flips the tumbler up or down depending on if the number is getting larger or smaller.
    //might need to make three functions for each of increment, decrement, and updateDigit.
}


@end
