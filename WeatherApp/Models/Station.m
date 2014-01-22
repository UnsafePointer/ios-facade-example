//
//  Station.m
//  WeatherApp
//
//  Created by Renzo Crisóstomo on 1/16/14.
//  Copyright (c) 2014 Ruenzuo. All rights reserved.
//

#import "Station.h"

@implementation Station

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
             @"name" : @"name",
             @"temp" : @"main.temp",
             @"pressure" : @"main.pressure",
             @"humidity" : @"main.humidity"
            };
}

+ (NSDictionary *)managedObjectKeysByPropertyKey
{
    return @{
             @"name" : @"name",
             @"temp" : @"temp",
             @"pressure" : @"pressure",
             @"humidity" : @"humidity"
            };
}

+ (NSString *)managedObjectEntityName
{
    return @"StationManagedObject";
}

@end
