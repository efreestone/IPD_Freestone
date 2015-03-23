// Elijah Freestone
// IPD1 1503
// Week 3
// March 18th, 2015

//
//  CustomTableViewCell.h
//  MyBrewLogV1
//
//  Created by Elijah Freestone on 3/21/15.
//  Copyright (c) 2015 Elijah Freestone. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomTableViewCell : UITableViewCell

//Declare cell labels and image
@property (strong, nonatomic) IBOutlet UIImageView *cellImage;
@property (strong, nonatomic) IBOutlet UILabel *recipeNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *detailsLabel;

@end
