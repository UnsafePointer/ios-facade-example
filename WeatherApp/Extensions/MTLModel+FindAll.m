//
//  NSManagedObject+FindAll.m
//  WeatherApp
//
//  Created by Renzo Crisóstomo on 1/15/14.
//  Copyright (c) 2014 Ruenzuo. All rights reserved.
//

#import "MTLModel+FindAll.h"

@implementation MTLModel (FindAll)

+ (NSArray *)WA_findAll
{
    NSManagedObjectContext *context = [NSManagedObjectContext MR_contextForCurrentThread];
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:NSStringFromClass(self)];
    __block NSArray *results = nil;
    [context performBlockAndWait:^{
        NSError *error = nil;
        results = [context executeFetchRequest:request error:&error];
        if (results == nil) {
            [MagicalRecord handleErrors:error];
        }
    }];
	return results;
}

+ (NSArray *)WA_findAllInContext:(NSManagedObjectContext *)context
{
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:NSStringFromClass(self)];
    __block NSArray *results = nil;
    [context performBlockAndWait:^{
        NSError *error = nil;
        results = [context executeFetchRequest:request error:&error];
        if (results == nil) {
            [MagicalRecord handleErrors:error];
        }
    }];
	return results;
}

+ (NSArray *)WA_findAllWithPredicate:(NSPredicate *)searchTerm
{
    NSManagedObjectContext *context = [NSManagedObjectContext MR_contextForCurrentThread];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
	[request setEntity:[NSEntityDescription entityForName:NSStringFromClass(self)
                                   inManagedObjectContext:context]];
    [request setPredicate:searchTerm];
    __block NSArray *results = nil;
    [context performBlockAndWait:^{
        NSError *error = nil;
        results = [context executeFetchRequest:request error:&error];
        if (results == nil) {
            [MagicalRecord handleErrors:error];
        }
    }];
	return results;
}

+ (NSArray *)WA_findAllWithPredicate:(NSPredicate *)searchTerm
                            inContext:(NSManagedObjectContext *)context
{
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
	[request setEntity:[NSEntityDescription entityForName:NSStringFromClass(self)
                                   inManagedObjectContext:context]];
    [request setPredicate:searchTerm];
    __block NSArray *results = nil;
    [context performBlockAndWait:^{
        NSError *error = nil;
        results = [context executeFetchRequest:request error:&error];
        if (results == nil) {
            [MagicalRecord handleErrors:error];
        }
    }];
	return results;
}

@end
