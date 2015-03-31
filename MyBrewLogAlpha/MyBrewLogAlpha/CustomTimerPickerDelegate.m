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
        hourArray = [[NSMutableArray alloc] init];
        minuteArray = [[NSMutableArray alloc] init];
        
        for(int i=0; i<61; i++)
        {
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
            if (i < 5) {
                [dayArray addObject:stringVal];
            }
            //Creat array with 24 hours
            if (i < 25) {
                [hourArray addObject:stringVal];
            }
            
            //create arrays with 60 minutes
            [minuteArray addObject:stringVal];
        }

    }
    return self;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 5;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    // Returns
    switch (component) {
        case 0:
            return [monthArray count];
        case 1:
            return [weekArray count];
        case 2:
            return [dayArray count];
        case 3:
            return [hourArray count];
        case 4:
            return [minuteArray count];
        default:
            break;
    }
    return 0;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    switch (component) {
        case 0:
            return monthArray[row];
        case 1:
            return weekArray[row];
        case 2:
            return dayArray[row];
        case 3:
            return hourArray[row];
        case 4:
            return minuteArray[row];
        default:
            break;
    }
    return nil;
}

@end
