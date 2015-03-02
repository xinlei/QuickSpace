//
//  ListingMapViewController.h
//  QuickSpace
//
//  Created by Tony Wang on 3/1/15.
//  Copyright (c) 2015 Jordan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "Listing.h"

@interface ListingMapViewController : UIViewController
@property (weak, nonatomic) IBOutlet MKMapView *myMapView;

@property (nonatomic, strong) NSArray *listings;

@end
