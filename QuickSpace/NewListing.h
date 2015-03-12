//
//  Listing.h
//  QuickSpace
//
//  Created by Gene Oetomo on 1/25/15.
//  Copyright (c) 2015 Jordan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>
#import <MapKit/MapKit.h>
#import "Type.h"
#import "Amenity.h"

@interface NewListing : PFObject<PFSubclassing>

@property (retain) NSString *address;
@property (retain) NSMutableArray *amenities;
@property (retain) NSString *information;
@property (retain) NSArray *images;
@property (retain) PFUser *lister;
@property (retain) PFGeoPoint *location;
@property int price;
@property int ratingValue;
@property (retain) NSString *title;
@property int totalRaters;
@property int totalRating;
@property (retain) NSMutableArray *types;

+ (NSString *) parseClassName;

+ (NewListing *) retrieveNewListing;

- (BOOL) addNewListing;

- (void) setLocationWith: (MKPlacemark *)placemark;

+ (NSArray *) getAllAvailableListingsWithAmenities:(NSDictionary *) amenities
                                             Types:(NSArray *)spaceType
                                         StartTime:(NSDate *) startTime
                                           EndTime:(NSDate *) endTime
                                             Price:(NSNumber *)price
                                         Longitude:(NSNumber *)longitude
                                          Latitude:(NSNumber *)latitude;

- (NSString *) amenitiesToString;

- (NSString *) typesToString;

+ (void) cancelListingForHost:(NSString *) object_id;

- (BOOL) isEqual: other;
//- (unsigned) hash;
@end
