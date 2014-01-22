//
//  NetworkOperation.m
//  WeatherApp
//
//  Created by Renzo Crisóstomo on 1/17/14.
//  Copyright (c) 2014 Ruenzuo. All rights reserved.
//

#import "CitiesOperation.h"
#import "Country.h"
#import "TranslatorHelper.h"
#import "DatabaseHelper.h"
#import "ModelUtils.h"
#import "CityManagedObject.h"
#import "ConfigurationHelper.h"

@interface CitiesOperation ()

@property (nonatomic, retain, readwrite) Country *country;
@property (nonatomic, strong) TranslatorHelper *translatorHelper;
@property (nonatomic, strong) DatabaseHelper *databaseHelper;
@property (nonatomic, strong) ConfigurationHelper *configurationHelper;

@end

@implementation CitiesOperation

- (id)initWithCountry:(Country *)country
{
    if (self = [super init]) {
        self.country = country;
    }
    return self;
}

#pragma mark - Lazy Loading Pattern

- (TranslatorHelper *)translatorHelper
{
    if (_translatorHelper == nil) {
        _translatorHelper = [[TranslatorHelper alloc] init];
    }
    return _translatorHelper;
}

- (DatabaseHelper *)databaseHelper
{
    if (_databaseHelper == nil) {
        _databaseHelper = [[DatabaseHelper alloc] init];
    }
    return _databaseHelper;
}

- (ConfigurationHelper *)configurationHelper
{
    if (_configurationHelper == nil) {
        _configurationHelper = [[ConfigurationHelper alloc] init];
    }
    return _configurationHelper;
}

#pragma mark - Main

- (void)main
{
    @autoreleasepool {
        
        if (self.isCancelled)
            return;
        CountryManagedObject *countryManagedObject = [[self databaseHelper] getCountryManagedObjectWithCountryCode:
                                                      _country.countryCode
                                                                                                         inContext:
                                                      [NSManagedObjectContext MR_contextForCurrentThread]];
        if (self.isCancelled)
            return;
        NSArray *array = [CityManagedObject MR_findAllWithPredicate:
                          [NSPredicate predicateWithFormat:@"country == %@", countryManagedObject]
                                                          inContext:
                          [NSManagedObjectContext MR_contextForCurrentThread]];
        if (self.isCancelled)
            return;
        if ([array count] > 0) {
            return;
        }
        NSString *URLString = [NSString stringWithFormat:@"http://api.geonames.org/searchJSON?country=%@&username=WeatherApp", _country.countryCode];
        if ([[self configurationHelper] productionEnvironment]) {
            URLString = [URLString stringByAppendingString:[[self configurationHelper] maxCitiesPerCountryParameter]];
        }
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        [request setURL:[NSURL URLWithString:URLString]];
        [request setHTTPMethod:@"GET"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        NSURLResponse *response;
        NSError *error = nil;
        NSData *data = [NSURLConnection sendSynchronousRequest:request
                                             returningResponse:&response
                                                         error:&error];
        NSArray *sortedArray;
        if (!error && response) {
            NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data
                                                                       options:kNilOptions
                                                                         error:&error];
            if (self.isCancelled)
                return;
            NSArray *cities = [[self translatorHelper] translateCollectionFromJSON:[dictionary objectForKey:@"geonames"]
                                                                     withClassName:@"City"];
            sortedArray = [ModelUtils sortCities:cities];
            if (self.isCancelled)
                return;
            [[self databaseHelper] storeCities:sortedArray
                                   fromCountry:_country];
        }
        
        if (self.isCancelled)
            return;
        if ([self.delegate respondsToSelector:@selector(citiesOperationDidFinish:)]) {
            [(NSObject *)self.delegate performSelectorOnMainThread:@selector(citiesOperationDidFinish:)
                                                        withObject:@{@"operation" : self, @"cities": sortedArray}
                                                     waitUntilDone:NO];
        }
    }
}

@end
