//
//  ViewController.m
//  Chronometer
//
//  Created by Matthew Breton & Ian McClure on 2/14/14.
//
//

/***********************************************
 Bug list!
 
 ***********************************************
 Intentional bugs! er.. features!

 */

#import "ViewController.h"
#import "Chronometer.h"
#import "CustomKeyboard.h"

#define AppWhiteColor [UIColor colorWithRed:.949 green:.945 blue:.968 alpha:1]
#define AppGreyColor [UIColor colorWithRed:.498 green:.494 blue:.517 alpha:1]

@interface ViewController () {
    
    bool atTop;
    
    CGSize _screenSize;
    
    Chronometer *_chronometer;
    
    CustomKeyboard *_keyboard;
    
    NSString *_customTime;
    
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

- (void)buildButtons;
- (void)buildCounter;
- (void)buildSettingsView;
- (void)buildTimerView;

- (void)animateButtonTransitionWithDirection:(int)direction;
- (void)animateTimerViewDown;
- (void)animateTimerViewUp;
- (void)autocompletePanGestureMovement:(CGPoint)translation;
- (void)callKeyboard;
- (UIButton *)createButtonAtLocation:(CGPoint)location withTag:(uint)tag;
- (void)handlePanGesture:(UIPanGestureRecognizer *)gesture;
- (void)leftButtonTapped;
- (void)numberPadButtonPressed:(id)sender;
- (void)presetButtonPressed:(id)sender;
- (void)rightButtonTapped;
- (void)updateButtons;
- (void)updateCounter:(NSString *)timeInterval;
- (void)updateNextPlace:(Place)p;
- (void)updatePreviousPlace:(Place)p;
- (void)updateTimeButton:(NSTimeInterval)interval;

@end

#pragma mark -
@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _screenSize = [UIScreen mainScreen].bounds.size;
    _counterStyle = kSimpleTimer;
    
    _chronometer = [[Chronometer alloc] initWithViewController:self];
    
    _customTime = @"";
    
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

#pragma mark - Actions

- (void)acceptCustomTime {

    [_chronometer reset];
    
    NSArray *substrings = [_timeButton.titleLabel.text componentsSeparatedByString:@":"];
    
    double hours = [[substrings objectAtIndex:0] doubleValue]*3600;
    double minutes = [[substrings objectAtIndex:1] doubleValue]*60;
    double seconds = [[substrings objectAtIndex:2] doubleValue];
    
    NSLog(@"%f, %f, %f", hours, minutes, seconds);
    
    if (hours != 0) {
        [_chronometer addTime:hours];
    }
    
    if (minutes != 0) {
        [_chronometer addTime:minutes];
    }
    
    if (seconds != 0) {
        [_chronometer addTime:seconds];
    }
    
    _customTime = @"";
    //[self updateTimeButtonTitle];
}

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

//not sure what to call this method.
//Updates the Chronometer's view to show the correct timeInterval.
- (void)updateCounter:(NSString *)timeInterval {
    
    [_ChronometerLabel setText:timeInterval];
    
}

- (void)updateTimeButtonTitle {
    
    NSString *string = @"";
    
    for (int i = 6; i > [_customTime length]; i--) {
        string = [string stringByAppendingString:@"0"];
    }
    
    string = [string stringByAppendingString:_customTime];
    
    if ([string isEqualToString:@"000000"]) {
        string = @"hh:mm:ss";
    } else {
        string = [NSString stringWithFormat:@"%@:%@:%@", [string substringWithRange:NSMakeRange(0, 2)], [string substringWithRange:NSMakeRange(2, 2)], [string substringWithRange:NSMakeRange(4, 2)]];
    }
    
    [_timeButton setTitle:string forState:UIControlStateNormal];
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
    
    _keyboard = [[CustomKeyboard alloc] initWithFrame:CGRectMake(0, _screenSize.height-216, _screenSize.width, 216) viewController:self];
    
    _timeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_timeButton setFrame:CGRectMake(5, 300, 266, 44)];
    [_timeButton setBackgroundColor: AppWhiteColor];
    [_timeButton setTitle:@"hh:mm:ss" forState:UIControlStateNormal];
    [_timeButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_timeButton addTarget:self action:@selector(callKeyboard) forControlEvents:UIControlEventTouchUpInside];
    
    _resetButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_resetButton setFrame:CGRectMake(271, 300, 44, 44)];
    [_resetButton setBackgroundColor:AppWhiteColor];
    [_resetButton setTitle:@"X" forState:UIControlStateNormal];
    [_resetButton addTarget:_chronometer action:@selector(reset) forControlEvents:UIControlEventTouchUpInside];
    [_resetButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    [_settingsView addSubview:_timeButton];
    [_settingsView addSubview:_resetButton];
    [_settingsView addSubview:_keyboard];
}

