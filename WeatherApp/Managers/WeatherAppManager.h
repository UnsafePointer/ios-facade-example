//
//  CitiesManager.h
//  WeatherApp
//
//  Created by Renzo Crisóstomo on 1/14/14.
//  Copyright (c) 2014 Ruenzuo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CitiesFetcher.h"
#import "CountriesFetcher.h"
#import "StationsFetcher.h"
#import "CitiesOperation.h"
#import "StationOperation.h"

@interface WeatherAppManager : NSObject <CitiesFetcher, CountriesFetcher, StationsFetcher, CitiesOperationDelegate, StationOperationDelegate>

+ (WeatherAppManager *)sharedManager;
- (void)startBackgroundCitiesFetchingWithCountries:(NSArray *)countries;
- (void)startBackgroundStationFetchingWithCities:(NSArray *)cities;

@end
