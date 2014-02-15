//
//  Chronometer.m
//  Chronometer
//
//  Created by Matthew Breton & Ian McClure on 2/14/14.
//
//

#import "Chronometer.h"

//A flag to tell Chronometer it is running, stopped or paused; Default is kStopped;
typedef enum {
    kStopped,
    kPaused,
    kRunning
} ChronoState;

//A flag to tell Chronometer it is running as a timer, stopwatch, or Interval Timer; Default is kStopwatch;
typedef enum{
    kStopwatch,
    kTimer,
    kInterval
} ChronoMode;

@interface Chronometer () {
    
    CADisplayLink *_displayLink;
    
    ChronoState _state;
    ChronoMode _mode;
    
    NSDate  *_date,
            *_startDate,
            *_stopDate;
}

- (void)update;

@end

@implementation Chronometer

#pragma mark - Initializers

- (id)init {
    
    if (self = [super init]) {
        
        _mode = kStopwatch;
        _state = kStopped;
        _displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(update)];
        
    }
    
    return self;
}

#pragma mark - Actions

- (void)cancel {
    
    [_displayLink removeFromRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
}

- (void)pause {
    
    _stopDate = [NSDate date];
    _state = kPaused;
    
    [_displayLink removeFromRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
    
}

- (void)reset {
    
    _mode = kStopwatch;
    _state = kStopped;
}

- (void)start {
    
    _startDate = [NSDate date];
    
    //If the timer was paused, see how long it has been paused
    //then add that time to the _startDate to offset the time it was paused;
    if (_mode == kPaused) {
        NSTimeInterval pauseTime = [_stopDate timeIntervalSinceNow];
        _startDate = [_startDate dateByAddingTimeInterval:pauseTime];
    }
    
    //A method that caused update: to be called everytime the screen refreshes;
    [_displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
    
}

#pragma mark - Update

- (void)update {
    
    //Not sure how we are going to update things on the screen.
    //We can add a reference to the ViewController and make the ViewController's UILabel a property so
    //we can access it or add methods to the ViewController to have this function update via that method.
    
    //Better yet, I think we can have the DisplayLink call update: in the ViewController and have it ask this object for the info.    
}

@end
