// Elijah Freestone
// IPY 1504
// Week 3 - Release Candidate
// April 17th, 2015

//
//  AppDelegate.h
//  MyBrewLogRC
//
//  Created by Elijah Freestone on 4/17/15.
//  Copyright (c) 2015 Elijah Freestone. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EventManager.h"
//#import "TimersViewController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) EventManager *eventManager;

@property (strong, nonatomic) NSTimer *firstTimer;
@property (strong, nonatomic) NSTimer *secondTimer;

@end

