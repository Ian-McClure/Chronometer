//
//  ViewController.m
//  Chronometer
//
//  Created by Ian McClure on 2/14/14.
//
//

#import "ViewController.h"

@interface ViewController () {

    CGSize _screenSize;
    
    //Use two button that change their function instead of 5 different buttons?
    UIButton *_leftButton,
             *_rightButton;
    
    UILabel *_ChronometerLabel;
    
}
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _screenSize = [UIScreen mainScreen].bounds.size;
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    //UIlabel is a UIView with text. This will be the visual representation for our timer.
    _ChronometerLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, _screenSize.height/2 -64, 300, 128)];
    [_ChronometerLabel setFont:[UIFont fontWithName:@"Superclarendon-Regular" size:72]];
    [_ChronometerLabel setTextAlignment:NSTextAlignmentLeft];
    [_ChronometerLabel setTextColor:[UIColor blackColor]];
    
    //The label won't draw unless it is added to the ViewController's view.
    [self.view addSubview:_ChronometerLabel];
    
}

//not sure what to call this method.
//Updates the Chronometer's view to show the correct timeInterval.
- (void)updateCounter:(NSString *)timeInterval {
    
}

//Handles what happens when the left button was tapped.
- (void)leftButtonTapped {
    
}

//Handles what happens when the right button was tapped.
- (void)rightButtonTapped {
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
