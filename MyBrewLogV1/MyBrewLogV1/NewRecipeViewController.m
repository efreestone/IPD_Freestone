// Elijah Freestone
// IPD1 1503
// Week 3
// March 18th, 2015

//
//  NewRecipeViewController.m
//  MyBrewLogV1
//
//  Created by Elijah Freestone on 3/22/15.
//  Copyright (c) 2015 Elijah Freestone. All rights reserved.
//

#import "NewRecipeViewController.h"

@interface NewRecipeViewController ()

@end

@implementation NewRecipeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)onCancel:(id)sender {
    //Dismiss view controller
    [self dismissViewControllerAnimated:YES completion:nil];
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
