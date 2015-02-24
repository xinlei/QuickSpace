//
// ConfirmationViewController.m
// QuickSpace
//
// Created by Tony Wang on 1/31/15.
// Copyright (c) 2015 Jordan. All rights reserved.
//
#import "ConfirmationViewController.h"
#import <Parse/Parse.h>
#import "Listing.h"
@interface ConfirmationViewController ()
@property NSArray *amenities;
@end
@implementation ConfirmationViewController

@synthesize theImage;
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
    listingImg.image = theImage;
    
    // Get values from UserDefaults
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *newListingBasicInfo = [defaults objectForKey:@"newListingBasicInfo"];
    NSDictionary *listingAmenities = [defaults objectForKey:@"newListingAmenities"];
    NSInteger price = [defaults integerForKey:@"newListingPrice"];
    
    NSSet *keys = [listingAmenities keysOfEntriesPassingTest:^(id key, id obj, BOOL *stop){
        return [obj boolValue];
    }];
    self.amenities = [keys allObjects];
    
    // Display values to view
    titleLabel.text = newListingBasicInfo[@"title"];
    priceLabel.text = [NSString stringWithFormat:@"$%ld/hour", (long)price];
    locationLabel.text = newListingBasicInfo[@"location"];
    amenitiesLabel.text = [Listing amenitiesToString:self.amenities];
    descriptionLabel.text = newListingBasicInfo[@"description"];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSArray *spaceType = [defaults objectForKey:@"newListingSpaceType"];
    NSDictionary *newListingBasicInfo = [defaults objectForKey:@"newListingBasicInfo"];
    NSString *address = [newListingBasicInfo objectForKey:@"location"];
    NSMutableArray *listingTypes = [[NSMutableArray alloc]init];
    if ([[spaceType objectAtIndex:0] boolValue] == YES){
        [listingTypes addObject:@"Rest"];
    }
    if ([[spaceType objectAtIndex:1] boolValue] == YES){
        [listingTypes addObject:@"Closet"];
    }
    if ([[spaceType objectAtIndex:2] boolValue] == YES){
        [listingTypes addObject:@"Office"];
    }
    if ([[spaceType objectAtIndex:3] boolValue] == YES){
        [listingTypes addObject:@"Quiet"];;
    }
    
    
    NSNumber *num = [NSNumber numberWithInteger:[defaults integerForKey:@"newListingPrice"]];
    UIImage *myImage = listingImg.image;
    NSData *image = UIImagePNGRepresentation(myImage);
    PFFile *imageFile = [PFFile fileWithName:@"listingImage.png" data:image];
    
    NSArray *allImages = [[NSArray alloc] initWithObjects:imageFile, nil];
    PFUser *currentUser = [PFUser currentUser];
    
    NSNumber *latitude = [defaults objectForKey:@"Latitude"];
    NSNumber *longitude = [defaults objectForKey:@"Longitude"];
    
    PFGeoPoint *currentPoint =
    [PFGeoPoint geoPointWithLatitude:[latitude doubleValue]
                           longitude:[longitude doubleValue]];
    
    PFObject *listingObject = [PFObject objectWithClassName:@"Listing"];
    listingObject[@"title"] = titleLabel.text;
    listingObject[@"price"] = num;
    listingObject[@"location"] = currentPoint;
    listingObject[@"amenities"] = self.amenities;
    listingObject[@"description"] = descriptionLabel.text;
    listingObject[@"lister"] = currentUser.username;
    listingObject[@"images"] = allImages;
    listingObject[@"type"] = listingTypes;
    listingObject[@"totalRating"] = @0;
    listingObject[@"totalRaters"] = @0;
    listingObject[@"ratingValue"] = @0;
    listingObject[@"address"] = address;
    
    [listingObject save];
    NSString *object_id = listingObject.objectId;
    [defaults setObject:object_id forKey:@"object_id"];
}

@end