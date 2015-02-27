//
//  editListingViewController.h
//  QuickSpace
//
//  Created by Jordan on 2/17/15.
//  Copyright (c) 2015 Jordan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Listing.h"

@interface editListingViewController : UIViewController
@property (strong, nonatomic) IBOutlet UITextField *titleText;

@property (strong, nonatomic) IBOutlet UILabel *locationLabel;

@property (strong, nonatomic) IBOutlet UITextField *descriptionTextField;
@property (strong, nonatomic) IBOutlet UITextField *addressTextField;

@property (nonatomic) Listing *listing;
@property (strong, nonatomic) IBOutlet UIImageView *image;
@property (strong, nonatomic) IBOutlet UISwitch *restSwitch;
@property (strong, nonatomic) IBOutlet UISwitch *closetSwitch;
@property (strong, nonatomic) IBOutlet UISwitch *quietSwitch;
@property (strong, nonatomic) IBOutlet UISwitch *officeSwitch;

@end
