//
//  CountryManagedObject.h
//  WeatherApp
//
//  Created by Renzo Crisóstomo on 1/16/14.
//  Copyright (c) 2014 Ruenzuo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class CityManagedObject;

@interface CountryManagedObject : NSManagedObject

@property (nonatomic, retain) NSString *countryCode;
@property (nonatomic, retain) NSString *countryName;
@property (nonatomic, retain) NSOrderedSet *cities;
@end

@interface CountryManagedObject (CoreDataGeneratedAccessors)

- (void)insertObject:(CityManagedObject *)value inCitiesAtIndex:(NSUInteger)idx;
- (void)removeObjectFromCitiesAtIndex:(NSUInteger)idx;
- (void)insertCities:(NSArray *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeCitiesAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInCitiesAtIndex:(NSUInteger)idx withObject:(CityManagedObject *)value;
- (void)replaceCitiesAtIndexes:(NSIndexSet *)indexes withCities:(NSArray *)values;
- (void)addCitiesObject:(CityManagedObject *)value;
- (void)removeCitiesObject:(CityManagedObject *)value;
- (void)addCities:(NSOrderedSet *)values;
- (void)removeCities:(NSOrderedSet *)values;

@end
