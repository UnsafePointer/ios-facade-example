//
//  DatabaseHelper.m
//  WeatherApp
//
//  Created by Renzo Crisóstomo on 1/15/14.
//  Copyright (c) 2014 Ruenzuo. All rights reserved.
//

#import "DatabaseHelper.h"
#import "MTLModel+FindAll.h"
#import "City.h"
#import "Country.h"

static const int ddLogLevel = LOG_LEVEL_INFO;

@implementation DatabaseHelper

#pragma mark - CitiesFetcher Protocol

- (void)getCitiesWithCountry:(Country *)country
                  completion:(ArrayCompletionBlock)completion
{
    NSArray *array = [City WA_findAllWithPredicate:[NSPredicate predicateWithFormat:@"country == %@", country]
                                         inContext:[NSManagedObjectContext MR_defaultContext]];
    completion(array, nil);
}

#pragma mark - CitiesStorage Protocol

- (void)storeCities:(NSArray *)cities fromCountry:(Country *)country
{
    [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
        [country addCities:[NSSet setWithArray:cities]];
        [cities enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            NSError *error;
            [((City *)obj) setCountry:country];
            [MTLManagedObjectAdapter managedObjectFromModel:obj
                                       insertingIntoContext:localContext
                                                      error:&error];
        }];
    } completion:^(BOOL success, NSError *error) {
        if (success) {
            DDLogInfo(@"Cities stored on database without errors");
        }
        else {
            DDLogInfo(@"Cities failed to stored on database with Error %@", [error localizedDescription]);
        }
    }];
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
