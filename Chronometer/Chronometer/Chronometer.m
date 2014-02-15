//
//  Chronometer.m
//  Chronometer
//
//  Created by Matthew Breton on 2/14/14.
//
//

#import "Chronometer.h"

@interface Chronometer () {
    
    CADisplayLink *_displayLink;
    
}

- (void)update;

@end

@implementation Chronometer

- (id)init {
    
    if (self = [super init]) {
        
        _displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(update)];
        
    }
    
    return self;
}

- (void)update {
    
};

@end
