//
//  City.h
//  WeatherApp
//
//  Created by Renzo Crisóstomo on 1/16/14.
//  Copyright (c) 2014 Ruenzuo. All rights reserved.
//

#import <Mantle/Mantle.h>

@class Country;

@interface City : MTLModel <MTLJSONSerializing, MTLManagedObjectSerializing>

@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSNumber *lat;
@property (nonatomic, retain) NSNumber *lng;
@property (nonatomic, retain) Country *country;

@end
