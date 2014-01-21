//
//  NSManagedObjectContext+BackgroundFetch.h
//  WeatherApp
//
//  Created by Renzo Crisóstomo on 1/21/14.
//  Copyright (c) 2014 Ruenzuo. All rights reserved.
//

#import <CoreData/CoreData.h>
#include "Blocks.h"

@interface NSManagedObjectContext (BackgroundFetch)

- (void)executeFetchRequest:(NSFetchRequest *)request
                 completion:(ArrayCompletionBlock)completion;

@end
