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
    
//    [self.locationManager startUpdatingLocation];
//
//    CLLocation *location = self.locationManager.location;
//    if (location) {
//        self.currentLocation = location;
//    }

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

-(void) populateListings{
    listings = [[NSArray alloc] init];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *amenities = [defaults objectForKey:@"additionalFilters"];
    NSNumber *price = [defaults objectForKey:@"maxPrice"];
    NSNumber *latitude = [defaults objectForKey:@"latitude"];
    NSNumber *longitude = [defaults objectForKey:@"longitude"];
    PFGeoPoint *discoverLocation = [PFGeoPoint geoPointWithLatitude:[latitude doubleValue] longitude:[longitude doubleValue]];
    NSLog(@"Latitude: %f. Longitude: %f", [latitude doubleValue], [longitude doubleValue]);

//    PFGeoPoint *currLocationGeoPoint = [PFGeoPoint geoPointWithLocation:_currentLocation];
//    [self.locationManager stopUpdatingLocation];
    
    // Exclude booked locations
    NSDate *now = [NSDate date];
    __block NSMutableArray *excludedListings = [[NSMutableArray alloc] init];
    PFQuery *innerQuery = [PFQuery queryWithClassName:@"Booking"];
    [innerQuery whereKey:@"endTime" greaterThan:now];
    [innerQuery whereKey:@"startTime" lessThan:now];
    [innerQuery includeKey:@"listing"];
    NSArray *existingBookings = [innerQuery findObjects];
    for (PFObject *booking in existingBookings) {
        PFObject *listing = [booking objectForKey:@"listing"];
        [excludedListings addObject:[listing valueForKeyPath:@"objectId"]];
    }
    PFQuery *query = [PFQuery queryWithClassName:@"Listing"];
    [query whereKey:@"objectId" notContainedIn:excludedListings];
    
    // End
    [query whereKey:@"location" nearGeoPoint:discoverLocation withinMiles:20];
    bool wifi = [[amenities objectForKey:@"wifi"] boolValue];
    bool refrigerator = [[amenities objectForKey:@"refrigerator"] boolValue];
    bool study = [[amenities objectForKey:@"studyDesk"] boolValue];
    bool monitor = [[amenities objectForKey:@"monitor"] boolValue];
    bool services = [[amenities objectForKey:@"services"] boolValue];
    
    
    NSMutableArray *amenitiesQueryArray = [[NSMutableArray alloc] init];
    
    if(wifi){
        [amenitiesQueryArray addObject:@"wifi"];
    }
    if(refrigerator){
        [amenitiesQueryArray addObject:@"refrigerator"];
    }
    if(study){
        [amenitiesQueryArray addObject:@"studyDesk"];
    }
    if(monitor){
        [amenitiesQueryArray addObject:@"monitor"];
    }
    if(services){
        [amenitiesQueryArray addObject:@"services"];
    }
    
    NSMutableArray *typeQueryArray = [[NSMutableArray alloc] init];
    if ([[self.spaceType objectAtIndex:0] boolValue] == YES){
        [typeQueryArray addObject:@"Rest"];
    }
    if ([[self.spaceType objectAtIndex:1] boolValue] == YES){
        [typeQueryArray addObject:@"Closet"];
    }
    if ([[self.spaceType objectAtIndex:2] boolValue] == YES){
        [typeQueryArray addObject:@"Office"];
    }
    if ([[self.spaceType objectAtIndex:3] boolValue] == YES){
        [typeQueryArray addObject:@"Quiet"];;
    }
    
   
    if([amenitiesQueryArray count] > 0)
        [query whereKey:@"amenities" containsAllObjectsInArray:amenitiesQueryArray];
    if(price > 0)
        [query whereKey:@"price" lessThanOrEqualTo: price];
    if([typeQueryArray count] > 0)
        [query whereKey:@"type" containsAllObjectsInArray:typeQueryArray];
    
    NSArray* AllListings = [query findObjects];
    listings = [Listing objectToListingsWith:AllListings];
    
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
        NSLog(@"View Controller Row: %lu", (long)indexPath.row);
    }
}
@end
