//
//  viewBookingsController.h
//  QuickSpace
//
//  Created by Gene Oetomo on 2/27/15.
//  Copyright (c) 2015 Jordan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Listing.h"
#import <Parse/Parse.h>
#import "SVProgressHUD.h"
#import "Booking.h"

@interface viewBookingsController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *listingTitle;

@property (weak, nonatomic) IBOutlet UITableView *bookingsTable;
@property (nonatomic) Listing * listing;

-(void) populateBookings;

@end
