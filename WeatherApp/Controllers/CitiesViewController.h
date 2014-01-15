//
//  CitiesViewController.h
//  WeatherApp
//
//  Created by Renzo Crisóstomo on 1/15/14.
//  Copyright (c) 2014 Ruenzuo. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Country;

@interface CitiesViewController : UITableViewController

@property (nonatomic, strong) Country *country;

- (IBAction)onRefreshControlValueChanged:(id)sender;

@end
