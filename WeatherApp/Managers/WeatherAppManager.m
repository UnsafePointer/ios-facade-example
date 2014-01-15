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

@interface WeatherAppManager ()

@property (nonatomic, strong) NetworkingHelper *networkingHelper;
@property (nonatomic, strong) CacheHelper *cacheHelper;
@property (nonatomic, strong) DatabaseHelper *databaseHelper;

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

#pragma mark - Class Methods

+ (WeatherAppManager *)sharedManager
{
    static WeatherAppManager *_sharedManager;
    dispatch_once(&oncePredicate, ^{
        _sharedManager = [[self alloc] init];
    });
    return _sharedManager;
}

#pragma mark - CitiesFetcher Protocol

- (void)getCitiesWithCountry:(Country *)country
                  completion:(ArrayCompletionBlock)completion
{
    [[self networkingHelper] getCitiesWithCountry:country completion:^(NSArray *array, NSError *error) {
        if (!error) {
            if (array) {
                DDLogInfo(@"Cities retrieved from network");
                completion(array, nil);
            }
        }
        else {
            completion(nil, error);
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
                                [[self cacheHelper] storeCountries:array];
                                [[self databaseHelper] storeCountries:array];
                                DDLogInfo(@"Contries retrieved from network");
                                completion(array, nil);
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
