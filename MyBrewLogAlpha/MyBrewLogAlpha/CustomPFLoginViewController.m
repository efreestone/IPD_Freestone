// Elijah Freestone
// IPY 1504
// Week 1 - Alpha
// March 30th, 2015

//
//  CustomPFLoginViewController.m
//  MyBrewLogAlpha
//
//  Created by Elijah Freestone on 3/30/15.
//  Copyright (c) 2015 Elijah Freestone. All rights reserved.
//

#import "CustomPFLoginViewController.h"

@interface CustomPFLoginViewController ()

@end

@implementation CustomPFLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //Create blank view to cover default logo
    UIView *blankRect=[[UIView alloc] initWithFrame:CGRectMake(0, 0, self.logInView.logo.frame.size.width + 10, self.logInView.logo.frame.size.height + 10)];
    [blankRect setBackgroundColor:self.logInView.backgroundColor];
    [self.logInView.logo addSubview:blankRect];
    
    //Set logo
    UIImageView *logoImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"my-logo.png"]];
    [logoImage setContentMode:UIViewContentModeScaleAspectFill];
    [logoImage setFrame:CGRectMake(0,0,self.logInView.logo.frame.size.width,self.logInView.logo.frame.size.height)];
    [self.logInView.logo addSubview:logoImage];
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
