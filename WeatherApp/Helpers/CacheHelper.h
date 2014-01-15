//
//  CacheHelper.h
//  WeatherApp
//
//  Created by Renzo Crisóstomo on 1/15/14.
//  Copyright (c) 2014 Ruenzuo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Cities.h"
#import "Countries.h"

extern NSString * const CacheHelperErrorDomain;
extern int const MEMORY_CACHE_COST_LIMIT;
extern int const MEMORY_CACHE_COUNTRIES_COST;

@interface CacheHelper : NSObject <Countries>

@end
