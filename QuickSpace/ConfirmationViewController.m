//
//  ConfirmationViewController.m
//  QuickSpace
//
//  Created by Tony Wang on 1/31/15.
//  Copyright (c) 2015 Jordan. All rights reserved.
//

#import "ConfirmationViewController.h"
#import <Parse/Parse.h>

@interface ConfirmationViewController ()

@end

@implementation ConfirmationViewController

@synthesize listingImg;
@synthesize titleLabel;
@synthesize priceLabel;
@synthesize locationLabel;
@synthesize amenitiesLabel;
@synthesize descriptionLabel;

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
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *newListingBasicInfo = [defaults objectForKey:@"newListingBasicInfo"];
    NSDictionary *amenities = [defaults objectForKey:@"newListingAmenities"];
    NSInteger price = [defaults integerForKey:@"newListingPrice"];
    
    titleLabel.text = newListingBasicInfo[@"title"];
    priceLabel.text = [NSString stringWithFormat:@"$%d/hour", price];
    locationLabel.text = newListingBasicInfo[@"location"];
    
    NSMutableString *amenitiesString = [[NSMutableString alloc] initWithString:@"Amenities: "];
    
    for (id key in amenities) {
        if([[amenities objectForKey:key] boolValue]){
            NSLog(@"true");
            [amenitiesString appendString:key];
            [amenitiesString appendString:@" "];
        }
    }
    amenitiesLabel.text = amenitiesString;
    descriptionLabel.text = newListingBasicInfo[@"description"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    PFUser *currentUser = [PFUser currentUser];
    PFObject *listingObject = [PFObject objectWithClassName:@"Listing"];
    listingObject[@"title"] = titleLabel.text;
    listingObject[@"price"] = priceLabel.text;
    listingObject[@"location"] = locationLabel.text;
    
    // Need to change into an array of amenities later
    listingObject[@"amenities"] = amenitiesLabel.text;
    listingObject[@"description"] = descriptionLabel.text;
    listingObject[@"lister"] = currentUser.username;
    [listingObject save];
 
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *object_id = listingObject.objectId;
    [defaults setObject:object_id forKey:@"object_id"];
    
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
