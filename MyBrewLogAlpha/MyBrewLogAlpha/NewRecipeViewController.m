// Elijah Freestone
// IPY 1504
// Week 1 - Alpha
// March 30th, 2015

//
//  NewRecipeViewController.m
//  MyBrewLogAlpha
//
//  Created by Elijah Freestone on 3/30/15.
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
#import "CustomTimerPickerDelegate.h"

@interface NewRecipeViewController () <UIActionSheetDelegate> {
    NSArray *recipeTypes;
    NSArray *ingredientArray;
    NSDate *selectedDate;
    NSDate *selectedTime;
    AbstractActionSheetPicker *actionSheetPicker;
    
    NSInteger selectedBigUnit;
    NSInteger selectedSmallUnit;
    
    id buttonSender;
}

@end

@implementation NewRecipeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    selectedDate = [NSDate date];
    selectedTime = [NSDate date];
    
    //Create arrays for pickers
    recipeTypes = [NSArray arrayWithObjects:@"Beer", @"Wine", @"Other", nil];
    ingredientArray = [NSArray arrayWithObjects:@"Ingedient 1", @"Ingedient 2", @"Ingedient 3", @"Ingedient 4", @"Ingedient 5", @"Ingedient 6", nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

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
//                                           NSLog(@"Picker: %@", picker);
//                                           NSLog(@"Selected Index: %ld", (long)selectedIndex);
                                           NSLog(@"Selected Value: %@", selectedValue);
                                           [self showQuantityPicker:sender];
                                       }
                                     cancelBlock:^(ActionSheetStringPicker *picker) {
                                         NSLog(@"Block Picker Canceled");
                                     }
                                          origin:sender];

}

//Show custom quantity picker. Triggered after selecting ingredient
-(void)showQuantityPicker:(id)sender {
    CustomPickerDelegate *delegate = [[CustomPickerDelegate alloc] init];
    NSNumber *yass1 = @0;
    NSNumber *yass2 = @0;
    NSArray *initialSelections = @[yass1, yass2];
    [ActionSheetCustomPicker showPickerWithTitle:@"Select Quantity"
                                        delegate:delegate
                                showCancelButton:YES
                                          origin:sender
                               initialSelections:initialSelections];
    
}

//Show Timer Picker
-(IBAction)showTimerPicker:(id)sender {
    buttonSender = sender;
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Is timer over 24 hours?"
                                                             delegate:self
                                                    cancelButtonTitle:@"Cancel"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"Yes", @"No", nil];
    
    actionSheet.tag = 200;
    
    [actionSheet showInView:self.view];
    
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
                                            action:@selector(tempSelected)
                                            origin:sender];

}

-(void)tempSelected {
    NSLog(@"Temp selected");
}

#pragma mark - action sheet delegate

//Grab action sheet actions via delegate method
-(void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex{
    if (actionSheet.tag == 100) {
        NSLog(@"Recipe Type");
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

//Show countdown picker. Triggered from selecting No to over 24 hour ActionSheet
-(void)showCountdownPicker:(id)sender {
    //Create picker and set to temer mode
    actionSheetPicker = [[ActionSheetDatePicker alloc] initWithTitle:@"Under 24 hours"
                                                      datePickerMode:UIDatePickerModeCountDownTimer
                                                        selectedDate:nil
                                                           doneBlock:^(ActionSheetDatePicker *picker, id dateSelected, id origin) {
                                                               NSLog(@"dateSelected: %@", dateSelected);
                                                               //                                           self.counDownTextField.text = [selectedDate stringValue];
                                                               NSLog(@"picker.countDownDuration, %f", picker.countDownDuration);
                                                               //                                           self.counDownTextField.text = [NSString stringWithFormat:@"%f", picker.countDownDuration];
                                                           } cancelBlock:^(ActionSheetDatePicker *picker) {
                                                               NSLog(@"Cancel clicked");
                                                           } origin:sender];
    [(ActionSheetDatePicker *) actionSheetPicker setCountDownDuration:120];
    //actionSheetPicker.hideCancel = YES;
    [actionSheetPicker showActionSheetPicker];
    
}

//Show custom picker. Triggered from selecting Yes to over 24 hour ActionSheet
-(void)showCustomTimePicker:(id)sender {
    CustomTimerPickerDelegate *timerDelegate = [[CustomTimerPickerDelegate alloc] init];
    NSNumber *comp0 = @0;
    NSNumber *comp1 = @0;
    NSNumber *comp2 = @0;
    NSNumber *comp3 = @0;
    NSNumber *comp4 = @0;
    NSNumber *comp5 = @0;
    NSArray *initialSelections = @[comp0, comp1, comp2, comp3, comp4, comp5];
//    [ActionSheetCustomPicker showPickerWithTitle:@"Select Time"
//                                        delegate:timerDelegate
//                                showCancelButton:YES
//                                          origin:sender
//                               initialSelections:initialSelections];
    ActionSheetCustomPicker *customPicker = [[ActionSheetCustomPicker alloc] initWithTitle:@"Select Time" delegate:timerDelegate showCancelButton:YES origin:sender initialSelections:initialSelections];
    
    [customPicker showActionSheetPicker];
    
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
