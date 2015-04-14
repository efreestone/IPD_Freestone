// Elijah Freestone
// IPY 1504
// Week 2 - Beta
// April 5th, 2015

//
//  NewRecipeViewController.h
//  MyBrewLogBeta
//
//  Created by Elijah Freestone on 4/5/15.
//  Copyright (c) 2015 Elijah Freestone. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyRecipeViewController.h"
#import "RecipeDetailsViewController.h"

@interface NewRecipeViewController : UIViewController

-(IBAction)onCancel:(id)sender;
-(IBAction)showRecipeTypePicker:(id)sender;
-(IBAction)showIngredientPicker:(id)sender;
-(IBAction)showTimerPicker:(id)sender;
-(IBAction)showTempPicker:(id)sender;

@property (strong, nonatomic) IBOutlet UIButton *typeButton;
@property (strong, nonatomic) IBOutlet UIButton *batchButton;
@property (strong, nonatomic) IBOutlet UIButton *ingredientButton;
@property (strong, nonatomic) IBOutlet UIButton *tempButton;
@property (strong, nonatomic) IBOutlet UIButton *timerButton;
@property (strong, nonatomic) IBOutlet UIButton *notesButton;

@property (strong, nonatomic) IBOutlet UITextField *recipeNameTF;
@property (strong, nonatomic) IBOutlet UITextView *ingredientsTV;
@property (strong, nonatomic) IBOutlet UITextView *instructionsTV;
@property (strong, nonatomic) MyRecipeViewController *myRecipeVC;
@property (strong, nonatomic) RecipeDetailsViewController *recipeDetailsVC;

@property (strong, nonatomic) NSString *passedName;
@property (strong, nonatomic) NSString *passedType;
@property (strong, nonatomic) NSString *passedIngredients;
@property (strong, nonatomic) NSString *passedInstructions;
@property (strong, nonatomic) NSString *passedObjectID;
@property (strong, nonatomic) PFObject *passedObject;

-(void)quantityPicked:(NSString *)formattedQuantity;
-(void)timerPicked: (NSString *)formattedTime;

@end
