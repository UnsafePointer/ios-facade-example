//
//  Country.m
//  WeatherApp
//
//  Created by Renzo Crisóstomo on 1/14/14.
//  Copyright (c) 2014 Ruenzuo. All rights reserved.
//

#import "Country.h"
#import "City.h"

@implementation Country

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
             @"countryName" : @"countryName",
             @"countryCode" : @"countryCode"
            };
}

+ (NSDictionary *)managedObjectKeysByPropertyKey
{
    return @{
             @"countryName" : @"countryName",
             @"countryCode" : @"countryCode"
            };
}

+ (NSString *)managedObjectEntityName
{
    return @"CountryManagedObject";
}

@end
