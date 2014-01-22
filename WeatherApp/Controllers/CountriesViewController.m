//
//  CitiesViewController.m
//  WeatherApp
//
//  Created by Renzo Crisóstomo on 1/14/14.
//  Copyright (c) 2014 Ruenzuo. All rights reserved.
//

#import "CountriesViewController.h"
#import "CitiesViewController.h"
#import "WeatherAppManager.h"
#import "Country.h"
#import "City.h"
#import "DatabaseHelper.h"
#import "CityManagedObject.h"
#import "StationManagedObject.h"
#include <mach/mach_time.h>

static const int ddLogLevel = LOG_LEVEL_INFO;

@interface CountriesViewController ()

@property (nonatomic, strong) NSMutableArray *countries;
@property (nonatomic, strong) DatabaseHelper *databaseHelper;

- (void)loadCountries;

@end

@interface CountriesViewController (Testing)

- (void)testDataSource;

@end

@implementation CountriesViewController
{
}

#pragma mark - View Controller Life Cycle

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        _countries = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self loadCountries];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"CitySegue"]) {
        CitiesViewController *viewController = (CitiesViewController *)[segue destinationViewController];
        NSIndexPath *selectedIndexPath = [self.tableView indexPathForSelectedRow];
        Country *country = [_countries objectAtIndex:selectedIndexPath.row];
        viewController.country = country;
    }
}

- (BOOL)canBecomeFirstResponder
{
    return YES;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self becomeFirstResponder];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self resignFirstResponder];
    [super viewWillDisappear:animated];
}

#pragma mark - Private Methods

/*
 Benchmarking method copied from Peter Steinberger's PSPDFPerformAndTrackTime available here: https://github.com/steipete/PSTFoundationBenchmark
 */

- (void)loadCountries
{
    uint64_t startTime = mach_absolute_time();
    [[WeatherAppManager sharedManager] getCountriesWithCompletion:^(NSArray *array, NSError *error) {
        uint64_t endTime = mach_absolute_time();
        uint64_t elapsedTime = endTime - startTime;
        static double ticksToNanoseconds = 0.0;
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            mach_timebase_info_data_t timebase;
            mach_timebase_info(&timebase);
            ticksToNanoseconds = (double)timebase.numer / timebase.denom;
        });
        double elapsedTimeInNanoseconds = elapsedTime * ticksToNanoseconds;
        DDLogInfo(@"Execution time: %f [ms]", elapsedTimeInNanoseconds/1E6);
        if (!error) {
            if (array) {
                [self.countries removeAllObjects];
                [self.countries addObjectsFromArray:array];
                [[WeatherAppManager sharedManager] startBackgroundCitiesFetchingWithCountries:array];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.tableView reloadData];
                });
            }
        }
    }];
}

#pragma mark - IBAction

- (IBAction)onRefreshControlValueChanged:(id)sender
{
    [[WeatherAppManager sharedManager] getCountriesWithCompletion:^(NSArray *array, NSError *error) {
        
        if (!error) {
            if (array) {
                [self.countries removeAllObjects];
                [self.countries addObjectsFromArray:array];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.tableView reloadData];
                });
            }
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [[self refreshControl] endRefreshing];
        });
    }];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    return [_countries count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CountryCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier
                                                            forIndexPath:indexPath];
    Country *country = [_countries objectAtIndex:indexPath.row];
    cell.textLabel.text = country.countryName;
    return cell;
}

@end

#pragma mark - Testing

@implementation CountriesViewController (Testing)

- (DatabaseHelper *)databaseHelper
{
    if (_databaseHelper == nil) {
        _databaseHelper = [[DatabaseHelper alloc] init];
    }
    return _databaseHelper;
}

- (void)testDataSource
{
    DDLogInfo(@"Country count: %d", [_countries count]);
    for (Country *country in _countries) {
        CountryManagedObject *countryManagedObject = [[self databaseHelper] getCountryManagedObjectWithCountryCode:
                                                      country.countryCode
                                                                                                         inContext:
                                                      [NSManagedObjectContext MR_contextForCurrentThread]];
        NSArray *array = [CityManagedObject MR_findAllWithPredicate:
                          [NSPredicate predicateWithFormat:@"country == %@", countryManagedObject]
                                                          inContext:
                          [NSManagedObjectContext MR_contextForCurrentThread]];
        DDLogInfo(@"City count for %@: %d", country.countryName, [array count]);
        for (City *city in array) {
            CityManagedObject *cityManagedObject = [[self databaseHelper] getCityManagedObjectWithName:city.name
                                                                                             inContext:[NSManagedObjectContext MR_contextForCurrentThread]];
            NSArray *stations = [StationManagedObject MR_findAllWithPredicate:[NSPredicate predicateWithFormat:@"city == %@", cityManagedObject]
                                                                    inContext:
                                 [NSManagedObjectContext MR_contextForCurrentThread]];
            DDLogInfo(@"Station count for %@: %d", city.name, [stations count]);
        }
    }
}

- (void)motionEnded:(UIEventSubtype)motion
          withEvent:(UIEvent *)event
{
    if (motion == UIEventSubtypeMotionShake) {
        [self testDataSource];
    }
}

@end
