//
//  ConfigurationHelper.h
//  WeatherApp
//
//  Created by Renzo Crisóstomo on 1/22/14.
//  Copyright (c) 2014 Ruenzuo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ConfigurationHelper : NSObject

@property (nonatomic, assign, readonly) BOOL productionEnvironment;
@property (nonatomic, assign, readonly) NSString *maxCitiesPerCountryParameter;

@end
