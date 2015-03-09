//
//  ListingDetailViewController.h
//  QuickSpace
//
//  Created by Gene Oetomo on 1/23/15.
//  Copyright (c) 2015 Jordan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Listing.h"
#import "NewListing.h"
#import "Booking.h"

@interface ListingDetailViewController : UIViewController <UIGestureRecognizerDelegate>

@property (nonatomic, strong) NewListing *listing;
@property (nonatomic, strong) Booking *booking;

@property (nonatomic, strong) IBOutlet UIImageView *image;
@property (nonatomic, strong) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
@property (weak, nonatomic) IBOutlet UILabel *ratingLabel;

@property (weak, nonatomic) IBOutlet UITextView *locationText;
@property (weak, nonatomic) IBOutlet UILabel *location;

@property (weak, nonatomic) IBOutlet UILabel *amenitiesLabel;
@property (weak, nonatomic) IBOutlet UILabel *amenities;

@property (weak, nonatomic) IBOutlet UILabel *descriptions;
@property (weak, nonatomic) IBOutlet UITextView *descriptionsText;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIButton *bookButton;

+(void) setItemLocation:(UIView *)item withPrev:(UIView *)prev apartBy:(CGFloat)dist atX:(CGFloat)x;
+(void) addSeparatorOnto:(UIView *)view at:(CGFloat)y;

@end
