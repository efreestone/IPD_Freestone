// Elijah Freestone
// IPD1 1503
// Week 3
// March 18th, 2015

//
//  TimersViewController.m
//  MyBrewLogV1
//
//  Created by Elijah Freestone on 3/19/15.
//  Copyright (c) 2015 Elijah Freestone. All rights reserved.
//

#import "TimersViewController.h"

@interface TimersViewController ()

@end

@implementation TimersViewController

@synthesize loadedLabel;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    loadedLabel.textColor = [UIColor redColor];
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

@end
