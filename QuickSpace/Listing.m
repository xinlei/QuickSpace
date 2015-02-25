//
//  Listing.m
//  QuickSpace
//
//  Created by Gene Oetomo on 1/25/15.
//  Copyright (c) 2015 Jordan. All rights reserved.
//

#import "Listing.h"
#import <Parse/Parse.h>

@implementation Listing
@synthesize description;
@synthesize object_id;
@synthesize startTime;
@synthesize endTime;
@synthesize guest_id;

+ (NSMutableArray *)objectToListingsWith:(NSArray *)PFObjects {
    NSMutableArray *listings = [[NSMutableArray alloc] init];

    for (PFObject *object in PFObjects) {
        Listing *lister = [[Listing alloc] init];
        [object fetchIfNeeded];
        
        
        PFFile *imageFile = [object[@"images"] firstObject];
        NSData *myData = [imageFile getData];
        lister.imageData = myData;
        
        lister.title = object[@"title"];
        lister.types = object[@"type"];
        lister.location = object[@"location"];
        lister.description = object[@"description"];
        lister.address = object[@"address"];
        lister.object_id = object.objectId;
        lister.owner = object[@"lister"];

        
        // Booking information. These fields are nil if no value has been set
        lister.startTime = object[@"startTime"];
        lister.endTime = object[@"endTime"];
        lister.guest_id = object[@"guest_id"];
        
        
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
    [amenitiesString appendString:@"-"];
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
//    if (self == other)
//        return YES;
//    if(!other || ![other isKindOfClass: [self class]])
//        return NO;
    return [[self object_id] isEqualToString:[other object_id]];
}

//-(unsigned)hash{
//    NSUInteger prime = 31;
//    NSUInteger result = 1;
////    result = prime*result 
//}

@end
