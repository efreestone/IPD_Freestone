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

@end
