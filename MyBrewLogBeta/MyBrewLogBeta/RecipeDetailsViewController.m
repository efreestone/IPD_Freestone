// Elijah Freestone
// IPY 1504
// Week 2 - Beta
// April 5th, 2015

//
//  RecipeDetailsViewController.m
//  MyBrewLogBeta
//
//  Created by Elijah Freestone on 4/5/15.
//  Copyright (c) 2015 Elijah Freestone. All rights reserved.
//

#import "RecipeDetailsViewController.h"
#import "NewRecipeViewController.h"
#import "TimersViewController.h"

@interface RecipeDetailsViewController () <UITextViewDelegate, UIActionSheetDelegate> {
    NSInteger countdownSeconds;
    TimersViewController *timersViewController;
    BOOL isCopy;
}

@end

@implementation RecipeDetailsViewController

//Synthesize for getters/setters
@synthesize nameLabel, ingredientsTV, instructionsTV;
@synthesize passedObject, passedName, passedType, passedIngredients, passedUsername, passedInstructions, passedObjectID;

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
    //Grab timers view controller to start timers from textview
    timersViewController = (TimersViewController*)[[self.tabBarController viewControllers] objectAtIndex:2];
    
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

//Method to create and show alert view if there is no internet connectivity
-(void)showTimerAlert:(NSString *)alertMessage {
    NSString *formattedString = [NSString stringWithFormat:@"%@ \nPlease enter a discription for timer", alertMessage];
    
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
            [self performSegueWithIdentifier:@"Edit" sender:self];
            break;
        case 1: //Copy
            NSLog(@"1");
            isCopy = YES;
            [self performSegueWithIdentifier:@"Edit" sender:self];
            break;
        case 2: //Share
            NSLog(@"2");
            [self shareClicked];
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
    //NSLog(@"timeString %@", timeString);
    //Get third char and check if :
    NSRange range = {2,1};
    NSString *charAtThree = [timeString substringWithRange:range];
    //Is countdown timer if contains char is :
    if ([charAtThree isEqualToString:@":"]) {
//        NSLog(@"equals :");
        NSArray *numbersArray = [timeString componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@":"]];
        
        NSInteger hoursFromString = [numbersArray[0] intValue];
        NSInteger minuteFromString = [numbersArray[1] intValue];
        NSInteger hoursInt = 0;
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
        
    } else {
        NSLog(@"Not :, over 24 hours");
    }
    
    return NO;
}

@end
