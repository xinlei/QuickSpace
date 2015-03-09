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
#import "AppDelegate.h"

@interface ProfileViewController ()

-(void) refreshTableData;

@end

@implementation ProfileViewController

@synthesize listingSegments;
@synthesize popup;
@synthesize logoutButton;
NSMutableArray *userListings;
//NSMutableArray *allTitles;

//NSArray *allListings;
//NSArray *allRentals;

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
    
    // Send back to the login page
    AppDelegate *appDelegateTemp = [[UIApplication sharedApplication]delegate];
    UIViewController* rootController = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"LoginViewController"];
    UINavigationController* navigation = [[UINavigationController alloc] initWithRootViewController:rootController];
    appDelegateTemp.window.rootViewController = navigation;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // Show popup menu for additional options
    if (listingSegments.selectedSegmentIndex == 1){
        popup = [[UIActionSheet alloc]
                 initWithTitle:@"Listing Options"
                 delegate:self
                 cancelButtonTitle:@"Cancel"
                 destructiveButtonTitle:@"Remove Listing"
                 otherButtonTitles:@"Edit Listing", @"View Current Bookings", nil];
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
    NewListing *currListing = [userListings objectAtIndex:actionSheet.tag];
    //NSString *currListing_id = [userListings objectAtIndex:actionSheet.tag];
    
    // Remove listing
    if (listingSegments.selectedSegmentIndex == 1){
        if (buttonIndex == actionSheet.destructiveButtonIndex) {
            [currListing delete];
            [self.listingTable reloadData];
        }
        // Edit Listing
        else if (buttonIndex == actionSheet.firstOtherButtonIndex){
            [self performSegueWithIdentifier:@"editSegue" sender:self];
        }
        //View Bookings
        else if (buttonIndex == actionSheet.firstOtherButtonIndex + 1){
            [self performSegueWithIdentifier:@"bookingSegue" sender:self];
        }
    }
    
    // Set listing rating
    if (listingSegments.selectedSegmentIndex == 0){
        Booking *booking = [bookings objectAtIndex:actionSheet.tag];
        switch (buttonIndex) {
            case 0:
                booking[@"rating"] = @3;
                break;
            case 1:
                booking[@"rating"] = @2;
                break;
            case 2:
                booking[@"rating"] = @1;
                break;
            default:
                booking[@"rating"] = @0;
        }
        [booking saveInBackground];
        currListing.totalRating = currListing.totalRating + booking.rating;
        currListing.totalRaters = currListing.totalRaters + 1;
        currListing.ratingValue = currListing.totalRating / currListing.totalRaters;
        [currListing save];
    }
}

- (void) refreshTableData {
    [SVProgressHUD show];
  //  dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        PFUser *currentUser = [PFUser currentUser];
        [userListings removeAllObjects];
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
            
            
            //NSMutableArray* allRentals = [[NSMutableArray alloc] init];
            //NSMutableArray* titles = [[NSMutableArray alloc] init];
            for (Booking *booking in bookings) {
                
                [userListings addObject:booking.listing];
                //if(object[@"listing_id"] != nil && object[@"listing_title"] != nil){
                //[allRentals addObject:object[@"listing_id"]];
                //[titles addObject:object[@"listing_title"]];
                //}
            }
            //userListings = allRentals;
            //allTitles = titles;
            //*/
        } else {
            PFQuery *notExpired = [PFQuery queryWithClassName:@"Booking"];
            [notExpired whereKey:@"owner" equalTo:currentUser];
            bookings = [notExpired findObjects];
            
            // Get listings posted by this user
            PFQuery *query = [PFQuery queryWithClassName:@"Listing"];
            [query whereKey:@"lister" equalTo:currentUser];
            
            userListings = [[NSMutableArray alloc] initWithArray:[query findObjects]];
            
            //NSMutableArray* allIDs = [[NSMutableArray alloc] init];
            //NSMutableArray* titles = [[NSMutableArray alloc] init];
            //for (PFObject *object in allListings) {
 
                //[allIDs addObject:object.objectId];
                //[titles addObject:object[@"title"]];
            //}
            //userListings = allIDs;
            //allTitles = titles;
        }
//        dispatch_async(dispatch_get_main_queue(), ^{
            [self.listingTable reloadData];
            [SVProgressHUD dismiss];
//        });
//    });
    
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
    //title.text = [allTitles objectAtIndex:indexPath.row];
    title.text = thisListing.title;
    
    if (listingSegments.selectedSegmentIndex == 0){
        Booking *thisBooking = [bookings objectAtIndex:indexPath.row];
        NSString *timeDiff = [[NSString alloc] init];
        NSTimeInterval interval = [thisBooking.endTime timeIntervalSinceNow];
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
        //PFQuery *query = [PFQuery queryWithClassName:@"Listing"];
        //PFObject *listingObj = [query getObjectWithId:[userListings objectAtIndex:indexPath.row]];
        //NSArray *stupid = [[NSArray alloc]initWithObjects:listingObj, nil];
        
        editListingViewController *destViewController = segue.destinationViewController;
        destViewController.listing = [userListings objectAtIndex:indexPath.row];
    }
    else if ([[segue identifier] isEqualToString:@"bookingSegue"]){
        //NSString *selectedListing = [userListings objectAtIndex:indexPath.row];
        viewBookingsController *destViewController = segue.destinationViewController;
        //destViewController.listing_id = selectedListing;
        //destViewController.listing_title = [allTitles objectAtIndex:indexPath.row];
        destViewController.listing = [userListings objectAtIndex:indexPath.row];
    }
}

@end
