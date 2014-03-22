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
    
    ViewController *_viewController;
}

@end

@implementation CustomKeyboard

- (id)initWithFrame:(CGRect)frame viewController:(ViewController *)controller {
    
    self = [super initWithFrame:frame];
    
    if (self) {
        
        _viewController = controller;
        
        [self setBackgroundColor:[UIColor colorWithRed:.776 green:.772 blue:.788 alpha:.5]];
        
        _preset = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 216)];
        _numberPad = [[UIView alloc] initWithFrame:CGRectMake(320, 0, 320, 216)];
        
        [self BuildNumberPad];
        [self BuildPreset];
        [self addSubview:_numberPad];
        [self addSubview:_preset];
    }
    return self;
}

- (void)swapKeyboards {
    
}

- (void) BuildNumberPad {
    int values[12] = {1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 0, 11};
    int xPos[3] = {8, 110, 212};
    int yPos[4] = {21, 64, 107, 150};
    
    for (int i = 0; i < 12; i++) {
        CGRect frame = CGRectMake(xPos[i%3], yPos[(i/3)%4], 100, 41);
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setFrame:frame];
        [button setImage:[[ImageCache sharedImageCache] imageForNumberPad:i forPressed:NO] forState:UIControlStateNormal];
        [button setImage:[[ImageCache sharedImageCache] imageForNumberPad:i forPressed:YES] forState:UIControlStateHighlighted];
        [button setTag:values[i]];
        [button addTarget:_viewController action:@selector(numberPadButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        
        [_numberPad addSubview:button];
    }
}

- (void) BuildPreset {
    int values[24] = {2, 15, 30, 45, 60, 90, 120, 180, 300, 420, 600, 900, 1200, 1500, 1800, 2400, 2700, 3000, 3600, 5400, 7200, 9000, 10800, 18000};
    int xPos[6] = {8, 59, 110, 161, 212, 263};
    int yPos[4] = {15, 66, 109, 160};
    
    for (int i = 0; i < 24; i++) {
        
        CGRect frame = CGRectMake(xPos[i%6], yPos[(i/6)%4], 49, 42);
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setFrame:frame];
        [button setImage:[[ImageCache sharedImageCache] imageForPresetButton:i forPressed:NO] forState:UIControlStateNormal];
        [button setImage:[[ImageCache sharedImageCache] imageForPresetButton:i forPressed:YES] forState:UIControlStateHighlighted];
        [button setTag:values[i]];
        [button addTarget:_viewController action:@selector(presetButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        
        [_preset addSubview:button];
    }
}

@end
