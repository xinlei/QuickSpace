//
// Listing.m
// QuickSpace
//
// Created by Gene Oetomo on 1/25/15.
// Copyright (c) 2015 Jordan. All rights reserved.
//
#import "Listing.h"
#import <Parse/Parse.h>
@implementation Listing
@synthesize description;
@synthesize object_id;
@synthesize startTime;
@synthesize endTime;
@synthesize guest_id;
+ (NSArray *) getAllAvailableListingsWithAmenities:(NSDictionary *) amenities
                                         withTypes:(NSArray *)spaceType
                                     withStartTime:(NSDate *) startTime
                                       withEndTime:(NSDate *) endTime
                                          forPrice:(NSNumber *)price
                                      forLongitude:(NSNumber *)longitude
                                       forLatitude:(NSNumber *)latitude {
    PFGeoPoint *discoverLocation = [PFGeoPoint geoPointWithLatitude:[latitude doubleValue] longitude:[longitude doubleValue]];
    // PFGeoPoint *currLocationGeoPoint = [PFGeoPoint geoPointWithLocation:_currentLocation];
    // [self.locationManager stopUpdatingLocation];
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
    PFQuery *query = [PFQuery queryWithClassName:@"Listing"];
    [query whereKey:@"objectId" notContainedIn:excludedListings];
    [query whereKey:@"location" nearGeoPoint:discoverLocation withinMiles:20];
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
    if([typeQueryArray count] > 0)
        [query whereKey:@"type" containsAllObjectsInArray:typeQueryArray];
    return [self objectToListingsWith:[query findObjects]];
}
+ (NSMutableArray *)objectToListingsWith:(NSArray *)PFObjects {
    NSMutableArray *listings = [[NSMutableArray alloc] init];
    for (PFObject *object in PFObjects) {
        Listing *lister = [[Listing alloc] init];
        [object fetchIfNeeded];
        NSMutableArray *imageData = [[NSMutableArray alloc]init];
        NSArray *allImageFiles = object[@"images"];
        for(PFFile *file in allImageFiles){
            [imageData addObject:[file getData]];
        }
        lister.allImageData = imageData;
        // PFFile *imageFile = [object[@"images"] firstObject];
        // NSData *myData = [imageFile getData];
        // lister.imageData = myData;
        lister.title = object[@"title"];
        lister.types = object[@"type"];
        lister.location = object[@"location"];
        lister.description = object[@"description"];
        lister.address = object[@"address"];
        lister.object_id = object.objectId;
        lister.owner = object[@"lister"];
        lister.amenitiesArray = object[@"amenities"];
        // Booking information. These fields are nil if no value has been set
        // depreciated
        //lister.startTime = object[@"startTime"];
        //lister.endTime = object[@"endTime"];
        //lister.guest_id = object[@"guest_id"];
        NSMutableString *amenitiesString = [[NSMutableString alloc] init];
        for (NSString *key in object[@"amenities"]) {
            if ([key isEqualToString:@"wifi"]){
                if (amenitiesString.length != 0) [amenitiesString appendString:@"\n"];
                [amenitiesString appendString:@"WiFi Internet"];
            }
            if ([key isEqualToString:@"refrigerator"]){
                if (amenitiesString.length != 0) [amenitiesString appendString:@"\n"];
                [amenitiesString appendString:@"Refrigerator"];
            }
            if ([key isEqualToString:@"studyDesk"]){
                if (amenitiesString.length != 0) [amenitiesString appendString:@"\n"];
                [amenitiesString appendString:@"Study Desk"];
            }
            if ([key isEqualToString:@"monitor"]){
                if (amenitiesString.length != 0) [amenitiesString appendString:@"\n"];
                [amenitiesString appendString:@"Monitor"];
            }
            if ([key isEqualToString:@"services"]){
                if (amenitiesString.length != 0) [amenitiesString appendString:@"\n"];
                [amenitiesString appendString:@"Janitoral Services"];
            }
        }
        lister.amenities = amenitiesString;
        lister.rating = [object[@"ratingValue"] intValue];
        [listings addObject:lister];
    }
    return listings;
}
+ (NSString *)amenitiesToString:(NSArray *)amenities {
    NSMutableString *amenitiesString = [[NSMutableString alloc] init];
    for (NSString *key in amenities) {
        if ([key isEqualToString:@"wifi"]){
            if (amenitiesString.length != 0) [amenitiesString appendString:@"\n"];
            [amenitiesString appendString:@"WiFi Internet"];
        }
        if ([key isEqualToString:@"refrigerator"]){
            if (amenitiesString.length != 0) [amenitiesString appendString:@"\n"];
            [amenitiesString appendString:@"Refrigerator"];
        }
        if ([key isEqualToString:@"studyDesk"]){
            if (amenitiesString.length != 0) [amenitiesString appendString:@"\n"];
            [amenitiesString appendString:@"Study Desk"];
        }
        if ([key isEqualToString:@"monitor"]){
            if (amenitiesString.length != 0) [amenitiesString appendString:@"\n"];
            [amenitiesString appendString:@"Monitor"];
        }
        if ([key isEqualToString:@"services"]){
            if (amenitiesString.length != 0) [amenitiesString appendString:@"\n"];
            [amenitiesString appendString:@"Janitoral Services"];
        }
    }
    return amenitiesString;
}
+ (NSString *) typesToString:(NSArray *)spaceType {
    NSMutableString *typeDesc = [[NSMutableString alloc] init];
    for (NSString *listingType in spaceType){
        if (typeDesc.length != 0)
            [typeDesc appendString:@"\n"];
        [typeDesc appendString:listingType];
    }
    return typeDesc;
}
+ (void) cancelListingForHost:(NSString *) object_id {
    PFQuery *query = [PFQuery queryWithClassName:@"Listing"];
    PFObject *currentListing = [query getObjectWithId: object_id];
    [currentListing delete];
}
- (BOOL) isEqual:(id)other{
    // if (self == other)
    // return YES;
    // if(!other || ![other isKindOfClass: [self class]])
    // return NO;
    return [[self object_id] isEqualToString:[other object_id]];
}
//-(unsigned)hash{
// NSUInteger prime = 31;
// NSUInteger result = 1;
//// result = prime*result
//}
@end