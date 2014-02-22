//
//  ImageCache.m
//  Chronometer
//
//  Created by Matthew Breton & Ian McClure on 2/20/14.
//
//

#import "ImageCache.h"

@implementation ImageCache

//Dispatch tokens are markers used by Grand Central Dispatch to ensure that this object is instantiated only once.
//Look up Singletons for more info.

+ (id)sharedImageCache {
    static ImageCache *sharedImageCache = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        sharedImageCache = [[self alloc] init];
    });
    
    return sharedImageCache;
}

- (UIImage *)imageNamed:(NSString *)string {
    
    NSString *tag = [string substringFromIndex:(string.length - 4)];
    string = ([tag isEqualToString:@".png"]) ? string : [string stringByAppendingString:@".png"];

    return [UIImage imageNamed:string];
}

- (UIImage *)imageForTumbler:(int)digit half:(BOOL)top place:(int)place {
    
    NSString *string = [NSString stringWithFormat:@"tumbler%d", digit];

    if (place == 2 || place == 4) {
        string = [string stringByAppendingString:@"rightcolon"];
    } else if (place == 1 || place == 3) {
        string = [string stringByAppendingString:@"leftCcolon"];
    } else {
        string = [string stringByAppendingString:@"nocolon"];
    }
    string = (top) ? [string stringByAppendingString:@"top"] : [string stringByAppendingString:@"bottom"];
    
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    if (orientation == UIInterfaceOrientationLandscapeLeft || orientation == UIInterfaceOrientationLandscapeRight) {
        if ([UIScreen mainScreen].bounds.size.height) {
            string = [string stringByAppendingString:@"568hlandscape"];
        } else {
            string = [string stringByAppendingString:@"landscape"];
        }
    }
    string = [string stringByAppendingString:@".png"];
    
    return [UIImage imageNamed:string];
}

@end
