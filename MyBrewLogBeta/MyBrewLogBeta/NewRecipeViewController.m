// Elijah Freestone
// IPY 1504
// Week 2 - Beta
// April 5th, 2015

//
//  NewRecipeViewController.m
//  MyBrewLogBeta
//
//  Created by Elijah Freestone on 4/5/15.
//  Copyright (c) 2015 Elijah Freestone. All rights reserved.
//

#import "NewRecipeViewController.h"
#import "ActionSheetStringPicker.h"
#import "ActionSheetDatePicker.h"
#import "ActionSheetCustomPickerDelegate.h"
#import "ActionSheetCustomPicker.h"
#import "ActionSheetDistancePicker.h"
#import "DistancePickerView.h"
#import "CustomPickerDelegate.h"
#import "CustomQuantityPickerDelegate.h"
#import "CustomTimerPickerDelegate.h"
#import <Parse/Parse.h>

@interface NewRecipeViewController () <UIActionSheetDelegate> {
    NSArray *recipeTypes;
    NSArray *ingredientArray;
    NSDate *selectedDate;
    NSDate *selectedTime;
    AbstractActionSheetPicker *actionSheetPicker;
    
    NSInteger selectedBigUnit;
    NSInteger selectedSmallUnit;
    NSInteger selectedIndex;
    NSString *ingredientSelected;
    NSString *ingredientWithQuantity;
    NSString *otherIngredient;
    
    NSString *ingredientTVString;
    NSString *instructionsTVString;
    NSString *recipeIngredients;
    NSString *recipeInstructions;
    NSString *recipeType;
    NSString *recipeName;
    NSString *recipeNotes;
    double selectedCountdownDouble;
    
    NSString *parseClassName;
    id buttonSender;
    
    BOOL browseCopy;
}

@end

@implementation NewRecipeViewController

//Synthesize for getters/setters
@synthesize typeButton, batchButton, ingredientButton, tempButton, timerButton, notesButton;
@synthesize recipeNameTF, ingredientsTV, instructionsTV;
@synthesize passedName, passedType, passedIngredients, passedInstructions, passedUsername, passedObject, passedObjectID, isCopy;

