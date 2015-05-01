// Elijah Freestone
// IPY 1504
// Week 4 - Release Candidate
// April 26th, 2015

//
//  AppDelegate.h
//  MyBrewLogGold
//
//  Created by Elijah Freestone on 4/26/15.
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

