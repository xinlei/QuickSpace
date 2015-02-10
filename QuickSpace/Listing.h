//
//  Listing.h
//  QuickSpace
//
//  Created by Gene Oetomo on 1/25/15.
//  Copyright (c) 2015 Jordan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

@interface Listing : NSObject

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) PFGeoPoint *location;
@property (nonatomic, strong) NSArray *types;
@property (nonatomic, strong) NSString *description;
@property (nonatomic, strong) NSData *imageData;
@property (nonatomic, strong) NSNumber *price;
@property (nonatomic) NSString *object_id;
@property (nonatomic) NSString *address;

// Booking information
@property (nonatomic, strong) NSDate *startTime;
@property (nonatomic, strong) NSDate *endTime;
@property (nonatomic, strong) NSString *guest_id;

+ (NSMutableArray *)objectToListingsWith:(NSArray *)PFObjects;
+ (NSString *) amenitiesToString:(NSArray *) amenities;
+ (void) cancelListingForHost:(NSString *) object_id;
- (BOOL) isEqual: other;
//- (unsigned) hash;
@end
