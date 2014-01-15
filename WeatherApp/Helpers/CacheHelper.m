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
NSString *const MEMORY_CACHE_CITIES_KEY = @"MEMORY_CACHE_CITIES_KEY";
int const MEMORY_CACHE_COST_LIMIT = 100;
int const MEMORY_CACHE_COUNTRIES_COST = 50;
int const MEMORY_CACHE_CITIES_COST = 20;

static const int ddLogLevel = LOG_LEVEL_INFO;

@interface CacheHelper ()

@end

@implementation CacheHelper
{
}

#pragma mark - CitiesFetcher Protocol

- (void)getCitiesWithCountry:(Country *)country
                  completion:(ArrayCompletionBlock)completion
{
    [[TMCache sharedCache] objectForKey:[NSString stringWithFormat:@"%@-%@", MEMORY_CACHE_CITIES_KEY, country.countryCode]
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
                                          DDLogInfo(@"Cities failed to retrieved from memory with Error %@", [error localizedDescription]);
                                          completion(nil, error);
                                      }
                                  }];
}

#pragma mark - CitiesStorage Protocol

- (void)storeCities:(NSArray *)cities fromCountry:(Country *)country
{
    [[[TMCache sharedCache] memoryCache] setObject:cities
                                            forKey:[NSString stringWithFormat:@"%@-%@", MEMORY_CACHE_CITIES_KEY, country.countryCode]
                                          withCost:MEMORY_CACHE_CITIES_COST
                                             block:^(TMMemoryCache *cache, NSString *key, id object) {
                                                 if (object) {
                                                     DDLogInfo(@"Cities stored on memory without errors");
                                                 }
                                                 else {
                                                     NSDictionary *userInfo = @{
                                                                                NSLocalizedDescriptionKey: @"Object not available in memory",
                                                                                };
                                                     NSError *error = [NSError errorWithDomain:CacheHelperErrorDomain
                                                                                          code:-13
                                                                                      userInfo:userInfo];
                                                     DDLogInfo(@"Cities failed to stored on memory with Error %@", [error localizedDescription]);
                                                 }
                                             }];
}

#pragma mark - CountriesFetcher Protocol

- (void)getCountriesWithCompletion:(ArrayCompletionBlock)completion
{
    [[TMCache sharedCache] objectForKey:MEMORY_CACHE_COUNTRIES_KEY
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
                                          DDLogInfo(@"Countries failed to retrieved from memory with Error %@", [error localizedDescription]);
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
                                             block:^(TMMemoryCache *cache, NSString *key, id object) {
                                                 if (object) {
                                                     DDLogInfo(@"Countries stored on memory without errors");
                                                 }
                                                 else {
                                                     NSDictionary *userInfo = @{
                                                                                NSLocalizedDescriptionKey: @"Object not available in memory",
                                                                                };
                                                     NSError *error = [NSError errorWithDomain:CacheHelperErrorDomain
                                                                                          code:-13
                                                                                      userInfo:userInfo];
                                                     DDLogInfo(@"Countries failed to stored on memory with Error %@", [error localizedDescription]);
                                                 }
                                             }];
}

@end
