//
//  TranslatorHelper.h
//  WeatherApp
//
//  Created by Renzo Crisóstomo on 1/15/14.
//  Copyright (c) 2014 Ruenzuo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TranslatorHelper : NSObject

- (id)translateObjectFromJSON:(NSDictionary *)JSON
                withclassName:(NSString *)className;
- (id)translateCollectionFromJSON:(NSDictionary *)JSON
                    withClassName:(NSString *)className;

@end
