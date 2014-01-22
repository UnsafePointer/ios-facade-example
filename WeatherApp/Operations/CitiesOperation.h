//
//  NetworkOperation.h
//  WeatherApp
//
//  Created by Renzo Crisóstomo on 1/17/14.
//  Copyright (c) 2014 Ruenzuo. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Country;
@protocol CitiesOperationDelegate;

@interface CitiesOperation : NSOperation

@property (nonatomic, retain, readonly) Country *country;
@property (nonatomic, assign) id <CitiesOperationDelegate> delegate;

- (id)initWithCountry:(Country *)country;

@end

@protocol CitiesOperationDelegate <NSObject>

- (void)citiesOperationDidFinish:(NSDictionary *)dictionary;

@end
