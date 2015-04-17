// Elijah Freestone
// IPY 1504
// Week 2 - Beta
// April 5th, 2015

//
//  CustomTimerPickerDelegate.h
//  MyBrewLogBeta
//
//  Created by Elijah Freestone on 4/5/15.
//  Copyright (c) 2015 Elijah Freestone. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ActionSheetCustomPickerDelegate.h"
#import "NewRecipeViewController.h"

@interface CustomTimerPickerDelegate : NSObject <ActionSheetCustomPickerDelegate> {
    NSMutableArray *monthArray;
    NSMutableArray *weekArray;
    NSMutableArray *dayArray;
    NSMutableArray *hourArray;
    NSMutableArray *minuteArray;
    
}

@property (nonatomic, assign) NSInteger monthDigits;
@property (nonatomic, assign) NSInteger weekDigits;
@property (nonatomic, assign) NSInteger dayDigits;
@property (nonatomic,strong) NewRecipeViewController *myRecipeVC;

@end
