//
//  CacheHelper.m
//  WeatherApp
//
//  Created by Renzo Crisóstomo on 1/15/14.
//  Copyright (c) 2014 Ruenzuo. All rights reserved.
//

#import <TMCache/TMCache.h>
#import "CacheHelper.h"
#import "Blocks.h"

@implementation CacheHelper

#pragma mark - Public Methods

- (BOOL)objectIsAvailableForKey:(NSString *)key
{
    return [[[TMCache sharedCache] memoryCache] objectForKey:key] || [[[TMCache sharedCache] diskCache] fileURLForKey:key];
}

#pragma mark - Cities Protocol

- (void)getCitiesFromLatitude:(double)latitude
                    longitude:(double)longitude
                   completion:(ArrayCompletionBlock)completion
{
    
}

#pragma mark - Countries Protocol

- (void)getCountriesWithCompletion:(ArrayCompletionBlock)completion
{
    [[TMCache sharedCache] objectForKey:@"Countries"
                                  block:^(TMCache *cache, NSString *key, id object) {
                                      completion(object, nil);
                                  }];
}

@end
