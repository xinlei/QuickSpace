//
//  ListingMapViewController.m
//  QuickSpace
//
//  Created by Tony Wang on 3/1/15.
//  Copyright (c) 2015 Jordan. All rights reserved.
//

#import "ListingMapViewController.h"
#import "ListingDetailViewController.h"

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
        customAnnotation *point = [[customAnnotation alloc]initWithTitle:listing.title Location:coordinate];
        [point setSubTitle:[NSString stringWithFormat:@"Price: %d", listing.price]];
        [point setListing:listing];
        [myMapView addAnnotation:point];
    }
    [myMapView showAnnotations:myMapView.annotations animated:YES];
}

-(MKAnnotationView *)mapView:(MKMapView*)mapView viewForAnnotation:(id<MKAnnotation>)annotation{
    if([annotation isKindOfClass:[customAnnotation class]]){
        customAnnotation *myPin = (customAnnotation *)annotation;
        MKAnnotationView *annotationView = [mapView dequeueReusableAnnotationViewWithIdentifier:@"customAnnotation"];//
        
        if (annotationView == nil)
            annotationView = myPin.annotationView;
        else
            annotationView.annotation = annotation;
        
        annotationView.canShowCallout = YES;
        annotationView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        return annotationView;
    }
    return nil;
}

-(void)mapView:(MKMapView*) mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control{
    [self performSegueWithIdentifier:@"toDetailViewController" sender:view];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)dismissView:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"toDetailViewController"]){
        ListingDetailViewController* destViewController = segue.destinationViewController;
        MKAnnotationView *annotationView = sender;
        customAnnotation *myAnnotation = annotationView.annotation;
        
        destViewController.listing = myAnnotation.listing;
    }
}

@end
