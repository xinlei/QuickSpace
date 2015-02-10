//
//  ListingDetailViewController.m
//  QuickSpace
//
//  Created by Gene Oetomo on 1/23/15.
//  Copyright (c) 2015 Jordan. All rights reserved.
//

#import "ListingDetailViewController.h"
#import "BookingConfirmationViewController.h"
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
@synthesize ratingLabel;
@synthesize amenitiesLabel;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    titleLabel.text = listing.title;
    image.image = [UIImage imageWithData: listing.imageData];
    type.text = listing.type;
    location.text = listing.location;
    
    PFQuery *query = [PFQuery queryWithClassName:@"ListingObject"];
    // Retrieve the object by id
    [query getObjectInBackgroundWithId:listing.object_id block:^(PFObject *parseListing, NSError *error) {
        int rating = [parseListing[@"ratingValue"] intValue];
        if (rating == 0) {
            ratingLabel.text = @"No Ratings Yet";
        } else {
            ratingLabel.text = [NSString stringWithFormat:@"Rating: %d/3", rating];
        }
        
        //updating the amenities in the listing view
        NSMutableString *amenitiesString = [[NSMutableString alloc] init];
        NSArray *amenities = parseListing[@"amenities"];
        for (NSString *amenity in amenities){
            [amenitiesString appendString:@"- "];
            [amenitiesString appendString:amenity];
            [amenitiesString appendString:@" "];
            
        }
        [amenitiesString appendString:@"-"];
        amenitiesLabel.text = amenitiesString;
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// Set guest_id, startTime, and endTime and save to server
- (IBAction)bookButton:(UIButton *)sender {
    PFObject *booking = [PFObject objectWithClassName:@"Booking"];
    PFQuery *query = [PFQuery queryWithClassName:@"ListingObject"];
    
    // Retrieve the object by id
    [query getObjectInBackgroundWithId:listing.object_id block:^(PFObject *parseListing, NSError *error) {
        PFUser *currentUser = [PFUser currentUser];
        
        // Update start and end time
        NSDate *startTime = [NSDate date];
        
        // Hard-coded 30 seconds. Need to be changed later once date picker is implmented
        NSDate *endTime = [startTime dateByAddingTimeInterval:180];
        
        booking[@"startTime"] = startTime;
        booking[@"endTime"] = endTime;
        booking[@"guest"] = currentUser;
        booking[@"owner"] = parseListing[@"lister"];
        booking[@"rating"] = @0;
        booking[@"listing"] = parseListing;
        [parseListing saveInBackground];
        [booking saveInBackground]; 
    }];
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"ShowBookingConfirmation"]){
        BookingConfirmationViewController *destViewController = segue.destinationViewController;
        destViewController.listing = listing;
    }
}


@end
