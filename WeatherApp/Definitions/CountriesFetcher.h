//
//  Countries.h
//  WeatherApp
//
//  Created by Renzo Crisóstomo on 1/14/14.
//  Copyright (c) 2014 Ruenzuo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Blocks.h"

@protocol CountriesFetcher <NSObject>

- (void)getCountriesWithCompletion:(ArrayCompletionBlock)completion;

@end
