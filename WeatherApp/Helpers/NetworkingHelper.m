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

@interface NetworkingHelper ()

@property (nonatomic, strong) TranslatorHelper *translatorHelper;

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

#pragma mark - CitiesFetcher Protocol

- (void)getCitiesWithCountry:(Country *)country
                  completion:(ArrayCompletionBlock)completion
{
    AFHTTPRequestOperation *requestOperation = [NetworkingHelper createHTTPRequestOperationWithConfiguration:^(RequestOperationConfig *config) {
        config.URL = [NSURL URLWithString:[NSString stringWithFormat:@"http://api.geonames.org/searchJSON?country=%@&username=WeatherApp", country.countryCode]];
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

@end
