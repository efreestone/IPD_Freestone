// Elijah Freestone
// IPY 1504
// Week 1 - Alpha
// March 30th, 2015

//
//  CustomTimerPickerDelegate.h
//  MyBrewLogAlpha
//
//  Created by Elijah Freestone on 3/30/15.
//  Copyright (c) 2015 Elijah Freestone. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ActionSheetCustomPickerDelegate.h"

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

@end
