//
//  Booking.h
//  QuickSpace
//
//  Created by Tony Wang on 2/26/15.
//  Copyright (c) 2015 Jordan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Listing.h"
#import "NewListing.h"
#import <Parse/Parse.h>


@interface Booking : PFObject<PFSubclassing>

@property (retain) NSDate *startTime;
@property (retain) NSDate *endTime;
@property (retain) PFUser *guest;
@property (retain) PFUser *owner;
@property (retain) NewListing *listing;
@property (retain) NSString *listing_id;
@property (retain) NSString *listing_title;
@property int rating;

+ (NSString *) parseClassName;

@end