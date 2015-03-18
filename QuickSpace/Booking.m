//
//  Booking.m
//  QuickSpace
//
//  Created by Tony Wang on 2/26/15.
//  Copyright (c) 2015 Jordan. All rights reserved.
//

#import "Booking.h"
#import <Parse/PFObject+Subclass.h>
#import "Listing.h"

@implementation Booking
@dynamic startTime;
@dynamic endTime;
@dynamic guest;
@dynamic owner;
@dynamic listing;
@dynamic rating;

+ (void)load {
    //[self registerSubclass];
}

+ (NSString *)parseClassName {
    return @"Booking";
}


@end
