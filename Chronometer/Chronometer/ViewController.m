//
//  ViewController.m
//  Chronometer
//
//  Created by Matthew Breton & Ian McClure on 2/14/14.
//
//

#import "ViewController.h"
#import "Chronometer.h"
#import "CustomKeyboard.h"

@interface ViewController () {

    CGSize _screenSize;
    
    Chronometer *_chronometer;
    
    CustomKeyboard *_keyboard;
    
    //Use two button that change their function instead of 5 different buttons?
    UIButton *_leftButton,
             *_rightButton;
    
    UILabel *_ChronometerLabel;
    
    UIView *_timerView,
           *_settingsView;
    
    NSMutableArray *_tumblers;
    
}
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _screenSize = [UIScreen mainScreen].bounds.size;
    
    _timerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _screenSize.width, _screenSize.height)];
    [_timerView setBackgroundColor:[UIColor colorWithRed:.949 green:.945 blue:.968 alpha:1]];
    _settingsView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _screenSize.width, _screenSize.height)];
    [_settingsView setBackgroundColor:[UIColor colorWithRed:.498 green:.494 blue:.517 alpha:1]];
    
    _keyboard = [[CustomKeyboard alloc] initWithFrame:CGRectMake(0, _screenSize.height - 216, _screenSize.width, 216)];
    [_keyboard setBackgroundColor:[UIColor colorWithRed:.776 green:.772 blue:.788 alpha:.5]];
    
    _tumblers = [[NSMutableArray alloc] initWithCapacity:6];
    
    for (int i = 0; i <= 5; i++) {
        //CGRectZero needs to be replaced!!!!!!
        Tumbler *t = [[Tumbler alloc] initWithFrame:CGRectZero Digit:kZero Place:(6-i) ViewController:self];
        [_tumblers addObject:t];
    }
    
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
    [self.view addSubview:_settingsView];
    [self.view addSubview:_timerView];
    [_timerView addSubview:_ChronometerLabel];
    [_timerView addSubview:_leftButton];
    [_timerView addSubview:_rightButton];
    [_settingsView addSubview:_keyboard];
    
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
