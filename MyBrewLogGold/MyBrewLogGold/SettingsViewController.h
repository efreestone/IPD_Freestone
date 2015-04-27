// Elijah Freestone
// IPY 1504
// Week 4 - Release Candidate
// April 26th, 2015

//
//  SettingsViewController.h
//  MyBrewLogGold
//
//  Created by Elijah Freestone on 4/26/15.
//  Copyright (c) 2015 Elijah Freestone. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyRecipeViewController.h"

@interface SettingsViewController : UITableViewController

@property (strong, nonatomic) IBOutlet UIButton *logOutButton;
@property (strong, nonatomic) IBOutlet UIButton *editUserButton;
@property (strong, nonatomic) IBOutlet UIButton *infoButton;

@property (strong, nonatomic) IBOutlet UISwitch *autoSyncSwitch;
@property (strong, nonatomic) IBOutlet UISwitch *editRecipeSwitch;
@property (strong, nonatomic) IBOutlet UISwitch *publicSwitch;
@property (strong, nonatomic) IBOutlet UISegmentedControl *unitsSegment;

-(IBAction)unitsSegmentIndexChanged:(id)sender;

@end