- (void)buildTimerView {
    
    _timerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _screenSize.width, _screenSize.height)];
    [_timerView setBackgroundColor: AppWhiteColor];
    
}

#pragma mark - Button Methods

//for direction 1 represent out and 0 represents in for the right button.
- (void)animateButtonTransitionWithDirection:(int)direction {
    if (direction == 1) {
        [UIView animateWithDuration:0.25 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            _leftButton.frame = CGRectMake(_leftButton.frame.origin.x, _leftButton.frame.origin.y, 320, _leftButton.frame.size.height),
            _leftButton.contentEdgeInsets = UIEdgeInsetsMake(22, 138, 22, 138),
            _rightButton.frame = CGRectMake(320, _rightButton.frame.origin.y, _rightButton.frame.size.width, _rightButton.frame.size.height);
        } completion:^(BOOL finished) {
            if (_chronometer.mode == kStopwatch) {
                [_rightButton setImage:[UIImage imageNamed:@"pauseup.png"] forState:UIControlStateNormal];
                [_rightButton setImage:[UIImage imageNamed:@"pausedown.png"] forState:UIControlStateHighlighted];
            } else {
                [_rightButton setImage:[UIImage imageNamed:@"cancelup.png"] forState:UIControlStateNormal];
                [_rightButton setImage:[UIImage imageNamed:@"canceldown.png"] forState:UIControlStateHighlighted];
            }
        }];
    } else {
        
        if (_chronometer.mode != kStopwatch) {
            [_rightButton setImage:[UIImage imageNamed:@"resetup.png"] forState:UIControlStateNormal];
            [_rightButton setImage:[UIImage imageNamed:@"resetdown.png"] forState:UIControlStateHighlighted];
        }
        
        [UIView animateWithDuration:0.25 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            _leftButton.frame = CGRectMake(_leftButton.frame.origin.x, _leftButton.frame.origin.y, 160, _leftButton.frame.size.height),
            _leftButton.contentEdgeInsets = UIEdgeInsetsMake(22, 58, 22, 58),
            _rightButton.frame = CGRectMake(160, _rightButton.frame.origin.y, _rightButton.frame.size.width, _rightButton.frame.size.height);
        } completion:^(BOOL finished) {
            if (_chronometer.mode == kStopwatch) {
                [_rightButton setImage:[UIImage imageNamed:@"pauseup.png"] forState:UIControlStateNormal];
                [_rightButton setImage:[UIImage imageNamed:@"pausedown.png"] forState:UIControlStateHighlighted];
            }
        }];
    }
}

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

//tag 10 == Accept; tag 11 == Delete;
- (void)numberPadButtonPressed:(id)sender {
    
    UIButton *object = (UIButton *)sender;
    int value = (int)[object tag];
    
    switch (value) {
        case 11:
            if ([_customTime length] > 0) {
                _customTime = [_customTime substringToIndex:[_customTime length]-1];
                [self updateTimeButtonTitle];
            } else {
                [_timeButton setTitle:@"hh:mm:ss" forState:UIControlStateNormal];
            }
            break;
        case 10:
            [self acceptCustomTime];
            break;
        default:
            
            if ([_customTime isEqualToString:@"0"]) {
                _customTime = @"";
            }
            
            if ([_customTime length] < 6) {
                _customTime = [_customTime stringByAppendingString:[NSString stringWithFormat:@"%d", value]];
            }
                
            [self updateTimeButtonTitle];
            break;
    }
}

- (void)presetButtonPressed:(id)sender {
    UIButton *object = (UIButton *)sender;
    double value = [object tag];
    
    if (_chronometer.state == kStopped) {
        [_chronometer setTime:value];
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
        if (_chronometer.state == kRunning) {
            [_chronometer cancel];
        } else {
            [_chronometer reset];
        }
    }
}

