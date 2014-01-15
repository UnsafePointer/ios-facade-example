//
//  CountriesStorage.h
//  WeatherApp
//
//  Created by Renzo Crisóstomo on 1/15/14.
//  Copyright (c) 2014 Ruenzuo. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol CountriesStorage <NSObject>

- (void)storeCountries:(NSArray *)countries;

@end
