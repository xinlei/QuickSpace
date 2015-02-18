//
//  ProfileViewController.m
//  QuickSpace
//
//  Created by Tony Wang on 1/31/15.
//  Copyright (c) 2015 Jordan. All rights reserved.
//

#import "ProfileViewController.h"
#import <Parse/Parse.h>
#import "SVProgressHUD.h"
#import "Listing.h"
#import <UIKit/UIKit.h>
#import "editListingViewController.h"

@interface ProfileViewController ()

-(void) refreshTableData;

@end

@implementation ProfileViewController

@synthesize listingSegments;
@synthesize popup;
@synthesize logoutButton;
NSMutableArray *userListings;
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
    [self refreshTableData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// Log out the current user
- (IBAction)logoutButtonTouched:(UIButton *)sender {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:@"object_id"];
    [defaults removeObjectForKey:@"newListingAmenities"];
    [defaults removeObjectForKey:@"newListingBasicInfo"];
    [defaults removeObjectForKey:@"newListingPrice"];
    [defaults removeObjectForKey:@"Latitude"];
    [defaults removeObjectForKey:@"Longitude"];
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
                 otherButtonTitles:@"Edit Listing", nil];
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
    Listing *currListing = [userListings objectAtIndex:actionSheet.tag];
    NSLog(@"Button Index: %ld", (long)buttonIndex);
    // Remove listing
    if (listingSegments.selectedSegmentIndex == 1){
        if (buttonIndex == actionSheet.destructiveButtonIndex) {
            PFQuery *query = [PFQuery queryWithClassName:@"Listing"];
            [query getObjectInBackgroundWithId:currListing.object_id block:^(PFObject *parseListing, NSError *error) {
                [parseListing delete];
            }];
            [self.listingTable reloadData];
        }
        // Edit Listing
        else if (buttonIndex == actionSheet.firstOtherButtonIndex){
            [self performSegueWithIdentifier:@"editSegue" sender:self];
        }
    }
    
    // Set listing rating
    if (listingSegments.selectedSegmentIndex == 0){
        PFObject *booking = [bookings objectAtIndex:actionSheet.tag];
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
        PFQuery *query = [PFQuery queryWithClassName:@"Listing"];
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
    [SVProgressHUD show];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        PFUser *currentUser = [PFUser currentUser];
        NSDate *now = [NSDate date];
        if (listingSegments.selectedSegmentIndex == 0){
            
            PFQuery *notExpired = [PFQuery queryWithClassName:@"Booking"];
            [notExpired whereKey:@"guest" equalTo:currentUser];
            [notExpired whereKey:@"endTime" greaterThan:now];
            
            PFQuery *noRatings = [PFQuery queryWithClassName:@"Booking"];
            [noRatings whereKey:@"guest" equalTo:currentUser];
            [noRatings whereKey:@"rating" lessThanOrEqualTo:@0];
            
            PFQuery *query = [PFQuery orQueryWithSubqueries:@[noRatings,notExpired]];
            bookings = [query findObjects];
            
            NSMutableArray* allRentals = [[NSMutableArray alloc] init];
            for (PFObject *object in bookings) {
                [allRentals addObject:object[@"listing"]];
            }
            userListings = [Listing objectToListingsWith:allRentals];
            
        } else {
            PFQuery *notExpired = [PFQuery queryWithClassName:@"Booking"];
            [notExpired whereKey:@"owner" equalTo:currentUser];
            bookings = [notExpired findObjects];
            
            // Get listings posted by this user
            PFQuery *query = [PFQuery queryWithClassName:@"Listing"];
            [query whereKey:@"lister" equalTo:currentUser.username];
            NSArray* AllListings = [query findObjects];
            userListings = [Listing objectToListingsWith:AllListings];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.listingTable reloadData];
            [SVProgressHUD dismiss];
        });
    });
    
}

- (IBAction)listingSegmentValueChanged:(UISegmentedControl *)sender {
    [self refreshTableData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [userListings count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"userListingCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    Listing *thisListing = [userListings objectAtIndex:indexPath.row];
    UILabel *timeRemaining = (UILabel *)[cell viewWithTag:2];
    UILabel *title = (UILabel *)[cell viewWithTag:1];
    title.text = thisListing.title;
    
    if (listingSegments.selectedSegmentIndex == 0){
        PFObject *thisBooking = [bookings objectAtIndex:indexPath.row];
        NSString *timeDiff = [[NSString alloc] init];
        NSTimeInterval interval = [thisBooking[@"endTime"] timeIntervalSinceNow];
        int minutes = interval/60;
        
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
        timeRemaining.text = @"";
    }
    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    NSIndexPath *indexPath = [self.listingTable indexPathForSelectedRow];
    if([[segue identifier] isEqualToString:@"editSegue"]){
        Listing *selectedListing = [userListings objectAtIndex:indexPath.row];
        editListingViewController *destViewController = segue.destinationViewController;
        destViewController.listing = selectedListing;
    }
}

@end
