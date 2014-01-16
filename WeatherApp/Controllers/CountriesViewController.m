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
#include <mach/mach_time.h>

@interface CountriesViewController ()

@property (nonatomic, strong) NSMutableArray *countries;

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
    }}

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
        NSLog(@"Execution time: %f [ms]", elapsedTimeInNanoseconds/1E6);
        if (!error) {
            if (array) {
                [self.countries removeAllObjects];
                [self.countries addObjectsFromArray:array];
                [self.tableView reloadData];
            }
        }
        [[self refreshControl] endRefreshing];
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

@end
