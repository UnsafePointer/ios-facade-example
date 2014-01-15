//
//  CompletionBlocks.h
//  WeatherApp
//
//  Created by Renzo Crisóstomo on 1/14/14.
//  Copyright (c) 2014 Ruenzuo. All rights reserved.
//

#import "RequestOperationConfig.h"

typedef void (^CompletionBlock)(NSError *error);

typedef void (^BooleanCompletionBlock)(BOOL result, NSError *error);

typedef void (^ObjectCompletionBlock)(id object, NSError *error);

typedef void (^ArrayCompletionBlock)(NSArray *array, NSError *error);

typedef void (^RequestOperationConfigBlock)(RequestOperationConfig *config);