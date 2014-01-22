//
//  RelationshipHelper.h
//  WeatherApp
//
//  Created by Renzo Crisóstomo on 1/16/14.
//  Copyright (c) 2014 Ruenzuo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ModelUtils : NSObject

+ (NSArray *)sortCountries:(NSArray *)countries;
+ (NSArray *)sortCities:(NSArray *)cities;
+ (NSArray *)sortStations:(NSArray *)stations;

@end
