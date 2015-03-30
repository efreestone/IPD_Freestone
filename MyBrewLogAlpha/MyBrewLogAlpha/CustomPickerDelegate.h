// Elijah Freestone
// IPD1 1503
// Week 3
// March 18th, 2015

//
//  CustomPickerDelegate.h
//  MyBrewLogV1
//
//  Created by Elijah Freestone on 3/26/15.
//  Copyright (c) 2015 Elijah Freestone. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ActionSheetCustomPickerDelegate.h"

@interface CustomPickerDelegate : NSObject <ActionSheetCustomPickerDelegate> {
    NSArray *measurementArray;
    NSArray *ingredientArray;
}

@property (nonatomic, strong) NSString *selectedMeasurement;
@property (nonatomic, strong) NSString *selectedIngredient;

@end
