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

@interface CacheHelper : NSObject <Cities, Countries>

- (BOOL)objectIsAvailableForKey:(NSString *)key;

@end
