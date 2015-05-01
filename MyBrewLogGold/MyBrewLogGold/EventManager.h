// Elijah Freestone
// IPY 1504
// Week 4 - Release Candidate
// April 26th, 2015

//
//  EventManager.h
//  MyBrewLogGold
//
//  Created by Elijah Freestone on 4/26/15.
//  Copyright (c) 2015 Elijah Freestone. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <EventKit/EventKit.h>

@interface EventManager : NSObject

@property (strong, nonatomic) EKEventStore *eventStore;
@property (strong, nonatomic) EKCalendar *recipeCalendar;
@property (nonatomic) BOOL accessGranted;

@end
