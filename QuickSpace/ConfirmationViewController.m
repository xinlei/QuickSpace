//
// ConfirmationViewController.m
// QuickSpace
//
// Created by Tony Wang on 1/31/15.
// Copyright (c) 2015 Jordan. All rights reserved.
//
#import "ConfirmationViewController.h"
#import <Parse/Parse.h>
@interface ConfirmationViewController ()
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
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *newListingBasicInfo = [defaults objectForKey:@"newListingBasicInfo"];
    NSDictionary *amenities = [defaults objectForKey:@"newListingAmenities"];
    NSInteger price = [defaults integerForKey:@"newListingPrice"];
    titleLabel.text = newListingBasicInfo[@"title"];
    priceLabel.text = [NSString stringWithFormat:@"$%d/hour", price];
    locationLabel.text = newListingBasicInfo[@"location"];
    NSMutableString *amenitiesString = [[NSMutableString alloc] init];
    for (id key in amenities) {
        if([[amenities objectForKey:key] boolValue]){
            [amenitiesString appendString: @"- "];
            NSLog(@"true");
            [amenitiesString appendString:key];
            [amenitiesString appendString:@" "];
        }
    }
    [amenitiesString appendString:@"-"];
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
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *listingAmenities = [defaults objectForKey:@"newListingAmenities"];
    NSArray *listingTypes = [defaults objectForKey:@"newListingSpaceType"];
    
    NSSet *keys = [listingAmenities keysOfEntriesPassingTest:^(id key, id obj, BOOL *stop){
        if([obj boolValue] == YES)
            NSLog(@"Key: %@", key);
        return [obj boolValue];
    }];
    NSArray *amenities = [keys allObjects];
    NSNumber *num = [NSNumber numberWithInteger:[defaults integerForKey:@"newListingPrice"]];
    UIImage *myImage = listingImg.image;
    NSData *image = UIImagePNGRepresentation(myImage);
    PFFile *imageFile = [PFFile fileWithName:@"listingImage.png" data:image];
    PFUser *currentUser = [PFUser currentUser];
    
    NSNumber *latitude = [defaults objectForKey:@"Latitude"];
    NSNumber *longitude = [defaults objectForKey:@"Longitude"];
    
    NSLog(@"New Latitude: %f, New Longitude: %f", [latitude doubleValue], [longitude doubleValue]);
    PFGeoPoint *currentPoint =
    [PFGeoPoint geoPointWithLatitude:[latitude doubleValue]
                           longitude:[longitude doubleValue]];
    
    PFObject *listingObject = [PFObject objectWithClassName:@"Listing"];
    listingObject[@"title"] = titleLabel.text;
    listingObject[@"price"] = num;
    listingObject[@"amenities"] = amenities;
    listingObject[@"description"] = descriptionLabel.text;
    listingObject[@"lister"] = currentUser.username;
    listingObject[@"image"] = imageFile;
    listingObject[@"type"] = listingTypes;
    listingObject[@"location"] = currentPoint;
    listingObject[@"totalRating"] = @0;
    listingObject[@"totalRaters"] = @0;
    listingObject[@"ratingValue"] = @0;
    
    [listingObject save];
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