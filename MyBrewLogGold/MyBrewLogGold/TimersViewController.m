// Elijah Freestone
// IPY 1504
// Week 4 - Release Candidate
// April 26th, 2015

//
//  TimersViewController.m
//  MyBrewLogGold
//
//  Created by Elijah Freestone on 4/26/15.
//  Copyright (c) 2015 Elijah Freestone. All rights reserved.
//

#import "TimersViewController.h"
#import "AppDelegate.h"
#import "CustomTimerPickerDelegate.h"
#import "ActionSheetCustomPicker.h"
#import "ActionSheetDatePicker.h"
#import <EventKitUI/EventKitUI.h>

@interface TimersViewController () <UIActionSheetDelegate> {
    int hoursInt;
    int minutesInt;
    int secondsInt;
    
    NSString *timerString;
    NSDate *pauseStart, *previousFireDate;
    BOOL timerPaused;
    
    EKCalendar *recipeCalendar;
    id buttonSender;
}

@end

@implementation TimersViewController

//Synthesize for getters/setters
@synthesize oneDescriptionLabel, timerOneLabel, onePauseButton, oneCancelButton, oneView, oneDescription;
@synthesize twoDescriptionLabel, timerTwoLabel, twoPauseButton, twoCancelButton, twoView, twoDescription;
@synthesize firstTimer, secondTimer, timerDate, timerDateTwo, countdownSeconds, countdownSecondsOne, countdownSecondsTwo;

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
    if (twoDescription) {
        twoDescriptionLabel.text = twoDescription;
    }
    
    
    //oneView.hidden = YES;
    
    if ([UIApplication instancesRespondToSelector:@selector(registerUserNotificationSettings:)]) {
        [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert|UIUserNotificationTypeSound categories:nil]];
    }
    
//    NSString *recipeTitle = @"My Brew Log Test";
//    NSInteger testInt = 120;
//    NSDate *testDate = [NSDate date];
//    testDate = [testDate dateByAddingTimeInterval:testInt];
    
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

-(void)addNewTimer:(NSInteger)time withDetails:(NSString *)description {
    oneDescription = description;
    
    //Calculate hours/minutes/seconds from countdownSeconds
    secondsInt = time % 60;
    minutesInt = (time / 60) % 60;
    hoursInt = (time / 3600) % 24;
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
    [onePauseButton setTitle:@"Start" forState:UIControlStateNormal];
    timerPaused = YES;
}

-(void)startTimerFromDetails:(NSInteger)time withDetails:(NSString *)description {
    NSLog(@"Timer seconds = %ld", (long)time);
    countdownSeconds = time;
    if (time <= 86340) {
        if (firstTimer == nil) {
            countdownSecondsOne = time;
//            oneView.hidden = NO;
            //oneDescriptionLabel.text = oneDescription;
            firstTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(runTimer) userInfo:nil repeats:YES];
            
            //Pass timer to app delegate to be invalidated and start local notification when app is backgrounded
            self.appDelegate.firstTimer = firstTimer;
            
            oneDescription = description;
            
            oneDescriptionLabel.text = description;
            
            timerDate = [NSDate date];
            timerDate = [timerDate dateByAddingTimeInterval:countdownSecondsOne];
            //[self startLocalNotification:timerDate];
        } else if (secondTimer == nil) {
            countdownSecondsTwo = time;
            //Second timer
            NSLog(@"Second timer");
            secondTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(runTimerTwo) userInfo:nil repeats:YES];
            
            twoDescription = description;
            
            twoDescriptionLabel.text = description;
            
            timerDateTwo = [NSDate date];
            timerDateTwo = [timerDateTwo dateByAddingTimeInterval:countdownSecondsTwo];
        } else {
            NSLog(@"No timers available");
        }

    } else {
        NSLog(@"Over 23:59");
        NSDate *calDate = [NSDate date];
        calDate = [calDate dateByAddingTimeInterval:countdownSeconds];
        [self createCalendarEvent:calDate withTitle:description];
    }
}

-(void)runTimer {
    countdownSecondsOne = countdownSecondsOne - 1;
    
    //Calculate hours/minutes/seconds from countdownSeconds
    secondsInt = countdownSecondsOne % 60;
    minutesInt = (countdownSecondsOne / 60) % 60;
    hoursInt = (countdownSecondsOne / 3600) % 24;
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
    //Display current countdown time
    timerOneLabel.text = timerString;
    
    //Play sound and invalidate once time down to zero
    if (countdownSecondsOne == 0) {
        [firstTimer invalidate];
        firstTimer = nil;
        [self.alarmPlayer play];
        NSLog(@"Timer over");
    }
}

