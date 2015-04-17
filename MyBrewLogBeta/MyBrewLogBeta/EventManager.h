// Elijah Freestone
// IPY 1504
// Week 2 - Beta
// April 5th, 2015

//
//  EventManager.h
//  MyBrewLogBeta
//
//  Created by Elijah Freestone on 4/15/15.
//  Copyright (c) 2015 Elijah Freestone. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <EventKit/EventKit.h>

@interface EventManager : NSObject

@property (strong, nonatomic) EKEventStore *eventStore;
@property (strong, nonatomic) EKCalendar *recipeCalendar;
@property (nonatomic) BOOL accessGranted;

@end
