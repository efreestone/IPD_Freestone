// Elijah Freestone
// IPY 1504
// Week 2 - Beta
// April 5th, 2015

//
//  BrowseDetailsViewController.m
//  MyBrewLogBeta
//
//  Created by Elijah Freestone on 4/5/15.
//  Copyright (c) 2015 Elijah Freestone. All rights reserved.
//

#import "BrowseDetailsViewController.h"
#import "NewRecipeViewController.h"

@interface BrowseDetailsViewController () {
    NSArray *recipesArray;
    NSArray *listItems;
    NSString *usernameString;
}

@end

@implementation BrowseDetailsViewController

//Synthesize for getters/setters
@synthesize nameLabel, usernameLabel, ingredientsTV, instructionsTV;
@synthesize passedObject, passedName, passedType, passedIngredients, passedUsername, passedInstructions, passedObjectID;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //Set textviews with passed data
    nameLabel.text = passedName;
    ingredientsTV.text = passedIngredients;
    instructionsTV.text = passedInstructions;
    //Grab username and display
    usernameString = [passedObject objectForKey:@"createdBy"];
    usernameLabel.text = [NSString stringWithFormat:@"By: %@", usernameString];
    
    //Set rounded corners on ing and inst textviews
    [[ingredientsTV layer] setBorderColor:[[UIColor lightGrayColor] CGColor]];
    [[ingredientsTV layer] setBorderWidth:0.5];
    [[ingredientsTV layer] setCornerRadius:7.5];
    
    [[instructionsTV layer] setBorderColor:[[UIColor lightGrayColor] CGColor]];
    [[instructionsTV layer] setBorderWidth:0.5];
    [[instructionsTV layer] setCornerRadius:7.5];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//Share button clicked
-(IBAction)shareClicked:(id)sender {
    NSString *titleString = @"Share Recipe";
    NSString *alertMessage = @"Recipe would have been shared via social networks, however this feature is not functional yet";
    [self showAlert:alertMessage withTitle:titleString];
}

//Method to create and show alert view
-(void)showAlert:(NSString *)alertMessage withTitle:(NSString *)titleString {
    UIAlertView *copyAlert = [[UIAlertView alloc] initWithTitle:titleString message:alertMessage delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    //Show alert
    [copyAlert show];
}

//Set object to favorites when fav selected
-(IBAction)favoriteSelected:(id)sender {
    PFQuery *editQuery = [PFQuery queryWithClassName:@"newRecipe"];
    [editQuery getObjectInBackgroundWithId:passedObjectID block:^(PFObject *favObject, NSError *error) {
        [favObject addUniqueObject:[PFUser currentUser].objectId forKey:@"favorites"];
        [favObject saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (!error) {
                NSLog(@"Favorited Success");
                //Create and show an alert
                NSString *titleString = @"Favorite Recipe";
                NSString *alertMessage = @"Recipe added to favorites. Select Favorite in the Browse Sort to see your Favorite Recipes";
                [self showAlert:alertMessage withTitle:titleString];
            } else {
                NSLog(@"Favorited ERROR");
            }
        }];
    }];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"DetailsCopy"]) {
        //Get VC and set items for passed object
        NewRecipeViewController *newRecipeVC = segue.destinationViewController;
        newRecipeVC.passedName = passedName;
        newRecipeVC.passedType = passedType;
        newRecipeVC.passedIngredients = passedIngredients;
        newRecipeVC.passedInstructions = passedInstructions;
        newRecipeVC.passedUsername = usernameString;
        newRecipeVC.passedObjectID = passedObjectID;
        newRecipeVC.passedObject = passedObject;
        newRecipeVC.isCopy = YES;
    }
}


@end
