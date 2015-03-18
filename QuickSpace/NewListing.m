//
//  Listing.m
//  QuickSpace
//
//  Created by Gene Oetomo on 1/25/15.
//  Copyright (c) 2015 Jordan. All rights reserved.
//

#import "NewListing.h"
#import <Parse/PFObject+Subclass.h>
#import <Parse/Parse.h>


@implementation NewListing

@dynamic address;
@dynamic amenities;
@dynamic information;
@dynamic images;
@dynamic lister;
@dynamic location;
@dynamic price;
@dynamic ratingValue;
@dynamic title;
@dynamic totalRaters;
@dynamic totalRating;
@dynamic types;

+ (void) load {
    //[self registerSubclass];
}

+ (NSString *)parseClassName {
    return @"Listing";
}

// Retrieve the most recently pinned listing
+ (NewListing *) retrieveNewListing {
    PFQuery *query = [[NewListing query] fromPin];
    NSArray *objects = [query findObjects];
    if([objects count] >= 1) return [objects objectAtIndex:0];
    return nil;
}

// Set the location coordintes of the listing
- (void) setLocationWith:(MKPlacemark *)placemark{
    self.location = [[PFGeoPoint alloc] init];
    self.location.latitude = placemark.coordinate.latitude;
    self.location.longitude = placemark.coordinate.longitude;
}

// Return all available listing based on search criteria
+ (NSArray *) getAllAvailableListingsWithAmenities:(NSArray *)amenityType
                                             Types:(NSArray *)spaceType
                                         StartTime:(NSDate *)startTime
                                           EndTime:(NSDate *)endTime
                                             Price:(NSNumber *)price
                                         Longitude:(NSNumber *)longitude
                                          Latitude:(NSNumber *)latitude {
    PFGeoPoint *discoverLocation = [PFGeoPoint geoPointWithLatitude:[latitude doubleValue] longitude:[longitude doubleValue]];
    
    // Exclude booked locations
    __block NSMutableArray *excludedListings = [[NSMutableArray alloc] init];
    PFQuery *innerQuery = [PFQuery queryWithClassName:@"Booking"];
    [innerQuery whereKey:@"endTime" greaterThan:endTime];
    [innerQuery whereKey:@"startTime" lessThan:startTime];
    [innerQuery includeKey:@"listing"];
    NSArray *existingBookings = [innerQuery findObjects];
    
    // Get the listings of all the excluded bookings
    for (PFObject *booking in existingBookings) {
        PFObject *listing = [booking objectForKey:@"listing"];
        [excludedListings addObject:[listing valueForKeyPath:@"objectId"]];
    }
    // Get the listings not in the excluded listing list
    PFQuery *query = [NewListing query];
    [query whereKey:@"objectId" notContainedIn:excludedListings];
    
    // Limit to 30 mile radius
    [query whereKey:@"location" nearGeoPoint:discoverLocation withinMiles:25];
    
    // Check amenities
    if([amenityType count] > 0)
        [query whereKey:@"amenities" containsAllObjectsInArray:amenityType];
    // Check prices range
    if(price > 0)
        [query whereKey:@"price" lessThanOrEqualTo: price];
    // Check space type
    if([spaceType count] > 0){
        [query whereKey:@"types" containsAllObjectsInArray:spaceType];
    }
    return [query findObjects];
}

// Return a string version of all the amenities separated by space
- (NSString *) amenitiesToString {
    NSMutableString *amenitiesString = [[NSMutableString alloc] init];
    
    for (NSNumber *value in self.amenities){
        if([value isEqual:[NSNumber numberWithInt:wifi]]) {
            if (amenitiesString.length != 0) [amenitiesString appendString:@"\n"];
            [amenitiesString appendString:@"WiFi Internet"];
        }
        if([value isEqual:[NSNumber numberWithInt:refrigerator]]) {
            if (amenitiesString.length != 0) [amenitiesString appendString:@"\n"];
            [amenitiesString appendString:@"Refrigerator"];
        }
        if([value isEqual:[NSNumber numberWithInt:studyDesk]]){
            if (amenitiesString.length != 0) [amenitiesString appendString:@"\n"];
            [amenitiesString appendString:@"Study Desk"];
        }
        if([value isEqual:[NSNumber numberWithInt:monitor]]){
            if (amenitiesString.length != 0) [amenitiesString appendString:@"\n"];
            [amenitiesString appendString:@"Monitor"];
        }
        if([value isEqual:[NSNumber numberWithInt:services]]){
            if (amenitiesString.length != 0) [amenitiesString appendString:@"\n"];
            [amenitiesString appendString:@"Janitoral Services"];
        }
    }
    return amenitiesString;
}

// Return a string version of all the types separated by space
- (NSString *) typesToString {
    NSMutableString *typesString = [[NSMutableString alloc] init];
    for (NSNumber *value in self.types){
        if ([value isEqual:[NSNumber numberWithInt:rest]]){
            if (typesString.length != 0) [typesString appendString:@"\n"];
            [typesString appendString:@"Rest"];
        }
        if ([value isEqual:[NSNumber numberWithInt:closet]]){
            if (typesString.length != 0) [typesString appendString:@"\n"];
            [typesString appendString:@"Closet"];
        }
        if ([value isEqual:[NSNumber numberWithInt:office]]){
            if (typesString.length != 0) [typesString appendString:@"\n"];
            [typesString appendString:@"Office"];
        }
        if ([value isEqual:[NSNumber numberWithInt:quiet]]){
            if (typesString.length != 0) [typesString appendString:@"\n"];
            [typesString appendString:@"Quiet"];
        }
    }
    return typesString;
}

// Return nil if the address is valid, error msg otherwise
+ (NSString *) isValidAddress: (NSString *) address{
    dispatch_group_t group = dispatch_group_create();
    dispatch_group_enter(group);
    CLGeocoder *location = [[CLGeocoder alloc] init];
    __block NSString *errorMsg;
    
    // Makes an asychronous call to check the address
    [location geocodeAddressString:address completionHandler:^(NSArray* placemarks, NSError* error){
        if (placemarks && placemarks.count > 0) {
            errorMsg = nil;
        } else {
            errorMsg = [NSString stringWithFormat:@"%@ is not a valid address", address];
        }
        dispatch_group_leave(group);
    }];
    // Block until the call is complete
    while (dispatch_group_wait(group, DISPATCH_TIME_NOW)) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode
                                 beforeDate:[NSDate dateWithTimeIntervalSinceNow:1.f]];
    }
    return errorMsg;
}

// Return nil if the price is valid, error msg otherwise
+ (NSString *) isValidPrice: (NSString *) price{
    NSCharacterSet* notDigits = [[NSCharacterSet decimalDigitCharacterSet] invertedSet];
    NSString *error;
    if ([price rangeOfCharacterFromSet:notDigits].location != NSNotFound || [price length] == 0){
        error = @"Price must be a whole number";
    } else if ([price intValue] < 0 || [price intValue] > 500){
        error = @"Set price between 0-500";
    }
    return error;
}


@end
