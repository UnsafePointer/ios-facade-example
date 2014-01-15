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
#import "Country.h"

NSString *const CacheHelperErrorDomain = @"CacheHelperErrorDomain";
NSString *const MEMORY_CACHE_COUNTRIES_KEY = @"MEMORY_CACHE_COUNTRIES_KEY";
int const MEMORY_CACHE_COST_LIMIT = 100;
int const MEMORY_CACHE_COUNTRIES_COST = 50;

@interface CacheHelper ()

@end

@implementation CacheHelper
{
}

#pragma mark - CountriesFetcher Protocol

- (void)getCountriesWithCompletion:(ArrayCompletionBlock)completion
{
    [[TMCache sharedCache] objectForKey:@"Countries"
                                  block:^(TMCache *cache, NSString *key, id object) {
                                      if (object) {
                                          completion(object, nil);
                                      }
                                      else {
                                          NSDictionary *userInfo = @{
                                                                     NSLocalizedDescriptionKey: @"Object not available in memory",
                                                                    };
                                          NSError *error = [NSError errorWithDomain:CacheHelperErrorDomain
                                                                               code:-13
                                                                           userInfo:userInfo];
                                          completion(nil, error);
                                      }
                                  }];
}

#pragma mark - CountriesStorage Protocol

- (void)storeCountries:(NSArray *)countries
{
    [[[TMCache sharedCache] memoryCache] setObject:countries
                                            forKey:MEMORY_CACHE_COUNTRIES_KEY
                                          withCost:MEMORY_CACHE_COUNTRIES_COST
                                             block:nil];
}

@end
