//
//  StationsViewController.m
//  WeatherApp
//
//  Created by Renzo Crisóstomo on 1/21/14.
//  Copyright (c) 2014 Ruenzuo. All rights reserved.
//

#import "StationsViewController.h"
#import "WeatherAppManager.h"
#import "Station.h"
#import "StationDetailsViewController.h"
#include <mach/mach_time.h>

static const int ddLogLevel = LOG_LEVEL_INFO;

@interface StationsViewController ()

@property (nonatomic, strong) NSMutableArray *stations;

@end

@implementation StationsViewController

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        _stations = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self loadStations];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"StationDetailsSegue"]) {
        StationDetailsViewController *viewController = (StationDetailsViewController *)[segue destinationViewController];
        NSIndexPath *selectedIndexPath = [self.tableView indexPathForSelectedRow];
        Station *station = [_stations objectAtIndex:selectedIndexPath.row];
        viewController.station = station;
    }
}


#pragma mark - Private Methods

/*
 Benchmarking method copied from Peter Steinberger's PSPDFPerformAndTrackTime available here: https://github.com/steipete/PSTFoundationBenchmark
 */

- (void)loadStations
{
    uint64_t startTime = mach_absolute_time();
    [[WeatherAppManager sharedManager] getStationsWithCity:_city
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
                                                            [self.stations removeAllObjects];
                                                            [self.stations addObjectsFromArray:array];
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
    [[WeatherAppManager sharedManager] getStationsWithCity:_city
                                                completion:^(NSArray *array, NSError *error) {
        if (!error) {
            if (array) {
                [self.stations removeAllObjects];
                [self.stations addObjectsFromArray:array];
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
    return [_stations count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"StationCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    Station *station = [_stations objectAtIndex:indexPath.row];
    cell.textLabel.text = station.name;
    return cell;
}

@end
