//
//  DatabaseHelper.m
//  WeatherApp
//
//  Created by Renzo Crisóstomo on 1/15/14.
//  Copyright (c) 2014 Ruenzuo. All rights reserved.
//

#import "DatabaseHelper.h"
#import "City.h"
#import "Country.h"
#import "TranslatorHelper.h"
#import "CountryManagedObject.h"
#import "CityManagedObject.h"
#import "CountryManagedObject+Fixes.h"

static const int ddLogLevel = LOG_LEVEL_INFO;

@interface DatabaseHelper ()

@property (nonatomic, strong) TranslatorHelper *translatorHelper;

- (CountryManagedObject *)getCountryManagedObjectWithCountryCode:(NSString *)countryCode
                                                       inContext:(NSManagedObjectContext *)context;

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

#pragma mark - Private Methods

- (CountryManagedObject *)getCountryManagedObjectWithCountryCode:(NSString *)countryCode
                                                       inContext:(NSManagedObjectContext *)context
{
    return [CountryManagedObject MR_findFirstByAttribute:@"countryCode"
                                               withValue:countryCode
                                               inContext:context];
}

#pragma mark - CitiesFetcher Protocol

- (void)getCitiesWithCountry:(Country *)country
                  completion:(ArrayCompletionBlock)completion
{
    CountryManagedObject *countryManagedObject = [self getCountryManagedObjectWithCountryCode:country.countryCode
                                                                                    inContext:[NSManagedObjectContext MR_contextForCurrentThread]];
    NSArray *array = [CityManagedObject MR_findAllSortedBy:@"name"
                                                 ascending:YES
                                             withPredicate:[NSPredicate predicateWithFormat:@"country == %@", countryManagedObject]
                                                 inContext:[NSManagedObjectContext MR_contextForCurrentThread]];
    completion([[self translatorHelper] translateCollectionfromManagedObjects:array
                                                                withClassName:@"City"], nil);
}

#pragma mark - CitiesStorage Protocol

- (void)storeCities:(NSArray *)cities
        fromCountry:(Country *)country
{
    [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
        [cities enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            NSError *error;
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
    NSArray *array = [CountryManagedObject MR_findAllSortedBy:@"countryName"
                                                    ascending:YES
                                                    inContext:[NSManagedObjectContext MR_contextForCurrentThread]];
    completion([[self translatorHelper] translateCollectionfromManagedObjects:array
                                                                withClassName:@"Country"], nil);
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
