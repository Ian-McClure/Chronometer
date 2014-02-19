//
//  Chronometer.h
//  Chronometer
//
//  Created by Matthew Breton & Ian McClure on 2/14/14.
//
//

#import <Foundation/Foundation.h>

//A blank class so I am not importing the ViewController into this header because I am importing this header into my ViewController. Yo, dawg.
@class ViewController;

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

//Public variables and methods are initialized here.
@interface Chronometer : NSObject

@property ChronoState state;
@property ChronoMode mode;

- (id)initWithViewController:(ViewController *)controller;

- (void)cancel;
- (void)pause;
- (void)reset;
- (void)start;


@end
