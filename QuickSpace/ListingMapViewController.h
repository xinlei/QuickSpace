//
//  ListingMapViewController.h
//  QuickSpace
//
//  Created by Tony Wang on 3/1/15.
//  Copyright (c) 2015 Jordan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <MapKit/MKPointAnnotation.h>
#import "Listing.h"
#import "NewListing.h"
#import "customAnnotation.h"

@interface ListingMapViewController : UIViewController <MKMapViewDelegate>
@property (weak, nonatomic) IBOutlet MKMapView *myMapView;
@property (weak, nonatomic) IBOutlet UIButton *showListViewButton;

@property (nonatomic, strong) NSArray *listings;

@end
