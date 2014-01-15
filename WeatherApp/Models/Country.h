//
//  Country.h
//  WeatherApp
//
//  Created by Renzo Crisóstomo on 1/14/14.
//  Copyright (c) 2014 Ruenzuo. All rights reserved.
//

#import <Mantle/Mantle.h>

@interface Country : MTLModel <MTLJSONSerializing, MTLManagedObjectSerializing>

@property (nonatomic, copy, readonly) NSString *countryName;
@property (nonatomic, copy, readonly) NSString *currencyCode;
@property (nonatomic, copy, readonly) NSString *fipsCode;
@property (nonatomic, copy, readonly) NSString *countryCode;
@property (nonatomic, copy, readonly) NSString *isoNumeric;
@property (nonatomic, copy, readonly) NSString *capital;
@property (nonatomic, copy, readonly) NSString *continentName;
@property (nonatomic, copy, readonly) NSString *areaInSqKm;
@property (nonatomic, copy, readonly) NSString *languages;
@property (nonatomic, copy, readonly) NSString *isoAlpha3;
@property (nonatomic, copy, readonly) NSString *continent;
@property (nonatomic, copy, readonly) NSString *population;
@property (nonatomic, copy, readonly) NSNumber *north;
@property (nonatomic, copy, readonly) NSNumber *south;
@property (nonatomic, copy, readonly) NSNumber *east;
@property (nonatomic, copy, readonly) NSNumber *west;
@property (nonatomic, copy, readonly) NSNumber *geonameId;

@end
