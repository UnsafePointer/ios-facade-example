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

- (IBAction)onRefreshControlValueChanged:(id)sender
{
    [[WeatherAppManager sharedManager] getCountriesWithCompletion:^(NSArray *array, NSError *error) {
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
