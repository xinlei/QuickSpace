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
@synthesize showListViewButton;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    for (NewListing *listing in listings){
        PFGeoPoint *gp = listing.location;
        CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(gp.latitude, gp.longitude);
        MKPointAnnotation *point = [[MKPointAnnotation alloc] init];
        [point setCoordinate:coordinate];
        [point setTitle:listing.title];
        [point setSubtitle:[NSString stringWithFormat:@"Hourly Rate: $%d", listing.price]];
        //point.
        [myMapView addAnnotation:point];
    }
    [myMapView showAnnotations:myMapView.annotations animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control{
    [self performSegueWithIdentifier:@"ShowListingDetail" sender:view];
}

- (IBAction)dismissView:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
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
