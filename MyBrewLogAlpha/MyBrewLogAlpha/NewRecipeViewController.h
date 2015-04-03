// Elijah Freestone
// IPY 1504
// Week 1 - Alpha
// March 30th, 2015

//
//  NewRecipeViewController.h
//  MyBrewLogAlpha
//
//  Created by Elijah Freestone on 3/30/15.
//  Copyright (c) 2015 Elijah Freestone. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyRecipeViewController.h"

@interface NewRecipeViewController : UIViewController

-(IBAction)onCancel:(id)sender;
-(IBAction)showRecipeTypePicker:(id)sender;
-(IBAction)showIngredientPicker:(id)sender;
-(IBAction)showTimerPicker:(id)sender;
-(IBAction)showTempPicker:(id)sender;

@property (strong, nonatomic) IBOutlet UITextField *recipeNameTF;
@property (strong, nonatomic) IBOutlet UITextView *ingredientsTV;
@property (strong, nonatomic) IBOutlet UITextView *instructionsTV;
@property (strong, nonatomic) MyRecipeViewController *myRecipeVC;

-(void)quantityPicked:(NSString *)formattedQuantity;
-(void)timerPicked: (NSString *)formattedTime;

@end
