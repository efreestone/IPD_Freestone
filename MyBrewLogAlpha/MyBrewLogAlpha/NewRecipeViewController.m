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

#pragma mark - Pickers
//Using ActionSheetPicker, an open source lib. Found at https://github.com/skywinder/ActionSheetPicker-3.0

//Show Recipe Type Picker
-(IBAction)showRecipeTypePicker:(id)sender {
    //Create picker and fill with Recipe Type array
//    [ActionSheetStringPicker showPickerWithTitle:@"Select a Recipe Type"
//                                            rows:recipeTypes
//                                initialSelection:0
//                                       doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
////                                           NSLog(@"Picker: %@", picker);
////                                           NSLog(@"Selected Index: %ld", (long)selectedIndex);
//                                           NSLog(@"Selected Value: %@", selectedValue);
//                                       }
//                                     cancelBlock:^(ActionSheetStringPicker *picker) {
//                                         NSLog(@"Block Picker Canceled");
//                                     }
//                                          origin:sender];
    
    //Create ActionSheet for recipe types
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Recipe Type"
                                                             delegate:self
                                                    cancelButtonTitle:@"Cancel"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:nil];
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
//    [ActionSheetStringPicker showPickerWithTitle:@"Add Ingredient"
//                                            rows:ingredientArray
//                                initialSelection:0
//                                       doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
////                                           NSLog(@"Picker: %@", picker);
////                                           NSLog(@"Selected Index: %ld", (long)selectedIndex);
//                                           NSLog(@"Selected Value: %@", selectedValue);
//                                       }
//                                     cancelBlock:^(ActionSheetStringPicker *picker) {
//                                         NSLog(@"Block Picker Canceled");
//                                     }
//                                          origin:sender];
    CustomPickerDelegate *delegate = [[CustomPickerDelegate alloc] init];
    NSNumber *yass1 = @0;
    NSNumber *yass2 = @0;
    NSArray *initialSelections = @[yass1, yass2];
    [ActionSheetCustomPicker showPickerWithTitle:@"Select Ingredient"
                                        delegate:delegate
                                showCancelButton:YES
                                          origin:sender
                               initialSelections:initialSelections];

}

//Show Timer Picker
-(IBAction)showTimerPicker:(id)sender {
//    //Create picker and set to temer mode
//    actionSheetPicker = [[ActionSheetDatePicker alloc] initWithTitle:@""
//                                  datePickerMode:UIDatePickerModeCountDownTimer
//                                    selectedDate:nil
//                                       doneBlock:^(ActionSheetDatePicker *picker, id selectedDate, id origin) {
//                                           NSLog(@"selectedDate: %@", selectedDate);
////                                           self.counDownTextField.text = [selectedDate stringValue];
//                                           NSLog(@"picker.countDownDuration, %f", picker.countDownDuration);
////                                           self.counDownTextField.text = [NSString stringWithFormat:@"%f", picker.countDownDuration];
//                                       } cancelBlock:^(ActionSheetDatePicker *picker) {
//                                           NSLog(@"Cancel clicked");
//                                       } origin:sender];
//    [(ActionSheetDatePicker *) actionSheetPicker setCountDownDuration:120];
//    //actionSheetPicker.hideCancel = YES;
//    [actionSheetPicker showActionSheetPicker];
    
//    CustomTimerPickerDelegate *timerDelegate = [[CustomTimerPickerDelegate alloc] init];
//    NSNumber *yass0 = @0;
//    NSNumber *yass1 = @0;
//    NSNumber *yass2 = @0;
//    NSNumber *yass3 = @0;
//    NSNumber *yass4 = @60;
//    NSArray *initialSelections = @[yass0, yass1, yass2, yass3, yass4];
//    [ActionSheetCustomPicker showPickerWithTitle:@"Select Time"
//                                        delegate:timerDelegate
//                                showCancelButton:YES
//                                          origin:sender
//                               initialSelections:initialSelections];
    
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

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (actionSheet.tag == 100) {
        NSLog(@"Recipe Type");
    } else if (actionSheet.tag == 200) {
        NSLog(@"Timer length");
    } else {
        NSLog(@"Something else selected");
    }
    
    NSLog(@"Index = %ld - Title = %@", (long)buttonIndex, [actionSheet buttonTitleAtIndex:buttonIndex]);
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
