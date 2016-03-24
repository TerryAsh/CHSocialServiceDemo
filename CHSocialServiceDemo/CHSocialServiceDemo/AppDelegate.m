//
//  AppDelegate.m
//  CHSocialServiceDemo
//
//  Created by Chausson on 16/3/24.
//  Copyright © 2016年 Chausson. All rights reserved.
//

#import "AppDelegate.h"
#import "CHSocialService.h"
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [CHSocialServiceCenter setUmengAppkey:@"53290df956240b6b4a0084b3"];
    [[CHSocialServiceCenter shareInstance] configurationAppKey:nil AppIdentifier:@"wxdc1e388c3822c80b" secret:@"a393c1527aaccb95f3a4c88d6d1455f6" redirectURL:nil sourceURL:@"http://www.umeng.com/social" type:CHSocialWeChat];
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
