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

@end

@implementation ViewController

NSMutableArray *listings;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

    
    // Right now the queries are running on the main thread. Need to eventually change this.
    
    listings = [[NSMutableArray alloc] init];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *amenities = [defaults objectForKey:@"additionalFilters"];
    
//    PFQuery *priceQuery = [PFQuery queryWithClassName:@"ListingObject"];
//    [priceQuery whereKey:@"price" lessThanOrEqualTo: [defaults objectForKey:@"maxPrice"]];
    
    PFQuery *fakeQuery = [PFQuery queryWithClassName:@"ListingObject"];
    [fakeQuery whereKey:@"title" notEqualTo:@"blah"];
    
    NSArray *fakeObjects = [fakeQuery findObjects];
//    NSMutableArray *fakeLists = [[NSMutableArray alloc] init];
    listings = [Listing objectToListingsWith:fakeObjects];
    
    
    NSMutableSet *myIntersect = [NSMutableSet setWithArray: listings];
    NSLog(@"Initial count: %lu", (unsigned long)myIntersect.count);
    
    
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
    

    
    if([queryArray count] != 0){
        PFQuery *myquery = [PFQuery queryWithClassName:@"ListingObject"];
        [myquery whereKey:@"amenities" containsAllObjectsInArray:queryArray];
        
        NSArray *queryResults = [myquery findObjects];
        listings = [Listing objectToListingsWith:queryResults];

    }
    
    [defaults removeObjectForKey:@"additionalFilters"];
    [defaults removeObjectForKey:@"maxPrice"];
    
    // Convert into listing objects using class method
//    listings = [Listing objectToListingsWith:AllListings];


}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryCheckmark;
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
