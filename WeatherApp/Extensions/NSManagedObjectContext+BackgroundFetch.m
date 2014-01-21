//
//  NSManagedObjectContext+BackgroundFetch.m
//  WeatherApp
//
//  Created by Renzo Crisóstomo on 1/21/14.
//  Copyright (c) 2014 Ruenzuo. All rights reserved.
//

#import "NSManagedObjectContext+BackgroundFetch.h"

@implementation NSManagedObjectContext (BackgroundFetch)

- (void)executeFetchRequest:(NSFetchRequest *)request
                 completion:(ArrayCompletionBlock)completion
{
    NSPersistentStoreCoordinator *coordinator = self.persistentStoreCoordinator;
    NSManagedObjectContext *backgroundContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
    [backgroundContext performBlock:^{
        backgroundContext.persistentStoreCoordinator = coordinator;
        NSError *error = nil;
        NSArray *fetchedObjects = [backgroundContext executeFetchRequest:request error:&error];
        [self performBlock:^{
            if (fetchedObjects) {
                NSMutableArray *mutObjectIds = [[NSMutableArray alloc] initWithCapacity:[fetchedObjects count]];
                for (NSManagedObject *obj in fetchedObjects) {
                    [mutObjectIds addObject:obj.objectID];
                }
                NSMutableArray *mutObjects = [[NSMutableArray alloc] initWithCapacity:[mutObjectIds count]];
                for (NSManagedObjectID *objectID in mutObjectIds) {
                    NSManagedObject *obj = [self objectWithID:objectID];
                    [mutObjects addObject:obj];
                }
                if (completion) {
                    NSArray *objects = [mutObjects copy];
                    completion(objects, nil);
                }
            } else {
                if (completion) {
                    completion(nil, error);
                }
            }
        }];
    }];
}

@end
