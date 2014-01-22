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
#import "StationOperation.h"
#import "Country.h"
#import "City.h"

@interface WeatherAppManager ()

@property (nonatomic, strong) NetworkingHelper *networkingHelper;
@property (nonatomic, strong) CacheHelper *cacheHelper;
@property (nonatomic, strong) DatabaseHelper *databaseHelper;
@property (nonatomic, strong) NSMutableSet *currentCitiesOperations;
@property (nonatomic, strong) NSOperationQueue *citiesOperationQueue;
@property (nonatomic, strong) NSMutableSet *currentStationsOperations;
@property (nonatomic, strong) NSOperationQueue *stationsOperationQueue;

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

- (NSMutableSet *)currentCitiesOperations
{
    if (!_currentCitiesOperations) {
        _currentCitiesOperations = [[NSMutableSet alloc] init];
    }
    return _currentCitiesOperations;
}

- (NSOperationQueue *)citiesOperationQueue
{
    if (!_citiesOperationQueue) {
        _citiesOperationQueue = [[NSOperationQueue alloc] init];
        _citiesOperationQueue.name = @"Cities Operation Queue";
        _citiesOperationQueue.maxConcurrentOperationCount = 3;
    }
    return _citiesOperationQueue;
}

- (NSMutableSet *)currentStationsOperations
{
    if (!_currentStationsOperations) {
        _currentStationsOperations = [[NSMutableSet alloc] init];
    }
    return _currentStationsOperations;
}

- (NSOperationQueue *)stationsOperationQueue
{
    if (!_stationsOperationQueue) {
        _stationsOperationQueue = [[NSOperationQueue alloc] init];
        _stationsOperationQueue.name = @"Stations Operation Queue";
        _stationsOperationQueue.maxConcurrentOperationCount = 3;
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

#pragma mark - Public Methods

- (void)startBackgroundCitiesFetchingWithCountries:(NSArray *)countries
{
    for (Country *country in countries) {
        if (![[self currentCitiesOperations] containsObject:country.countryCode]) {
            CitiesOperation *operation = [[CitiesOperation alloc] initWithCountry:country];
            operation.delegate = self;
            [[self currentCitiesOperations] addObject:country.countryCode];
            [[self citiesOperationQueue] addOperation:operation];
        }   
    }
}

- (void)startBackgroundStationFetchingWithCities:(NSArray *)cities
{
    for (City *city in cities) {
        if (![[self currentStationsOperations] containsObject:city.name]) {
            StationOperation *operation = [[StationOperation alloc] initWithCity:city];
            operation.delegate = self;
            [[self currentStationsOperations] addObject:city.name];
            [[self stationsOperationQueue] addOperation:operation];
        }
    }
}

#pragma mark - CitiesOperationDelegate

- (void)citiesOperationDidFinish:(NSDictionary *)dictionary;
{
    CitiesOperation *operation = [dictionary objectForKey:@"operation"];
    NSArray *cities = [dictionary objectForKey:@"cities"];
    [[self currentCitiesOperations] removeObject:operation.country.countryCode];
    DDLogInfo(@"Remaining cities operations: %d", [[self currentCitiesOperations] count]);
    [self startBackgroundStationFetchingWithCities:cities];
}

#pragma mark - StationsOperationDelegate

- (void)stationsOperationDidFinish:(StationOperation *)operation
{
    [[self currentStationsOperations] removeObject:operation.city.name];
    DDLogInfo(@"Remaining stations operations: %d", [[self currentStationsOperations] count]);
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

#pragma mark - StationsFetcher Protocol

- (void)getStationsWithCity:(City *)city
                 completion:(ArrayCompletionBlock)completion
{
    [[self cacheHelper] getStationsWithCity:city
                                 completion:^(NSArray *array, NSError *error) {
        if (array) {
            DDLogInfo(@"Stations retrieved from memory");
            completion(array, nil);
        }
        else {
            [[self databaseHelper] getStationsWithCity:city
                                            completion:^(NSArray *array, NSError *error) {
                if ([array count] > 0) {
                    [[self cacheHelper] storeStations:array
                                             fromCity:city];
                    DDLogInfo(@"Stations retrieved from database");
                    completion(array, nil);
                }
                else {
                    [[self networkingHelper] getStationsWithCity:city
                                                      completion:^(NSArray *array, NSError *error) {
                        if (!error) {
                            if (array) {
                                NSArray *sortedArray = [ModelUtils sortStations:array];
                                [[self cacheHelper] storeStations:sortedArray
                                                         fromCity:city];
                                [[self databaseHelper] storeStations:sortedArray
                                                            fromCity:city];
                                DDLogInfo(@"Stations retrieved from network");
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
