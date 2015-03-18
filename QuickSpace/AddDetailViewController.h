//
//  AddDetailViewController.h
//  QuickSpace
//
//  Created by Tony Wang on 1/29/15.
//  Copyright (c) 2015 Jordan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Listing.h"
#import "NewListing.h"

@interface AddDetailViewController : UIViewController<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UISwitch *wifiSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *refrigeratorSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *studyDeskSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *monitorSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *servicesSwitch;
@property (weak, nonatomic) IBOutlet UITextField *priceTextField;
@property (nonatomic, strong) NewListing *listing;

@property (weak, nonatomic) UIScrollView *scrollView;
@end
