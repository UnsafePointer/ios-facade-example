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

@interface CitiesOperation ()

@property (nonatomic, retain, readwrite) Country *country;
@property (nonatomic, strong) TranslatorHelper *translatorHelper;
@property (nonatomic, strong) DatabaseHelper *databaseHelper;

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

#pragma mark - Main

- (void)main
{
    @autoreleasepool {
        
        if (self.isCancelled)
            return;
        
        if ([_country.cities count] > 0) {
            return;
        }
        
        NSString *URL = [NSString stringWithFormat:@"http://api.geonames.org/searchJSON?country=%@&username=WeatherApp", _country.countryCode];
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        [request setURL:[NSURL URLWithString:URL]];
        [request setHTTPMethod:@"GET"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        NSURLResponse *response;
        NSError *error = nil;
        NSData *data = [NSURLConnection sendSynchronousRequest:request
                                             returningResponse:&response
                                                         error:&error];
        if (!error && response) {
            NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data
                                                                       options:kNilOptions
                                                                         error:&error];
            if (self.isCancelled)
                return;
            NSArray *cities = [[self translatorHelper] translateCollectionFromJSON:[dictionary objectForKey:@"geonames"]
                                                                     withClassName:@"City"];
            NSArray *sortedArray = [ModelUtils sortCities:cities];
            [ModelUtils relateCities:sortedArray
                         withCountry:_country];
            if (self.isCancelled)
                return;
            [[self databaseHelper] storeCities:sortedArray
                                   fromCountry:_country];
        }
        
        if (self.isCancelled)
            return;
        if ([self.delegate respondsToSelector:@selector(citiesOperationDidFinish:)]) {
            [(NSObject *)self.delegate performSelectorOnMainThread:@selector(citiesOperationDidFinish:)
                                                        withObject:self
                                                     waitUntilDone:NO];
        }
    }
}

@end