-(void)runTimerTwo {
    countdownSecondsTwo = countdownSecondsTwo - 1;
    
    //Calculate hours/minutes/seconds from countdownSeconds
    secondsInt = countdownSecondsTwo % 60;
    minutesInt = (countdownSecondsTwo / 60) % 60;
    hoursInt = (countdownSecondsTwo / 3600) % 24;
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
    //Display currnet countdown time
    timerTwoLabel.text = timerString;
    
    //Play sound and invalidate once time down to zero
    if (countdownSecondsTwo == 0) {
        [secondTimer invalidate];
        secondTimer = nil;
        [self.alarmPlayer play];
        NSLog(@"Timer over");
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

-(void)startLocalNotification:(NSDate *)fire withDescription:(NSString *)description {
    UILocalNotification *localNotification = [[UILocalNotification alloc] init];
    localNotification.fireDate = fire;
    localNotification.alertBody = [NSString stringWithFormat:@"Alert for %@", description];
    localNotification.soundName = UILocalNotificationDefaultSoundName;
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
    NSLog(@"Local notifiaction started");
}

//Create calendar
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

#pragma new timer

//Show Timer Picker
-(IBAction)showTimerPicker:(id)sender {
    //Pass (id)sender to be used for launching ActionSheetPicker from reg action sheet
    buttonSender = sender;
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Is timer over 24 hours?"
                                                             delegate:self
                                                    cancelButtonTitle:@"Cancel"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"Yes", @"No", nil];
    //Set tag and show action sheet
    actionSheet.tag = 200;
    [actionSheet showInView:self.view];
}

//Show countdown picker. Triggered from selecting No to over 24 hour ActionSheet
-(void)showCountdownPicker:(id)sender {
    //Create picker and set to timer mode
    ActionSheetDatePicker *actionSheetPicker = [[ActionSheetDatePicker alloc] initWithTitle:@"Under 24 hours"
                                                      datePickerMode:UIDatePickerModeCountDownTimer
                                                        selectedDate:nil
                                                           doneBlock:^(ActionSheetDatePicker *picker, id dateSelected, id origin) {
                                                               NSLog(@"dateSelected: %@", dateSelected);
                                                               [self under24Hours:picker.countDownDuration element:origin];
                                                           } cancelBlock:^(ActionSheetDatePicker *picker) {
                                                               NSLog(@"Cancel clicked");
                                                           } origin:sender];
    [(ActionSheetDatePicker *) actionSheetPicker setCountDownDuration:120];
    [actionSheetPicker showActionSheetPicker];
}

//Grab input countdown time
- (void)under24Hours:(double)selectedCountdownDuration element:(id)element {
    [self showTimerAlert];
    countdownSeconds = selectedCountdownDuration;
    NSLog(@"countdown %f", selectedCountdownDuration);
}

//Show custom picker. Triggered from selecting Yes to over 24 hour ActionSheet
-(void)showCustomTimePicker:(id)sender {
    //Init custom delegate
    CustomTimerPickerDelegate *timerDelegate = [[CustomTimerPickerDelegate alloc] init];
    NSNumber *comp0 = @0;
    NSNumber *comp1 = @0;
    NSNumber *comp2 = @0;
    NSNumber *comp3 = @0;
    NSNumber *comp4 = @0;
    NSNumber *comp5 = @0;
    //Set initial selections
    NSArray *initialSelections = @[comp0, comp1, comp2, comp3, comp4, comp5];
    
    ActionSheetCustomPicker *customPicker = [[ActionSheetCustomPicker alloc] initWithTitle:@"Select Time" delegate:timerDelegate showCancelButton:YES origin:sender initialSelections:initialSelections];
    
    timerDelegate.timersVC = self;
    [customPicker showActionSheetPicker];
}

//Timer picked (over 24) formats and adds ingredients to textview. Called from Timer Delegate
-(void)timerPicked:(NSString *)formattedTime {
    NSLog(@"NewRec: %@", formattedTime);
    
    NSArray *numbersArray = [formattedTime componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@","]];
    
    NSInteger monthsFromString = [numbersArray[0] intValue];
    NSInteger monthsInt = 0;
    NSInteger weeksFromString = [numbersArray[1] intValue];
    NSInteger weeksInt = 0;
    NSInteger daysFromString = [numbersArray[2] intValue];
    NSInteger daysInt = 0;
    
    //NSLog(@"M - %ld, W - %ld, D - %ld", (long)monthsFromString, (long)weeksFromString, (long)daysFromString);
    
    if (monthsFromString != 00) {
        monthsInt = monthsFromString * 2592000;
        NSLog(@"Months in seconds = %ld", (long)monthsInt);
    }
    if (weeksFromString != 00) {
        weeksInt = weeksFromString * 604800;
    }
    if (daysFromString != 00) {
        daysInt = daysFromString * 86400;
    }
    
    countdownSeconds = monthsInt + weeksInt + daysInt;
    [self showTimerAlert];
}

//Grab action sheet actions via delegate method
-(void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex {
    //Over 24 hours (Yes clicked)
    if (buttonIndex == 0) {
        NSLog(@"index 0");
        
        [self showCustomTimePicker:buttonSender];
    //Under 24 hours (No clicked)
    } else if (buttonIndex == 1) {
        NSLog(@"index 1");
        [self showCountdownPicker:buttonSender];
    //Cancel clicked
    } else {
        NSLog(@"Other index");
    }
}

//Method to create and show alert view with text input
-(void)showTimerAlert {
    NSString *alertString = @"Please enter a discription for the new timer. Over 24 hours will be calendar entries.";
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Start Timer"
                                                    message:alertString
                                                   delegate:self
                                          cancelButtonTitle:@"Cancel"
                                          otherButtonTitles:@"Start", nil];
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    [alert show];
} //showAlert close

//Grab text entered into alertview
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSString *description = [alertView textFieldAtIndex:0].text;
    if (buttonIndex == 1) {
        NSLog(@"index 1");
        if (description.length == 0) {
            description = @"No Description";
        }
        
        if (countdownSeconds <= 86340) {
            //Add one to countdown to utilize runTimer to set up nstimer
//            countdownSeconds = countdownSeconds + 1;
//            [self runTimer];
//            [onePauseButton setTitle:@"Start" forState:UIControlStateNormal];
//            timerPaused = YES;
//            [self pauseTimer:firstTimer];
        }
        //[self addNewTimer:countdownSeconds withDetails:description];
        
//        timerOneLabel.text = timerString;
        
        [self startTimerFromDetails:countdownSeconds withDetails:description];
        
        //timersViewController.oneView.hidden = NO;
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
