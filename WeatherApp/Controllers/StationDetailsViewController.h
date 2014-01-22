//
//  StationDetailsViewController.h
//  WeatherApp
//
//  Created by Renzo Crisóstomo on 1/22/14.
//  Copyright (c) 2014 Ruenzuo. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Station;

@interface StationDetailsViewController : UITableViewController

@property (nonatomic, strong) Station *station;
@property (nonatomic, weak) IBOutlet UILabel *lblTemperature;
@property (nonatomic, weak) IBOutlet UILabel *lblPressure;
@property (nonatomic, weak) IBOutlet UILabel *lblHumidity;

@end
