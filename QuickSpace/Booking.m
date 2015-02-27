//
//  Booking.m
//  QuickSpace
//
//  Created by Tony Wang on 2/26/15.
//  Copyright (c) 2015 Jordan. All rights reserved.
//

#import "Booking.h"

@implementation Booking
@synthesize startTime;
@synthesize endTime;
@synthesize guest;
@synthesize owner;
@synthesize listing;
//@synthesize rating = _rating;

- (instancetype)initWithStartTime:(NSDate *)aStartTime endTime:(NSDate *)aEndTime guest:(NSObject *)aGuest owner:(NSObject *)aOwner listing:(Listing *)aListing{
    if (self == [super init]) {
        startTime = aStartTime;
        endTime = aEndTime;
        guest = aGuest;
        owner = aOwner;
        listing = aListing;
        _rating = 0;
    }
    return self;
}

- (NSString *) confirmBooking {
    PFObject *booking = [PFObject objectWithClassName:@"Booking"];
    PFObject *parseListing = [PFObject objectWithoutDataWithClassName:@"Listing" objectId:listing.object_id];
    booking[@"startTime"] = startTime;
    booking[@"endTime"] = endTime;
    booking[@"guest"] = guest;
    booking[@"owner"] = owner;
    booking[@"rating"] = [NSNumber numberWithInt:_rating];
    //[booking setObject:listing forKey:@"listing"];
    booking[@"listing"] = parseListing;
    if([booking save]){
        return [booking objectId];
    } else {
        return nil;
    }
}

@end
