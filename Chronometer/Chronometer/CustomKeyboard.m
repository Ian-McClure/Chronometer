//
//  CustomKeyboard.m
//  Chronometer
//
//  Created by Matthew Breton on 2/21/14.
//
//

#import "CustomKeyboard.h"
#import "ImageCache.h"
#import "ViewController.h"

@interface CustomKeyboard () {
    UIView *_numberPad;
    UIView *_preset;
    
    NSMutableArray *_presetButtons;
    
    ViewController *_viewController;
}

@end

@implementation CustomKeyboard

- (id)initWithFrame:(CGRect)frame viewController:(ViewController *)controller {
    
    self = [super initWithFrame:frame];
    
    if (self) {
        
        _viewController = controller;
        
        _presetButtons = [[NSMutableArray alloc] initWithCapacity:24];
        _preset = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 216)];
        
        //[self BuildNumberPad];
        [self BuildPreset];
        [self addSubview:_preset];
    }
    return self;
}

//- (void) BuildNumberPad {
//    int values[12] = {0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11};
//    
//    for (int i = 0; i < 12; i++) {
//        //due stuff
//    }
//}

- (void) BuildPreset {
    int values[24] = {10, 15, 30, 45, 60, 90, 120, 180, 300, 420, 600, 900, 1200, 1500, 1800, 2400, 2700, 3000, 3600, 5400, 7200, 9000, 10800, 18000};
    int xPos[6] = {8, 59, 110, 161, 212, 263};
    int yPos[4] = {15, 66, 109, 160};
    
    for (int i = 0; i < 24; i++) {
        
        CGRect frame = CGRectMake(xPos[i%6], yPos[(i/6)%4], 49, 42);
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setFrame:frame];
        [button setImage:[[ImageCache sharedImageCache] imageForPresetButton:i forPressed:NO] forState:UIControlStateNormal];
        [button setImage:[[ImageCache sharedImageCache] imageForPresetButton:i forPressed:YES] forState:UIControlStateNormal];
        [button setTag:values[i]];
        [button addTarget:_viewController action:@selector(presetButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        
        [_preset addSubview:button];
    }
}

@end
