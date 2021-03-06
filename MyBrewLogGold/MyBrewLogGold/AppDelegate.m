// Elijah Freestone
// IPY 1504
// Week 4 - Release Candidate
// April 26th, 2015

//
//  AppDelegate.m
//  MyBrewLogGold
//
//  Created by Elijah Freestone on 4/26/15.
//  Copyright (c) 2015 Elijah Freestone. All rights reserved.
//

#import "AppDelegate.h"
#import "TimersViewController.h"
#import "BrowseViewController.h"
#import <Parse/Parse.h>

@interface AppDelegate () {
    TimersViewController *timerVC;
    NSDate *fireDateOne;
    NSDate *fireDateTwo;
    NSDate *pauseStartOne;
    NSDate *pauseStartTwo;
    NSUserDefaults *userDefaults;
    NSString *timerOneDesc;
    NSString *timerTwoDesc;
}

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    userDefaults = [NSUserDefaults standardUserDefaults];
    // [Optional] Power your app with Local Datastore. For more info, go to
    // https://parse.com/docs/ios_guide#localdatastore/iOS
        [Parse enableLocalDatastore];
    
    // Initialize Parse.
    [Parse setApplicationId:@"HFCzzZqkKhg4PrVoCRQSJmRlCGCUFi1DckNMbx4D"
                  clientKey:@"VJOEAlb0WMoPpvzdcwqxzAOTTBxr8eEAf9OyTAmw"];
    
    // [Optional] Track statistics around application opens.
    [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
    
    if ([UIApplication instancesRespondToSelector:@selector(registerUserNotificationSettings:)]) {
        [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert|UIUserNotificationTypeSound categories:nil]];
    }
    
    // Override point for customization after application launch.
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
    if (timerVC.firstTimer != nil) {
        //Start local notification for timer
        [timerVC startLocalNotification:timerVC.timerDate withDescription:timerVC.oneDescription];
        //Grab dates to be saved in user defaults
        fireDateOne = timerVC.firstTimer.fireDate;
        pauseStartOne = [NSDate date];
        timerOneDesc = timerVC.oneDescriptionLabel.text;
        //Invalidate timer
        [timerVC.firstTimer invalidate];
        //Set dates in user defaults
        [userDefaults setObject:fireDateOne forKey:@"fireDateOne"];
        [userDefaults setObject:pauseStartOne forKey:@"pauseStartOne"];
        [userDefaults setObject:timerOneDesc forKey:@"timerOneDesc"];
    }
    if (timerVC.secondTimer != nil) {
        //Start local notification for timer
        [timerVC startLocalNotification:timerVC.timerDateTwo withDescription:timerVC.twoDescription];
        //Grab dates to be saved in user defaults
        fireDateTwo = timerVC.secondTimer.fireDate;
        pauseStartTwo = [NSDate date];
        timerTwoDesc = timerVC.twoDescriptionLabel.text;
        //Invalidate timer
        [timerVC.secondTimer invalidate];
        //Set dates in user defaults
        [userDefaults setObject:fireDateTwo forKey:@"fireDateTwo"];
        [userDefaults setObject:pauseStartTwo forKey:@"pauseStartTwo"];
        [userDefaults setObject:timerTwoDesc forKey:@"timerTwoDesc"];
    }
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    self.eventManager = [[EventManager alloc] init];
    
    UITabBarController *tabController = (UITabBarController *)self.window.rootViewController;
    
    timerVC = (TimersViewController *)[[tabController viewControllers] objectAtIndex:2];
    
    // Construct URL to sound file
    NSString *path = [NSString stringWithFormat:@"%@/bell.mp3", [[NSBundle mainBundle] resourcePath]];
    NSURL *soundUrl = [NSURL fileURLWithPath:path];
    timerVC.alarmPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:soundUrl error:nil];
    
    if ([userDefaults objectForKey:@"fireDateOne"]) {
        fireDateOne = [userDefaults objectForKey:@"fireDateOne"];
        pauseStartOne = [userDefaults objectForKey:@"pauseStartOne"];
    }
    if ([userDefaults objectForKey:@"fireDateTwo"]) {
        fireDateTwo = [userDefaults objectForKey:@"fireDateTwo"];
        pauseStartTwo = [userDefaults objectForKey:@"pauseStartTwo"];
    }
    
    if ([fireDateOne timeIntervalSinceNow] < 0.0) {
        NSTimeInterval secondsOne = -1 * [pauseStartOne timeIntervalSinceNow];
        //NSDate *minusDate = [fireDateOne dateByAddingTimeInterval:secondsOne];
        NSLog(@"Fire Date has NOT passed, seconds = %f", secondsOne);
        
        NSDate *newFire = [fireDateOne initWithTimeInterval:secondsOne sinceDate:[NSDate date]];
        double newFireSeconds = -[newFire timeIntervalSinceDate:[NSDate date]] * 86400;
        
        NSLog(@"Now = %@", [NSDate date]);
        
        NSLog(@"new fire seconds = %f", newFireSeconds);
    } else {
        NSLog(@"Fire Date has passed");
    }
    
    if (fireDateTwo > [NSDate date]) {
        
    }
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
