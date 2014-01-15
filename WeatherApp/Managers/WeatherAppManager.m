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

@interface WeatherAppManager ()

@property (nonatomic, strong) NetworkingHelper *networkingHelper;
@property (nonatomic, strong) CacheHelper *cacheHelper;

@end

static dispatch_once_t oncePredicate;

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

#pragma mark - Class Methods

+ (WeatherAppManager *)sharedManager
{
    static WeatherAppManager *_sharedManager;
    dispatch_once(&oncePredicate, ^{
        _sharedManager = [[self alloc] init];
    });
    return _sharedManager;
}

#pragma mark - Cities Protocol

- (void)getCitiesFromLatitude:(double)latitude
                    longitude:(double)longitude
                   completion:(ArrayCompletionBlock)completion
{
    
}

#pragma mark - Countries

- (void)getCountriesWithCompletion:(ArrayCompletionBlock)completion
{
    if ([[self cacheHelper] objectIsAvailableForKey:@"Countries"]) {
        [[self cacheHelper] getCountriesWithCompletion:completion];
    }
    else {
        [[self networkingHelper] getCountriesWithCompletion:completion];
    }
}

@end
