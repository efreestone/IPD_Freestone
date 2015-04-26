// Elijah Freestone
// IPY 1504
// Week 4 - Release Candidate
// April 26th, 2015

//
//  MyRecipeViewController.h
//  MyBrewLogGold
//
//  Created by Elijah Freestone on 4/26/15.
//  Copyright (c) 2015 Elijah Freestone. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import <ParseUI/ParseUI.h>

@interface MyRecipeViewController : PFQueryTableViewController

//Declare table view
@property (strong, nonatomic) IBOutlet UITableView *myTableView;

@property (nonatomic, strong) UISearchController *recipeSearchController;
@property (nonatomic, strong) NSMutableArray *recipeSearchResults;

-(void)refreshTable;

@end
