//
//  editListingViewController.h
//  QuickSpace
//
//  Created by Jordan on 2/17/15.
//  Copyright (c) 2015 Jordan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Listing.h"
#import "NewListing.h"
#import "ListingDetailViewController.h"

@interface editListingViewController : UIViewController
@property (strong, nonatomic) IBOutlet UIImageView *image;
//title
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UITextField *titleText;

//space types
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;

@property (weak, nonatomic) IBOutlet UILabel *restLabel;
@property (strong, nonatomic) IBOutlet UISwitch *restSwitch;
@property (weak, nonatomic) IBOutlet UILabel *closetLabel;
@property (strong, nonatomic) IBOutlet UISwitch *closetSwitch;
@property (weak, nonatomic) IBOutlet UILabel *quietLabel;
@property (strong, nonatomic) IBOutlet UISwitch *quietSwitch;
@property (weak, nonatomic) IBOutlet UILabel *officeLabel;
@property (strong, nonatomic) IBOutlet UISwitch *officeSwitch;

//address
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UITextField *addressTextField;

//amenities
@property (weak, nonatomic) IBOutlet UILabel *amenitiesLabel;
@property (weak, nonatomic) IBOutlet UILabel *wifiLabel;
@property (strong, nonatomic) IBOutlet UISwitch *wifiSwitch;
@property (weak, nonatomic) IBOutlet UILabel *fridgeLabel;
@property (strong, nonatomic) IBOutlet UISwitch *fridgeSwitch;
@property (weak, nonatomic) IBOutlet UILabel *deskLabel;
@property (strong, nonatomic) IBOutlet UISwitch *deskSwitch;
@property (weak, nonatomic) IBOutlet UILabel *servicesLabel;
@property (strong, nonatomic) IBOutlet UISwitch *servicesSwitch;
@property (weak, nonatomic) IBOutlet UILabel *monitorLabel;
@property (strong, nonatomic) IBOutlet UISwitch *monitorSwitch;

//decriptions
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (strong, nonatomic) IBOutlet UITextField *descriptionTextField;

@property (weak, nonatomic) IBOutlet UIButton *saveButton;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (nonatomic) NewListing *listing;

- (IBAction)saveButtonClick:(id)sender;

+ (void) centerLeft:(UIView *)item inFrame:(CGRect)viewFrame;

@end
