//
//  CitiesManager.m
//  WeatherApp
//
//  Created by Renzo Crisóstomo on 1/14/14.
//  Copyright (c) 2014 Ruenzuo. All rights reserved.
//

#import <TMCache/TMCache.h>
#import "WeatherAppManager.h"
#import "NetworkingHelper.h"
#import "CacheHelper.h"
#import "DatabaseHelper.h"
#import "ModelUtils.h"
#import "CitiesOperation.h"
#import "Country.h"

@interface WeatherAppManager ()

@property (nonatomic, strong) NetworkingHelper *networkingHelper;
@property (nonatomic, strong) CacheHelper *cacheHelper;
@property (nonatomic, strong) DatabaseHelper *databaseHelper;
@property (nonatomic, strong) NSMutableSet *currentCitiesOperations;
@property (nonatomic, strong) NSOperationQueue *citiesOperationQueue;

@end

static dispatch_once_t oncePredicate;
static const int ddLogLevel = LOG_LEVEL_INFO;

@implementation WeatherAppManager
{
}

#pragma mark - Lazy Loading Pattern

- (NetworkingHelper *)networkingHelper
{
    if (_networkingHelper == nil) {
        _networkingHelper = [[NetworkingHelper alloc] init];
    }
    return _networkingHelper;
}

- (CacheHelper *)cacheHelper
{
    if (_cacheHelper == nil) {
        _cacheHelper = [[CacheHelper alloc] init];
    }
    return _cacheHelper;
}

- (DatabaseHelper *)databaseHelper
{
    if (_databaseHelper == nil) {
        _databaseHelper = [[DatabaseHelper alloc] init];
    }
    return _databaseHelper;
}

- (NSMutableSet *)currentCitiesOperations {
    if (!_currentCitiesOperations) {
        _currentCitiesOperations = [[NSMutableSet alloc] init];
    }
    return _currentCitiesOperations;
}

- (NSOperationQueue *)citiesOperationQueue {
    if (!_citiesOperationQueue) {
        _citiesOperationQueue = [[NSOperationQueue alloc] init];
        _citiesOperationQueue.name = @"Cities Operation Queue";
        _citiesOperationQueue.maxConcurrentOperationCount = 3;
    }
    return _citiesOperationQueue;
}

#pragma mark - Class Methods

+ (WeatherAppManager *)sharedManager
{
    static WeatherAppManager *_sharedManager;
    dispatch_once(&oncePredicate, ^{
        _sharedManager = [[self alloc] init];
    });
    return _sharedManager;
}

#pragma mark - Private Methods

- (void)startBackgroundCitiesFetchingWithCountries:(NSArray *)countries
{
    for (Country *country in countries) {
        if (![[self currentCitiesOperations] containsObject:country]) {
            CitiesOperation *operation = [[CitiesOperation alloc] initWithCountry:country];
            [[self currentCitiesOperations] addObject:country.countryCode];
            [[self citiesOperationQueue] addOperation:operation];
        }   
    }
}

#pragma mark - CitiesOperationDelegate

- (void)citiesOperationDidFinish:(CitiesOperation *)operation
{
    [[self currentCitiesOperations] removeObject:operation.country.countryCode];
}

#pragma mark - CitiesFetcher Protocol

- (void)getCitiesWithCountry:(Country *)country
                  completion:(ArrayCompletionBlock)completion
{
    [[self cacheHelper] getCitiesWithCountry:country
                                  completion:^(NSArray *array, NSError *error) {
        if (array) {
            DDLogInfo(@"Cities retrieved from memory");
            completion(array, nil);
        }
        else {
            [[self databaseHelper] getCitiesWithCountry:country
                                             completion:^(NSArray *array, NSError *error) {
                if ([array count] > 0) {
                    [[self cacheHelper] storeCities:array
                                        fromCountry:country];
                    DDLogInfo(@"Cities retrieved from database");
                    completion(array, nil);
                }
                else {
                    [[self networkingHelper] getCitiesWithCountry:country
                                                       completion:^(NSArray *array, NSError *error) {
                        if (!error) {
                            if (array) {
                                NSArray *sortedArray = [ModelUtils sortCities:array];
                                [ModelUtils relateCities:sortedArray
                                             withCountry:country];
                                [[self cacheHelper] storeCities:sortedArray
                                                    fromCountry:country];
                                [[self databaseHelper] storeCities:sortedArray
                                                       fromCountry:country];
                                DDLogInfo(@"Cities retrieved from network");
                                completion(sortedArray, nil);
                            }
                        }
                        else {
                            completion(nil, error);
                        }
                    }];
                }
            }];
            
        }
    }];
}

#pragma mark - CountriesStorage Protocol

- (void)getCountriesWithCompletion:(ArrayCompletionBlock)completion
{
    [[self cacheHelper] getCountriesWithCompletion:^(NSArray *array, NSError *error) {
        if (array) {
            DDLogInfo(@"Contries retrieved from memory");
            completion(array, nil);
        }
        else {
            [[self databaseHelper] getCountriesWithCompletion:^(NSArray *array, NSError *error) {
                if ([array count] > 0) {
                    [[self cacheHelper] storeCountries:array];
                    DDLogInfo(@"Contries retrieved from database");
                    completion(array, nil);
                }
                else {
                    [[self networkingHelper] getCountriesWithCompletion:^(NSArray *array, NSError *error) {
                        if (!error) {
                            if (array) {
                                NSArray *sortedArray = [ModelUtils sortCountries:array];
                                [[self cacheHelper] storeCountries:sortedArray];
                                [[self databaseHelper] storeCountries:sortedArray];
                                DDLogInfo(@"Contries retrieved from network");
                                completion(sortedArray, nil);
                            }
                        }
                        else {
                            completion(nil, error);
                        }
                    }];
                }
            }];
        }
    }];
}

@end
