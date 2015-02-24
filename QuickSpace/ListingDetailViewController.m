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

@interface ListingDetailViewController () {
    NSString *booking_id;
}

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
@synthesize descriptionsLabel;
@synthesize booking_id;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    titleLabel.text = listing.title;
    image.image = [UIImage imageWithData: listing.imageData];
//    type.text = listing.type;
//    location.text = listing.location;
    
    PFQuery *query = [PFQuery queryWithClassName:@"Listing"];
    [query getObjectInBackgroundWithId:listing.object_id block:^(PFObject *parseListing, NSError *error) {
        int rating = [parseListing[@"ratingValue"] intValue];
        if (rating == 0) {
            ratingLabel.text = @"No Ratings Yet";
        } else {
            ratingLabel.text = [NSString stringWithFormat:@"Rating: %d/3", rating];
        }
        
        //update the amenities in the listing view
        amenitiesLabel.text = [Listing amenitiesToString:parseListing[@"amenities"]];
        
        //update the description
        NSString *descripString = parseListing[@"description"];
        descriptionsLabel.text = descripString;
        
        //update the space type
        NSMutableString *typeDesc = [[NSMutableString alloc] init];
        NSArray *spaceType = parseListing[@"type"];
        for (NSString *listingType in spaceType){
            [typeDesc appendString:@"- "];
            [typeDesc appendString:listingType];
            [typeDesc appendString:@" "];
        }

        [typeDesc appendString:@"-"];
        type.text = typeDesc;
        
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// Set guest_id, startTime, and endTime and save to server
- (IBAction)bookButton:(UIButton *)sender {
    PFObject *booking = [PFObject objectWithClassName:@"Booking"];
    PFQuery *query = [PFQuery queryWithClassName:@"Listing"];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    // Retrieve the object by id
    [query getObjectInBackgroundWithId:listing.object_id block:^(PFObject *parseListing, NSError *error) {
        PFUser *currentUser = [PFUser currentUser];
        
        // Update start and end time
        NSDate *startTime = [defaults objectForKey:@"startDate"];
        NSDate *endTime = [defaults objectForKey:@"endDate"];
        
        booking[@"startTime"] = startTime;
        booking[@"endTime"] = endTime;
        booking[@"guest"] = currentUser;
        booking[@"owner"] = parseListing[@"lister"];
        booking[@"rating"] = @0;
        booking[@"listing"] = parseListing;
        [parseListing save];
        [booking saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (succeeded) booking_id = [booking objectId];
        }];
    }];
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"ShowBookingConfirmation"]){
        BookingConfirmationViewController *destViewController = segue.destinationViewController;
        destViewController.listing = listing;
        destViewController.booking_id = booking_id;
    }
}


@end
