//
//  CitiesViewController.m
//  WeatherApp
//
//  Created by Renzo Crisóstomo on 1/15/14.
//  Copyright (c) 2014 Ruenzuo. All rights reserved.
//

#import "CitiesViewController.h"
#import "StationsViewController.h"
#import "WeatherAppManager.h"
#import "City.h"
#include <mach/mach_time.h>

static const int ddLogLevel = LOG_LEVEL_INFO;

@interface CitiesViewController ()

@property (nonatomic, strong) NSMutableArray *cities;

- (void)loadCities;

@end

@implementation CitiesViewController
{
}

#pragma mark - View Controller Life Cycle

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        _cities = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self loadCities];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"StationSegue"]) {
        StationsViewController *viewController = (StationsViewController *)[segue destinationViewController];
        NSIndexPath *selectedIndexPath = [self.tableView indexPathForSelectedRow];
        City *city = [_cities objectAtIndex:selectedIndexPath.row];
        viewController.city = city;
    }
}

#pragma mark - Private Methods

/*
 Benchmarking method copied from Peter Steinberger's PSPDFPerformAndTrackTime available here: https://github.com/steipete/PSTFoundationBenchmark
 */

- (void)loadCities
{
    uint64_t startTime = mach_absolute_time();
    [[WeatherAppManager sharedManager] getCitiesWithCountry:_country
                                                 completion:^(NSArray *array, NSError *error) {
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
                                                             [self.cities removeAllObjects];
                                                             [self.cities addObjectsFromArray:array];
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
    [[WeatherAppManager sharedManager] getCitiesWithCountry:_country completion:^(NSArray *array, NSError *error) {
        if (!error) {
            if (array) {
                [self.cities removeAllObjects];
                [self.cities addObjectsFromArray:array];
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_cities count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CityCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    City *city = [_cities objectAtIndex:indexPath.row];
    cell.textLabel.text = city.name;
    return cell;
}

@end
