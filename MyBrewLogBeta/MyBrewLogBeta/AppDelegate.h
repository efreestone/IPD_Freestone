// Elijah Freestone
// IPY 1504
// Week 2 - Beta
// April 5th, 2015

//
//  AppDelegate.h
//  MyBrewLogBeta
//
//  Created by Elijah Freestone on 4/5/15.
//  Copyright (c) 2015 Elijah Freestone. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EventManager.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) EventManager *eventManager;

@end

