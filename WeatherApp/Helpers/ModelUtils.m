//
//  RelationshipHelper.m
//  WeatherApp
//
//  Created by Renzo Crisóstomo on 1/16/14.
//  Copyright (c) 2014 Ruenzuo. All rights reserved.
//

#import "ModelUtils.h"
#import "Country.h"
#import "City.h"

@interface ModelUtils ()

+ (NSArray *)sortArray:(NSArray *)array
     withDescriptorKey:(NSString *)descriptorKey;

@end

@implementation ModelUtils
{
}

#pragma mark - Private Methods

+ (NSArray *)sortArray:(NSArray *)array
     withDescriptorKey:(NSString *)descriptorKey
{
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:descriptorKey ascending:YES];
    return [array sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]];
}

#pragma mark - Public Methods

+ (NSArray *)sortCountries:(NSArray *)countries
{
    return [self sortArray:countries
         withDescriptorKey:@"countryName"];
}

+ (NSArray *)sortCities:(NSArray *)cities
{
    return [self sortArray:cities
         withDescriptorKey:@"name"];
}

+ (NSArray *)sortStations:(NSArray *)stations
{
    return [self sortArray:stations
         withDescriptorKey:@"name"];
}

@end
