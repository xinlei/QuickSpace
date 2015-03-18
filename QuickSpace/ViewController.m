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
#import "ListingMapViewController.h"
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
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self populateListings];
    [self.tableView reloadData]; 
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)viewSwitcherValueChanged:(UISegmentedControl *)sender {
    if (viewSwitcher.selectedSegmentIndex == 1){
        [self dismissViewControllerAnimated:NO completion:^{
        }];
    }
}

// Fill an array of available listings given a set of user filters
-(void) populateListings{
    listings = [[NSArray alloc] init];
    [SVProgressHUD show];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSArray *amenityType = [defaults objectForKey:@"amenityType"];
        NSNumber *price = [defaults objectForKey:@"maxPrice"];
        NSNumber *latitude = [defaults objectForKey:@"latitude"];
        NSNumber *longitude = [defaults objectForKey:@"longitude"];
        NSDate *startTime = [defaults objectForKey:@"startTime"];
        NSDate *endTime = [defaults objectForKey:@"endTime"];
        NSArray *spaceType = [defaults objectForKey:@"spaceTypes"];
        
        // Get all available listings currently not booked
        listings = [NewListing getAllAvailableListingsWithAmenities:amenityType Types:spaceType StartTime:startTime EndTime:endTime Price:price Longitude:longitude Latitude:latitude];
        
        // Reset filters
        [defaults removeObjectForKey:@"additionalFilters"];
        [defaults removeObjectForKey:@"maxPrice"];
        [defaults removeObjectForKey:@"amenityType"];
        
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
    if (buttonIndex == 0)[self.navigationController popViewControllerAnimated:YES];
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
    NewListing *thisListing = [listings objectAtIndex:indexPath.row];
    
    // Set background image
    cell.backgroundView.contentMode = UIViewContentModeTop;
    cell.selectedBackgroundView = [[UIImageView alloc] initWithImage:[UIImage imageWithData: [[thisListing.images firstObject] getData]]];
    cell.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageWithData: [[thisListing.images firstObject] getData]]];
    
    // Title and location
    UILabel *title = (UILabel *)[cell viewWithTag:2];
    title.text = thisListing.title;
    UILabel *location = (UILabel *)[cell viewWithTag:4];
    location.text = thisListing.address;
    return cell;
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"ShowListingDetail"]){
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        ListingDetailViewController *destViewController = segue.destinationViewController;
        destViewController.listing = [listings objectAtIndex:indexPath.row];
    }
    if ([segue.identifier isEqualToString:@"ShowMapView"]){
        ListingMapViewController *desViewController = segue.destinationViewController;
        desViewController.listings = listings; 
    }
}
@end
