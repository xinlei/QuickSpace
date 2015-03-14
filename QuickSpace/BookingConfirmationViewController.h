//
//  BookingConfirmationViewController.h
//  QuickSpace
//
//  Created by Tony Wang on 2/3/15.
//  Copyright (c) 2015 Jordan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Listing.h"
#import "Booking.h"

@interface BookingConfirmationViewController : UIViewController

@property (nonatomic, strong) Booking *booking;

- (IBAction)homeButton:(id)sender;
- (IBAction)cancelButton:(id)sender;

@end
