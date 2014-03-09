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
    
    NSTimeInterval _timerLengths[100];
    
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

- (void)addTime:(double)timeInterval {
    
    if (_mode != kInterval) {
        _timerLengths[0] = timeInterval;
        _mode = kTimer;
        _startDate = [[NSDate date] dateByAddingTimeInterval:_timerLengths[0]];
        _stopDate = [NSDate date];
        
        [self update];
        [_viewController updateButtons];
    }
    
}

- (void)cancel {
    _state = kStopped;
    
    [_displayLink removeFromRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
    
    if (_mode != kStopwatch) {
        [self addTime:_timerLengths[0]];
    }
    
    [_viewController updateButtons];
}

- (void)pause {
    _state = kPaused;
    
    _stopDate = [NSDate date];
    
    [_displayLink removeFromRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
    
    [_viewController updateButtons];
}

- (void)reset {
    _state = kStopped;
    _mode = kStopwatch;
    
    _startDate = [NSDate date];
    _stopDate = nil;
    [self update];
    
    [_viewController updateButtons];
}

- (void)start {
    
    //If the timer was paused, see how long it has been paused
    //then add that time to the _startDate to offset the time it was paused.
    if (nil != _stopDate) {

        //timeIntervalSinceNow returns a negative number so we invert it.
        NSTimeInterval pauseTime = [_stopDate timeIntervalSinceNow] * -1;

        _startDate = [_startDate dateByAddingTimeInterval:pauseTime];
        _stopDate = nil;
        
    } else {
        _startDate = [NSDate date];
    }
    
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
        
        if (_elapsedTime <= 0) {
            [self cancel];
            _elapsedTime = 0;
            
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Time's up!" message:@"" delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:@"Restart", nil];
            [alertView show];
        }
    }
    
    NSString *_formattedString = [_dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:_elapsedTime]];    
    [_viewController updateCounter:_formattedString];
}

#pragma mark - UIAlertView delegate methods

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    NSString *buttonTitle = [alertView buttonTitleAtIndex:buttonIndex];
    
    if ([buttonTitle isEqualToString:@"Restart"]) {
        [self start];
    } else {
        [self reset];
    }
    
}

#pragma mark - UITableView delegate methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 3;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return [[UITableViewCell alloc] init];
}

@end
