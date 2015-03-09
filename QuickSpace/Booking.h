//
//  Booking.h
//  QuickSpace
//
//  Created by Tony Wang on 2/26/15.
//  Copyright (c) 2015 Jordan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Listing.h"
#import <Parse/Parse.h>


@interface Booking : PFObject<PFSubclassing>

@property (retain) NSDate *startTime;
@property (retain) NSDate *endTime;
@property (retain) NSObject *guest;
@property (retain) NSObject *owner;
//@property (retain) Listing *listing;
@property (retain) NSString *listing_id;
@property (retain) NSString *listing_title;
@property int rating;

+ (NSString *) parseClassName;

@end