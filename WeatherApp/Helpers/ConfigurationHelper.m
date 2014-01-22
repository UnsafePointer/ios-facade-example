//
//  ConfigurationHelper.m
//  WeatherApp
//
//  Created by Renzo Crisóstomo on 1/22/14.
//  Copyright (c) 2014 Ruenzuo. All rights reserved.
//

#import "ConfigurationHelper.h"

@interface ConfigurationHelper ()

@property (nonatomic, assign, readwrite) BOOL productionEnvironment;
@property (nonatomic, assign, readwrite) NSString *maxCitiesPerCountryParameter;

@end

@implementation ConfigurationHelper

- (id)init
{
    self = [super init];
    if (self) {
        _productionEnvironment = TRUE;
        _maxCitiesPerCountryParameter = @"&maxRows=3";
    }
    return self;
}

@end
