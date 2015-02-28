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

@interface viewBookingsController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *listingTitle;

@property (nonatomic) Listing * listing;

@end
