//
//  NSManagedObject+FindAll.h
//  WeatherApp
//
//  Created by Renzo Crisóstomo on 1/15/14.
//  Copyright (c) 2014 Ruenzuo. All rights reserved.
//

#import "Country.h"

@interface MTLModel (FindAll)

+ (NSArray *)WA_findAll;
+ (NSArray *)WA_findAllInContext:(NSManagedObjectContext *)context;

@end
