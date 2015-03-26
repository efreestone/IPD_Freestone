// Elijah Freestone
// IPD1 1503
// Week 3
// March 18th, 2015

//
//  SettingsViewController.m
//  MyBrewLogV1
//
//  Created by Elijah Freestone on 3/19/15.
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

-(IBAction)onLogOutClick:(id)sender {
    //Change tab to My Recipes and log out user. This also triggers presenting the login screen
    [self.tabBarController setSelectedIndex:0];
    [PFUser logOut];
    
    NSLog(@"user logged out from settings");
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
