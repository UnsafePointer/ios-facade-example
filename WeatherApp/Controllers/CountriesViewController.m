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
#include <mach/mach_time.h>

static const int ddLogLevel = LOG_LEVEL_INFO;

@interface CountriesViewController ()

@property (nonatomic, strong) NSMutableArray *countries;

- (void)loadCountries;

@end

@interface CountriesViewController (Testing)

- (void)testDataSource;

@end

@implementation CountriesViewController

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

- (void)loadCountries
{
    [[WeatherAppManager sharedManager] getCountriesWithCompletion:^(NSArray *array, NSError *error) {
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

/*
 Benchmarking method copied from Peter Steinberger's PSPDFPerformAndTrackTime available here: https://github.com/steipete/PSTFoundationBenchmark
 */

- (IBAction)onRefreshControlValueChanged:(id)sender
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

#pragma mark - TableViewDataSource

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

#pragma mark - Testing

- (void)testDataSource
{
    NSLog(@"Total countries: %d", [_countries count]);
    for (Country *country in _countries) {
        NSLog(@"Total cities: %d", [country.cities count]);
        for (City *city in country.cities) {
            
        }
    }
}

- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    if (motion == UIEventSubtypeMotionShake) {
        [self testDataSource];
    }
}

@end
