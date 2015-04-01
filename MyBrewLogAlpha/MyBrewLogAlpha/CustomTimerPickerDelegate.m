// Elijah Freestone
// IPY 1504
// Week 1 - Alpha
// March 30th, 2015

//
//  CustomTimerPickerDelegate.m
//  MyBrewLogAlpha
//
//  Created by Elijah Freestone on 3/30/15.
//  Copyright (c) 2015 Elijah Freestone. All rights reserved.
//

#import "CustomTimerPickerDelegate.h"

@implementation CustomTimerPickerDelegate

- (id)init
{
    if (self = [super init]) {
        monthArray = [[NSMutableArray alloc] init];
        weekArray = [[NSMutableArray alloc] init];
        dayArray = [[NSMutableArray alloc] init];
//        hourArray = [[NSMutableArray alloc] init];
//        minuteArray = [[NSMutableArray alloc] init];
        
        for(int i = 0; i < 13; i++) {
            NSString *stringVal = [NSString stringWithFormat:@"%d", i];
            //Create array with 12 months
            if (i < 13)
            {
                [monthArray addObject:stringVal];
            }
            //Create array with 4 weeks
            if (i < 5) {
                [weekArray addObject:stringVal];
            }
            //Create array with 7 days
            if (i < 8) {
                [dayArray addObject:stringVal];
            }
//            //Creat array with 24 hours
//            if (i < 25) {
//                [hourArray addObject:stringVal];
//            }
//            
//            //create arrays with 60 minutes
//            [minuteArray addObject:stringVal];
        }

    }
    return self;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 6;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    // Returns
    switch (component) {
        case 0:
            return [monthArray count];
        case 1:
            return 1;
        case 2:
            return [weekArray count];
        case 3:
            return 1;
        case 4:
            return [dayArray count];
        case 5:
            return 1;
        default:
            break;
    }
    return 0;
}

// returns width of column and height of row for each component.
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    switch (component) {
        case 0:
            return 35.0f;
        case 1:
            return 50.0f;
        case 2:
            return 35.0f;
        case 3:
            return 50.0f;
        case 4:
            return 40.0f;
        case 5:
            return 55.0f;
        default:break;
    }
    return 0;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    [pickerView sizeToFit];
    switch (component) {
        case 0:
            return monthArray[row];
        case 1:
            return @"-M-";
        case 2:
            return weekArray[row];
        case 3:
            return @"-W-";
        case 4:
            return dayArray[row];
        case 5:
            return @"-D-";
        default:
            break;
    }
    return nil;
}

@end
