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
#import "AppDelegate.h"
#import <EventKitUI/EventKitUI.h>

@interface TimersViewController () {
    int hoursInt;
    int minutesInt;
    int secondsInt;
    
    NSString *timerString;
    
    NSDate *pauseStart, *previousFireDate;
    BOOL timerPaused;
    
    NSString *oneDescription;
    EKCalendar *recipeCalendar;
}

@end

@implementation TimersViewController

//Synthesize for getters/setters
@synthesize oneDescriptionLabel, timerOneLabel, onePauseButton, oneCancelButton, oneView;
@synthesize firstTimer, secondTimer, timerDate, countdownSeconds;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //Grab app delegate and set calendar
    self.appDelegate = [[UIApplication sharedApplication] delegate];
    recipeCalendar = self.appDelegate.eventManager.recipeCalendar;
    
    //Set boarders for timer views to match textviews and textfields elsewhere
    [[self.oneView layer] setBorderColor:[[UIColor lightGrayColor] CGColor]];
    [[self.oneView layer] setBorderWidth:0.5];
    [[self.oneView layer] setCornerRadius:7.5];
    
    [[self.twoView layer] setBorderColor:[[UIColor lightGrayColor] CGColor]];
    [[self.twoView layer] setBorderWidth:0.5];
    [[self.twoView layer] setCornerRadius:7.5];
    
    if (oneDescription.length != 0) {
//        oneDescription = @"Description for timer";
        oneDescriptionLabel.text = oneDescription;
    }
    
    //oneView.hidden = YES;
    
//    if ([UIApplication instancesRespondToSelector:@selector(registerUserNotificationSettings:)]) {
//        [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert|UIUserNotificationTypeSound categories:nil]];
//    }
    
    NSString *recipeTitle = @"My Brew Log Test";
    NSInteger testInt = 120;
    NSDate *testDate = [NSDate date];
    testDate = [testDate dateByAddingTimeInterval:testInt];
    
    //[self createCalendarEvent:testDate withTitle:recipeTitle];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)startTimer:(id)sender {
    countdownSeconds = 180;
    firstTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(runTimer) userInfo:nil repeats:YES];
}

-(void)startTimerFromDetails:(NSInteger)time withDetails:(NSString *)description {
    NSLog(@"Timer seconds = %ld", (long)time);
    countdownSeconds = time;
    oneDescription = description;
    if (countdownSeconds <= 86340) {
        if (firstTimer == nil) {
//            oneView.hidden = NO;
            //oneDescriptionLabel.text = oneDescription;
            firstTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(runTimer) userInfo:nil repeats:YES];
            
            //Pass timer to app delegate to be invalidated and start local notification when app is backgrounded
            self.appDelegate.firstTimer = firstTimer;
            
            timerDate = [NSDate date];
            timerDate = [timerDate dateByAddingTimeInterval:countdownSeconds];
            //[self startLocalNotification:timerDate];
        } else if (secondTimer == nil) {
            //Second timer
            NSLog(@"Second timer");
        }

    } else {
        NSLog(@"Over 23:59");
        NSDate *calDate = [NSDate date];
        calDate = [calDate dateByAddingTimeInterval:countdownSeconds];
        [self createCalendarEvent:calDate withTitle:description];
        
    }
}

-(void)createCalendarEvent:(NSDate *)eventDate withTitle:(NSString *)title {
    if (title.length == 0) {
        title = @"My Brew Log Event. No Title";
    }
    
    recipeCalendar = self.appDelegate.eventManager.recipeCalendar;
    
    //Create the event, set title and calendar
    EKEvent *recipeEvent = [EKEvent eventWithEventStore:self.appDelegate.eventManager.eventStore];
    recipeEvent.title = title;
    recipeEvent.calendar = self.appDelegate.eventManager.recipeCalendar;
    
    //Set start/end date, which is set to 1 hour
    NSDate *endDate = [eventDate dateByAddingTimeInterval:3600];
    recipeEvent.startDate = eventDate;
    recipeEvent.endDate = endDate;
    [recipeEvent addAlarm:[EKAlarm alarmWithAbsoluteDate:eventDate]];
    
    //Make sure calendar exists and save event if it does
    if (recipeCalendar != nil) {
        // Save and commit the event.
        NSError *error;
        if ([self.appDelegate.eventManager.eventStore saveEvent:recipeEvent span:EKSpanFutureEvents commit:YES error:&error]) {
            NSLog(@"Event saved successfully");
        } else {
            // An error occurred, so log the error description.
            NSLog(@"%@", [error localizedDescription]);
        }
    } else {
        NSLog(@"Calendar doesn't exist");
    }
}

-(void)runTimer {
    countdownSeconds = countdownSeconds - 1;
    
    //Calculate hours/minutes/seconds from countdownSeconds
    secondsInt = countdownSeconds % 60;
    minutesInt = (countdownSeconds / 60) % 60;
    hoursInt = (countdownSeconds / 3600) % 24;
    //Display timer
//    NSString *timerString = [NSString stringWithFormat:@"%.2d:%.2d:%.2d left", hoursInt, minutesInt, secondsInt];
    
    if (hoursInt < 1) {
        timerString = [NSString stringWithFormat:@"%.2d:%.2d left", minutesInt, secondsInt];
    } else {
        if (hoursInt < 10) {
            timerString = [NSString stringWithFormat:@"%.1d:%.2d:%.2d left", hoursInt, minutesInt, secondsInt];
        } else {
            timerString = [NSString stringWithFormat:@"%.2d:%.2d:%.2d left", hoursInt, minutesInt, secondsInt];
        }
    }
    
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
    float pauseTime = -1 * [pauseStart timeIntervalSinceNow];
    [timer setFireDate:[previousFireDate initWithTimeInterval:pauseTime sinceDate:previousFireDate]];
    timerPaused = NO;
}

-(IBAction)pauseClicked:(id)sender {
    if (!timerPaused) {
        [self pauseTimer:firstTimer];
        [onePauseButton setTitle:@"Start" forState:UIControlStateNormal];
    } else {
        [self resumeTimer:firstTimer];
        [onePauseButton setTitle:@"Pause" forState:UIControlStateNormal];
    }
}

-(IBAction)cancelClicked:(id)sender {
    [firstTimer invalidate];
    firstTimer = nil;
    timerOneLabel.text = @"00:00";
}

-(void)startLocalNotification:(NSDate *)fire {
    UILocalNotification *localNotification = [[UILocalNotification alloc] init];
    localNotification.fireDate = fire;
    localNotification.alertBody = [NSString stringWithFormat:@"Alert for %@", oneDescription];
    localNotification.soundName = UILocalNotificationDefaultSoundName;
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
    NSLog(@"Local notifiaction started");
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
