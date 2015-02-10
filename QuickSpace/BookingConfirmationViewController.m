//
//  BookingConfirmationViewController.m
//  QuickSpace
//
//  Created by Tony Wang on 2/3/15.
//  Copyright (c) 2015 Jordan. All rights reserved.
//

#import "BookingConfirmationViewController.h"
#import <Parse/Parse.h>

@interface BookingConfirmationViewController ()

@end

@implementation BookingConfirmationViewController

@synthesize cancelButton;
@synthesize listing;

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
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)cancelBooking:(UIButton *)sender {
    PFQuery *query = [PFQuery queryWithClassName:@"Listing"];
    
    // TODO: NEED TO UPDATE TO REMOVE BOOKINGS !! DOESN'T WORK
    [query getObjectInBackgroundWithId:listing.object_id block:^(PFObject *parseListing, NSError *error) {
        parseListing[@"guest_id"] = @"";
        [parseListing saveInBackground];
    }];

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
