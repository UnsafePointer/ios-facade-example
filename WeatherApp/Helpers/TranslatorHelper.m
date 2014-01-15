//
//  TranslatorHelper.m
//  WeatherApp
//
//  Created by Renzo Crisóstomo on 1/15/14.
//  Copyright (c) 2014 Ruenzuo. All rights reserved.
//

#import "TranslatorHelper.h"
#import <Mantle/Mantle.h>

@implementation TranslatorHelper

- (id)translateObjectFromJSON:(NSDictionary *)JSON
                withclassName:(NSString *)className
{
    NSParameterAssert(className != nil);
    NSError *error = nil;
    id model = [MTLJSONAdapter modelOfClass:NSClassFromString(className)
                         fromJSONDictionary:JSON
                                      error:&error];
    if (!error) {
        return model;
    } else {
        return nil;
    }
}

- (id)translateCollectionFromJSON:(NSDictionary *)JSON
                    withClassName:(NSString *)className
{
    NSParameterAssert(className != nil);
    if ([JSON isKindOfClass:[NSArray class]]) {
        NSValueTransformer *valueTransformer = [MTLValueTransformer mtl_JSONArrayTransformerWithModelClass:NSClassFromString(className)];
        NSArray *collection = [valueTransformer transformedValue:JSON];
        return collection;
    }
    return nil;
}

@end
