//
//  DatabaseHelper.m
//  WeatherApp
//
//  Created by Renzo Crisóstomo on 1/15/14.
//  Copyright (c) 2014 Ruenzuo. All rights reserved.
//

#import "DatabaseHelper.h"
#import "TranslatorHelper.h"
#import "City.h"
#import "Country.h"
#import "CountryManagedObject.h"
#import "CityManagedObject.h"
#import "StationManagedObject.h"
#import "CountryManagedObject+Fixes.h"
#import "CityManagedObject+Fixes.h"
#import "NSManagedObjectContext+BackgroundFetch.h"

static const int ddLogLevel = LOG_LEVEL_INFO;

@interface DatabaseHelper ()

@property (nonatomic, strong) TranslatorHelper *translatorHelper;

- (NSFetchRequest *)backgroundFetchRequestForEntityName:(NSString *)entityName
                                  withSortDescriptorKey:(NSString *)sortDescriptorKey
                                              ascending:(BOOL)ascending
                                           andPredicate:(NSPredicate *)predicate;

@end

@implementation DatabaseHelper
{
}

#pragma mark - Lazy Loading Pattern

- (TranslatorHelper *)translatorHelper
{
    if (_translatorHelper == nil) {
        _translatorHelper = [[TranslatorHelper alloc] init];
    }
    return _translatorHelper;
}

#pragma mark - Public Methods

- (CountryManagedObject *)getCountryManagedObjectWithCountryCode:(NSString *)countryCode
                                                       inContext:(NSManagedObjectContext *)context
{
    return [CountryManagedObject MR_findFirstByAttribute:@"countryCode"
                                               withValue:countryCode
                                               inContext:context];
}

- (CityManagedObject *)getCityManagedObjectWithName:(NSString *)name
                                             inContext:(NSManagedObjectContext *)context
{
    return [CityManagedObject MR_findFirstByAttribute:@"name"
                                               withValue:name
                                               inContext:context];
}

#pragma mark - Private Methods

- (NSFetchRequest *)backgroundFetchRequestForEntityName:(NSString *)entityName
                                  withSortDescriptorKey:(NSString *)sortDescriptorKey
                                              ascending:(BOOL)ascending
                                           andPredicate:(NSPredicate *)predicate
{
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:entityName];
    fetchRequest.includesPropertyValues = NO;
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:sortDescriptorKey
                                                                   ascending:ascending];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObject:sortDescriptor]];
    if (predicate) {
        [fetchRequest setPredicate:predicate];
    }
    return fetchRequest;
}

#pragma mark - CountriesFetcher Protocol

- (void)getCountriesWithCompletion:(ArrayCompletionBlock)completion
{
    NSFetchRequest *fetchRequest = [self backgroundFetchRequestForEntityName:@"CountryManagedObject"
                                                       withSortDescriptorKey:@"countryName"
                                                                   ascending:YES
                                                                andPredicate:nil];
    NSManagedObjectContext *context = [NSManagedObjectContext MR_contextForCurrentThread];
    [context executeFetchRequest:fetchRequest
                      completion:^(NSArray *array, NSError *error) {
                          if (array) {
                              completion([[self translatorHelper] translateCollectionfromManagedObjects:array
                                                                                          withClassName:@"Country"], nil);
                          }
                          else {
                              completion(nil, error);
                          }
                      }];
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

#pragma mark - CitiesFetcher Protocol

- (void)getCitiesWithCountry:(Country *)country
                  completion:(ArrayCompletionBlock)completion
{
    CountryManagedObject *countryManagedObject = [self getCountryManagedObjectWithCountryCode:country.countryCode
                                                                                    inContext:[NSManagedObjectContext MR_contextForCurrentThread]];
    NSFetchRequest *fetchRequest = [self backgroundFetchRequestForEntityName:@"CityManagedObject"
                                                       withSortDescriptorKey:@"name"
                                                                   ascending:YES
                                                                andPredicate:[NSPredicate predicateWithFormat:@"country == %@", countryManagedObject]];
    NSManagedObjectContext *context = [NSManagedObjectContext MR_contextForCurrentThread];
    [context executeFetchRequest:fetchRequest
                      completion:^(NSArray *array, NSError *error) {
                          if (array) {
                              completion([[self translatorHelper] translateCollectionfromManagedObjects:array
                                                                                          withClassName:@"City"], nil);
                          }
                          else {
                              completion(nil, error);
                          }
                      }];
}

#pragma mark - CitiesStorage Protocol

- (void)storeCities:(NSArray *)cities
        fromCountry:(Country *)country
{
    [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
        CountryManagedObject *countryManagedObject = [self getCountryManagedObjectWithCountryCode:country.countryCode
                                                                                        inContext:localContext];
        [cities enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            NSError *error;
            CityManagedObject *cityManagedObject = [MTLManagedObjectAdapter managedObjectFromModel:obj
                                                                              insertingIntoContext:localContext
                                                                                             error:&error];
            [cityManagedObject setCountry:countryManagedObject];
            [countryManagedObject addCitiesObject:cityManagedObject];
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

#pragma mark - StationsFetcher Protocol

- (void)getStationsWithCity:(City *)city
                 completion:(ArrayCompletionBlock)completion
{
    CityManagedObject *cityManagedObject = [self getCityManagedObjectWithName:city.name
                                                                       inContext:[NSManagedObjectContext MR_contextForCurrentThread]];
    NSFetchRequest *fetchRequest = [self backgroundFetchRequestForEntityName:@"StationManagedObject"
                                                       withSortDescriptorKey:@"name"
                                                                   ascending:YES
                                                                andPredicate:[NSPredicate predicateWithFormat:@"city == %@", cityManagedObject]];
    NSManagedObjectContext *context = [NSManagedObjectContext MR_contextForCurrentThread];
    [context executeFetchRequest:fetchRequest
                      completion:^(NSArray *array, NSError *error) {
                          if (array) {
                              completion([[self translatorHelper] translateCollectionfromManagedObjects:array
                                                                                          withClassName:@"Station"], nil);
                          }
                          else {
                              completion(nil, error);
                          }
                      }];
}

#pragma mark - StationsStorage Protocol

- (void)storeStations:(NSArray *)stations
             fromCity:(City *)city
{
    [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
        CityManagedObject *cityManagedObject = [self getCityManagedObjectWithName:city.name
                                                                        inContext:localContext];
        [stations enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            NSError *error;
            StationManagedObject *stationManagedObject = [MTLManagedObjectAdapter managedObjectFromModel:obj
                                                                                    insertingIntoContext:localContext
                                                                                                   error:&error];
            [stationManagedObject setCity:cityManagedObject];
            [cityManagedObject addStationsObject:stationManagedObject];
        }];
    } completion:^(BOOL success, NSError *error) {
        if (success) {
            DDLogInfo(@"Stations stored on database without errors");
        }
        else {
            DDLogInfo(@"Stations failed to stored on database with Error %@", [error localizedDescription]);
        }
    }];
}

@end
