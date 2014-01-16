//
//  RelationshipHelper.h
//  WeatherApp
//
//  Created by Renzo Crisóstomo on 1/16/14.
//  Copyright (c) 2014 Ruenzuo. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Country;

@interface ModelUtils : NSObject

+ (void)relateCities:(NSArray *)cities
         withCountry:(Country *)country;
+ (NSArray *)sortCountries:(NSArray *)countries;
+ (NSArray *)sortCities:(NSArray *)cities;

@end
