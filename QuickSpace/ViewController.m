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

NSArray *listings;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

    
    // Right now the queries are running on the main thread. Need to eventually change this.
    
    listings = [[NSArray alloc] init];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *amenities = [defaults objectForKey:@"additionalFilters"];
    NSNumber *price = [defaults objectForKey:@"maxPrice"];
    
    NSLog(@"Price: %@", price);
    
    PFQuery *fakeQuery = [PFQuery queryWithClassName:@"ListingObject"];
    [fakeQuery whereKeyExists:@"title"];
    
    NSArray *allObjects = [fakeQuery findObjects];
    
    NSMutableSet *myIntersect = [NSMutableSet setWithArray: [Listing objectToListingsWith:allObjects]];
    NSLog(@"Initial count: %lu", (unsigned long)myIntersect.count);
    
    
    bool wifi = [[amenities objectForKey:@"wifi"] boolValue];
    bool refrigerator = [[amenities objectForKey:@"refrigerator"] boolValue];
    bool study = [[amenities objectForKey:@"studyDesk"] boolValue];
    bool monitor = [[amenities objectForKey:@"monitor"] boolValue];
    bool services = [[amenities objectForKey:@"services"] boolValue];
    
    
    NSMutableArray *queryArray = [[NSMutableArray alloc] init];
    
    if(price){
        PFQuery *priceQuery = [PFQuery queryWithClassName:@"ListingObject"];
        [priceQuery whereKey:@"price" lessThanOrEqualTo: price];
        [myIntersect intersectSet:[NSSet setWithArray:[Listing objectToListingsWith:[priceQuery findObjects]]]];
        NSLog(@"Post Price count: %lu", (unsigned long)myIntersect.count);
    }
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
        
        [myIntersect intersectSet:[NSSet setWithArray:[Listing objectToListingsWith:[myquery findObjects]]]];
        NSLog(@"Post switch count: %lu", (unsigned long)myIntersect.count);

    }
    
    listings = [myIntersect allObjects];
    
    [defaults removeObjectForKey:@"additionalFilters"];
    [defaults removeObjectForKey:@"maxPrice"];


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
