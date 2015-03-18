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
#import "modalPictureViewController.h"
#import "CancelViewController.h"

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


    


    //set scrollView
    scrollView.frame = self.view.frame;
    scrollView.contentSize = CGSizeMake(self.view.frame.size.width, 1000);
    CGRect viewFrame = scrollView.frame;
    CGFloat mid = viewFrame.size.width/2;
    
    //set image
    CGRect frame = listingImg.frame;
    frame.origin.x = mid - frame.size.width/2;
    frame.origin.y = 0;
    listingImg.frame = frame;
    listingImg.image = theImage;
    
    UITapGestureRecognizer *picClick = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(seeMorePics:)];
    [picClick setDelegate:self];
    [listingImg addGestureRecognizer:picClick];
    
    //set title
    titleText.text = listing.title;
    
    // new
    //CGRect frame = titleText.frame;
    
    frame = titleText.frame;
    frame.origin.x = mid;
    frame.origin.y = listingImg.frame.origin.y + listingImg.frame.size.height + 10;
    titleText.frame = frame;
    frame = titleLabel.frame;
    frame.origin.y = listingImg.frame.origin.y + listingImg.frame.size.height + 10;
    titleLabel.frame = frame;
    
    //set price
    priceText.text = [NSString stringWithFormat:@"$%d/hour", listing.price];
    frame = priceText.frame;
    priceText.frame = frame;
    [ListingDetailViewController setItemLocation:priceLabel withPrev:titleText apartBy:10 atX:priceLabel.frame.origin.x];
    [ListingDetailViewController setItemLocation:priceText withPrev:titleText apartBy:10 atX:mid];
    
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
    [ListingDetailViewController setItemLocation:locationLabel withPrev:priceText apartBy:10 atX:locationLabel.frame.origin.x];
    [ListingDetailViewController setItemLocation:locationText withPrev:priceText apartBy:10 atX:mid];
    
    //set amenities
    amenitiesText.text = [listing amenitiesToString];
    amenitiesText.numberOfLines = 0;
    NSLog(@"%@", amenitiesText.text);
    CGSize labelSize = [amenitiesText.text sizeWithAttributes:@{NSFontAttributeName:amenitiesText.font}];
    amenitiesText.frame = CGRectMake(mid, amenitiesText.frame.origin.y, amenitiesText.frame.size.width, labelSize.height);
    [ListingDetailViewController setItemLocation:amenitiesText withPrev:locationText apartBy:10 atX:mid];
    [ListingDetailViewController setItemLocation:amenitiesLabel withPrev:locationText apartBy:10 atX:amenitiesLabel.frame.origin.x];
    
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
    [ListingDetailViewController setItemLocation:descriptionsLabel withPrev:amenitiesText apartBy:10 atX:descriptionsLabel.frame.origin.x];
    [ListingDetailViewController setItemLocation:descriptionsText withPrev:descriptionsLabel apartBy:5 atX:mid - frame.size.width/2];
    
    //set button size
    frame = confirmButton.frame;
    frame.size.width = viewFrame.size.width;
    confirmButton.frame = frame;
    
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

-(BOOL) gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    return YES;
}

-(void) seeMorePics:(UITapGestureRecognizer *)sender{
    NSLog(@"IM HERE");
    [self performSegueWithIdentifier:@"confirmationModalPics" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"confirmationModalPics"]){
        modalPictureViewController *destViewController = segue.destinationViewController;
        destViewController.imageFiles = listing.images;
    }
    if ([segue.identifier isEqualToString:@"ShowFinalConfirmation"]){
        CancelViewController *destViewController = segue.destinationViewController;
    
        //if([self.allPhotos count] == 0){
        //NSData *currImage = UIImagePNGRepresentation([UIImage imageNamed:@"no-image.png"]);
        //PFFile *imageFile = [PFFile fileWithName:@"listingImage.png" data:currImage];
        //[self.allPhotos addObject:imageFile];
        //}
        
        destViewController.listing = listing;
        listing.lister = [PFUser currentUser];
        [listing pinInBackgroundWithName:@"Listing"];
        [listing saveInBackground];

    }
}

@end