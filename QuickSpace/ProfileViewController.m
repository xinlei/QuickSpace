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
#import <UIKit/UIKit.h>

@interface ProfileViewController ()

@end

@implementation ProfileViewController

@synthesize listingSegments;
@synthesize popup;
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // Show popup menu
    if (listingSegments.selectedSegmentIndex == 1){
        popup = [[UIActionSheet alloc]
                 initWithTitle:@"Listing Options"
                 delegate:self
                 cancelButtonTitle:@"Cancel"
                 destructiveButtonTitle:@"Remove Listing"
                 otherButtonTitles:nil];
        popup.actionSheetStyle = UIActionSheetStyleBlackOpaque;
        [popup showInView:self.view];
        popup.tag = indexPath.row;
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    // Remove listing
    if (buttonIndex == 0) {
        int row = actionSheet.tag;
        Listing *currListing = [listings objectAtIndex:row];
        PFQuery *query = [PFQuery queryWithClassName:@"Listing"];
            
        [query getObjectInBackgroundWithId:currListing.object_id block:^(PFObject *parseListing, NSError *error) {
            [parseListing deleteEventually];
        }];
        [self.listingTable reloadData];
    }
}

- (IBAction)listingSegmentValueChanged:(UISegmentedControl *)sender {
    PFUser *currentUser = [PFUser currentUser];
    if (listingSegments.selectedSegmentIndex == 0){
        
        NSDate *now = [NSDate date];
        
        // Get rentals booked by this user
        PFQuery *query = [PFQuery queryWithClassName:@"ListingObject"];
        [query whereKey:@"guest_id" equalTo:currentUser.username];
        [query whereKey:@"endTime" greaterThan:now];
        NSArray* AllListings = [query findObjects];
        listings = [Listing objectToListingsWith:AllListings];
        
    } else if (listingSegments.selectedSegmentIndex == 1){
        
        // Get listings posted by this user
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
    
    // Show the amount of time remaining on each booking
    if (listingSegments.selectedSegmentIndex == 0){
        NSString *timeDiff = [[NSString alloc] init];
        NSTimeInterval interval = [thisListing.endTime timeIntervalSinceNow];
        int minutes = interval/60;
        if (minutes == 1) {
            timeDiff = [NSString stringWithFormat:@"%d minute left", minutes];
        } else {
            timeDiff = [NSString stringWithFormat:@"%d minutes left", minutes];
        }
        UILabel *timeRemaining = (UILabel *)[cell viewWithTag:2];
        timeRemaining.text = timeDiff;

    } else {
        UILabel *timeRemaining = (UILabel *)[cell viewWithTag:2];
        timeRemaining.text = @"";
    }
    
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
