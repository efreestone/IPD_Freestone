// Elijah Freestone
// IPY 1504
// Week 3 - Release Candidate
// April 17th, 2015

//
//  RecipeDetailsViewController.m
//  MyBrewLogRC
//
//  Created by Elijah Freestone on 4/17/15.
//  Copyright (c) 2015 Elijah Freestone. All rights reserved.
//

#import "RecipeDetailsViewController.h"
#import "NewRecipeViewController.h"
#import "TimersViewController.h"
#import "AppDelegate.h"
#import <Social/Social.h>

@interface RecipeDetailsViewController () <UITextViewDelegate, UIActionSheetDelegate> {
    NSInteger countdownSeconds;
    TimersViewController *timersViewController;
    BOOL isCopy;
    AppDelegate *appDelegate;
}

@end

@implementation RecipeDetailsViewController

//Synthesize for getters/setters
@synthesize nameLabel, ingredientsTV, instructionsTV;
@synthesize passedObject, passedName, passedType, passedIngredients, passedUsername, passedInstructions, passedObjectID;
@synthesize activeSwitch, publicSwitch;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    appDelegate = [[UIApplication sharedApplication] delegate];
    //Grab timers view controller to start timers from textview
    timersViewController = (TimersViewController*)[[self.tabBarController viewControllers] objectAtIndex:2];
    //set timers app delegate
    timersViewController.appDelegate = appDelegate;
    
    //Set textviews with passed data
    nameLabel.text = passedName;
    ingredientsTV.text = passedIngredients;
    instructionsTV.text = passedInstructions;
    
    //Set rounded corners on ing and inst textviews
    [[ingredientsTV layer] setBorderColor:[[UIColor lightGrayColor] CGColor]];
    [[ingredientsTV layer] setBorderWidth:0.5];
    [[ingredientsTV layer] setCornerRadius:7.5];
    
    [[instructionsTV layer] setBorderColor:[[UIColor lightGrayColor] CGColor]];
    [[instructionsTV layer] setBorderWidth:0.5];
    [[instructionsTV layer] setCornerRadius:7.5];
    
    //Grab string and change to NSAttributedString
    NSMutableAttributedString * string = [[NSMutableAttributedString alloc]initWithString:passedInstructions];
    NSArray *words=[self.instructionsTV.text componentsSeparatedByString:@"\n"];
    //Add url attribute to lines that start with Timer:
    for (NSString *word in words) {
        if ([word hasPrefix:@"Timer:"]) {
            NSRange range=[self.instructionsTV.text rangeOfString:word];
            //Add URL attribute. This is captured later to trigger Timer code
            [string addAttribute:NSLinkAttributeName value:@"Timer://timer" range:range];
        }
    }
    [self.instructionsTV setAttributedText:string];
    
    [ingredientsTV flashScrollIndicators];
    [instructionsTV flashScrollIndicators];
    
    //Override link color
    instructionsTV.linkTextAttributes = @{NSForegroundColorAttributeName:[UIColor redColor]};
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//Dismiss view. Used to dismiss from new recipe edit upon saving
-(void)pressBackButton {
    [self.navigationController popViewControllerAnimated:YES];
}

//Share object
-(void)shareClicked {
    NSString *titleString = @"Share Recipe";
    NSString *alertMessage = @"Recipe would have been shared via social networks, however this feature is not functional yet";
    [self showAlert:alertMessage withTitle:titleString];
    
    NSString *testIngString = ingredientsTV.text;
    NSLog(@"Ing test = %@", testIngString);
    
    instructionsTV.text = testIngString;
}

# pragma mark - AlertViews

//Method to create and show alert view if there is no internet connectivity
-(void)showAlert:(NSString *)alertMessage withTitle:(NSString *)titleString {
    UIAlertView *copyAlert = [[UIAlertView alloc] initWithTitle:titleString message:alertMessage delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    //Show alert
    [copyAlert show];
} //showAlert close

//Method to create and show alert view with text input
-(void)showTimerAlert:(NSString *)alertMessage {
    NSString *formattedString = [NSString stringWithFormat:@"%@ \nPlease enter a discription for the new timer. Over 24 hours will be calendar entries.", alertMessage];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Start Timer"
                                                    message:formattedString
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
        [timersViewController startTimerFromDetails:countdownSeconds withDetails:description];
        //timersViewController.oneView.hidden = NO;
    }
}

