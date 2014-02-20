//
//  ViewController.m
//  Chronometer
//
//  Created by Matthew Breton & Ian McClure on 2/14/14.
//
//

#import "ViewController.h"
#import "Chronometer.h"

@interface ViewController () {

    CGSize _screenSize;
    
    Chronometer *_chronometer;
    
    //Use two button that change their function instead of 5 different buttons?
    UIButton *_leftButton,
             *_rightButton;
    
    UILabel *_ChronometerLabel;
    
    NSMutableArray *_tumblers;
    
}
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _tumblers = [[NSMutableArray alloc] initWithCapacity:6];
    
    for (int i = 0; i <= 5; i++) {
        //CGRectZero needs to be replaced!!!!!!
        Tumbler *t = [[Tumbler alloc] initWithFrame:CGRectZero Digit:kZero Place:(6-i) ViewController:self];
        [_tumblers addObject:t];
    }
    
    _screenSize = [UIScreen mainScreen].bounds.size;
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    _chronometer = [[Chronometer alloc] initWithViewController:self];
    
    //UIlabel is a UIView with text. This will be the visual representation for our timer.
    _ChronometerLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, _screenSize.height/2 -64, 300, 128)];
    [_ChronometerLabel setFont:[UIFont fontWithName:@"Baskerville" size:60]];
    [_ChronometerLabel setTextAlignment:NSTextAlignmentLeft];
    [_ChronometerLabel setTextColor:[UIColor blackColor]];
    [_ChronometerLabel setText:@"00:00:00.00"];
    
    _leftButton = [self createButtonAtLocation:CGPointMake(0, _screenSize.height * 0.75)];
    [_leftButton addTarget:self action:@selector(leftButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    [_leftButton setTitle:@"Start" forState:UIControlStateNormal];
    
    _rightButton = [self createButtonAtLocation:CGPointMake(160, _screenSize.height * 0.75)];
    [_rightButton addTarget:self action:@selector(rightButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    [_rightButton setTitle:@"Reset" forState:UIControlStateNormal];
    
    //Objects won't draw unless they are added to the ViewController's view.
    [self.view addSubview:_ChronometerLabel];
    [self.view addSubview:_leftButton];
    [self.view addSubview:_rightButton];
    
}

//not sure what to call this method.
//Updates the Chronometer's view to show the correct timeInterval.
- (void)updateCounter:(NSString *)timeInterval {
    
    [_ChronometerLabel setText:timeInterval];
    
}

//Handles what happens when the left button was tapped.
- (void)leftButtonTapped {
    NSLog(@"The left button was pressed.");
    
    [_chronometer start];
}

//Handles what happens when the right button was tapped.
- (void)rightButtonTapped {
    NSLog(@"The right button was pressed.");
    [_chronometer reset];
}

#pragma mark - Button Methods

//This will likely be replaced or ammended when we make the buttons images instead of text.
- (UIButton *)createButtonAtLocation:(CGPoint)location {
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setFrame:CGRectMake(location.x, location.y-44, 160, 88)];
    [button.titleLabel setFont:[UIFont fontWithName:@"Avenir-Black" size:36]];
    [button.titleLabel setTextAlignment:NSTextAlignmentCenter];
    [button setBackgroundColor:[UIColor clearColor]];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    return button;
}

//Called by _chronometer to update the text of the buttons to match the state of the Chronometer.
- (void)updateButtons {
    
}

- (void)updateNextPlace:(Place)p{
    if (p < 5) {
        Tumbler *t = [_tumblers objectAtIndex:p+1];
        [t increment];
    }
}

- (void)updatePreviousPlace:(Place)p{
    if (p > 0) {
        Tumbler *t = [_tumblers objectAtIndex:p-1];
        [t decrement];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
