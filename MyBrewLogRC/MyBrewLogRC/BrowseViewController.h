// Elijah Freestone
// IPY 1504
// Week 3 - Release Candidate
// April 17th, 2015

//
//  BrowseViewController.h
//  MyBrewLogRC
//
//  Created by Elijah Freestone on 4/17/15.
//  Copyright (c) 2015 Elijah Freestone. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ParseUI/ParseUI.h>

@interface BrowseViewController : PFQueryTableViewController

//Declare table view
@property (strong, nonatomic) IBOutlet UITableView *browseTableView;

@end
