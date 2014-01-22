//
//  StationsViewController.h
//  WeatherApp
//
//  Created by Renzo Crisóstomo on 1/21/14.
//  Copyright (c) 2014 Ruenzuo. All rights reserved.
//

#import <UIKit/UIKit.h>

@class City;

@interface StationsViewController : UITableViewController

@property (nonatomic, strong) City *city;

- (IBAction)onRefreshControlValueChanged:(id)sender;

@end
