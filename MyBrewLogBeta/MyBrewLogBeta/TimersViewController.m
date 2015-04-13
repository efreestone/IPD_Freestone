// Elijah Freestone
// IPY 1504
// Week 2 - Beta
// April 5th, 2015

//
//  TimersViewController.m
//  MyBrewLogBeta
//
//  Created by Elijah Freestone on 4/5/15.
//  Copyright (c) 2015 Elijah Freestone. All rights reserved.
//

#import "TimersViewController.h"

@interface TimersViewController () {
    NSTimer *firstTimer;
    int hoursInt;
    int minutesInt;
    int secondsInt;
    int countdownSeconds;
    
    NSDate *pauseStart, *previousFireDate;
    BOOL timerPaused;
}

@end

@implementation TimersViewController

//Synthesize for getters/setters
@synthesize oneDescriptionLabel, timerOneLabel, onePauseButton, oneCancelButton;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //Set boarders for timer views to match textviews and textfields elsewhere
    [[self.oneView layer] setBorderColor:[[UIColor lightGrayColor] CGColor]];
    [[self.oneView layer] setBorderWidth:0.5];
    [[self.oneView layer] setCornerRadius:7.5];
    
    [[self.twoView layer] setBorderColor:[[UIColor lightGrayColor] CGColor]];
    [[self.twoView layer] setBorderWidth:0.5];
    [[self.twoView layer] setCornerRadius:7.5];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)startTimer:(id)sender {
    countdownSeconds = 180;
    firstTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(runTimer) userInfo:nil repeats:YES];
}

-(void)runTimer {
    countdownSeconds = countdownSeconds - 1;
    
    minutesInt = countdownSeconds / 60;
    secondsInt = countdownSeconds - (minutesInt * 60);
    
    NSString *timerString = [NSString stringWithFormat:@"%.2d:%.2d left", minutesInt, secondsInt];
    timerOneLabel.text = timerString;
    
    if (countdownSeconds == 0) {
        [firstTimer invalidate];
        firstTimer = nil;
    }
}

-(void)pauseTimer:(NSTimer *)timer {
    pauseStart = [NSDate date];
    previousFireDate = [timer fireDate];
    [timer setFireDate:[NSDate distantFuture]];
    timerPaused = YES;
    //onePauseButton = @"Restart";
}

-(void)resumeTimer:(NSTimer *)timer {
    float pauseTime = -1*[pauseStart timeIntervalSinceNow];
    [timer setFireDate:[previousFireDate initWithTimeInterval:pauseTime sinceDate:previousFireDate]];
    timerPaused = NO;
}

-(IBAction)pauseClicked:(id)sender {
    if (!timerPaused) {
        [self pauseTimer:firstTimer];
    } else {
        [self resumeTimer:firstTimer];
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
