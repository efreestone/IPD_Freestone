// Elijah Freestone
// IPY 1504
// Week 1 - Alpha
// March 30th, 2015

//
//  CustomPickerDelegate.h
//  MyBrewLogAlpha
//
//  Created by Elijah Freestone on 3/30/15.
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
