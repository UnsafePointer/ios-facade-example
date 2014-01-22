//
//  CacheHelper.h
//  WeatherApp
//
//  Created by Renzo Crisóstomo on 1/15/14.
//  Copyright (c) 2014 Ruenzuo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CitiesFetcher.h"
#import "CountriesFetcher.h"
#import "CountriesStorage.h"
#import "CitiesFetcher.h"
#import "CitiesStorage.h"
#import "StationsFetcher.h"
#import "StationsStorage.h"

extern NSString * const CacheHelperErrorDomain;
extern NSString * const MEMORY_CACHE_COUNTRIES_KEY;
extern NSString * const MEMORY_CACHE_CITIES_KEY;
extern NSString * const MEMORY_CACHE_STATIONS_KEY;
extern int const MEMORY_CACHE_COST_LIMIT;
extern int const MEMORY_CACHE_COUNTRIES_COST;
extern int const MEMORY_CACHE_CITIES_COST;
extern int const MEMORY_CACHE_STATIONS_COST;

@interface CacheHelper : NSObject <CountriesFetcher, CountriesStorage, CitiesFetcher, CitiesStorage, StationsFetcher, StationsStorage>

@end
