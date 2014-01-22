//
//  Station.h
//  WeatherApp
//
//  Created by Renzo Crisóstomo on 1/16/14.
//  Copyright (c) 2014 Ruenzuo. All rights reserved.
//

#import <Mantle/Mantle.h>

@class City;

@interface Station : MTLModel <MTLJSONSerializing, MTLManagedObjectSerializing>

@property (nonatomic, copy, readonly) NSString *name;
@property (nonatomic, copy, readonly) NSNumber *temp;
@property (nonatomic, copy, readonly) NSNumber *pressure;
@property (nonatomic, copy, readonly) NSNumber *humidity;

@end
