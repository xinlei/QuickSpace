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
#import "NewListing.h"
#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface ProfileViewController ()

-(void) refreshTableData;

@end

@implementation ProfileViewController{
    NSArray *userListings;
    NSArray *bookings;
}

@synthesize listingSegments;
@synthesize popup;
@synthesize logoutButton;


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
//    userListings = [[NSMutableArray alloc] init];

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
    [defaults removeObjectForKey:@"spaceTypes"];
    [PFObject unpinAllObjects];
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


    // Remove listing
    if (listingSegments.selectedSegmentIndex == 1){
        if (buttonIndex == actionSheet.destructiveButtonIndex) {
            NewListing *currListing = [userListings objectAtIndex:actionSheet.tag];
            [currListing deleteInBackground];
            [currListing unpinWithName:@"Listing"];
            [self refreshTableData];
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
        PFQuery *query = [NewListing query];
        PFObject *currListing = [query getObjectWithId:[booking.listing objectId]];
        
        if(currListing){
            [booking unpinInBackgroundWithName:@"Booking"];
            [booking saveInBackground];
            booking.listing.totalRating = booking.listing.totalRating + booking.rating;
            booking.listing.totalRaters = booking.listing.totalRaters + 1;
            booking.listing.ratingValue = ((float)booking.listing.totalRating / (float)booking.listing.totalRaters) + 0.5;
            [booking.listing save];
            [self refreshTableData];
            [self.listingTable reloadData];
        } else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Feature not available" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
            [alert show];
        }
    }
}

- (void) refreshTableData {
    [SVProgressHUD show];
    PFUser *currentUser = [PFUser currentUser];
    NSDate *now = [NSDate date];
    if (listingSegments.selectedSegmentIndex == 0){
        
        /*
        PFQuery *query = [Booking query];
        [query whereKey:@"rating" lessThanOrEqualTo:@0];
        [query whereKey:@"guest" equalTo:currentUser];
        bookings = [query findObjects];
        */
        
        PFQuery *notExpired = [Booking query];
        [notExpired whereKey:@"guest" equalTo:currentUser];
        [notExpired whereKey:@"endTime" greaterThan:now];
        
        PFQuery *noRatings = [Booking query];
        [noRatings whereKey:@"guest" equalTo:currentUser];
        [noRatings whereKey:@"rating" lessThanOrEqualTo:@0];
        
        PFQuery *query = [PFQuery orQueryWithSubqueries:@[noRatings,notExpired]];
        bookings = [query findObjects];
        
    } else {
        PFQuery *query = [NewListing query];
        [query whereKey:@"lister" equalTo:currentUser];
        //[query fromPinWithName:@"Listing"];
        userListings = [query findObjects];
    }
    [self.listingTable reloadData];
    [SVProgressHUD dismiss];
}

- (IBAction)listingSegmentValueChanged:(UISegmentedControl *)sender {
    [self refreshTableData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (listingSegments.selectedSegmentIndex == 0)
        return [bookings count];
    return [userListings count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"userListingCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    

    UILabel *timeRemaining = (UILabel *)[cell viewWithTag:2];
    UILabel *title = (UILabel *)[cell viewWithTag:1];

    
    if (listingSegments.selectedSegmentIndex == 0){
        Booking *thisBooking = [bookings objectAtIndex:indexPath.row];
        
        PFQuery *query = [NewListing query];
        PFObject *currListing = [query getObjectWithId:[thisBooking.listing objectId]];
        
        if(currListing)
            title.text = thisBooking.listing.title;
        else
            title.text = @"Listing Removed";
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
        NewListing *thisListing = [userListings objectAtIndex:indexPath.row];
        title.text = thisListing.title;
        timeRemaining.text = @"";
    }
    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    NSIndexPath *indexPath = [self.listingTable indexPathForSelectedRow];
    if([[segue identifier] isEqualToString:@"editSegue"]){
        editListingViewController *destViewController = segue.destinationViewController;
        destViewController.listing = [userListings objectAtIndex:indexPath.row];
    }
    else if ([[segue identifier] isEqualToString:@"bookingSegue"]){
        viewBookingsController *destViewController = segue.destinationViewController;
        destViewController.listing = [userListings objectAtIndex:indexPath.row];
    }
}

@end
