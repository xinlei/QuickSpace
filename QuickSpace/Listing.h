//
//  Listing.h
//  QuickSpace
//
//  Created by Gene Oetomo on 1/25/15.
//  Copyright (c) 2015 Jordan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Listing : NSObject

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *imageName;
@property (nonatomic, strong) NSString *location;
@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSString *description;
@property (nonatomic, strong) NSData *imageData;
@property (nonatomic, strong) NSNumber *price;

+ (NSMutableArray *)objectToListingsWith:(NSArray *)PFObjects;

@end
