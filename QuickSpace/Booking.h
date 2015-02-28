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


@interface Booking : NSObject {
    NSString *objectId; 
    NSDate *startTime;
    NSDate *endTime;
    NSObject *guest;
    NSObject *owner;
    Listing *listing;
    int rating;
}

@property (nonatomic, strong) NSString *objectId;
@property (nonatomic, strong) NSDate *startTime;
@property (nonatomic, strong) NSDate *endTime;
@property (nonatomic, strong) NSObject *guest;
@property (nonatomic, strong) NSObject *owner;
@property (nonatomic, strong) Listing *listing;
@property (nonatomic) int rating;

- (instancetype) initWithStartTime:(NSDate *)aStartTime
                           endTime:(NSDate *)aEndTime
                             guest:(NSObject *)aGuest
                             owner:(NSObject *)aOwner
                           listing:(Listing *)aListing;

- (NSString *) confirm;
- (BOOL) cancel;

@end