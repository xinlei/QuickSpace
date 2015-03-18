//
//  SetLocationViewController.m
//  QuickSpace
//
//  Created by Jordan on 2/8/15.
//  Copyright (c) 2015 Jordan. All rights reserved.
//

#import "SetLocationViewController.h"
#import <MapKit/MapKit.h>
#import "AddDetailViewController.h"

@interface SetLocationViewController ()
@property (strong, nonatomic) IBOutlet MKMapView *myMapView;

@end

@implementation SetLocationViewController
@synthesize address;
@synthesize confirmButton;
@synthesize listing;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Don't let user hit confirm until their input has been verified
    confirmButton.hidden = YES;
    
    // Get coordinations from address string
    CLGeocoder *location = [[CLGeocoder alloc] init];
    [location geocodeAddressString:listing.address completionHandler:^(NSArray* placemarks, NSError* error){
        if (placemarks && placemarks.count > 0) {
            CLPlacemark *topResult = [placemarks objectAtIndex:0];
            MKPlacemark *placemark = [[MKPlacemark alloc] initWithPlacemark:topResult];
            
            MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(placemark.coordinate, 5000, 5000);
            
            // Save coordinations to listing
            [listing setLocationWith:placemark];
            [self.myMapView setRegion:region animated:YES];
            [self.myMapView addAnnotation:placemark];
            
            confirmButton.hidden = NO;
        } else {
            //Could not find a physical location for user input so report error
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Invalid Location" message:[NSString stringWithFormat:@"%@ is not a valid address", listing.address] delegate:self cancelButtonTitle:@"Try Again" otherButtonTitles: nil];
            [alert show];
        }
    }];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    // After closing alert go back to previous view
    if (buttonIndex == 0)
        [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    AddDetailViewController *destViewController = segue.destinationViewController;
    destViewController.listing = listing;
}

@end
