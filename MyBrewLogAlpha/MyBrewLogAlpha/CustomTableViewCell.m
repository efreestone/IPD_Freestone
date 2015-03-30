// Elijah Freestone
// IPD1 1503
// Week 3
// March 18th, 2015

//
//  CustomTableViewCell.m
//  MyBrewLogV1
//
//  Created by Elijah Freestone on 3/21/15.
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
