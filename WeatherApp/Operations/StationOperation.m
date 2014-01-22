//
//  StationOperation.m
//  WeatherApp
//
//  Created by Renzo Crisóstomo on 1/21/14.
//  Copyright (c) 2014 Ruenzuo. All rights reserved.
//

#import "StationOperation.h"
#import "TranslatorHelper.h"
#import "DatabaseHelper.h"
#import "City.h"
#import "StationManagedObject.h"
#import "ModelUtils.h"

@interface StationOperation ()

@property (nonatomic, retain, readwrite) City *city;
@property (nonatomic, strong) TranslatorHelper *translatorHelper;
@property (nonatomic, strong) DatabaseHelper *databaseHelper;

@end

@implementation StationOperation

- (id)initWithCity:(City *)city
{
    if (self = [super init]) {
        self.city = city;
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
        CityManagedObject *cityManagedObject = [[self databaseHelper] getCityManagedObjectWithName:_city.name
                                                                                         inContext:[NSManagedObjectContext MR_contextForCurrentThread]];
        if (self.isCancelled)
            return;
        NSArray *array = [StationManagedObject MR_findAllWithPredicate:[NSPredicate predicateWithFormat:@"city == %@", cityManagedObject]
                                                             inContext:[NSManagedObjectContext MR_contextForCurrentThread]];
        if (self.isCancelled)
            return;
        if ([array count] > 0) {
            return;
        }
        NSString *URL = [NSString stringWithFormat:@"http://api.openweathermap.org/data/2.5/find?lat=%.2f&lon=%.2f", [_city.lat floatValue], [_city.lng floatValue]];
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
            NSArray *stations = [[self translatorHelper] translateCollectionFromJSON:[dictionary objectForKey:@"list"]
                                                                       withClassName:@"Station"];
            NSArray *sortedArray = [ModelUtils sortCities:stations];
            if (self.isCancelled)
                return;
            [[self databaseHelper] storeStations:sortedArray
                                        fromCity:_city];
        }
        
        if (self.isCancelled)
            return;
        if ([self.delegate respondsToSelector:@selector(stationsOperationDidFinish:)]) {
            [(NSObject *)self.delegate performSelectorOnMainThread:@selector(stationsOperationDidFinish:)
                                                        withObject:self
                                                     waitUntilDone:NO];
        }
    }
}

@end
