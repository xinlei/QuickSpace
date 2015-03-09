//
// ConfirmationViewController.h
// QuickSpace
//
// Created by Tony Wang on 1/31/15.
// Copyright (c) 2015 Jordan. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "ListingDetailViewController.h"
#import "NewListing.h"
@interface ConfirmationViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIImageView *listingImg;

@property (weak, nonatomic) IBOutlet UILabel *titleText;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceText;

@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@property (weak, nonatomic) IBOutlet UITextView *locationText;
@property (weak, nonatomic) IBOutlet UILabel *amenitiesText;
@property (weak, nonatomic) IBOutlet UILabel *amenitiesLabel;
@property (weak, nonatomic) IBOutlet UITextView *descriptionsText;
@property (weak, nonatomic) IBOutlet UILabel *descriptionsLabel;
@property (weak, nonatomic) IBOutlet UIButton *confirmButton;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (nonatomic, retain) UIImage *theImage;
@property (nonatomic, retain) NSArray *allPhotos;
@property (nonatomic, retain) NewListing *listing;
@end