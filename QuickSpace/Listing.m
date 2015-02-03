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

+ (NSMutableArray *)objectToListingsWith:(NSArray *)PFObjects {
    NSMutableArray *listings = [[NSMutableArray alloc] init];
    

    for (PFObject *object in PFObjects) {
        PFFile *imageFile = object[@"image"];
        NSData *myData = [imageFile getData];
        
        Listing *lister = [[Listing alloc] init];
        lister.title = object[@"title"];
        lister.type = object[@"type"];
        lister.location = object[@"location"];
        lister.description = object[@"description"];
        lister.imageData = myData;
        lister.object_id = object.objectId;
        [listings addObject:lister];
    }
    return listings;
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
