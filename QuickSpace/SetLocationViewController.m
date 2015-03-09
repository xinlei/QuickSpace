//
//  SetLocationViewController.m
//  QuickSpace
//
//  Created by Jordan on 2/8/15.
//  Copyright (c) 2015 Jordan. All rights reserved.
//

#import "SetLocationViewController.h"
#import <MapKit/MapKit.h>

@interface SetLocationViewController ()
@property (strong, nonatomic) IBOutlet MKMapView *myMapView;

@end

@implementation SetLocationViewController

@synthesize listing;

- (void)viewDidLoad {
    [super viewDidLoad];
    PFQuery *query = [NewListing query];
    [query fromLocalDatastore]; 
    NSArray *objects = [query findObjects];
    listing = [NewListing retrieveNewListing];
    [listing fetchFromLocalDatastore];
    
    CLGeocoder *location = [[CLGeocoder alloc] init];
    [location geocodeAddressString:listing.address completionHandler:^(NSArray* placemarks, NSError* error){
        if (placemarks && placemarks.count > 0) {
            CLPlacemark *topResult = [placemarks objectAtIndex:0];
            MKPlacemark *placemark = [[MKPlacemark alloc] initWithPlacemark:topResult];
            
            MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(placemark.coordinate, 5000, 5000);
            
            [listing setLocationWith:placemark];
            [self.myMapView setRegion:region animated:YES];
            [self.myMapView addAnnotation:placemark];
        } else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Invalid Location" message:[NSString stringWithFormat:@"%@ is not a valid address", listing.address] delegate:self cancelButtonTitle:@"Try Again" otherButtonTitles: nil];
            [alert show];
        }
    }];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
        [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
