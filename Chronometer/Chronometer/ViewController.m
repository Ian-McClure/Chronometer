//
//  ViewController.m
//  Chronometer
//
//  Created by Matthew Breton & Ian McClure on 2/14/14.
//
//  Buttons in timer mode don't work.  Preset buttons don't draw on device.

#import "ViewController.h"
#import "Chronometer.h"
#import "CustomKeyboard.h"

#define AppWhiteColor [UIColor colorWithRed:.949 green:.945 blue:.968 alpha:1]
#define AppGreyColor [UIColor colorWithRed:.498 green:.494 blue:.517 alpha:1]

@interface ViewController () {

    CGSize _screenSize;
    
    Chronometer *_chronometer;
    
    CustomKeyboard *_keyboard;
    
    UIButton *_leftButton,
             *_rightButton,
             *_resetButton,
             *_timeButton;
    
    UILabel *_ChronometerLabel;
    
    UIView *_timerView,
           *_settingsView,
           *_tumblerView;
    
    NSMutableArray *_tumblers;
    
}

- (void)animateButtonTransition:(uint)direction;
- (void)updateNextPlace:(Place)p;
- (void)updatePreviousPlace:(Place)p;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _screenSize = [UIScreen mainScreen].bounds.size;
    _counterStyle = kSimpleTimer;
    
    _chronometer = [[Chronometer alloc] initWithViewController:self];
    
    UIPanGestureRecognizer *panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGesture:)];
    [self.view addGestureRecognizer:panRecognizer];
    
    [self buildTimerView];
    [self buildSettingsView];
    
    [self buildCounter];
    [self buildButtons];
    
    
    //Objects won't draw unless they are added to the ViewController's view.
    [self.view addSubview:_settingsView];
    [self.view addSubview:_timerView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//not sure what to call this method.
//Updates the Chronometer's view to show the correct timeInterval.
- (void)updateCounter:(NSString *)timeInterval {
    
    [_ChronometerLabel setText:timeInterval];
    
}

#pragma mark - Actions

- (void)callKeyboard {
    
//    if (nil == _keyboard) {
//        _keyboard = [[CustomKeyboard alloc] initWithFrame:CGRectMake(0, _screenSize.height, _screenSize.width, 216) viewController:self];
//    }
    
    if (_keyboard.center.y > 568) {
        [UIView animateWithDuration:0.25 delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            _keyboard.center = CGPointMake(_screenSize.width/2, _screenSize.height - 108);
        } completion:NO];
    } else {
        [UIView animateWithDuration:0.25 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
            _keyboard.center = CGPointMake(_screenSize.width/2, _screenSize.height + 108);
        } completion:NO];
    }
    
}

#pragma mark - Builder methods

- (void)buildButtons {
    _leftButton = [self createButtonAtLocation:CGPointMake(0, _screenSize.height * 0.75) withTag:0];
    [_leftButton addTarget:self action:@selector(leftButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    
    _rightButton = [self createButtonAtLocation:CGPointMake(320, _screenSize.height * 0.75)withTag:1];
    [_rightButton addTarget:self action:@selector(rightButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    
    [_timerView addSubview:_leftButton];
    [_timerView addSubview:_rightButton];
}

//Builds the visual representation of the timer.
- (void)buildCounter {
    if (_counterStyle == kSimpleTimer) {
        

        _ChronometerLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, _screenSize.height/2 -64, 300, 128)];
        [_ChronometerLabel setFont:[UIFont fontWithName:@"Baskerville" size:60]];
        [_ChronometerLabel setTextAlignment:NSTextAlignmentLeft];
        [_ChronometerLabel setTextColor:[UIColor blackColor]];
        [_ChronometerLabel setText:@"00:00:00.00"];
        [_timerView addSubview:_ChronometerLabel];
        
    } else {
        
        _tumblers = [[NSMutableArray alloc] initWithCapacity:6];
        _tumblerView = [[UIView alloc] initWithFrame:CGRectMake(5, (_screenSize.height/2)-38, 310, 76)];
        
        for (int i = 0; i <= 5; i++) {
            Tumbler *t = [[Tumbler alloc] initWithFrame:CGRectMake(i*43, 0, 42, 76) Digit:kZero Place:(6-i) ViewController:self];
            [_tumblers addObject:t];
            [_tumblerView addSubview:t];
        }
        [_timerView addSubview:_tumblerView];
    }
}

- (void)buildSettingsView {
    
    _settingsView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _screenSize.width, _screenSize.height)];
    [_settingsView setBackgroundColor: AppGreyColor];
    
    _keyboard = [[CustomKeyboard alloc] initWithFrame:CGRectMake(0, _screenSize.height, _screenSize.width, 216) viewController:self];
    
    _timeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_timeButton setFrame:CGRectMake(5, 284, 266, 44)];
    [_timeButton setBackgroundColor: AppWhiteColor];
    [_timeButton setTitle:@"hh:mm:ss" forState:UIControlStateNormal];
    [_timeButton addTarget:self action:@selector(callKeyboard) forControlEvents:UIControlEventTouchUpInside];
    
    _resetButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_resetButton setFrame:CGRectMake(271, 284, 44, 44)];
    [_resetButton setBackgroundColor:AppWhiteColor];
    [_resetButton setTitle:@"X" forState:UIControlStateNormal];
    [_resetButton addTarget:_chronometer action:@selector(reset) forControlEvents:UIControlEventTouchUpInside];
    
    [_settingsView addSubview:_timeButton];
    [_settingsView addSubview:_resetButton];
    [_settingsView addSubview:_keyboard];
}

