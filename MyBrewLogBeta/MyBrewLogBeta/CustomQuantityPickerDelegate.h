// Elijah Freestone
// IPY 1504
// Week 2 - Beta
// April 5th, 2015

//
//  CustomQuantityPickerDelegate.h
//  MyBrewLogBeta
//
//  Created by Elijah Freestone on 4/5/15.
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