- (void)viewDidLoad {
    [super viewDidLoad];
    //Init NSDates
    selectedDate = [NSDate date];
    selectedTime = [NSDate date];
    
    parseClassName = @"newRecipe";
    
    [[recipeNameTF layer] setBorderColor:[[UIColor lightGrayColor] CGColor]];
    [[recipeNameTF layer] setBorderWidth:0.5];
    [[recipeNameTF layer] setCornerRadius:7.5];
    
    [[ingredientsTV layer] setBorderColor:[[UIColor lightGrayColor] CGColor]];
    [[ingredientsTV layer] setBorderWidth:0.5];
    [[ingredientsTV layer] setCornerRadius:7.5];
    
    [[instructionsTV layer] setBorderColor:[[UIColor lightGrayColor] CGColor]];
    [[instructionsTV layer] setBorderWidth:0.5];
    [[instructionsTV layer] setCornerRadius:7.5];
    
    //Create arrays for pickers
    recipeTypes = [NSArray arrayWithObjects:@"Beer", @"Wine", @"Other", nil];
    ingredientArray = [NSArray arrayWithObjects:@"Ingedient 1", @"Ingedient 2", @"Ingedient 3", @"Ingedient 4", @"Ingedient 5", @"Ingedient 6", @"Other", nil];
    
    //Set default recipe type to Other
    recipeType = @"Other";
    recipeNotes = @"";
    
    //Grab user and username
    PFUser *user = [PFUser currentUser];
    NSString *usernameString = [user objectForKey:@"username"];
    
    //Check if passedName exists. Only true when editing
    if (passedName != nil) {
        NSLog(@"Passed Name not nil");
        if ([passedUsername isEqualToString: usernameString]) {
            NSLog(@"Username equals current");
            //Check if recipe is a copy (not from browse)
            if (isCopy) {
                //Add copy to name of recipe
                recipeNameTF.text = [NSString stringWithFormat:@"%@ Copy", passedName];
            } else {
                recipeNameTF.text = passedName;
            }
        } else {
            NSLog(@"user = %@", passedUsername);
            recipeNameTF.text = [NSString stringWithFormat:@"%@ by %@", passedName, passedUsername];
            browseCopy = YES;
        }
        recipeType = passedType;
        ingredientsTV.text = passedIngredients;
        instructionsTV.text = passedInstructions;
    } else {
        NSLog(@"Passed Name IS nil");
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)fillFieldsForEdit {
    
}

//Dismiss new recipe view on cancel
-(IBAction)onCancel:(id)sender {
    //Dismiss view controller
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Pickers and Action Sheets
//Using ActionSheetPicker, an open source lib. Found at https://github.com/skywinder/ActionSheetPicker-3.0

//Show Recipe Type Picker
-(IBAction)showRecipeTypePicker:(id)sender {
    //Create ActionSheet for recipe types
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Select a Recipe Type"
                                                             delegate:self
                                                    cancelButtonTitle:@"Cancel"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:nil];
    
//    [[[actionSheet valueForKey:@"_buttons"] objectAtIndex:0] setImage:[UIImage imageNamed:@"beer-bottle.png"] forState:UIControlStateNormal];
//    [[[actionSheet valueForKey:@"_buttons"] objectAtIndex:1] setImage:[UIImage imageNamed:@"wine-glass.png"] forState:UIControlStateNormal];
//    [[[actionSheet valueForKey:@"_buttons"] objectAtIndex:2] setImage:[UIImage imageNamed:@"other-icon.png"] forState:UIControlStateNormal];
//    
//    for (UIView *subview in actionSheet.subviews) {
//        if ([subview isKindOfClass:[UIButton class]]) {
//            UIButton *button = (UIButton *)subview;
//            [button setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
//        }
//    }
    
    //Fast enum recipe types and apply to "other" button
    for (NSString *title in recipeTypes) {
        [actionSheet addButtonWithTitle:title];
    }
    
    actionSheet.tag = 100;
    
    [actionSheet showInView:self.view];
}

//Show Ingredients Picker
-(IBAction)showIngredientPicker:(id)sender {
    //Create picker and fill with Ingredients Array
    [ActionSheetStringPicker showPickerWithTitle:@"Add Ingredient"
                                            rows:ingredientArray
                                initialSelection:0
                                       doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
                                           NSLog(@"Selected Value: %@", selectedValue);
                                           //Grab value selected
                                           [self ingredientSelected:selectedValue fromSender:sender];
                                       }
                                     cancelBlock:^(ActionSheetStringPicker *picker) {
                                         NSLog(@"Block Picker Canceled");
                                     }
                                          origin:sender];
}

//Ingredient selected. Will create alertview with textfield if Other selected
-(void)ingredientSelected:(NSString *)ing fromSender:(id)sender {
    if ([ing isEqualToString:@"Other"]) {
        //Alert with TextField
        [self showOtherSelectedAlert:sender];
        NSLog(@"Other Selected");
    } else {
        ingredientSelected = ing;
        [self showQuantityPicker:sender];
    }
}

//Create and show alert view if Other is selected for ingredient
-(void)showOtherSelectedAlert:(id)sender {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Other Ingredient"
                                                    message:@"Please enter your ingredient name"
                                                   delegate:self
                                          cancelButtonTitle:@"Cancel"
                                          otherButtonTitles:@"Save", nil];
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    [alert show];
    buttonSender = sender;
    alert.tag = 5;
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    //Other ingredient is tag 5
    if ([alertView tag] == 5) {
        otherIngredient = [alertView textFieldAtIndex:0].text;
        if (buttonIndex == 1) {
            if (otherIngredient.length != 0) {
                ingredientSelected = otherIngredient;
                [self showQuantityPicker:buttonSender];
            } else {
                [self showOtherSelectedAlert:buttonSender];
            }
        }
    }
    //Notes is tag 6
    if ([alertView tag] == 6) {
        recipeNotes = [alertView textFieldAtIndex:0].text;
        if (buttonIndex == 1) {
            NSLog(@"Notes: %@", recipeNotes);
            [self addNotesToInstructions];
        }
    }
}