- (void)buildTimerView {
    
    _timerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _screenSize.width, _screenSize.height)];
    [_timerView setBackgroundColor: AppWhiteColor];
    
}

#pragma mark - Button Methods

//Tag 0 represents the left button. Tag 1 represents the right button
- (UIButton *)createButtonAtLocation:(CGPoint)location withTag:(uint)tag {
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTag:tag];
    [button setBackgroundColor:[UIColor clearColor]];

    if (tag == 0) {
        [button setFrame:CGRectMake(location.x, location.y-44, 320, 88)];
        [button setImage:[UIImage imageNamed:@"startup.png"] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"startdown.png"] forState:UIControlStateHighlighted];
        [button setContentEdgeInsets:UIEdgeInsetsMake(22, 138, 22, 138)];

    } else {
        [button setFrame:CGRectMake(location.x, location.y-44, 160, 88)];
        [button setImage:[UIImage imageNamed:@"pauseup.png"] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"pausedown.png"] forState:UIControlStateHighlighted];
        [button setContentEdgeInsets:UIEdgeInsetsMake(22, 58, 22, 58)];

    }
    
    return button;
}

//Called by _chronometer to update the images of the buttons to match the state of the Chronometer.
- (void)updateButtons {
    
    if (_chronometer.mode == kStopwatch) {
        if (_chronometer.state == kRunning) {
            [_leftButton setImage:[UIImage imageNamed:@"newlapup.png"] forState:UIControlStateNormal];
            [_leftButton setImage:[UIImage imageNamed:@"newlapdown.png"] forState:UIControlStateHighlighted];
            
            if (_rightButton.frame.origin.x > 160) {
                [self animateButtonTransition:0];
            } else {
                [_rightButton setImage:[UIImage imageNamed:@"pauseup.png"] forState:UIControlStateNormal];
                [_rightButton setImage:[UIImage imageNamed:@"pausedown.png"] forState:UIControlStateHighlighted];
            }
            
        } else if (_chronometer.state == kPaused) {
            [_leftButton setImage:[UIImage imageNamed:@"startup.png"] forState:UIControlStateNormal];
            [_leftButton setImage:[UIImage imageNamed:@"startdown.png"] forState:UIControlStateHighlighted];
            
            [_rightButton setImage:[UIImage imageNamed:@"resetup.png"] forState:UIControlStateNormal];
            [_rightButton setImage:[UIImage imageNamed:@"resetdown.png"] forState:UIControlStateHighlighted];
            
        } else { //kStopped
            [_leftButton setImage:[UIImage imageNamed:@"startup.png"] forState:UIControlStateNormal];
            [_leftButton setImage:[UIImage imageNamed:@"startdown.png"] forState:UIControlStateHighlighted];
            
            if (_rightButton.frame.origin.x < 320) {
                [self animateButtonTransition:1];
            } else {
                [_rightButton setImage:[UIImage imageNamed:@"pauseup.png"] forState:UIControlStateNormal];
                [_rightButton setImage:[UIImage imageNamed:@"pausedown.png"] forState:UIControlStateHighlighted];
            }
        }
    } else {
        if (_chronometer.mode == kRunning) {
            [_leftButton setImage:[UIImage imageNamed:@"pauseup.png"] forState:UIControlStateNormal];
            [_leftButton setImage:[UIImage imageNamed:@"pausedown.png"] forState:UIControlStateHighlighted];
            
            [_rightButton setImage:[UIImage imageNamed:@"cancelup.png"] forState:UIControlStateNormal];
            [_rightButton setImage:[UIImage imageNamed:@"canceldown.png"] forState:UIControlStateHighlighted];
            
        } else if (_chronometer.mode == kPaused) {
            [_leftButton setImage:[UIImage imageNamed:@"startup.png"] forState:UIControlStateNormal];
            [_leftButton setImage:[UIImage imageNamed:@"startdown.png"] forState:UIControlStateHighlighted];
            
            [_rightButton setImage:[UIImage imageNamed:@"cancelup.png"] forState:UIControlStateNormal];
            [_rightButton setImage:[UIImage imageNamed:@"canceldown.png"] forState:UIControlStateHighlighted];
            
        } else { //kStopped
            [_leftButton setImage:[UIImage imageNamed:@"startup.png"] forState:UIControlStateNormal];
            [_leftButton setImage:[UIImage imageNamed:@"startdown.png"] forState:UIControlStateHighlighted];
            
            [_rightButton setImage:[UIImage imageNamed:@"resetup.png"] forState:UIControlStateNormal];
            [_rightButton setImage:[UIImage imageNamed:@"resetdown.png"] forState:UIControlStateHighlighted];
        }
    }
}

