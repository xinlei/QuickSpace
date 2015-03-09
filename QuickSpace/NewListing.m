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

+ (NewListing *) retrieveNewListing {
    PFQuery *query = [[NewListing query] fromPin];
    NSArray *objects = [query findObjects];
    if([objects count] >= 1) return [objects objectAtIndex:0];
    return nil;
}

- (BOOL) addNewListing {
    [self pin];
    return YES; 
}

- (void) setLocationWith:(MKPlacemark *)placemark{
    self.location = [[PFGeoPoint alloc] init];
    self.location.latitude = placemark.coordinate.latitude;
    self.location.longitude = placemark.coordinate.longitude;
}

+ (NSArray *) getAllAvailableListingsWithAmenities:(NSDictionary *) amenities
                                         withTypes:(NSArray *)spaceType
                                     withStartTime:(NSDate *)startTime
                                       withEndTime:(NSDate *)endTime
                                          forPrice:(NSNumber *)price
                                      forLongitude:(NSNumber *)longitude
                                       forLatitude:(NSNumber *)latitude {
    PFGeoPoint *discoverLocation = [PFGeoPoint geoPointWithLatitude:[latitude doubleValue] longitude:[longitude doubleValue]];
    
    // Exclude booked locations
    __block NSMutableArray *excludedListings = [[NSMutableArray alloc] init];
    PFQuery *innerQuery = [PFQuery queryWithClassName:@"Booking"];
    [innerQuery whereKey:@"endTime" greaterThan:endTime];
    [innerQuery whereKey:@"startTime" lessThan:startTime];
    [innerQuery includeKey:@"listing"];
    NSArray *existingBookings = [innerQuery findObjects];
    for (PFObject *booking in existingBookings) {
        PFObject *listing = [booking objectForKey:@"listing"];
        [excludedListings addObject:[listing valueForKeyPath:@"objectId"]];
    }
    PFQuery *query = [NewListing query];
    [query whereKey:@"objectId" notContainedIn:excludedListings];
    [query whereKey:@"location" nearGeoPoint:discoverLocation withinMiles:50];
    
    bool wifi = [[amenities objectForKey:@"wifi"] boolValue];
    bool refrigerator = [[amenities objectForKey:@"refrigerator"] boolValue];
    bool study = [[amenities objectForKey:@"studyDesk"] boolValue];
    bool monitor = [[amenities objectForKey:@"monitor"] boolValue];
    bool services = [[amenities objectForKey:@"services"] boolValue];
    
    
    NSMutableArray *amenitiesQueryArray = [[NSMutableArray alloc] init];
    
    if(wifi){
        [amenitiesQueryArray addObject:@"wifi"];
    }
    if(refrigerator){
        [amenitiesQueryArray addObject:@"refrigerator"];
    }
    if(study){
        [amenitiesQueryArray addObject:@"studyDesk"];
    }
    if(monitor){
        [amenitiesQueryArray addObject:@"monitor"];
    }
    if(services){
        [amenitiesQueryArray addObject:@"services"];
    }
    
    NSMutableArray *typeQueryArray = [[NSMutableArray alloc] init];
    if ([[spaceType objectAtIndex:0] boolValue] == YES){
        [typeQueryArray addObject:@"Rest"];
    }
    if ([[spaceType objectAtIndex:1] boolValue] == YES){
        [typeQueryArray addObject:@"Closet"];
    }
    if ([[spaceType objectAtIndex:2] boolValue] == YES){
        [typeQueryArray addObject:@"Office"];
    }
    if ([[spaceType objectAtIndex:3] boolValue] == YES){
        [typeQueryArray addObject:@"Quiet"];;
    }
    if([amenitiesQueryArray count] > 0)
        [query whereKey:@"amenities" containsAllObjectsInArray:amenitiesQueryArray];
    if(price > 0)
        [query whereKey:@"price" lessThanOrEqualTo: price];
    if([typeQueryArray count] > 0){
        //[query whereKey:@"type" :typeQueryArray];
    }
    return [query findObjects];
}

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
    
    /*
    for (int i = 0; i < [self.amenities count]; i++) {
        if (i == 0 && [self.amenities[i] boolValue] == YES){
            if (amenitiesString.length != 0) [amenitiesString appendString:@"\n"];
            [amenitiesString appendString:@"WiFi Internet"];
        }
        if (i == 1 && [self.amenities[i] boolValue] == YES){
            if (amenitiesString.length != 0) [amenitiesString appendString:@"\n"];
            [amenitiesString appendString:@"Refrigerator"];
        }
        if (i == 2 && [self.amenities[i] boolValue] == YES){
            if (amenitiesString.length != 0) [amenitiesString appendString:@"\n"];
            [amenitiesString appendString:@"Study Desk"];
        }
        if (i == 3 && [self.amenities[i] boolValue] == YES){
            if (amenitiesString.length != 0) [amenitiesString appendString:@"\n"];
            [amenitiesString appendString:@"Monitor"];
        }
        if (i == 4 && [self.amenities[i] boolValue] == YES){
            if (amenitiesString.length != 0) [amenitiesString appendString:@"\n"];
            [amenitiesString appendString:@"Janitoral Services"];
        }
    }
     */
    return amenitiesString;
}
             
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
    [typesString appendString:@"-"];
    return typesString;

}

+ (void) cancelListingForHost:(NSString *) object_id {
    PFQuery *query = [PFQuery queryWithClassName:@"Listing"];
    PFObject *currentListing = [query getObjectWithId: object_id];
    [currentListing delete];
}

@end