# pragma mark - ActionSheet (menu)

//Create and show action sheet
-(IBAction)showMenuActionSheet:(id)sender {
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"What would you like to do with this recipe?"
                                                             delegate:self
                                                    cancelButtonTitle:@"Cancel"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"Edit", @"Copy", @"Share", @"Delete", nil];
    
    [actionSheet showInView:self.view];
}

//Get tag for action sheet but selected and process accordingly
-(void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex {
    switch (buttonIndex) {
        case 0: //Edit
            NSLog(@"0");
            //Set copy BOOL
            isCopy = NO;
            [self performSegueWithIdentifier:@"Edit" sender:self];
            break;
        case 1: //Copy
            NSLog(@"1");
            //Set copy BOOL
            isCopy = YES;
            [self performSegueWithIdentifier:@"Edit" sender:self];
            break;
        case 2: //Share
            NSLog(@"2");
            //[self shareClicked];
            [self postToTwitter];
            break;
        case 3: //Delete
            NSLog(@"3");
            [self deleteObject];
            break;
        default:
            NSLog(@"Other clicked");
            break;
    }
}

//Delete object
-(void)deleteObject {
    // Delete the object from the data source
    [passedObject deleteInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        //[self loadObjects];
        [self pressBackButton];
    }];
}

#pragma mark - UISwitch

//Active switch changed
-(IBAction)activeSwitchChanged:(id)sender {
    //Check switch status
    if ([activeSwitch isOn]) {
        NSLog(@"Switch is on");
        passedObject[@"Active"] = [NSNumber numberWithBool:YES];
    } else {
        NSLog(@"Switch is off");
        passedObject[@"Active"] = [NSNumber numberWithBool:NO];
    }
    [passedObject saveInBackgroundWithBlock:^(BOOL success, NSError *error){
        if (!error) {
            NSLog(@"Save successful");
        } else {
            NSLog(@"Error saving object");
        }
    }];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"Edit"]) {
        //Get VC and set items for passed object
        NewRecipeViewController *newRecipeVC = segue.destinationViewController;
        newRecipeVC.passedName = passedName;
        newRecipeVC.passedType = passedType;
        newRecipeVC.passedIngredients = passedIngredients;
        newRecipeVC.passedInstructions = passedInstructions;
        newRecipeVC.passedUsername = passedUsername;
        newRecipeVC.passedObjectID = passedObjectID;
        newRecipeVC.passedObject = passedObject;
        newRecipeVC.isCopy = isCopy;
        
        newRecipeVC.recipeDetailsVC = self;
    }
}

