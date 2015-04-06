// Elijah Freestone
// IPY 1504
// Week 2 - Beta
// April 5th, 2015

//
//  SettingsViewController.m
//  MyBrewLogBeta
//
//  Created by Elijah Freestone on 4/5/15.
//  Copyright (c) 2015 Elijah Freestone. All rights reserved.
//

#import "SettingsViewController.h"
#import "MyRecipeViewController.h"
#import <Parse/Parse.h>

@interface SettingsViewController ()

@end

@implementation SettingsViewController {
    MyRecipeViewController *myRecipes;
}

- (void)viewDidLoad {
//    myRecipes = (MyRecipeViewController*)self.window.rootViewController;
//    UIViewController *rootVC = self.parentViewController;
//    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main"
//                                                         bundle: nil];
//    myRecipes = [storyboard instantiateViewControllerWithIdentifier:@"MyRecipe"];
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//Log user out
-(IBAction)onLogOutClick:(id)sender {
    //Change tab to My Recipes and log out user. This also triggers presenting the login screen
    [self.tabBarController setSelectedIndex:0];
    [PFUser logOut];
    
    NSLog(@"user logged out from settings");
}

//Create alert with 2 text fields for changing email and/or username
-(IBAction)onEditUserClick:(id)sender {
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Edit User"
                                                   message:@"Reset username and/or email. Please use \"Forgot Password?\" on the login screen to reset password. Requires Email"
                                                  delegate:self cancelButtonTitle:@"Cancel"
                                         otherButtonTitles:@"Save", nil];
    
    alert.alertViewStyle = UIAlertViewStyleLoginAndPasswordInput;
    [alert textFieldAtIndex:1].secureTextEntry = NO;
    [alert textFieldAtIndex:0].placeholder = @"Enter New Email";
    [alert textFieldAtIndex:1].placeholder = @"Enter New Username";
    [alert show];
}

//Capture text input from alertview and reset username and/or email
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    NSString *newEmail = [alertView textFieldAtIndex:0].text;
    NSString *newUsername = [alertView textFieldAtIndex:1].text;
    if (buttonIndex == 1) {
        if (newEmail.length != 0) {
            [[PFUser currentUser] setEmail:newEmail];
            [[PFUser currentUser] saveInBackground];
        }
        if (newUsername.length != 0) {
            [[PFUser currentUser] setUsername:newUsername];
            [[PFUser currentUser] saveInBackground];
        }
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
