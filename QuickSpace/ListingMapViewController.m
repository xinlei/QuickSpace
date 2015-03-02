//
//  ListingMapViewController.m
//  QuickSpace
//
//  Created by Tony Wang on 3/1/15.
//  Copyright (c) 2015 Jordan. All rights reserved.
//

#import "ListingMapViewController.h"

@interface ListingMapViewController ()

@end

@implementation ListingMapViewController

@synthesize myMapView;
@synthesize listings;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    for (Listing *listing in listings){
        PFGeoPoint *gp = listing.location;
        CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(gp.latitude, gp.longitude);
        MKPlacemark *placemark = [[MKPlacemark alloc] initWithCoordinate:coordinate addressDictionary:nil];
        [myMapView addAnnotation:placemark];
    }
    [myMapView showAnnotations:myMapView.annotations animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
