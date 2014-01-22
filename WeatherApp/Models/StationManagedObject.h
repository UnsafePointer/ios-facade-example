//
//  StationManagedObject.h
//  WeatherApp
//
//  Created by Renzo Crisóstomo on 1/21/14.
//  Copyright (c) 2014 Ruenzuo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class CityManagedObject;

@interface StationManagedObject : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * temp;
@property (nonatomic, retain) NSNumber * pressure;
@property (nonatomic, retain) NSNumber * humidity;
@property (nonatomic, retain) CityManagedObject *city;

@end
