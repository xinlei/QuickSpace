//
//  AddDetailViewController.h
//  QuickSpace
//
//  Created by Tony Wang on 1/29/15.
//  Copyright (c) 2015 Jordan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Listing.h"

@interface AddDetailViewController : UIViewController
@property (weak, nonatomic) IBOutlet UISwitch *wifiSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *refrigeratorSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *studyDeskSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *monitorSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *servicesSwitch;
@property (weak, nonatomic) IBOutlet UITextField *priceTextField;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

@end
