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

-(void) refreshTableData;

@end

@implementation ProfileViewController

@synthesize listingSegments;
@synthesize popup;
@synthesize logoutButton;
NSMutableArray *listings;
NSArray *bookings;

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
    
    [self refreshTableData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// Log out the current user
- (IBAction)logoutButtonTouched:(UIButton *)sender {
    [PFUser logOut];
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
    
    if (listingSegments.selectedSegmentIndex == 0){
        popup = [[UIActionSheet alloc]
                 initWithTitle:@"Rate Your Experience"
                 delegate:self
                 cancelButtonTitle:@"Cancel"
                 destructiveButtonTitle:nil
                 otherButtonTitles:@"❤️❤️❤️", @"❤️❤️", @"❤️", nil];
        popup.actionSheetStyle = UIActionSheetStyleBlackOpaque;
        [popup showInView:self.view];
        popup.tag = indexPath.row;
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    Listing *currListing = [listings objectAtIndex:actionSheet.tag];
    PFObject *booking = [bookings objectAtIndex:actionSheet.tag];
    // Remove listing
    if (listingSegments.selectedSegmentIndex == 1){
        if (buttonIndex == 0) {
            PFQuery *query = [PFQuery queryWithClassName:@"ListingObject"];
            [query getObjectInBackgroundWithId:currListing.object_id block:^(PFObject *parseListing, NSError *error) {
                [parseListing delete];
            }];
            [self.listingTable reloadData];
        }
    }
    
    // Set listing rating
    if (listingSegments.selectedSegmentIndex == 0){
        switch (buttonIndex) {
            case 0:
                booking[@"rating"] = @3;
                break;
            case 1:
                booking[@"rating"] = @2;
                break;
            case 2:
                booking[@"rating"] = @1;
            default:
                booking[@"rating"] = @0;
        }
        [booking saveInBackground];
        PFQuery *query = [PFQuery queryWithClassName:@"ListingObject"];
        [query getObjectInBackgroundWithId:currListing.object_id block:^(PFObject *parseListing, NSError *error) {
            
            int currTotalRating = [parseListing[@"totalRating"] intValue];
            int currTotalRaters = [parseListing[@"totalRaters"] intValue];
            int currRating = [booking[@"rating"] intValue];
            
            int newTotalRating = currTotalRating + currRating;
            int newTotalRaters = currTotalRaters + 1;
            int newRating = newTotalRating / newTotalRaters;
            
            parseListing[@"totalRating"] = [NSNumber numberWithInt:(newTotalRating)];
            parseListing[@"totalRaters"] = [NSNumber numberWithInt:(newTotalRaters)];
            parseListing[@"ratingValue"] = [NSNumber numberWithInt:(newRating)];
            
            [parseListing saveInBackground];
        }];
    }
    
}

- (void) refreshTableData {
    PFUser *currentUser = [PFUser currentUser];
    if (listingSegments.selectedSegmentIndex == 0){
        
        NSDate *now = [NSDate date];
        
        PFQuery *notExpired = [PFQuery queryWithClassName:@"Booking"];
        [notExpired whereKey:@"guest" equalTo:currentUser];
        [notExpired whereKey:@"endTime" greaterThan:now];
        
        PFQuery *noRatings = [PFQuery queryWithClassName:@"Booking"];
        [noRatings whereKey:@"rating" lessThanOrEqualTo:@0];
        
        PFQuery *query = [PFQuery orQueryWithSubqueries:@[noRatings,notExpired]];
        bookings = [query findObjects];
        
        NSMutableArray* allRentals = [[NSMutableArray alloc] init];
        for (PFObject *object in bookings) {
            [allRentals addObject:object[@"listing"]];
        }
        listings = [Listing objectToListingsWith:allRentals];
        
    } else {
        // Get listings posted by this user
        PFQuery *query = [PFQuery queryWithClassName:@"ListingObject"];
        [query whereKey:@"lister" equalTo:currentUser.username];
        NSArray* AllListings = [query findObjects];
        listings = [Listing objectToListingsWith:AllListings];
    }
    [self.listingTable reloadData];
}

- (IBAction)listingSegmentValueChanged:(UISegmentedControl *)sender {
    [self refreshTableData];
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
    PFObject *thisBooking = [bookings objectAtIndex:indexPath.row];
    
    UILabel *title = (UILabel *)[cell viewWithTag:1];
    title.text = thisListing.title;
    NSString *timeDiff = [[NSString alloc] init];
    NSTimeInterval interval = [thisBooking[@"endTime"] timeIntervalSinceNow];
    UILabel *timeRemaining = (UILabel *)[cell viewWithTag:2];
    int minutes = interval/60;
    
    // Show the amount of time remaining on each booking
    if (listingSegments.selectedSegmentIndex == 0){
        if (minutes < 0){
            timeRemaining.text = @"";
        } else {
            if (minutes == 1) {
                timeDiff = [NSString stringWithFormat:@"%d minute left", minutes];
            } else {
                timeDiff = [NSString stringWithFormat:@"%d minutes left", minutes];
            }
            timeRemaining.text = timeDiff;
        }

    } else {
        if (minutes > 0){
            if (minutes == 1) {
                timeDiff = [NSString stringWithFormat:@"%d minute left", minutes];
            } else {
                timeDiff = [NSString stringWithFormat:@"%d minutes left", minutes];
            }
            timeRemaining.text = timeDiff;
        } else {
            timeRemaining.text = @"";
        }
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
