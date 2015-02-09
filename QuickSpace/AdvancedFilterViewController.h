//
//  AdvancedFilterViewController.h
//  QuickSpace
//
//  Created by Tony Wang on 1/27/15.
//  Copyright (c) 2015 Jordan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AdvancedFilterViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UISlider *priceSlider;
@property (weak, nonatomic) IBOutlet UISwitch *wifiSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *refrigeratorSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *studySwitch;
@property (weak, nonatomic) IBOutlet UISwitch *computerSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *janitorSwitch;

@property (strong, nonatomic) NSMutableArray *spaceType;
@property (weak, nonatomic) NSDate *startDate;
@property (weak, nonatomic) NSDate *endDate;

@end