//Show custom quantity picker. Triggered after selecting ingredient
-(void)showQuantityPicker:(id)sender {
    //Init custom picker delegate
    CustomQuantityPickerDelegate *delegate = [[CustomQuantityPickerDelegate alloc] init];
    delegate.myRecipeVC = self;
    //Set initial selections
    NSNumber *comp0 = @0;
    NSNumber *comp1 = @0;
    NSNumber *comp2 = @0;
    NSNumber *comp3 = @0;
    NSArray *initialSelections = @[comp0, comp1, comp2, comp3];
    [ActionSheetCustomPicker showPickerWithTitle:@"Select Quantity"
                                        delegate:delegate
                                showCancelButton:YES
                                          origin:sender
                               initialSelections:initialSelections];
    
}

//Quantity picked formats and adds ingredients to textview. Called from Quantity Delegate
-(void)quantityPicked:(NSString *)formattedQuantity {
    NSLog(@"NewRec: %@", formattedQuantity);
    NSString *currentInst = ingredientsTV.text;
    
    //Check if last line of string ends in new line, add before temp if it doesn't exist
    NSString *addNewLine = @"";
    if (![currentInst hasSuffix:@"\n"]) {
        NSLog(@"new line");
        addNewLine = @"\n";
    }
    
    //Remove new line if textview was empty. Behaviour isn't always as expected when including this check above
    if (currentInst.length == 0) {
        NSLog(@"Textview was empty");
        addNewLine = @"";
    }
    
    ingredientWithQuantity = [NSString stringWithFormat:@"%@%@ - %@\n", addNewLine, ingredientSelected, formattedQuantity];
    
    ingredientTVString = [NSString stringWithFormat:@"%@%@", currentInst, ingredientWithQuantity];
    ingredientsTV.text = ingredientTVString;
}

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
    //Create picker and set to temer mode
    actionSheetPicker = [[ActionSheetDatePicker alloc] initWithTitle:@"Under 24 hours"
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
    //Cast time interval to int to calculate hour and min
    NSInteger timerInt = (NSInteger)selectedCountdownDuration;
    NSInteger minutes = (timerInt / 60) % 60;
    NSInteger hours = (timerInt / 3600);
    NSString *time = [NSString stringWithFormat:@"%02ld:%02ld", (long)hours, (long)minutes];
    
    NSString *currentInst = instructionsTV.text;
    
    //Check if last line of string ends in new line, add before temp if it doesn't exist
    NSString *addNewLine = @"";
    if (![currentInst hasSuffix:@"\n"]) {
        NSLog(@"new line");
        addNewLine = @"\n";
    }
    
    //Remove new line if textview was empty. Behaviour isn't always as expected when including this check above
    if (currentInst.length == 0) {
        NSLog(@"Textview was empty");
        addNewLine = @"";
    }
    
    NSString *formattedTime = [NSString stringWithFormat:@"%@Timer: %@ \n", addNewLine, time];
    instructionsTVString = [NSString stringWithFormat:@"%@%@", currentInst, formattedTime];
    
    instructionsTV.text = instructionsTVString;
    
    selectedCountdownDouble = selectedCountdownDuration;
    NSLog(@"countdown %ld", (long)timerInt);
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
    
    timerDelegate.myRecipeVC = self;
    [customPicker showActionSheetPicker];
}

//Timer picked (over 24) formats and adds ingredients to textview. Called from Quantity Delegate
-(void)timerPicked:(NSString *)formattedTime {
    NSLog(@"NewRec: %@", formattedTime);
    NSString *currentInst = instructionsTV.text;
    
    //Check if last line of string ends in new line, add before temp if it doesn't exist
    NSString *addNewLine = @"";
    if (![currentInst hasSuffix:@"\n"]) {
        NSLog(@"new line");
        addNewLine = @"\n";
    }
    
    //Remove new line if textview was empty. Behaviour isn't always as expected when including this check above
    if (currentInst.length == 0) {
        NSLog(@"Textview was empty");
        addNewLine = @"";
    }
    
    NSString *timerWithNewLine = [NSString stringWithFormat:@"%@Timer: %@\n", addNewLine, formattedTime];
    
    instructionsTVString = [NSString stringWithFormat:@"%@%@", currentInst, timerWithNewLine];
    instructionsTV.text = instructionsTVString;
}

