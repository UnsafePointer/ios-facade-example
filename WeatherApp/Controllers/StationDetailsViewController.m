//
//  StationDetailsViewController.m
//  WeatherApp
//
//  Created by Renzo Crisóstomo on 1/22/14.
//  Copyright (c) 2014 Ruenzuo. All rights reserved.
//

#import "StationDetailsViewController.h"
#import "Station.h"

@interface StationDetailsViewController ()

- (void)setupView;

@end

@implementation StationDetailsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Private Methods

- (void)setupView
{
    _lblHumidity.text = [NSString stringWithFormat:@"%.1f %%", [_station.humidity floatValue]];
    _lblPressure.text = [NSString stringWithFormat:@"%.1f hpa", [_station.pressure floatValue]];
    _lblTemperature.text = [NSString stringWithFormat:@"%.1f °K", [_station.temp floatValue]];
}

@end
