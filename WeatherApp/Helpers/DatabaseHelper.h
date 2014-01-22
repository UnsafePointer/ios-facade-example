//
//  DatabaseHelper.h
//  WeatherApp
//
//  Created by Renzo Crisóstomo on 1/15/14.
//  Copyright (c) 2014 Ruenzuo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CountriesFetcher.h"
#import "CountriesStorage.h"
#import "CitiesFetcher.h"
#import "CitiesStorage.h"
#import "StationsFetcher.h"
#import "StationsStorage.h"

@class CountryManagedObject;
@class CityManagedObject;

@interface DatabaseHelper : NSObject <CountriesFetcher, CountriesStorage, CitiesFetcher, CitiesStorage, StationsFetcher, StationsStorage>

- (CountryManagedObject *)getCountryManagedObjectWithCountryCode:(NSString *)countryCode
                                                       inContext:(NSManagedObjectContext *)context;
- (CityManagedObject *)getCityManagedObjectWithName:(NSString *)name
                                          inContext:(NSManagedObjectContext *)context;

@end
