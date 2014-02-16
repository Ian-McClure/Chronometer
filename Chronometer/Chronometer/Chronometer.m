//
//  Chronometer.m
//  Chronometer
//
//  Created by Matthew Breton & Ian McClure on 2/14/14.
//
//

#import "Chronometer.h"
#import "ViewController.h"

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

//Private variables and methods are initialized? here.
@interface Chronometer () {
    
    CADisplayLink *_displayLink;
    
    ChronoState _state;
    ChronoMode _mode;
    
    NSDate  *_date,
            *_startDate,
            *_stopDate;
    
    //Creates a string from an NSDate or NSTimeInterval and vice versa.
    NSDateFormatter *_dateFormatter;
    
    //I need a reference to the ViewController so I can send it messages.
    ViewController *_viewController;
}

- (void)update;

@end

@implementation Chronometer

#pragma mark - Initializers

- (id)initWithViewController:(ViewController *)controller {
    
    if (self = [super init]) {
        
        _mode = kStopwatch;
        _state = kStopped;
        _displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(update)];
        _viewController = controller;
        
        _dateFormatter = [[NSDateFormatter alloc] init];
        [_dateFormatter setDateFormat:@"hh:mm:SS.ss"];
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

//This should do all the number calculations and formatting, then tell the view controller to update the timer view.
- (void)update {
    
    //NSTimeInterval _elapsedTime = [_startDate timeIntervalSinceNow];
    
}

@end
