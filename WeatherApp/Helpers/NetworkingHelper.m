//
//  NetworkingHelper.m
//  WeatherApp
//
//  Created by Renzo Crisóstomo on 1/14/14.
//  Copyright (c) 2014 Ruenzuo. All rights reserved.
//

#import <Mantle/Mantle.h>
#import <AFNetworking/AFNetworking.h>
#import <TMCache/TMCache.h>
#import "NetworkingHelper.h"
#import "Country.h"
#import "TranslatorHelper.h"
#import "Blocks.h"
#import "CacheHelper.h"
#import "City.h"
#import "ConfigurationHelper.h"

@interface NetworkingHelper ()

@property (nonatomic, strong) TranslatorHelper *translatorHelper;
@property (nonatomic, strong) ConfigurationHelper *configurationHelper;

+ (AFHTTPRequestOperation *)createHTTPRequestOperationWithConfiguration:(RequestOperationConfigBlock)configuration;

@end

@implementation NetworkingHelper
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

- (ConfigurationHelper *)configurationHelper
{
    if (_configurationHelper == nil) {
        _configurationHelper = [[ConfigurationHelper alloc] init];
    }
    return _configurationHelper;
}

#pragma mark - Private Methods

+ (AFHTTPRequestOperation *)createHTTPRequestOperationWithConfiguration:(RequestOperationConfigBlock)configuration
{
    NSParameterAssert(configuration != nil);
    RequestOperationConfig* requestOperationConfig = [[RequestOperationConfig alloc] init];
    if (configuration) {
        configuration(requestOperationConfig);
    }
    NSURLRequest *request = [NSURLRequest requestWithURL:[requestOperationConfig URL]];
    AFHTTPRequestOperation *requestOperation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    requestOperation.responseSerializer = requestOperationConfig.responseSerializer;
    return requestOperation;
}

#pragma mark - CountriesFetcher Protocol

- (void)getCountriesWithCompletion:(ArrayCompletionBlock)completion
{
    AFHTTPRequestOperation *requestOperation = [NetworkingHelper createHTTPRequestOperationWithConfiguration:^(RequestOperationConfig *config) {
        config.URL = [NSURL URLWithString:@"http://api.geonames.org/countryInfoJSON?username=WeatherApp"];
        config.responseSerializer = [AFJSONResponseSerializer serializer];
    }];
    [requestOperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (!completion) {
            return;
        }
        NSArray *collection = [[self translatorHelper] translateCollectionFromJSON:[responseObject objectForKey:@"geonames"]
                                                                     withClassName:@"Country"];
        completion(collection, nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (completion) {
            completion(nil, error);
        }
    }];
    [[NSOperationQueue mainQueue] addOperation:requestOperation];
}

#pragma mark - CitiesFetcher Protocol

- (void)getCitiesWithCountry:(Country *)country
                  completion:(ArrayCompletionBlock)completion
{
    AFHTTPRequestOperation *requestOperation = [NetworkingHelper createHTTPRequestOperationWithConfiguration:^(RequestOperationConfig *config) {
        NSString *URLString = [NSString stringWithFormat:@"http://api.geonames.org/searchJSON?country=%@&username=WeatherApp", country.countryCode];
        if ([[self configurationHelper] productionEnvironment]) {
            URLString = [URLString stringByAppendingString:[[self configurationHelper] maxCitiesPerCountryParameter]];
        }
        config.URL = [NSURL URLWithString:URLString];
        config.responseSerializer = [AFJSONResponseSerializer serializer];
    }];
    [requestOperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (!completion) {
            return;
        }
        NSArray *collection = [[self translatorHelper] translateCollectionFromJSON:[responseObject objectForKey:@"geonames"]
                                                                     withClassName:@"City"];
        completion(collection, nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (completion) {
            completion(nil, error);
        }
    }];
    [[NSOperationQueue mainQueue] addOperation:requestOperation];
}

#pragma mark - StationsFetcher Protocol

- (void)getStationsWithCity:(City *)city
                 completion:(ArrayCompletionBlock)completion;
{
    AFHTTPRequestOperation *requestOperation = [NetworkingHelper createHTTPRequestOperationWithConfiguration:^(RequestOperationConfig *config) {
        config.URL = [NSURL URLWithString:[NSString stringWithFormat:@"http://api.openweathermap.org/data/2.5/find?lat=%.2f&lon=%.2f", [city.lat floatValue], [city.lng floatValue]]];
        config.responseSerializer = [AFJSONResponseSerializer serializer];
    }];
    [requestOperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (!completion) {
            return;
        }
        NSArray *collection = [[self translatorHelper] translateCollectionFromJSON:[responseObject objectForKey:@"list"]
                                                                     withClassName:@"Station"];
        completion(collection, nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (completion) {
            completion(nil, error);
        }
    }];
    [[NSOperationQueue mainQueue] addOperation:requestOperation];
}

@end
