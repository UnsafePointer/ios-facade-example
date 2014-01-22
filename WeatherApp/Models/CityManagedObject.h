//
//  CityManagedObject.h
//  WeatherApp
//
//  Created by Renzo Crisóstomo on 1/21/14.
//  Copyright (c) 2014 Ruenzuo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class CountryManagedObject, StationManagedObject;

@interface CityManagedObject : NSManagedObject

@property (nonatomic, retain) NSString * lat;
@property (nonatomic, retain) NSString * lng;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) CountryManagedObject *country;
@property (nonatomic, retain) NSOrderedSet *stations;
@end

@interface CityManagedObject (CoreDataGeneratedAccessors)

- (void)insertObject:(StationManagedObject *)value inStationsAtIndex:(NSUInteger)idx;
- (void)removeObjectFromStationsAtIndex:(NSUInteger)idx;
- (void)insertStations:(NSArray *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeStationsAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInStationsAtIndex:(NSUInteger)idx withObject:(StationManagedObject *)value;
- (void)replaceStationsAtIndexes:(NSIndexSet *)indexes withStations:(NSArray *)values;
- (void)addStationsObject:(StationManagedObject *)value;
- (void)removeStationsObject:(StationManagedObject *)value;
- (void)addStations:(NSOrderedSet *)values;
- (void)removeStations:(NSOrderedSet *)values;

@end
