//
//  ImageCache.h
//  Chronometer
//
//  Created by Matthew Breton & Ian McClure on 2/20/14.
//
//

#import <Foundation/Foundation.h>

@interface ImageCache : NSObject

+ (id)sharedImageCache;

- (UIImage *)imageNamed:(NSString *)string;
- (UIImage *)imageForTumbler:(int)digit half:(BOOL)top place:(int)place;
- (UIImage *)imageForPresetButton:(int)buttonNumber forPressed:(BOOL)pressed;
- (UIImage *)imageForNumberPad:(int)buttonNumber forPressed:(BOOL)pressed;

@end
