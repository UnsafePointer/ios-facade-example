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
#import "City.h"

NSString *const CacheHelperErrorDomain = @"CacheHelperErrorDomain";
NSString *const MEMORY_CACHE_COUNTRIES_KEY = @"MEMORY_CACHE_COUNTRIES_KEY";
NSString *const MEMORY_CACHE_CITIES_KEY = @"MEMORY_CACHE_CITIES_KEY";
NSString *const MEMORY_CACHE_STATIONS_KEY = @"MEMORY_CACHE_STATIONS_KEY ";
int const MEMORY_CACHE_COST_LIMIT = 100;
int const MEMORY_CACHE_COUNTRIES_COST = 50;
int const MEMORY_CACHE_CITIES_COST = 20;
int const MEMORY_CACHE_STATIONS_COST = 20;

static const int ddLogLevel = LOG_LEVEL_INFO;

@interface CacheHelper ()

- (void)getObjectForKey:(NSString *)key
         withCompletion:(ArrayCompletionBlock)completion;

- (void)storeObject:(id)object
             forKey:(NSString *)key
           withCost:(int)cost
         completion:(BooleanCompletionBlock)completion;

@end

@implementation CacheHelper
{
}

#pragma mark - Private Methods

- (void)getObjectForKey:(NSString *)key
         withCompletion:(ArrayCompletionBlock)completion
{
    [[TMCache sharedCache] objectForKey:key
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

- (void)storeObject:(id)object
             forKey:(NSString *)key
           withCost:(int)cost
         completion:(BooleanCompletionBlock)completion
{
    [[[TMCache sharedCache] memoryCache] setObject:object
                                            forKey:key
                                          withCost:cost
                                             block:^(TMMemoryCache *cache, NSString *key, id object) {
                                                 if (object) {
                                                     completion(TRUE, nil);
                                                 }
                                                 else {
                                                     NSDictionary *userInfo = @{
                                                                                NSLocalizedDescriptionKey: @"Object not available in memory",
                                                                                };
                                                     NSError *error = [NSError errorWithDomain:CacheHelperErrorDomain
                                                                                          code:-13
                                                                                      userInfo:userInfo];
                                                     completion(FALSE, error);
                                                 }
                                             }];
}

#pragma mark - CountriesFetcher Protocol

- (void)getCountriesWithCompletion:(ArrayCompletionBlock)completion
{
    [self getObjectForKey:MEMORY_CACHE_COUNTRIES_KEY
           withCompletion:^(NSArray *array, NSError *error) {
               if (error) {
                   DDLogInfo(@"Countries failed to retrieved from memory with Error %@", [error localizedDescription]);
                   completion(nil, error);
               }
               else {
                   completion(array, nil);
               }
        }];
}

#pragma mark - CountriesStorage Protocol

- (void)storeCountries:(NSArray *)countries
{
    [self storeObject:countries
               forKey:MEMORY_CACHE_COUNTRIES_KEY
             withCost:MEMORY_CACHE_COUNTRIES_COST
           completion:^(BOOL result, NSError *error) {
               if (error) {
                   DDLogInfo(@"Countries failed to stored on memory with Error %@", [error localizedDescription]);
               }
               else {
                   DDLogInfo(@"Countries stored on memory without errors");
               }
        }];
}

#pragma mark - CitiesFetcher Protocol

- (void)getCitiesWithCountry:(Country *)country
                  completion:(ArrayCompletionBlock)completion
{
    [self getObjectForKey:[NSString stringWithFormat:@"%@-%@", MEMORY_CACHE_CITIES_KEY, country.countryCode]
           withCompletion:^(NSArray *array, NSError *error) {
               if (error) {
                   DDLogInfo(@"Cities failed to retrieved from memory with Error %@", [error localizedDescription]);
                   completion(nil, error);
               }
               else {
                   completion(array, nil);
               }
        }];
}

#pragma mark - CitiesStorage Protocol

- (void)storeCities:(NSArray *)cities fromCountry:(Country *)country
{
    [self storeObject:cities
               forKey:[NSString stringWithFormat:@"%@-%@", MEMORY_CACHE_CITIES_KEY, country.countryCode]
             withCost:MEMORY_CACHE_CITIES_COST
           completion:^(BOOL result, NSError *error) {
               if (error) {
                   DDLogInfo(@"Cities failed to stored on memory with Error %@", [error localizedDescription]);
               }
               else {
                   DDLogInfo(@"Cities stored on memory without errors");
               }
        }];
}

#pragma mark - StationsFetcher Protocol

- (void)getStationsWithCity:(City *)city
                 completion:(ArrayCompletionBlock)completion
{
     [self getObjectForKey:[NSString stringWithFormat:@"%@-%@", MEMORY_CACHE_STATIONS_KEY, city.name]
            withCompletion:^(NSArray *array, NSError *error) {
                if (error) {
                    DDLogInfo(@"Stations failed to retrieved from memory with Error %@", [error localizedDescription]);
                    completion(nil, error);
                }
                else {
                    completion(array, nil);
                }
        }];
}

#pragma mark - StationsStorage Protocol

- (void)storeStations:(NSArray *)stations
             fromCity:(City *)city
{
    [self storeObject:stations
               forKey:[NSString stringWithFormat:@"%@-%@", MEMORY_CACHE_STATIONS_KEY, city.name]
             withCost:MEMORY_CACHE_STATIONS_COST
           completion:^(BOOL result, NSError *error) {
               if (error) {
                   DDLogInfo(@"Stations failed to stored on memory with Error %@", [error localizedDescription]);
               }
               else {
                   DDLogInfo(@"Stations stored on memory without errors");
               }
        }];
}

@end
