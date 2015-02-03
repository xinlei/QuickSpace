//
//  ListingDetailViewController.m
//  QuickSpace
//
//  Created by Gene Oetomo on 1/23/15.
//  Copyright (c) 2015 Jordan. All rights reserved.
//

#import "ListingDetailViewController.h"
#import <Parse/Parse.h>

@interface ListingDetailViewController ()

@end

@implementation ListingDetailViewController

@synthesize titleLabel;
@synthesize image;
@synthesize listing;
@synthesize type;
@synthesize location;
@synthesize bookButton;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    titleLabel.text = listing.title;
    image.image = [UIImage imageWithData: listing.imageData];
    type.text = listing.type;
    location.text = listing.location;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// Set guest_id, startTime, and endTime and save to server
- (IBAction)bookButton:(UIButton *)sender {
    PFQuery *query = [PFQuery queryWithClassName:@"ListingObject"];
    
    // Retrieve the object by id
    [query getObjectInBackgroundWithId:listing.object_id block:^(PFObject *listing, NSError *error) {
        PFUser *currentUser = [PFUser currentUser];
        
        // Update start and end time
        NSDate *startTime = [NSDate date];
        
        // Hard-coded 30 seconds. Need to be changed later once date picker is implmented
        NSDate *endTime = [startTime dateByAddingTimeInterval:180];
        
        listing[@"startTime"] = startTime;
        listing[@"endTime"] = endTime;
        listing[@"guest_id"] = currentUser.username;
        [listing saveInBackground];
    }];
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
