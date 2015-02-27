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
@property (nonatomic) NSString *amenities;
@property (nonatomic) int rating;
@property (nonatomic) NSString *owner;
@property (nonatomic) NSArray *allImageData;

// Booking information
@property (nonatomic, strong) NSDate *startTime;
@property (nonatomic, strong) NSDate *endTime;
@property (nonatomic, strong) NSString *guest_id;

+ (NSArray *) getAllAvailableListingsWithAmenities:(NSDictionary *) amenities
                                         withTypes:(NSArray *)spaceType
                                     withStartTime:(NSDate *) startTime
                                       withEndTime:(NSDate *) endTime
                                          forPrice:(NSNumber *)price
                                      forLongitude:(NSNumber *)longitude
                                       forLatitude:(NSNumber *)latitude; 
+ (NSMutableArray *)objectToListingsWith:(NSArray *)PFObjects;
+ (NSString *) amenitiesToString:(NSArray *) amenities;
+ (NSString *) typesToString:(NSArray *) spaceType;
+ (void) cancelListingForHost:(NSString *) object_id;
- (BOOL) isEqual: other;
//- (unsigned) hash;
@end