//Called by _chronometer to update the images of the buttons to match the state of the Chronometer.
- (void)updateButtons {
    
    if (_chronometer.mode == kStopwatch) {
        if (_chronometer.state == kRunning) {
            [_leftButton setImage:[UIImage imageNamed:@"newlapup.png"] forState:UIControlStateNormal];
            [_leftButton setImage:[UIImage imageNamed:@"newlapdown.png"] forState:UIControlStateHighlighted];
            
            if (_rightButton.frame.origin.x != 160) {
                [self animateButtonTransitionWithDirection:0];
            } else {
                [_rightButton setImage:[UIImage imageNamed:@"pauseup.png"] forState:UIControlStateNormal];
                [_rightButton setImage:[UIImage imageNamed:@"pausedown.png"] forState:UIControlStateHighlighted];
            }
            
            
        } else if (_chronometer.state == kPaused) {
            [_leftButton setImage:[UIImage imageNamed:@"startup.png"] forState:UIControlStateNormal];
            [_leftButton setImage:[UIImage imageNamed:@"startdown.png"] forState:UIControlStateHighlighted];
            
            if (_rightButton.frame.origin.x != 160) {
                [self animateButtonTransitionWithDirection:0];
            } else {
                [_rightButton setImage:[UIImage imageNamed:@"resetup.png"] forState:UIControlStateNormal];
                [_rightButton setImage:[UIImage imageNamed:@"resetdown.png"] forState:UIControlStateHighlighted];
            }
            
        } else { //kStopped
            [_leftButton setImage:[UIImage imageNamed:@"startup.png"] forState:UIControlStateNormal];
            [_leftButton setImage:[UIImage imageNamed:@"startdown.png"] forState:UIControlStateHighlighted];
            
            if (_rightButton.frame.origin.x != 320) {
                [self animateButtonTransitionWithDirection:1];
            } else {
                [_rightButton setImage:[UIImage imageNamed:@"pauseup.png"] forState:UIControlStateNormal];
                [_rightButton setImage:[UIImage imageNamed:@"pausedown.png"] forState:UIControlStateHighlighted];
            }
        }
    } else {
        if (_chronometer.state == kRunning) {
            [_leftButton setImage:[UIImage imageNamed:@"pauseup.png"] forState:UIControlStateNormal];
            [_leftButton setImage:[UIImage imageNamed:@"pausedown.png"] forState:UIControlStateHighlighted];
            
            if (_rightButton.frame.origin.x != 160) {
                [self animateButtonTransitionWithDirection:0];
            } else {
                [_rightButton setImage:[UIImage imageNamed:@"cancelup.png"] forState:UIControlStateNormal];
                [_rightButton setImage:[UIImage imageNamed:@"canceldown.png"] forState:UIControlStateHighlighted];
            }
            
        } else if (_chronometer.state == kPaused) {
            [_leftButton setImage:[UIImage imageNamed:@"startup.png"] forState:UIControlStateNormal];
            [_leftButton setImage:[UIImage imageNamed:@"startdown.png"] forState:UIControlStateHighlighted];
            
            if (_rightButton.frame.origin.x != 160) {
                [self animateButtonTransitionWithDirection:0];
            } else {
                [_rightButton setImage:[UIImage imageNamed:@"resetup.png"] forState:UIControlStateNormal];
                [_rightButton setImage:[UIImage imageNamed:@"resetdown.png"] forState:UIControlStateHighlighted];
            }
            
        } else { //kStopped
            [_leftButton setImage:[UIImage imageNamed:@"startup.png"] forState:UIControlStateNormal];
            [_leftButton setImage:[UIImage imageNamed:@"startdown.png"] forState:UIControlStateHighlighted];
            
            if (_rightButton.frame.origin.x != 320) {
                [self animateButtonTransitionWithDirection:1];
            } else {
                [_rightButton setImage:[UIImage imageNamed:@"resetup.png"] forState:UIControlStateNormal];
                [_rightButton setImage:[UIImage imageNamed:@"resetdown.png"] forState:UIControlStateHighlighted];
            }
        }
    }
}

- (void)updateTimeButton:(NSTimeInterval)interval {
    [_timeButton setTitle:[NSString stringWithFormat:@"%f", interval] forState:UIControlStateNormal];
}

#pragma mark - Touch Methods

- (void)animateTimerViewDown {
    [UIView animateWithDuration:0.25 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        _timerView.center = CGPointMake(_screenSize.width/2, _screenSize.height/2);
    } completion:NO];
    atTop = NO;
}

- (void)animateTimerViewUp {
    [UIView animateWithDuration:0.25 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        _timerView.center = CGPointMake(_screenSize.width/2, 0);
    } completion:NO];
    atTop = YES;
}

- (void)autocompletePanGestureMovement:(CGPoint)translation {
    
    if (translation.y < 0) {
        if (_timerView.center.y < _screenSize.height * 0.40) {
            [self animateTimerViewUp];
        } else {
            [self animateTimerViewDown];
        }
    } else {
        if (_timerView.center.y > _screenSize.height * 0.10) {
            [self animateTimerViewDown];
        } else {
            [self animateTimerViewUp];
        }
    }
}

- (void)handlePanGesture:(UIPanGestureRecognizer *)gesture {
    
    CGPoint translation = [gesture translationInView:self.view];
    
    if (atTop == YES) {
        [_timerView setCenter:CGPointMake(_timerView.center.x, 0 + translation.y)];
    } else {
        [_timerView setCenter:CGPointMake(_timerView.center.x, _screenSize.height/2 + translation.y)];
    }
    
    if (gesture.state == UIGestureRecognizerStateEnded) {
        [self autocompletePanGestureMovement:translation];
    }
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
