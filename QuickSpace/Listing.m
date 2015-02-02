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
        [listings addObject:lister];
    }
    return listings;
}
@end
