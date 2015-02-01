//
//  ProfileViewController.m
//  QuickSpace
//
//  Created by Tony Wang on 1/31/15.
//  Copyright (c) 2015 Jordan. All rights reserved.
//

#import "ProfileViewController.h"
#import <Parse/Parse.h>
#import "Listing.h"

@interface ProfileViewController ()

@end

@implementation ProfileViewController

@synthesize listingSegments;

NSMutableArray *listings;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    PFUser *currentUser = [PFUser currentUser];
    PFQuery *query = [PFQuery queryWithClassName:@"Listing"];
    [query whereKey:@"lister" equalTo:currentUser.username];
    
    NSArray* AllListings = [query findObjects];
    
    listings = [Listing objectToListingsWith:AllListings];
    NSLog(@"Listing count%d", [listings count]);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)listingSegmentValueChanged:(UISegmentedControl *)sender {
    if (listingSegments.selectedSegmentIndex == 0){
        
        // Testing, need to be replaced by rentals
        [listings removeAllObjects];
    } else if (listingSegments.selectedSegmentIndex == 1){
        
        // Get listings posted by this user
        PFUser *currentUser = [PFUser currentUser];
        PFQuery *query = [PFQuery queryWithClassName:@"Listing"];
        [query whereKey:@"lister" equalTo:currentUser.username];
        
        NSArray* AllListings = [query findObjects];
        
        listings = [Listing objectToListingsWith:AllListings];
    } else {
        
        // Testing, need to be replaced by recently viewed searches
        [listings removeAllObjects];
    }
    [self.listingTable reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [listings count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"userListingCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    
    Listing *thisListing = [listings objectAtIndex:indexPath.row];
    
    UILabel *title = (UILabel *)[cell viewWithTag:1];
    title.text = thisListing.title;
    return cell;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
