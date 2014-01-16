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
@property (nonatomic, retain) NSSet *cities;
@end

@interface CountryManagedObject (CoreDataGeneratedAccessors)

- (void)addCitiesObject:(CityManagedObject *)value;
- (void)removeCitiesObject:(CityManagedObject *)value;
- (void)addCities:(NSSet *)values;
- (void)removeCities:(NSSet *)values;

@end
