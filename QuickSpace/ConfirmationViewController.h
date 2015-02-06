//
// ConfirmationViewController.h
// QuickSpace
//
// Created by Tony Wang on 1/31/15.
// Copyright (c) 2015 Jordan. All rights reserved.
//
#import <UIKit/UIKit.h>
@interface ConfirmationViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIImageView *listingImg;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@property (weak, nonatomic) IBOutlet UILabel *amenitiesLabel;
@property (weak, nonatomic) IBOutlet UITextView *descriptionLabel;
@property (nonatomic, retain) UIImage *theImage;
@end