//
//  StationOperation.h
//  WeatherApp
//
//  Created by Renzo Crisóstomo on 1/21/14.
//  Copyright (c) 2014 Ruenzuo. All rights reserved.
//

#import <Foundation/Foundation.h>

@class City;
@protocol StationOperationDelegate;

@interface StationOperation : NSOperation

@property (nonatomic, retain, readonly) City *city;
@property (nonatomic, assign) id <StationOperationDelegate> delegate;

- (id)initWithCity:(City *)city;

@end

@protocol StationOperationDelegate <NSObject>

- (void)stationsOperationDidFinish:(StationOperation *)operation;

@end
