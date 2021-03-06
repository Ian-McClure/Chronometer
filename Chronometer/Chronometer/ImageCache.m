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

    return [UIImage imageNamed:string];
}

- (UIImage *)imageForTumbler:(int)digit half:(BOOL)top place:(int)place {
    
    NSString *string = [NSString stringWithFormat:@"tumbler%d", digit];

    if (place == 5 || place == 3) {
        string = [string stringByAppendingString:@"rightcolon"];
    } else if (place == 4 || place == 2) {
        string = [string stringByAppendingString:@"leftcolon"];
    } else {
        string = [string stringByAppendingString:@"nocolon"];
    }
    string = (top) ? [string stringByAppendingString:@"top"] : [string stringByAppendingString:@"bottom"];
    
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    
    if (orientation == UIInterfaceOrientationLandscapeLeft || orientation == UIInterfaceOrientationLandscapeRight) {
            string = [string stringByAppendingString:@"landscape"];
    }
        
    return [UIImage imageNamed:string];
}

- (UIImage *)imageForPresetButton:(int)buttonNumber forPressed:(BOOL)pressed {
    
    NSString *string = [NSString stringWithFormat:@"presetbutton%d", buttonNumber];
    string = (pressed) ? [string stringByAppendingString:@"down"] : [string stringByAppendingString:@"up"];
    
    return [UIImage imageNamed:string];
}

- (UIImage *)imageForNumberPad:(int)buttonNumber forPressed:(BOOL)pressed {
    
    NSString *string = [NSString stringWithFormat:@"numberpad%d", buttonNumber];
    string = (pressed) ? [string stringByAppendingString:@"down"] : [string stringByAppendingString:@"up"];
    
    return [UIImage imageNamed:string];
}

@end
