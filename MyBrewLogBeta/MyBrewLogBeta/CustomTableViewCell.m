// Elijah Freestone
// IPY 1504
// Week 2 - Beta
// April 5th, 2015

//
//  CustomTableViewCell.m
//  MyBrewLogBeta
//
//  Created by Elijah Freestone on 4/5/15.
//  Copyright (c) 2015 Elijah Freestone. All rights reserved.
//

#import "CustomTableViewCell.h"

@implementation CustomTableViewCell

//Synthesize for getter/setter
@synthesize cellImage, recipeNameLabel, detailsLabel;

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
