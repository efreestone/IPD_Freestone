// Elijah Freestone
// IPY 1504
// Week 3 - Release Candidate
// April 17th, 2015

//
//  BrowseDetailsViewController.h
//  MyBrewLogRC
//
//  Created by Elijah Freestone on 4/17/15.
//  Copyright (c) 2015 Elijah Freestone. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface BrowseDetailsViewController : UIViewController

@property (strong, nonatomic) IBOutlet UIButton *shareButton;
@property (strong, nonatomic) IBOutlet UIButton *favoriteButton;

@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UILabel *usernameLabel;
@property (strong, nonatomic) IBOutlet UITextView *ingredientsTV;
@property (strong, nonatomic) IBOutlet UITextView *instructionsTV;

@property (strong, nonatomic) NSString *passedName;
@property (strong, nonatomic) NSString *passedType;
@property (strong, nonatomic) NSString *passedIngredients;
@property (strong, nonatomic) NSString *passedInstructions;
@property (strong, nonatomic) NSString *passedUsername;
@property (strong, nonatomic) NSString *passedObjectID;
@property (strong, nonatomic) PFObject *passedObject;

@end
