//
//  DatabaseHelper.h
//  WeatherApp
//
//  Created by Renzo Crisóstomo on 1/15/14.
//  Copyright (c) 2014 Ruenzuo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CitiesFetcher.h"
#import "CountriesFetcher.h"
#import "CountriesStorage.h"

@interface DatabaseHelper : NSObject <CitiesFetcher, CountriesFetcher, CountriesStorage>

@end
