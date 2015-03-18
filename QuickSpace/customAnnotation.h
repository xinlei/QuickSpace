//
//  customAnnotation.h
//  QuickSpace
//
//  Created by Jordan on 3/18/15.
//  Copyright (c) 2015 Jordan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import "NewListing.h"

@interface customAnnotation : NSObject <MKAnnotation>

@property (copy, nonatomic) NSString *title;
@property (nonatomic) CLLocationCoordinate2D coordinate;
@property (nonatomic) NewListing *listing;
@property (copy, nonatomic) NSString *subtitle;

-(id) initWithTitle:(NSString *)title Location:(CLLocationCoordinate2D)coordinate;
-(MKAnnotationView *)annotationView;
-(void) setListing:(NewListing *)listing;
-(void) setSubTitle:(NSString *)subtitle;
@end

