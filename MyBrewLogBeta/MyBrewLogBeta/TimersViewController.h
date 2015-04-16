// Elijah Freestone
// IPY 1504
// Week 2 - Beta
// April 5th, 2015

//
//  TimersViewController.h
//  MyBrewLogBeta
//
//  Created by Elijah Freestone on 4/5/15.
//  Copyright (c) 2015 Elijah Freestone. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface TimersViewController : UIViewController

@property (strong, nonatomic) IBOutlet UIButton *addNewTimerButton;
@property (strong, nonatomic) IBOutlet UIButton *addOverDayButton;

@property (strong, nonatomic) IBOutlet UILabel *timerOneLabel;
@property (strong, nonatomic) IBOutlet UILabel *oneDescriptionLabel;
@property (strong, nonatomic) IBOutlet UILabel *timerTwoLabel;
@property (strong, nonatomic) IBOutlet UILabel *twoDescriptionLabel;
@property (strong, nonatomic) IBOutlet UILabel *timerThreeLabel;
@property (strong, nonatomic) IBOutlet UILabel *threeDescriptionLabel;

@property (strong, nonatomic) IBOutlet UIButton *onePauseButton;
@property (strong, nonatomic) IBOutlet UIButton *oneCancelButton;
@property (strong, nonatomic) IBOutlet UIButton *twoPauseButton;
@property (strong, nonatomic) IBOutlet UIButton *twoCancelButton;
@property (strong, nonatomic) IBOutlet UIButton *threePauseButton;
@property (strong, nonatomic) IBOutlet UIButton *threeCancelButton;

@property (strong, nonatomic) IBOutlet UIView *oneView;
@property (strong, nonatomic) IBOutlet UIView *twoView;

@property (strong, nonatomic) NSTimer *firstTimer;
@property (strong, nonatomic) NSTimer *secondTimer;
@property (strong, nonatomic) NSDate *timerDate;
@property (nonatomic) NSInteger countdownSeconds;

@property (nonatomic) AppDelegate *appDelegate;

-(IBAction)startTimer:(id)sender;
-(void)startTimerFromDetails:(NSInteger)time withDetails:(NSString *)details;
-(void)startLocalNotification:(NSDate *)fire;

@end
