//
//  AppDelegate.m
//  Bang
//
//  Created by yyx on 15/11/11.
//  Copyright © 2015年 saint. All rights reserved.
//

#import "AppDelegate.h"
#import <MAMapKit/MAMapKit.h>
#import <YTKNetwork/YTKNetworkConfig.h>
#import <Bugly/CrashReporter.h>
#import "ViewController.h"
#import "MainViewController.h"
#import <AMapSearchKit/AMapSearchServices.h>

@interface AppDelegate ()

@end

@implementation AppDelegate

/**
 *初始化地图key
 */
- (void) initAMap{
    [MAMapServices sharedServices].apiKey = kAMapKey;
    [AMapSearchServices sharedServices].apiKey = kAMapKey;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    _window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    _window.backgroundColor = [UIColor whiteColor];
    
    [DDLog addLogger:[DDTTYLogger sharedInstance]]; // TTY = Xcode console
    [DDLog addLogger:[DDASLLogger sharedInstance]]; // ASL = Apple System Logs
    [[DDTTYLogger sharedInstance] setColorsEnabled:YES];
    
    YTKNetworkConfig *config = [YTKNetworkConfig sharedInstance];
    config.baseUrl = kServiceUrl;

    [[CrashReporter sharedInstance] enableLog:YES];
    [[CrashReporter sharedInstance] installWithAppId:@"900008150"];
    
    [self initAMap];
    
    //ViewController *rootViewController = [[ViewController alloc] init];
    MainViewController *rootViewController = [[MainViewController alloc] init];
    UINavigationController *rootNavigation = [[UINavigationController alloc] initWithRootViewController:rootViewController];
    _window.rootViewController = rootNavigation;
    //DDLogDebug(@"w1w1w1w1%@",_window);
    [_window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