//for direction 1 represent out and 0 represents in for the right button.
- (void)animateButtonTransition:(uint)direction {
    if (direction == 1) {
        [UIView animateWithDuration:0.25 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            _leftButton.frame = CGRectMake(_leftButton.frame.origin.x, _leftButton.frame.origin.y, 320, _leftButton.frame.size.height),
            _leftButton.contentEdgeInsets = UIEdgeInsetsMake(22, 138, 22, 138),
            _rightButton.frame = CGRectMake(320, _rightButton.frame.origin.y, _rightButton.frame.size.width, _rightButton.frame.size.height);
        } completion:^(BOOL finished) {
            [_rightButton setImage:[UIImage imageNamed:@"pauseup.png"] forState:UIControlStateNormal];
            [_rightButton setImage:[UIImage imageNamed:@"pausedown.png"] forState:UIControlStateHighlighted];
        }];
    } else {
        [UIView animateWithDuration:0.25 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            _leftButton.frame = CGRectMake(_leftButton.frame.origin.x, _leftButton.frame.origin.y, 160, _leftButton.frame.size.height),
            _leftButton.contentEdgeInsets = UIEdgeInsetsMake(22, 58, 22, 58),
            _rightButton.frame = CGRectMake(160, _rightButton.frame.origin.y, _rightButton.frame.size.width, _rightButton.frame.size.height);
        } completion:^(BOOL finished) {
            [_rightButton setImage:[UIImage imageNamed:@"pauseup.png"] forState:UIControlStateNormal];
            [_rightButton setImage:[UIImage imageNamed:@"pausedown.png"] forState:UIControlStateHighlighted];
        }];
    }
}

//Handles what happens when the left button was tapped.
- (void)leftButtonTapped {
    NSLog(@"The left button was pressed.");
    if (_chronometer.mode == kStopwatch) {
        if (_chronometer.state == kRunning) {
            [_chronometer addLap];
        } else {
            [_chronometer start];
        }
    } else {
        if (_chronometer.state == kRunning) {
            [_chronometer pause];
        } else {
            [_chronometer start];
        }
    }
}

//Handles what happens when the right button was tapped.
- (void)rightButtonTapped {
    NSLog(@"The right button was pressed.");
    if (_chronometer.mode == kStopwatch) {
        if (_chronometer.state == kPaused) {
            [_chronometer reset];
        } else {
            [_chronometer pause];
        }
    } else {
        if (_chronometer.state == kStopped) {
            [_chronometer reset];
        } else {
            [_chronometer cancel];
        }
    }
}

- (void)presetButtonPressed:(id)sender {
    UIButton *object = (UIButton *)sender;
    double value = object.tag;
    
    if (_chronometer.state == kStopped) {
        [_chronometer addTime:value];
    }
    
}

- (void)updateTimeButton:(NSTimeInterval)interval {
    [_timeButton setTitle:[NSString stringWithFormat:@"%f", interval] forState:UIControlStateNormal];
}

#pragma mark - Touch Methods


- (void)handlePanGesture:(UIPanGestureRecognizer *)gesture {
    
    CGPoint translation = [gesture translationInView:self.view];
    
    [_timerView setCenter:CGPointMake(_timerView.center.x, _screenSize.height/2 + translation.y)];
    
    
    if (gesture.state == UIGestureRecognizerStateEnded) {
        [self autocompletePanGestureMovement:translation];
    }    
}

- (void)autocompletePanGestureMovement:(CGPoint)translation {
    
    if (translation.y < 0) {
        NSLog(@"translation is negative");
        if (_timerView.center.y < _screenSize.height * 0.40) {
            NSLog(@"moving view up");
            [self animateTimerViewUp];
        } else {
            NSLog(@"moving view down");
            [self animateTimerViewDown];
        }
    } else {
        NSLog(@"translation is positive");
        if (_timerView.center.y > _screenSize.height * 0.10) {
            NSLog(@"moving view down");
            [self animateTimerViewDown];
        } else {
            NSLog(@"moving view up");
            [self animateTimerViewUp];
        }
    }
}

- (void)animateTimerViewUp {
    [UIView animateWithDuration:0.25 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        _timerView.center = CGPointMake(_screenSize.width/2, 0);
    } completion:NO];
}

- (void)animateTimerViewDown {
    [UIView animateWithDuration:0.25 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        _timerView.center = CGPointMake(_screenSize.width/2, _screenSize.height/2);
    } completion:NO];
}

#pragma mark - Tumbler Delegate Methods

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

@end
