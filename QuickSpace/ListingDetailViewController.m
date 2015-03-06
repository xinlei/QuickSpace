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
#import "Booking.h"
#import "modalPictureViewController.h"

@interface ListingDetailViewController () {
    Booking *booking;
    NSMutableArray *images;
}

@end

@implementation ListingDetailViewController

@synthesize titleLabel;
@synthesize image;
@synthesize listing;
@synthesize typeLabel;
@synthesize locationLabel;
@synthesize location;
@synthesize amenities;
@synthesize bookButton;
@synthesize ratingLabel;
@synthesize amenitiesLabel;
@synthesize descriptionsLabel;
@synthesize booking;
@synthesize scrollView;
@synthesize descriptions;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    titleLabel.text = listing.title;
    image.image = [UIImage imageWithData: [listing.allImageData firstObject]];
    
    for (NSData *imageData in listing.allImageData) {
        [images addObject:[UIImage imageWithData:imageData]];
    }

    
    int rating = listing.rating;
    if (rating == 0) {
        ratingLabel.text = @"No Ratings Yet";
    } else {
        ratingLabel.text = [NSString stringWithFormat:@"Rating: %d/3", rating];
    }
    
    //set scrollView
    scrollView.frame = self.view.frame;
    scrollView.contentSize = CGSizeMake(self.view.frame.size.width, 1000);
    CGRect viewFrame = scrollView.frame;
    
    //set title
    CGRect frame = titleLabel.frame;
    frame.origin.x = viewFrame.size.width/2 - frame.size.width/2;
    frame.origin.y = image.frame.origin.y + image.frame.size.height + 10;
    titleLabel.frame = frame;
    
    //set type
    NSString *typeDesc = [Listing typesToString:listing.types];
    typeLabel.numberOfLines = 0;
    typeLabel.text = typeDesc;
    CGSize labelSize = [typeLabel.text sizeWithAttributes:@{NSFontAttributeName:typeLabel.font}];
    typeLabel.frame = CGRectMake(typeLabel.frame.origin.x, typeLabel.frame.origin.y, typeLabel.frame.size.width, labelSize.height);
    [ListingDetailViewController setItemLocation:typeLabel withPrev:titleLabel apartBy:5];
    
    //set rating
    ratingLabel.numberOfLines = 0;
    labelSize = [ratingLabel.text sizeWithAttributes:@{NSFontAttributeName:ratingLabel.font}];
    ratingLabel.frame = CGRectMake(ratingLabel.frame.origin.x, ratingLabel.frame.origin.y, ratingLabel.frame.size.width, labelSize.height);
    [ListingDetailViewController setItemLocation:ratingLabel withPrev:typeLabel apartBy:0];
    [ListingDetailViewController addSeparatorOnto:scrollView at:ratingLabel.frame.origin.y + ratingLabel.frame.size.height + 8];
    
    //set location
    locationLabel.text = listing.address;
    [ListingDetailViewController setItemLocation:location withPrev:ratingLabel apartBy:15];
    [ListingDetailViewController setItemLocation:locationLabel withPrev:ratingLabel apartBy:15];
//    [ListingDetailViewController addSeparatorOnto:scrollView at:locationLabel.frame.size.height + locationLabel.frame.origin.y];
    
    //set amenities
    amenitiesLabel.text = listing.amenities;
    amenitiesLabel.numberOfLines = 0;
    labelSize = [amenitiesLabel.text sizeWithAttributes:@{NSFontAttributeName:amenitiesLabel.font}];
    amenitiesLabel.frame = CGRectMake(amenitiesLabel.frame.origin.x, amenitiesLabel.frame.origin.y, amenitiesLabel.frame.size.width, labelSize.height);
    [ListingDetailViewController setItemLocation:amenities withPrev:location apartBy:5];
    [ListingDetailViewController setItemLocation:amenitiesLabel withPrev:location apartBy:5];
//    [ListingDetailViewController addSeparatorOnto:scrollView at:amenitiesLabel.frame.origin.y + amenitiesLabel.frame.size.height + 3];
    
    //set other descriptions
    //update the description
    NSString *descripString = listing.description;
    if (descripString.length == 0){
        descriptionsLabel.text = @"No Additional Description";
    } else {
        descriptionsLabel.text = descripString;
    }
    labelSize = [descriptionsLabel.text sizeWithAttributes:@{NSFontAttributeName:descriptionsLabel.font}];
    descriptionsLabel.frame = CGRectMake(descriptionsLabel.frame.origin.x, descriptionsLabel.frame.origin.y, descriptionsLabel.frame.size.width, labelSize.height);
    [ListingDetailViewController setItemLocation:descriptions withPrev:amenitiesLabel apartBy:5];
    [ListingDetailViewController setItemLocation:descriptionsLabel withPrev:descriptions apartBy:5];
    
    //if the page is longer than one page, move the book button down
    CGFloat endOfPage = descriptionsLabel.frame.origin.y + descriptionsLabel.frame.size.height + 10 + bookButton.frame.size.height;
    CGFloat bottomOfView = self.view.frame.size.height - self.navigationController.navigationBar.frame.size.height - self.tabBarController.tabBar.frame.size.height - [UIApplication sharedApplication].statusBarFrame.size.height;
    frame = bookButton.frame;
    if (endOfPage > bottomOfView){
        frame.origin.y = descriptionsLabel.frame.origin.y + descriptionsLabel.frame.size.height + 10;
        bookButton.frame = frame;
    } else {
        frame.origin.y = bottomOfView - bookButton.frame.size.height;
        bookButton.frame = frame;
    }
    
    //resize scrollview frame
    scrollView.contentSize = CGSizeMake(self.view.frame.size.width, bookButton.frame.size.height + bookButton.frame.origin.y);
}

+ (void) setItemLocation:(UIView *)item withPrev:(UILabel *)prev apartBy:(CGFloat)dist
{
    CGRect frame = item.frame;
    frame.origin.y = prev.frame.origin.y + prev.frame.size.height + dist;
    item.frame = frame;
}

+ (void) addSeparatorOnto:(UIView *)view at:(CGFloat)y
{
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(4, y, view.frame.size.width - 8, 1)];
    [line setBackgroundColor:[UIColor lightGrayColor]];
    [view addSubview:line];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// Set guest_id, startTime, and endTime and save to server
- (IBAction)bookButton:(UIButton *)sender {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    PFUser *currentUser = [PFUser currentUser];
    NSDate *startTime = [defaults objectForKey:@"startTime"];
    NSDate *endTime = [defaults objectForKey:@"endTime"];
    
    Booking *aBooking = [Booking object];
    aBooking.startTime = startTime;
    aBooking.endTime = endTime;
    aBooking.guest = currentUser;
    aBooking.owner = listing.owner;
    aBooking.rating = 0;
    //aBooking.listing = listing;
    [aBooking save];
}

-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [touches anyObject];
    if([touch view] == image){
        NSLog(@"I clicked the picture!");
        [self performSegueWithIdentifier:@"modalPics" sender:self];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"ShowBookingConfirmation"]){
        BookingConfirmationViewController *destViewController = segue.destinationViewController;
        destViewController.booking = booking;
    }
}


@end
