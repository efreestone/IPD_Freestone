// Elijah Freestone
// IPY 1504
// Week 2 - Beta
// April 5th, 2015

//
//  BrowseDetailsViewController.h
//  MyBrewLogBeta
//
//  Created by Elijah Freestone on 4/5/15.
//  Copyright (c) 2015 Elijah Freestone. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BrowseDetailsViewController : UIViewController

@property (strong, nonatomic) IBOutlet UIButton *navbarCopyButton;
@property (strong, nonatomic) IBOutlet UIButton *shareButton;
@property (strong, nonatomic) IBOutlet UIButton *favoriteButton;

@property (strong, nonatomic) IBOutlet UITextView *ingredientsTV;
@property (strong, nonatomic) IBOutlet UITextView *instructionsTV;

@end
