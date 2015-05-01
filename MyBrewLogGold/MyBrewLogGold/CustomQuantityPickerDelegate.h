// Elijah Freestone
// IPY 1504
// Week 4 - Release Candidate
// April 26th, 2015

//
//  CustomQuantityPickerDelegate.h
//  MyBrewLogGold
//
//  Created by Elijah Freestone on 4/26/15.
//  Copyright (c) 2015 Elijah Freestone. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ActionSheetCustomPickerDelegate.h"
#import "NewRecipeViewController.h"

@protocol CustomQuantityPickerDelegate <NSObject>

-(void)quantityPicked:(NSString *)formattedQuantity;

@end

@interface CustomQuantityPickerDelegate : NSObject <ActionSheetCustomPickerDelegate>

@property (nonatomic,strong) NewRecipeViewController *myRecipeVC;

@end
