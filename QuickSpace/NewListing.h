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

// Retrieve the most recently pinned listing
+ (NewListing *) retrieveNewListing;

// Return nil if the address is valid, error msg otherwise
+ (NSString *) isValidAddress: (NSString *) address;

// Return nil if the price is valid, error msg otherwise
+ (NSString *) isValidPrice: (NSString *) price;

// Set the location coordintes of the listing
- (void) setLocationWith: (MKPlacemark *)placemark;

// Return all available listing based on search criteria
+ (NSArray *) getAllAvailableListingsWithAmenities:(NSArray *) amenities
                                             Types:(NSArray *)spaceType
                                         StartTime:(NSDate *) startTime
                                           EndTime:(NSDate *) endTime
                                             Price:(NSNumber *)price
                                         Longitude:(NSNumber *)longitude
                                          Latitude:(NSNumber *)latitude;

// Return a string version of all the amenities separated by space
- (NSString *) amenitiesToString;

// Return a string version of all the types separated by space
- (NSString *) typesToString;
@end