//Show Temp Picker
-(IBAction)showTempPicker:(id)sender {
    //Create picker using Distance. Will likely need custom for real picker or use a stepper instead.
    [ActionSheetDistancePicker showPickerWithTitle:@"Select Temperature"
                                     bigUnitString:@"."
                                        bigUnitMax:999
                                   selectedBigUnit:selectedBigUnit
                                   smallUnitString:@"°"
                                      smallUnitMax:9
                                 selectedSmallUnit:selectedSmallUnit
                                            target:self
                                            action:@selector(tempSelected:smallUnit:)
                                            origin:sender];
}

//Grab temp selection
-(void)tempSelected:(NSNumber *)wholeNumber smallUnit:(NSNumber *)pointNumber {
    NSString *currentInst = instructionsTV.text;
//    NSString *lastChar = @"";
//    //Get last 2 char
//    if (currentInst.length >= 2) {
//        NSLog(@"Last char");
//        lastChar = [currentInst substringFromIndex: [currentInst length] - 2];
//        //[state substringFromIndex: MAX([state length] - 2, 0)];
//    }
    
    //Check if last line of string ends in new line, add before temp if it doesn't exist
    NSString *addNewLine = @"";
    if (![currentInst hasSuffix:@"\n"]) {
        NSLog(@"new line");
        addNewLine = @"\n";
    }
    
    //Remove new line if textview was empty. Behaviour isn't always as expected when including this check above
    if (currentInst.length == 0) {
        NSLog(@"Textview was empty");
        addNewLine = @"";
    }
    
    //Grab input numbers. Whole numbers are left of decimal
    selectedBigUnit = [wholeNumber intValue];
    selectedSmallUnit = [pointNumber intValue];
    NSString *formattedTemp = [NSString stringWithFormat:@"%@Temp: %ld.%ld °F \n", addNewLine, (long)selectedBigUnit, (long)selectedSmallUnit];
    //NSLog(@"Formatted %@", formattedTemp);
    
    instructionsTVString = [NSString stringWithFormat:@"%@%@", currentInst, formattedTemp];
    
    //NSLog(@"%@", instructionsTVString);
    
    instructionsTV.text = instructionsTVString;
}

//Create and show alert view w/ textfield for notes
-(IBAction)showNotesAlert:(id)sender {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Notes"
                                                    message:@"Please enter notes for your recipe"
                                                   delegate:self
                                          cancelButtonTitle:@"Cancel"
                                          otherButtonTitles:@"Save", nil];
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    [alert show];
    
    UITextField *notesTF = [alert textFieldAtIndex:0];
    //Set alert textfield as first responder after ending edit on both teextviews. This is to fix the occasional issue of trying to add notes but have the text appear in the instructions or ingredients textview instead
    [ingredientsTV endEditing:YES];
    [instructionsTV endEditing:YES];
    [notesTF becomeFirstResponder];
    
    alert.tag = 6;
}

//Add notes to instructions
-(void)addNotesToInstructions {
    NSString *currentInst = instructionsTV.text;
    
    //Check if last line of string ends in new line, add before temp if it doesn't exist
    NSString *addNewLine = @"";
    if (![currentInst hasSuffix:@"\n"]) {
        NSLog(@"new line");
        addNewLine = @"\n";
    }
    
    //Remove new line if textview was empty. Behaviour isn't always as expected when including this check above
    if (currentInst.length == 0) {
        NSLog(@"Textview was empty");
        addNewLine = @"";
    }
    
    NSString *formattedNotes = [NSString stringWithFormat:@"%@Notes: %@\n", addNewLine, recipeNotes];
    instructionsTVString = [NSString stringWithFormat:@"%@%@", currentInst, formattedNotes];
    
    instructionsTV.text = instructionsTVString;
}

#pragma mark - action sheet delegate

