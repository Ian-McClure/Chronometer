//
//  CustomKeyboard.m
//  Chronometer
//
//  Created by Matthew Breton on 2/21/14.
//
//

#import "CustomKeyboard.h"

@interface CustomKeyboard () {
    UIView *_numberPad;
    UIView *_preset;
}

@end

@implementation CustomKeyboard

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self BuildNumberPad];
        [self BuildPreset];
    }
    return self;
}

- (void) BuildNumberPad {
    int values[12] = {0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11};
    
    for (int i = 0; i < 24; i++) {
        //due stuff
    }
}

- (void) BuildPreset {
    int values[24] = {10, 15, 30, 45, 60, 90, 120, 180, 300, 420, 600, 900, 1200, 1500, 1800, 2400, 2700, 3000, 3600, 5400, 7200, 9000, 10800, 18000};
    
    for (int i = 0; i < 12; i++) {
        //due stuff
    }
}

@end
