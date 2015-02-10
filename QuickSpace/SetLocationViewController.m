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

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(BOOL) textFieldShouldReturn:(UITextField *)textField
{
    [[self addressTextField] resignFirstResponder];
    return YES;
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)search:(id)sender {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    CLGeocoder *location = [[CLGeocoder alloc] init];
    [location geocodeAddressString:self.addressTextField.text completionHandler:^(NSArray* placemarks, NSError* error){
        if (placemarks && placemarks.count > 0) {
            CLPlacemark *topResult = [placemarks objectAtIndex:0];
            MKPlacemark *placemark = [[MKPlacemark alloc] initWithPlacemark:topResult];
            
            MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(placemark.coordinate, 5000, 5000);
            
            
            NSNumber *latitude = [NSNumber numberWithDouble:placemark.coordinate.latitude];
            NSNumber *longitude = [NSNumber numberWithDouble:placemark.coordinate.longitude];
            
            [defaults setObject:latitude forKey:@"Latitude"];
            [defaults setObject:longitude forKey:@"Longitude"];
            NSLog(@"Latitude: %@ Longitude: %@", latitude, longitude);
            
            [self.myMapView setRegion:region animated:YES];
            [self.myMapView addAnnotation:placemark];
        }
    }];

}
@end
