//
//  Chronometer.m
//  Chronometer
//
//  Created by Matthew Breton & Ian McClure on 2/14/14.
//
//

#import "Chronometer.h"
#import "ViewController.h"

//Private variables and methods are initialized? here.
@interface Chronometer () {
    
    CADisplayLink *_displayLink;
    
    NSDate  *_startDate,
            *_stopDate;
    
    //Creates a string from an NSDate or NSTimeInterval and vice versa.
    NSDateFormatter *_dateFormatter;
    
    NSMutableArray *_lapTimes;
    
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
        [_dateFormatter setDateFormat:@"HH:mm:ss.SS"];
        [_dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
        _lapTimes = [[NSMutableArray alloc] initWithCapacity:104];
    }
    
    return self;
}

//With the Chronometer actions, always call the ViewController's updateButtons: last.
#pragma mark - Actions

- (void)addLap {
    
    NSLog(@"A new lap time will have been added.");
    
    [_viewController updateButtons];
}

- (void)cancel {
    
    [_displayLink removeFromRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
    
    [_viewController updateButtons];
}

- (void)pause {
    
    _stopDate = [NSDate date];
    _state = kPaused;
    
    [_displayLink removeFromRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
    
    [_viewController updateButtons];
}

- (void)reset {
    
    //[_displayLink removeFromRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
    
    _mode = kStopwatch;
    _state = kStopped;
    
    _startDate = [NSDate date];
    //_stopDate = nil;
    [self update];
    
    [_viewController updateButtons];
}

- (void)start {
    
    NSLog(@"_startDate is: %@", _startDate);
    NSLog(@"_stopDate is: %@", _stopDate);
    
    //If the timer was paused, see how long it has been paused
    //then add that time to the _startDate to offset the time it was paused;
    if (_state == kPaused) {
        NSLog(@"got here");
        //timeIntervalSinceNow returns a negative number so we invert it.
        NSTimeInterval pauseTime = [_stopDate timeIntervalSinceNow] * -1;
        NSLog(@"%f", pauseTime);
        _startDate = [_startDate dateByAddingTimeInterval:pauseTime];
        //_stopDate = nil;
    } else {
        _startDate = [NSDate date];
    }
    
    //A method that caused update: to be called everytime the screen refreshes;
    _displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(update)];
    [_displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
    _state = kRunning;
    
    [_viewController updateButtons];
}

#pragma mark - Update

//This should do all the number calculations and formatting, then tell the view controller to update the timer view.
- (void)update {
    
    NSTimeInterval _elapsedTime;
    
    if (_mode == kStopwatch) {
        _elapsedTime = [[NSDate date] timeIntervalSinceDate:_startDate];
    } else {
        _elapsedTime = [_startDate timeIntervalSinceNow];
    }
    
    NSString *_formattedString = [_dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:_elapsedTime]];
    //NSLog(_formattedString);
    
    [_viewController updateCounter:_formattedString];
}

@end
