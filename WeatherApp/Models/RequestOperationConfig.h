//
//  RequestOperationConfig.h
//  WeatherApp
//
//  Created by Renzo Crisóstomo on 1/15/14.
//  Copyright (c) 2014 Ruenzuo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworking.h>

@interface RequestOperationConfig : NSObject

@property (nonatomic, copy, readwrite) NSURL *URL;
@property (nonatomic, copy, readwrite) AFHTTPResponseSerializer *responseSerializer;

@end
