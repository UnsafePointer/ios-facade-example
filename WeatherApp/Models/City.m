//
//  City.m
//  WeatherApp
//
//  Created by Renzo Crisóstomo on 1/16/14.
//  Copyright (c) 2014 Ruenzuo. All rights reserved.
//

#import "City.h"
#import "Country.h"

@implementation City

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
             @"name" : @"name",
             @"lat" : @"lat",
             @"lng" : @"lng"
            };
}

+ (NSDictionary *)managedObjectKeysByPropertyKey
{
    return @{
             @"name" : @"name",
             @"lat" : @"lat",
             @"lng" : @"lng"
            };
}

+ (NSString *)managedObjectEntityName
{
    return @"CityManagedObject";
}

@end
