//
//  AppDelegate.m
//  WeatherApp
//
//  Created by Renzo Crisóstomo on 1/14/14.
//  Copyright (c) 2014 Ruenzuo. All rights reserved.
//

#import <TMCache/TMCache.h>
#import <AFNetworking/AFNetworkActivityIndicatorManager.h>
#import "CacheHelper.h"
#import "AppDelegate.h"

@implementation AppDelegate

-           (BOOL)application:(UIApplication *)application
didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [[[TMCache sharedCache] memoryCache] setCostLimit:MEMORY_CACHE_COST_LIMIT];
    [MagicalRecord setupAutoMigratingCoreDataStack];
    [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    [MagicalRecord cleanUp];
}

@end
