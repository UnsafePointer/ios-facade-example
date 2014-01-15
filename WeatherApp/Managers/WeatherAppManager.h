//
//  CitiesManager.h
//  WeatherApp
//
//  Created by Renzo Crisóstomo on 1/14/14.
//  Copyright (c) 2014 Ruenzuo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Cities.h"
#import "Countries.h"

@interface WeatherAppManager : NSObject <Cities, Countries>

+ (WeatherAppManager *)sharedManager;

@end