// Elijah Freestone
// IPY 1504
// Week 1 - Alpha
// March 30th, 2015

//
//  BrowseDetailsViewController.m
//  MyBrewLogAlpha
//
//  Created by Elijah Freestone on 3/30/15.
//  Copyright (c) 2015 Elijah Freestone. All rights reserved.
//

#import "BrowseDetailsViewController.h"

@interface BrowseDetailsViewController ()

@end

@implementation BrowseDetailsViewController

//Synthesize for getters/setters
@synthesize ingredientsTV, instructionsTV;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSString *testString = @"ingredient 1 \ningredient 2 \ningredient 3 \ningredient 4 \ningredient 5 \ningredient 6 \ningredient 7 \ningredient 8 \ningredient 9 \ningredient 10";
    
    ingredientsTV.text = testString;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(IBAction)recipeCopied:(id)sender {
    NSString *titleString = @"Copy Recipe";
    NSString *alertMessage = @"Recipe would have copied to My Recipes, however this feature is not functional yet";
    [self showAlert:alertMessage withTitle:titleString];
}

-(IBAction)shareClicked:(id)sender {
    NSString *titleString = @"Share Recipe";
    NSString *alertMessage = @"Recipe would have been shared via social networks, however this feature is not functional yet";
    [self showAlert:alertMessage withTitle:titleString];
}

-(IBAction)favoriteClicked:(id)sender {
    NSString *titleString = @"Favorite Recipe";
    NSString *alertMessage = @"Recipe would have been added to Favorite Recipes, however this feature is not functional yet";
    [self showAlert:alertMessage withTitle:titleString];
}

//Method to create and show alert view
-(void)showAlert:(NSString *)alertMessage withTitle:(NSString *)titleString {
    UIAlertView *copyAlert = [[UIAlertView alloc] initWithTitle:titleString message:alertMessage delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    //Show alert
    [copyAlert show];
}

@end
