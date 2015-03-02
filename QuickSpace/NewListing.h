//
//  Listing.h
//  QuickSpace
//
//  Created by Gene Oetomo on 1/25/15.
//  Copyright (c) 2015 Jordan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

@interface NewListing : PFObject<PFSubclassing>

@property (retain) NSString *address;
@property (retain) NSArray *amenities;
@property (retain) NSString *description;
@property (retain) PFFile *image;
@property (retain) PFUser *lister;
@property (retain) PFGeoPoint *location;
@property int price;
@property int ratingValue;
@property (retain) NSString *title;
@property int totalRaters;
@property (retain) NSArray *types;

+ (NSString *) parseClassName;

+ (NSArray *) getAllAvailableListingsWithAmenities:(NSDictionary *) amenities
                                         withTypes:(NSArray *)spaceType
                                     withStartTime:(NSDate *) startTime
                                       withEndTime:(NSDate *) endTime
                                          forPrice:(NSNumber *)price
                                      forLongitude:(NSNumber *)longitude
                                       forLatitude:(NSNumber *)latitude;

//+ (NSMutableArray *)objectToListingsWith:(NSArray *)PFObjects;

+ (NSString *) amenitiesToString:(NSArray *) amenities;

+ (NSString *) typesToString:(NSArray *) spaceType;

+ (void) cancelListingForHost:(NSString *) object_id;

- (BOOL) isEqual: other;
//- (unsigned) hash;
@end
