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
//- (id)init;

- (UIImage *)imageNamed:(NSString *)string;
- (UIImage *)imageForTumbler:(int)digit half:(BOOL)top place:(int)place;

@end
