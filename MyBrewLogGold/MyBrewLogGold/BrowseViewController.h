// Elijah Freestone
// IPY 1504
// Week 4 - Release Candidate
// April 26th, 2015

//
//  BrowseViewController.h
//  MyBrewLogGold
//
//  Created by Elijah Freestone on 4/26/15.
//  Copyright (c) 2015 Elijah Freestone. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ParseUI/ParseUI.h>

@interface BrowseViewController : PFQueryTableViewController

//Declare table view
@property (strong, nonatomic) IBOutlet UITableView *browseTableView;

@property (nonatomic, strong) UISearchController *browseSearchController;
@property (nonatomic, strong) NSMutableArray *browseSearchResults;

@end
