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
@synthesize titleText;
@synthesize priceLabel;
@synthesize priceText;
@synthesize locationLabel;
@synthesize locationText;
@synthesize amenitiesLabel;
@synthesize amenitiesText;
@synthesize descriptionsLabel;
@synthesize descriptionsText;
@synthesize confirmButton;
@synthesize scrollView;
@synthesize allPhotos;

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
    
    
    //set scrollView
    scrollView.frame = self.view.frame;
    scrollView.contentSize = CGSizeMake(self.view.frame.size.width, 1000);
    CGRect viewFrame = scrollView.frame;

    //set title
    titleText.text = newListingBasicInfo[@"title"];
    CGRect frame = titleText.frame;
    frame.origin.x = viewFrame.size.width/2;
    frame.origin.y = listingImg.frame.origin.y + listingImg.frame.size.height + 10;
    titleText.frame = frame;
    frame = titleLabel.frame;
    frame.origin.y = listingImg.frame.origin.y + listingImg.frame.size.height + 10;
    titleLabel.frame = frame;
    
    //set price
    priceText.text = [NSString stringWithFormat:@"$%ld/hour", (long)price];
    [ListingDetailViewController setItemLocation:priceLabel withPrev:titleText apartBy:10];
    [ListingDetailViewController setItemLocation:priceText withPrev:titleText apartBy:10];
    
    //set location
    locationText.text = newListingBasicInfo[@"location"];
    locationText.selectable = NO;
    locationText.editable = NO;
    locationText.scrollEnabled = NO;
    locationText.textContainer.lineFragmentPadding = 0;
    locationText.textContainerInset = UIEdgeInsetsZero;
    CGFloat fixedWidth = locationText.frame.size.width;
    CGSize newSize = [locationText sizeThatFits:CGSizeMake(fixedWidth, MAXFLOAT)];
    frame = locationText.frame;
    frame.size = CGSizeMake(fmaxf(newSize.width, fixedWidth), newSize.height);
    locationText.frame = frame;
    locationText.backgroundColor = [UIColor clearColor];
    [ListingDetailViewController setItemLocation:locationLabel withPrev:priceText apartBy:10];
    [ListingDetailViewController setItemLocation:locationText withPrev:priceText apartBy:10];
    
    //set amenities
    amenitiesText.text = [Listing amenitiesToString:self.amenities];
    amenitiesLabel.numberOfLines = 0;
    CGSize labelSize = [amenitiesLabel.text sizeWithAttributes:@{NSFontAttributeName:amenitiesLabel.font}];
    amenitiesLabel.frame = CGRectMake(amenitiesLabel.frame.origin.x, amenitiesLabel.frame.origin.y, amenitiesLabel.frame.size.width, labelSize.height);
    [ListingDetailViewController setItemLocation:amenitiesText withPrev:locationText apartBy:10];
    [ListingDetailViewController setItemLocation:amenitiesLabel withPrev:locationText apartBy:10];
    
    //set other descriptions
    //update the description
    NSString *descripString = newListingBasicInfo[@"description"];
    if (descripString.length == 0){
        descriptionsText.text = @"No Additional Description";
    } else {
        descriptionsText.text = descripString;
    }
    descriptionsText.textContainer.lineFragmentPadding = 0;
    descriptionsText.textContainerInset = UIEdgeInsetsZero;
    descriptionsText.selectable = NO;
    descriptionsText.editable = NO;
    descriptionsText.scrollEnabled = NO;
    fixedWidth = descriptionsText.frame.size.width;
    newSize = [descriptionsText sizeThatFits:CGSizeMake(fixedWidth, MAXFLOAT)];
    frame = descriptionsText.frame;
    frame.size = CGSizeMake(fmaxf(newSize.width, fixedWidth), newSize.height);
    descriptionsText.frame = frame;
    descriptionsText.backgroundColor = [UIColor clearColor];
    [ListingDetailViewController setItemLocation:descriptionsLabel withPrev:amenitiesLabel apartBy:10];
    [ListingDetailViewController setItemLocation:descriptionsText withPrev:descriptionsLabel apartBy:5];
    
    //if the page is longer than one page, move the confirm button down
    CGFloat endOfPage = descriptionsText.frame.origin.y + descriptionsText.frame.size.height + 10 + confirmButton.frame.size.height;
    CGFloat bottomOfView = self.view.frame.size.height - self.navigationController.navigationBar.frame.size.height - self.tabBarController.tabBar.frame.size.height - [UIApplication sharedApplication].statusBarFrame.size.height;
    frame = confirmButton.frame;
    if (endOfPage > bottomOfView){
        frame.origin.y = descriptionsText.frame.origin.y + descriptionsText.frame.size.height + 10;
        confirmButton.frame = frame;
    } else {
        frame.origin.y = bottomOfView - confirmButton.frame.size.height;
        confirmButton.frame = frame;
    }
    
    //resize scrollview frame
    scrollView.contentSize = CGSizeMake(self.view.frame.size.width, confirmButton.frame.size.height + confirmButton.frame.origin.y);

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
//    UIImage *myImage = listingImg.image;
    
    NSMutableArray *allImages = [[NSMutableArray alloc] init];
    for(UIImage *image in allPhotos){
        NSData *currImage = UIImagePNGRepresentation(image);
        PFFile *imageFile = [PFFile fileWithName:@"listingImage.png" data:currImage];
        [allImages addObject:imageFile];
    }
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
    listingObject[@"description"] = descriptionsLabel.text;
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