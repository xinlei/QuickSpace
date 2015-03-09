//
//  Amenity.h
//  QuickSpace
//
//  Created by Tony Wang on 3/8/15.
//  Copyright (c) 2015 Jordan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Amenity : NSObject

typedef enum {
    wifi = 0,
    refrigerator = 1,
    studyDesk = 2,
    monitor = 3,
    services = 4,
} Amenities;

@end
