// Elijah Freestone
// IPY 1504
// Week 3 - Release Candidate
// April 17th, 2015

//
//  SettingsViewController.h
//  MyBrewLogRC
//
//  Created by Elijah Freestone on 4/17/15.
//  Copyright (c) 2015 Elijah Freestone. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyRecipeViewController.h"

@interface SettingsViewController : UITableViewController

@property (strong, nonatomic) IBOutlet UIButton *logOutButton;
@property (strong, nonatomic) IBOutlet UIButton *editUserButton;
@property (strong, nonatomic) IBOutlet UIButton *infoButton;

@end
