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

@implementation ModelUtils

+ (void)relateCities:(NSArray *)cities
         withCountry:(Country *)country;
{
    for (City *city in cities) {
        [city setCountry:country];
    }
    [country setCities:cities];
}

+ (NSArray *)sortCountries:(NSArray *)countries
{
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"countryName" ascending:YES];
    return [countries sortedArrayUsingDescriptors:[NSArray arrayWithObject:sort]];
}

+ (NSArray *)sortCities:(NSArray *)cities
{
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES];
    return [cities sortedArrayUsingDescriptors:[NSArray arrayWithObject:sort]];
}

@end
