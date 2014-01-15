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

@interface DatabaseHelper : NSObject <CountriesFetcher, CountriesStorage, CitiesFetcher, CitiesStorage>

@end
