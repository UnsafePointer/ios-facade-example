//
//  CountryManagedObject+Fixes.m
//  WeatherApp
//
//  Created by Renzo Crisóstomo on 1/21/14.
//  Copyright (c) 2014 Ruenzuo. All rights reserved.
//

#import "CountryManagedObject+Fixes.h"

@implementation CountryManagedObject (Fixes)

- (void)addCitiesObject:(CityManagedObject *)value
{
    [self willChangeValueForKey:@"cities"];
    NSMutableOrderedSet *tempSet = [NSMutableOrderedSet orderedSetWithOrderedSet:self.cities];
    [tempSet addObject: value];
    self.cities = tempSet;
    [self didChangeValueForKey:@"cities"];
}

@end
