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
@synthesize locationText;
@synthesize location;
@synthesize amenities;
@synthesize bookButton;
@synthesize ratingLabel;
@synthesize amenitiesLabel;
@synthesize descriptionsText;
@synthesize booking;
@synthesize scrollView;
@synthesize descriptions;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    titleLabel.text = listing.title;

    image.image = [UIImage imageWithData: [[listing.images firstObject] getData]];

    int rating = listing.ratingValue;
    if (rating == 0) {
        ratingLabel.text = @"No Ratings Yet";
    } else {
        ratingLabel.text = [NSString stringWithFormat:@"Rating: %d/3", rating];
    }
    
    UITapGestureRecognizer *picClick = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(expandPics:)];
    [picClick setDelegate:self];
    [image addGestureRecognizer:picClick];
    
    //set scrollView
//    CGRect screenRect = [[UIScreen mainScreen] bounds];
//    scrollView.frame = screenRect;
//    scrollView.contentSize = CGSizeMake(screenRect.size.width, 1000);
    scrollView.frame = self.view.frame;
    scrollView.contentSize = CGSizeMake(self.view.frame.size.width, 1000);
    CGRect viewFrame = scrollView.frame;
    CGFloat mid = viewFrame.size.width/2;
    
    //set image location
    CGRect frame = image.frame;
//    frame.origin.x = mid - frame.size.width/2;
    frame.origin.y = 0;
    image.frame = frame;
    
    //set title
    frame = titleLabel.frame;
    frame.origin.x = mid - frame.size.width/2;
    frame.origin.y = image.frame.origin.y + image.frame.size.height + 10;
    titleLabel.frame = frame;
    
    //set type
    typeLabel.numberOfLines = 0;
    typeLabel.text = [listing typesToString];
    CGSize labelSize = [typeLabel.text sizeWithAttributes:@{NSFontAttributeName:typeLabel.font}];
    typeLabel.frame = CGRectMake(mid - typeLabel.frame.size.width/2, typeLabel.frame.origin.y, typeLabel.frame.size.width, labelSize.height);
    [ListingDetailViewController setItemLocation:typeLabel withPrev:titleLabel apartBy:5 atX:typeLabel.frame.origin.x];
    
    //set rating
    ratingLabel.numberOfLines = 0;
    labelSize = [ratingLabel.text sizeWithAttributes:@{NSFontAttributeName:ratingLabel.font}];
    ratingLabel.frame = CGRectMake(mid - ratingLabel.frame.size.width/2, ratingLabel.frame.origin.y, ratingLabel.frame.size.width, labelSize.height);
    [ListingDetailViewController setItemLocation:ratingLabel withPrev:typeLabel apartBy:5 atX:ratingLabel.frame.origin.x];
    [ListingDetailViewController addSeparatorOnto:scrollView at:ratingLabel.frame.origin.y + ratingLabel.frame.size.height + 10];
    
    //set location
    locationText.text = listing.address;
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
    [ListingDetailViewController setItemLocation:location withPrev:ratingLabel apartBy:15 atX:location.frame.origin.x];
    [ListingDetailViewController setItemLocation:locationText withPrev:ratingLabel apartBy:15 atX:mid];
//    [ListingDetailViewController addSeparatorOnto:scrollView at:locationLabel.frame.size.height + locationLabel.frame.origin.y];
    
    //set amenities
    amenitiesLabel.text = [listing amenitiesToString];
    amenitiesLabel.numberOfLines = 0;
    labelSize = [amenitiesLabel.text sizeWithAttributes:@{NSFontAttributeName:amenitiesLabel.font}];
    amenitiesLabel.frame = CGRectMake(mid, amenitiesLabel.frame.origin.y, amenitiesLabel.frame.size.width, labelSize.height);
    [ListingDetailViewController setItemLocation:amenities withPrev:locationText apartBy:10 atX:amenities.frame.origin.x];
    [ListingDetailViewController setItemLocation:amenitiesLabel withPrev:locationText apartBy:10 atX:mid];
//    [ListingDetailViewController addSeparatorOnto:scrollView at:amenitiesLabel.frame.origin.y + amenitiesLabel.frame.size.height + 3];
    
    //set other descriptions
    //update the description
    NSString *descripString = listing.information;
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
    [ListingDetailViewController setItemLocation:descriptions withPrev:amenitiesLabel apartBy:10 atX:descriptions.frame.origin.x];
    [ListingDetailViewController setItemLocation:descriptionsText withPrev:descriptions apartBy:5 atX:mid - frame.size.width/2];
    
    //resize button
    frame = bookButton.frame;
    frame.origin.x = 0;
    frame.size.width = viewFrame.size.width;
    bookButton.frame = frame;
    
    //if the page is longer than one page, move the book button down
    CGFloat endOfPage = descriptionsText.frame.origin.y + descriptionsText.frame.size.height + 10 + bookButton.frame.size.height;
    CGFloat bottomOfView = self.view.frame.size.height - self.navigationController.navigationBar.frame.size.height - self.tabBarController.tabBar.frame.size.height - [UIApplication sharedApplication].statusBarFrame.size.height;
    frame = bookButton.frame;
    frame.origin.x = mid - frame.size.width/2;
    if (endOfPage > bottomOfView){
        frame.origin.y = descriptionsText.frame.origin.y + descriptionsText.frame.size.height + 10;
        bookButton.frame = frame;
    } else {
        frame.origin.y = bottomOfView - bookButton.frame.size.height;
        bookButton.frame = frame;
    }
    
    //resize scrollview frame
    scrollView.contentSize = CGSizeMake(self.view.frame.size.width, bookButton.frame.size.height + bookButton.frame.origin.y);
}

+ (void) setItemLocation:(UIView *)item withPrev:(UILabel *)prev apartBy:(CGFloat)dist atX:(CGFloat)x
{
    CGRect frame = item.frame;
    frame.origin.y = prev.frame.origin.y + prev.frame.size.height + dist;
    frame.origin.x = x;
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
    aBooking.owner = listing.lister;
    aBooking.rating = 0;
    aBooking.listing = listing;
    //aBooking.listing_id = [listing objectId];
    //aBooking.listing_title = listing.title;
    [aBooking save];
}

-(BOOL) gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    return YES;
}

-(void) expandPics:(UITapGestureRecognizer *)sender{
    [self performSegueWithIdentifier:@"modalPics" sender:self];
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"ShowBookingConfirmation"]){
        BookingConfirmationViewController *destViewController = segue.destinationViewController;
        destViewController.booking = booking;
    } else if ([segue.identifier isEqualToString:@"modalPics"]){
        modalPictureViewController *destViewController = segue.destinationViewController;
        destViewController.imageData = listing.images;
    }
}


@end
