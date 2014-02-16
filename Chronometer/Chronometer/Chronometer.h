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

//Public variables and methods are initialized? here.
@interface Chronometer : NSObject

- (id)initWithViewController:(ViewController *)controller;

- (void)cancel;
- (void)pause;
- (void)reset;
- (void)start;


@end