//Grab URL click in TextView and start timer, return NO to stop browser from opening
-(BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange {
    NSString *rangeString = [textView.text substringWithRange:characterRange];
    NSLog(@"%@", rangeString);
    
    [self showTimerAlert:rangeString];
    
    NSString *timeString = [rangeString substringFromIndex:7];
    NSLog(@"timeString%@time", timeString);
    //Check format with regex. Under searches for 0:00 or 00:00 format
    NSString *under24Pattern = @"^([0-9]|0[0-9]|1?[0-9]|2[0-3]):([0-5][0-9] )$";
    NSPredicate *predicateOne = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", under24Pattern];
    //Check for 0 Months, 0 Weeks, 0 Days format. double digit for any of the numbers is accepted too
    NSString *over24Pattern = @"^[0-9]{1,2} Months, [0-9]{1,2} Weeks, [0-9]{1,2} Days$";
    NSPredicate *predicateTwo = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", over24Pattern];
    
    //If matches 0:00 or 00:00 formats
    if ([predicateOne evaluateWithObject:timeString]) {
        NSLog(@"00:00 matches");
        //Add extra zero at beginning if hours is only one digit
        if (timeString.length == 5) {
            timeString = [NSString stringWithFormat:@"0%@", timeString];
            NSLog(@"timerString = %@ %lu", timeString, (unsigned long)timeString.length);
        }
        //Is countdown timer if contains char is :
        NSArray *numbersArray = [timeString componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@":"]];
        
        NSInteger hoursFromString = [numbersArray[0] intValue];
        NSInteger hoursInt = 0;
        NSInteger minuteFromString = [numbersArray[1] intValue];
        NSInteger minutesInt = 0;
        
        //Make sure times aren't 00 and get seconds
        if (hoursFromString != 00) {
            hoursInt = hoursFromString * 3600;
        }
        if (minuteFromString != 00) {
            minutesInt = minuteFromString * 60;
        }
        countdownSeconds = hoursInt + minutesInt;
        NSLog(@"Countdown = %ld", (long)countdownSeconds);
    } else if ([predicateTwo evaluateWithObject:timeString]) {
        NSLog(@"Months, Weeks, Days matches");
        
    } else {
        NSLog(@"NO matches");
    }
    
//    //Is countdown timer if contains char is :
//    if ([charAtThree isEqualToString:@":"]) {
//        NSLog(@"equals :");
//        NSArray *numbersArray = [timeString componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@":"]];
//        
//        NSInteger hoursFromString = [numbersArray[0] intValue];
//        NSInteger hoursInt = 0;
//        NSInteger minuteFromString = 0;
//        if (numbersArray.count >= 2) {
//            minuteFromString = [numbersArray[1] intValue];
//        }
//        NSInteger minutesInt = 0;
//        
//        //Make sure times aren't 00 and get seconds
//        if (hoursFromString != 00) {
//            hoursInt = hoursFromString * 3600;
//        }
//        if (minuteFromString != 00) {
//            minutesInt = minuteFromString * 60;
//        }
//        countdownSeconds = hoursInt + minutesInt;
//        NSLog(@"Countdown = %ld", (long)countdownSeconds);
//    } else {
//        NSLog(@"Not :, over 24 hours");
//        if (timeString.length < 25) {
//            NSLog(@"Wrong format for timer");
//            NSArray *numbersArray = [timeString componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@" "]];
//            NSInteger hoursFromString = [numbersArray[0] intValue];
//            NSInteger hoursInt = 0;
//            NSInteger minuteFromString = 0;
//            if (numbersArray.count >= 2) {
//                minuteFromString = [numbersArray[2] intValue];
//            }
//            NSInteger minutesInt = 0;
//            
//            //Make sure times aren't 00 and get seconds
//            if (hoursFromString != 00) {
//                hoursInt = hoursFromString * 3600;
//            }
//            if (minuteFromString != 00) {
//                minutesInt = minuteFromString * 60;
//            }
//            countdownSeconds = hoursInt + minutesInt;
//            NSLog(@"Countdown = %ld", (long)countdownSeconds);
//        } else {
//            NSArray *numbersArray = [timeString componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@","]];
//            
//            NSInteger monthsFromString = [numbersArray[0] intValue];
//            NSInteger monthsInt = 0;
//            NSInteger weeksFromString = [numbersArray[1] intValue];
//            NSInteger weeksInt = 0;
//            NSInteger daysFromString = [numbersArray[2] intValue];
//            NSInteger daysInt = 0;
//            
//            //NSLog(@"M - %ld, W - %ld, D - %ld", (long)monthsFromString, (long)weeksFromString, (long)daysFromString);
//            
//            if (monthsFromString != 00) {
//                monthsInt = monthsFromString * 2592000;
//                NSLog(@"Months in seconds = %ld", (long)monthsInt);
//            }
//            if (weeksFromString != 00) {
//                weeksInt = weeksFromString * 604800;
//            }
//            if (daysFromString != 00) {
//                daysInt = daysFromString * 86400;
//            }
//            
//            countdownSeconds = monthsInt + weeksInt + daysInt;
//        }
//    }
    
    return NO;
}

//Post to twitter. This is still lacking a link but there is no website interface to handle it anyways.
-(void)postToTwitter {
    //Create string with username and score
    NSString *tweetString = [NSString stringWithFormat:@"Check out my %@ recipe on My Brew Log (insert link) called %@", passedType, passedName];
    
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter]) {
        SLComposeViewController *tweetSheet = [SLComposeViewController
                                               composeViewControllerForServiceType:SLServiceTypeTwitter];
        [tweetSheet setInitialText:tweetString];
        NSLog(@"Post to Twitter");
        [self presentViewController:tweetSheet animated:YES completion:nil];
    } else {
        [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", nil) message:NSLocalizedString(@"There is no twitter account available on your device. Please check your account settings and try again", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil] show];
    }
}

@end
