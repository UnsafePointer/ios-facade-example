//
//  DatabaseHelper.m
//  WeatherApp
//
//  Created by Renzo Crisóstomo on 1/15/14.
//  Copyright (c) 2014 Ruenzuo. All rights reserved.
//

#import "DatabaseHelper.h"
#import "MTLModel+FindAll.h"

static const int ddLogLevel = LOG_LEVEL_INFO;

@implementation DatabaseHelper

#pragma mark - CitiesFetcher Protocol

- (void)getCitiesWithCountry:(Country *)country
                  completion:(ArrayCompletionBlock)completion
{
    
}

#pragma mark - CitiesStorage Protocol

- (void)storeCities:(NSArray *)cities fromCountry:(Country *)country
{
    
}

#pragma mark - CountriesFetcher Protocol

- (void)getCountriesWithCompletion:(ArrayCompletionBlock)completion
{
    NSArray *array = [Country WA_findAllInContext:[NSManagedObjectContext MR_defaultContext]];
    completion(array, nil);
}

#pragma mark - CountriesStorage Protocol

- (void)storeCountries:(NSArray *)countries
{
    [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
        [countries enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            NSError *error;
            [MTLManagedObjectAdapter managedObjectFromModel:obj
                                       insertingIntoContext:localContext
                                                      error:&error];
        }];
    } completion:^(BOOL success, NSError *error) {
        if (success) {
            DDLogInfo(@"Countries stored on database without errors");
        }
        else {
            DDLogInfo(@"Countries failed to stored on database with Error %@", [error localizedDescription]);
        }
    }];
}

@end
