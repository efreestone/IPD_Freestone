// Elijah Freestone
// IPY 1504
// Week 2 - Beta
// April 5th, 2015

//
//  CustomPickerDelegate.h
//  MyBrewLogBeta
//
//  Created by Elijah Freestone on 4/5/15.
//  Copyright (c) 2015 Elijah Freestone. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ActionSheetCustomPickerDelegate.h"

@interface CustomPickerDelegate : NSObject <ActionSheetCustomPickerDelegate> {
    NSArray *measurementArray;
    NSArray *ingredientArray;
    NSMutableArray *amountArray;
}

@property (nonatomic, strong) NSString *selectedMeasurement;
@property (nonatomic, strong) NSString *selectedIngredient;

@end
