// Elijah Freestone
// IPY 1504
// Week 1 - Alpha
// March 30th, 2015

//
//  MyRecipeViewController.h
//  MyBrewLogAlpha
//
//  Created by Elijah Freestone on 3/30/15.
//  Copyright (c) 2015 Elijah Freestone. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import <ParseUI/ParseUI.h>

@interface MyRecipeViewController : PFQueryTableViewController

//Declare table view
@property (strong, nonatomic) IBOutlet UITableView *myTableView;

-(void)refreshTable;

@end
