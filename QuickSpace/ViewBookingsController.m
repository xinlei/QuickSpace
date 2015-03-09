//
//  viewBookingsController.m
//  QuickSpace
//
//  Created by Gene Oetomo on 2/27/15.
//  Copyright (c) 2015 Jordan. All rights reserved.
//

#import "viewBookingsController.h"
#import <Parse/Parse.h>

@interface viewBookingsController ()

@end

@implementation viewBookingsController
{
    NSArray *bookings;
}

@synthesize listing;
@synthesize listingTitle;
@synthesize bookingsTable;
@synthesize listing_id;
@synthesize listing_title;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"Current Bookings";
    listingTitle.text = listing_title;
    
    [self populateBookings];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) populateBookings
{
    bookings = [[NSArray alloc] init];
    [SVProgressHUD show];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    
    
        PFQuery *listingBookings = [PFQuery queryWithClassName:@"Booking"];
        [listingBookings whereKey:@"listing_id" equalTo:listing_id];
    bookings = [listingBookings findObjects];
    
    
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.bookingsTable reloadData];
            [SVProgressHUD dismiss];
        });
    });
    NSLog(@"boobs");
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [bookings count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"bookingCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    Booking *thisBooking = [bookings objectAtIndex:indexPath.row];
    //set start date
    UILabel *startDate = (UILabel *)[cell viewWithTag:5];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    startDate.text = [formatter stringFromDate:thisBooking.startTime];
    //set start time
    UILabel *startTime = (UILabel *)[cell viewWithTag:1];
    [formatter setDateFormat:@"HH:mm"];
    startTime.text = [formatter stringFromDate:thisBooking.startTime];
    //set end date
    UILabel *endDate = (UILabel *)[cell viewWithTag:2];
    formatter = [[NSDateFormatter alloc]init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    endDate.text = [formatter stringFromDate:thisBooking.endTime];
    //set start time
    UILabel *endTime = (UILabel *)[cell viewWithTag:3];
    [formatter setDateFormat:@"HH:mm"];
    endTime.text = [formatter stringFromDate:thisBooking.endTime];
    UILabel *guest = (UILabel *)[cell viewWithTag:4];
    PFUser *theGuest = (PFUser *)thisBooking.guest;
    guest.text = theGuest.username;
    
    return cell;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
