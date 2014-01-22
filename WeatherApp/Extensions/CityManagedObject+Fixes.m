//
//  CityManagedObject+Fixes.m
//  WeatherApp
//
//  Created by Renzo Crisóstomo on 1/21/14.
//  Copyright (c) 2014 Ruenzuo. All rights reserved.
//

#import "CityManagedObject+Fixes.h"

@implementation CityManagedObject (Fixes)

- (void)addStationsObject:(StationManagedObject *)value;
{
    [self willChangeValueForKey:@"stations"];
    NSMutableOrderedSet *tempSet = [NSMutableOrderedSet orderedSetWithOrderedSet:self.stations];
    [tempSet addObject: value];
    self.stations = tempSet;
    [self didChangeValueForKey:@"stations"];
}

@end