//Grab action sheet actions via delegate method
-(void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex {
    //Tag 100 is Recipe Type
    if (actionSheet.tag == 100) {
        recipeType = [actionSheet buttonTitleAtIndex:buttonIndex];
        NSLog(@"Recipe Type = %@", recipeType);
    //Tag 200 is first timer (is 24 hours)
    } else if (actionSheet.tag == 200) {
        NSLog(@"Timer length");
        //Yes or No selected in first timer action sheet
        if ([[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString:@"No"]) {
            //Under 24 selected, show countdown picker
            NSLog(@"Under 24 hours");
            [self showCountdownPicker:buttonSender];
        } else if ([[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString:@"Yes"]) {
            //Over 24 selected, show custom M/W/D picker
            NSLog(@"Over 24 hours");
            [self showCustomTimePicker:buttonSender];
        } else {
            NSLog(@"Button title is NOT yes or no");
        }
        
    } else {
        NSLog(@"Something else selected");
    }
    
    NSLog(@"Index = %ld - Title = %@", (long)buttonIndex, [actionSheet buttonTitleAtIndex:buttonIndex]);
}

#pragma mark - Save

//Save entered recipe to Parse
-(IBAction)onSave:(id)sender {
    //Grab text field for recipe name
    recipeName = recipeNameTF.text;
    //recipeNotes = notesTF.text;
    recipeIngredients = ingredientsTV.text;
    recipeInstructions = instructionsTV.text;
    //Grab current date. Used for updatedByUser in either case (edit or new recipe)
    NSDate *updated = [NSDate date];
    
    if (recipeName.length > 0 && recipeInstructions.length > 0) {
        //If objectID is not nil, object is being edited so query and update
        if (passedObjectID != nil && !isCopy) {
            PFQuery *editQuery = [PFQuery queryWithClassName:parseClassName];
            [editQuery getObjectInBackgroundWithId:passedObjectID block:^(PFObject *editObject, NSError *error) {
                editObject[@"Type"] = recipeType;
                editObject[@"Name"] = recipeName;
                editObject[@"Ingredients"] = recipeIngredients;
                editObject[@"Instructions"] = recipeInstructions;
                editObject[@"updatedByUser"] = updated;
                [editObject saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                    if (succeeded) {
                        NSLog(@"Edited item saved.");
                        //Dismiss add item view
                        [self dismissViewControllerAnimated:YES completion:nil];
                        [self.myRecipeVC refreshTable];
//                        [self.myRecipeVC.navigationController popToRootViewControllerAnimated:YES];
                        [self.recipeDetailsVC pressBackButton];
                    } else {
                        NSLog(@"%@", error);
                        //Error alert
                        [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", nil) message:NSLocalizedString(@"An error occured trying to save. Please try again.", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil] show];
                    }
                }];
            }];
        //Not editing, create new object to save
        } else {
            //Name was entered, continue saving
            PFObject *newRecipeObject = [PFObject objectWithClassName:parseClassName];
            newRecipeObject[@"Type"] = recipeType;
            newRecipeObject[@"Name"] = recipeName;
            //        newRecipeObject[@"Notes"] = recipeNotes;
            newRecipeObject[@"Ingredients"] = recipeIngredients;
            newRecipeObject[@"Instructions"] = recipeInstructions;
            newRecipeObject[@"createdBy"] = [PFUser currentUser].username;
            newRecipeObject[@"updatedByUser"] = updated;
            
            //newRecipeObject[@"array"] = ingredientArray;
            
            [newRecipeObject saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if (succeeded) {
                    NSLog(@"New item saved.");
                    //Dismiss add item view
                    [self dismissViewControllerAnimated:YES completion:nil];
                    [self.myRecipeVC refreshTable];
                } else {
                    NSLog(@"%@", error);
                    //Error alert
                    [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", nil) message:NSLocalizedString(@"An error occured trying to save. Please try again.", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil] show];
                }
            }];
        }
    //Name missing
    } else {
        NSLog(@"Name required");
        NSString *alertString = @"A Recipe Name and some Instructions are required to save. Please add them and try again.";
        [self showRequiredAlert:alertString];
    }
}

#pragma mark - Alerts

//Method to create and show alert view if required items are missing
-(void)showRequiredAlert:(NSString *)alertMessage {
    UIAlertView *copyAlert = [[UIAlertView alloc] initWithTitle:@"Alert: Required" message:alertMessage delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    //Show alert
    [copyAlert show];
}

@end
