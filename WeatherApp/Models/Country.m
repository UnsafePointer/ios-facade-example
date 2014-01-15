//
//  Country.m
//  WeatherApp
//
//  Created by Renzo Crisóstomo on 1/14/14.
//  Copyright (c) 2014 Ruenzuo. All rights reserved.
//

#import "Country.h"

@implementation Country

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
             @"countryName" : @"countryName",
             @"currencyCode" : @"currencyCode",
             @"fipsCode" : @"fipsCode",
             @"countryCode" : @"countryCode",
             @"isoNumeric" : @"isoNumeric",
             @"capital" : @"capital",
             @"continentName" : @"continentName",
             @"areaInSqKm" : @"areaInSqKm",
             @"languages" : @"languages",
             @"isoAlpha3" : @"isoAlpha3",
             @"continent" : @"continent",
             @"population" : @"population",
             @"north" : @"north",
             @"south" : @"south",
             @"east" : @"east",
             @"west" : @"west",
             @"geonameId" : @"geonameId"
             };
}

+ (NSDictionary *)managedObjectKeysByPropertyKey
{
    return @{
             @"countryName" : @"countryName",
             @"currencyCode" : @"currencyCode",
             @"fipsCode" : @"fipsCode",
             @"countryCode" : @"countryCode",
             @"isoNumeric" : @"isoNumeric",
             @"capital" : @"capital",
             @"continentName" : @"continentName",
             @"areaInSqKm" : @"areaInSqKm",
             @"languages" : @"languages",
             @"isoAlpha3" : @"isoAlpha3",
             @"continent" : @"continent",
             @"population" : @"population",
             @"north" : @"north",
             @"south" : @"south",
             @"east" : @"east",
             @"west" : @"west",
             @"geonameId" : @"geonameId"
             };
}

+ (NSString *)managedObjectEntityName {
    return @"Country";
}

@end
