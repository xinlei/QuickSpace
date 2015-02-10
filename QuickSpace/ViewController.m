//
//  ViewController.m
//  QuickSpace
//
//  Created by Jordan on 1/22/15.
//  Copyright (c) 2015 Jordan. All rights reserved.
//

#import "ViewController.h"
#import <Parse/Parse.h>
#import "ListingDetailViewController.h"
#import "Listing.h"

@interface ViewController ()

@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) CLLocation *currentLocation;
-(void) populateListings;
@end

@implementation ViewController

NSArray *listings;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.locationManager startUpdatingLocation];
    
    CLLocation *location = self.locationManager.location;
    if (location) {
        self.currentLocation = location;
    }
    [self populateListings];
}

//Taken from the AnyWall Parse tutorial
- (CLLocationManager *)locationManager {
    if (_locationManager == nil) {
        _locationManager = [[CLLocationManager alloc] init];
        _locationManager.delegate = self;
        _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        _locationManager.distanceFilter = kCLLocationAccuracyNearestTenMeters;
    }
    return _locationManager;
}

//Taken from the AnyWall Parse tutorial
- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation {
    self.currentLocation = newLocation;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) populateListings{
    listings = [[NSArray alloc] init];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *amenities = [defaults objectForKey:@"additionalFilters"];
    NSNumber *price = [defaults objectForKey:@"maxPrice"];
    
//    PFGeoPoint *currLocationGeoPoint = [PFGeoPoint geoPointWithLocation:_currentLocation];
//    [self.locationManager stopUpdatingLocation];
    
    PFQuery *fakeQuery = [PFQuery queryWithClassName:@"ListingObject"];
//    [fakeQuery whereKey:@"location" nearGeoPoint:currLocationGeoPoint];
    
    listings = [Listing objectToListingsWith:[fakeQuery findObjects]];
    
    bool wifi = [[amenities objectForKey:@"wifi"] boolValue];
    bool refrigerator = [[amenities objectForKey:@"refrigerator"] boolValue];
    bool study = [[amenities objectForKey:@"studyDesk"] boolValue];
    bool monitor = [[amenities objectForKey:@"monitor"] boolValue];
    bool services = [[amenities objectForKey:@"services"] boolValue];
    
    
    NSMutableArray *queryArray = [[NSMutableArray alloc] init];
    
    if(wifi){
        [queryArray addObject:@"wifi"];
    }
    if(refrigerator){
        [queryArray addObject:@"refrigerator"];
    }
    if(study){
        [queryArray addObject:@"studyDesk"];
    }
    if(monitor){
        [queryArray addObject:@"monitor"];
    }
    if(services){
        [queryArray addObject:@"services"];
    }
    
    PFQuery *query = [PFQuery queryWithClassName:@"ListingObject"];
    if([queryArray count] != 0)
        [query whereKey:@"amenities" containsAllObjectsInArray:queryArray];
    if(price > 0)
        [query whereKey:@"price" lessThanOrEqualTo: price];
    
    if([queryArray count] != 0 || price > 0){
        NSArray* AllListings = [query findObjects];
        listings = [Listing objectToListingsWith:AllListings];
    }
    
    [defaults removeObjectForKey:@"additionalFilters"];
    [defaults removeObjectForKey:@"maxPrice"];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [listings count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"ListingCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    
    Listing *thisListing = [listings objectAtIndex:indexPath.row];
    UIImageView *image = (UIImageView *)[cell viewWithTag:1];
    image.image = [UIImage imageWithData: thisListing.imageData];
    
    UILabel *title = (UILabel *)[cell viewWithTag:2];
    title.text = thisListing.title;
    
    UILabel *type = (UILabel *)[cell viewWithTag:3];
    type.text = thisListing.type;
    
    UILabel *location = (UILabel *)[cell viewWithTag:4];
    location.text = thisListing.location;
    
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
