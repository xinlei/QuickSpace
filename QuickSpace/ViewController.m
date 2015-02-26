//
//  ViewController.m
//  QuickSpace
//
//  Created by Jordan on 1/22/15.
//  Copyright (c) 2015 Jordan. All rights reserved.
//

#import "ViewController.h"
#import <Parse/Parse.h>
#import <QuartzCore/QuartzCore.h>
#import "SVProgressHUD.h"
#import "ListingDetailViewController.h"
#import "Listing.h"

@interface ViewController ()

@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) CLLocation *currentLocation;

-(void) populateListings;

@end

@implementation ViewController
@synthesize viewSwitcher;

NSArray *listings;

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    [self.locationManager startUpdatingLocation];
//
//    CLLocation *location = self.locationManager.location;
//    if (location) {
//        self.currentLocation = location;
//    }
    self.tableView.rowHeight = 226;
    [self populateListings];
}

//Taken from the AnyWall Parse tutorial
//- (CLLocationManager *)locationManager {
//    if (_locationManager == nil) {
//        _locationManager = [[CLLocationManager alloc] init];
//        _locationManager.delegate = self;
//        _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
//        _locationManager.distanceFilter = kCLLocationAccuracyNearestTenMeters;
//    }
//    return _locationManager;
//}

//Taken from the AnyWall Parse tutorial
//- (void)locationManager:(CLLocationManager *)manager
//    didUpdateToLocation:(CLLocation *)newLocation
//           fromLocation:(CLLocation *)oldLocation {
//    self.currentLocation = newLocation;
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)viewSwitcherValueChanged:(UISegmentedControl *)sender {
    if (viewSwitcher.selectedSegmentIndex == 1){
        
    }
}

-(void) populateListings{
    listings = [[NSArray alloc] init];
    [SVProgressHUD show];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSDictionary *amenities = [defaults objectForKey:@"additionalFilters"];
        NSNumber *price = [defaults objectForKey:@"maxPrice"];
        NSNumber *latitude = [defaults objectForKey:@"latitude"];
        NSNumber *longitude = [defaults objectForKey:@"longitude"];
        
        // Get all available listings currently not booked
        listings = [Listing getAllAvailableListingsWithAmenities:amenities withTypes:self.spaceType withStartTime:self.startDate withEndTime:self.endDate forPrice:price forLongitude:longitude forLatitude:latitude];
        
        // Reset filters
        [defaults removeObjectForKey:@"additionalFilters"];
        [defaults removeObjectForKey:@"maxPrice"];
        
        // Completion block
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
            [SVProgressHUD dismiss];
            
            // Error message if no listing is available
            if ([listings count] == 0){
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No Listings Available" message:@"Be the first to post a listing in this area!" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
                [alert show];
            }
        });
    });
}

// Go back to the previous screen when no listing is avilable
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0){
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [listings count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"ListingCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil)
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    Listing *thisListing = [listings objectAtIndex:indexPath.row];
    UIImageView *image = (UIImageView *)[cell viewWithTag:1];
    image.image = [UIImage imageWithData: thisListing.imageData];
    UILabel *title = (UILabel *)[cell viewWithTag:2];
    title.text = thisListing.title;
    
    NSMutableString *typeDesc = [[NSMutableString alloc] init];
    NSArray *spaceType = thisListing.types;
    for (NSString *listingType in spaceType){
//        [typeDesc appendString:@"- "];
        [typeDesc appendString:listingType];
        [typeDesc appendString:@" "];
    }
//    [typeDesc appendString:@"-"];
    
    UILabel *type = (UILabel *)[cell viewWithTag:3];
    type.text = typeDesc;

    UILabel *location = (UILabel *)[cell viewWithTag:4];
    location.text = thisListing.address;
    
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
//    cell.accessoryType = UITableViewCellAccessoryCheckmark;
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"ShowListingDetail"]){
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        ListingDetailViewController *destViewController = segue.destinationViewController;
        destViewController.listing = [listings objectAtIndex:indexPath.row];
    }
}
@end
