//
//  CitiesViewController.m
//  WeatherApp
//
//  Created by Renzo Crisóstomo on 1/15/14.
//  Copyright (c) 2014 Ruenzuo. All rights reserved.
//

#import "CitiesViewController.h"
#import "WeatherAppManager.h"
#import "City.h"

@interface CitiesViewController ()

@property (nonatomic, strong) NSMutableArray *cities;

@end

@implementation CitiesViewController

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - IBAction

- (IBAction)onRefreshControlValueChanged:(id)sender
{
    [[WeatherAppManager sharedManager] getCitiesWithCountry:_country completion:^(NSArray *array, NSError *error) {
        if (!error) {
            if (array) {
                [self.cities removeAllObjects];
                [self.cities addObjectsFromArray:array];
                [self.tableView reloadData];
            }
        }
        [[self refreshControl] endRefreshing];
    }];
}

#pragma mark - TableViewDataSource

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
