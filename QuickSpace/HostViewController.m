//
//  HostViewController.m
//  QuickSpace
//
//  Created by Tony Wang on 1/29/15.
//  Copyright (c) 2015 Jordan. All rights reserved.
//

#import "HostViewController.h"
#import <Bolts/BFTask.h>
#import "SetLocationViewController.h"
#import "Type.h"

@interface HostViewController ()

@end

@implementation HostViewController

@synthesize titleTextField;
@synthesize descriptionTextField;
@synthesize locationTextField;
@synthesize spaceType;
@synthesize restButton;
@synthesize closetButton;
@synthesize officeButton;
@synthesize quietButton;
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
    
    // Retrieve temporary created listing
    listing = [NewListing retrieveNewListing];
    
    //[PFObject unpinAllObjects];
    // Update view with values from the previous listing
    if(listing != nil){
        
        if([listing.types containsObject: [NSNumber numberWithInt:rest]]) restButton.selected = YES;
        if([listing.types containsObject: [NSNumber numberWithInt:closet]]) closetButton.selected = YES;
        if([listing.types containsObject: [NSNumber numberWithInt:office]]) officeButton.selected = YES;
        if([listing.types containsObject: [NSNumber numberWithInt:quiet]]) quietButton.selected = YES;
        titleTextField.text = listing.title;
        descriptionTextField.text = listing.information;
        locationTextField.text = listing.address;
    } else {
        listing = [NewListing object];
        [listing pin];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(BOOL) textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender {
    if ([identifier isEqualToString:@"ShowNewListingDetails"]) {
        
        bool canSegue = YES;
        NSString *alertText = @"";
        
        if (!titleTextField || titleTextField.text.length == 0){
            canSegue = NO;
            alertText = @"Please name your space.";
        }
        if (!locationTextField || locationTextField.text.length == 0){
            canSegue = NO;
            alertText = @"Please locate your space.";
        }
        if (canSegue){
            return YES;
        } else {
            UIAlertView *notPermitted = [[UIAlertView alloc]
                                        initWithTitle:@"Alert"
                                        message:alertText
                                        delegate:nil
                                        cancelButtonTitle:@"OK"
                                        otherButtonTitles:nil];
            
            [notPermitted show];
            return NO;
        }
    }
    return YES;
}

// spacetype buttons
- (IBAction)restSelected:(id)sender {
    UIButton *button = (UIButton *)sender;
    button.selected = !button.selected;
}

- (IBAction)closetSelected:(id)sender {
    UIButton *button = (UIButton *)sender;
    button.selected = !button.selected;
}

- (IBAction)officeSelected:(id)sender {
    UIButton *button = (UIButton *)sender;
    button.selected = !button.selected;
}

- (IBAction)quietSelected:(id)sender {
    UIButton *button = (UIButton *)sender;
    button.selected = !button.selected;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
    if ([segue.identifier isEqualToString:@"ShowNewListingDetails"]){
        SetLocationViewController *destViewController = segue.destinationViewController;
        destViewController.address = locationTextField.text;
    }
    
    listing.types = [[NSMutableArray alloc] init];
    if (restButton.selected)
        [listing.types addObject:[NSNumber numberWithInt:rest]];
        //[spaceType replaceObjectAtIndex:0 withObject:[NSNumber numberWithBool:YES]];
    if (closetButton.selected)
        [listing.types addObject:[NSNumber numberWithInt:closet]];
        //[spaceType replaceObjectAtIndex:1 withObject:[NSNumber numberWithBool:YES]];
    if (officeButton.selected)
        [listing.types addObject:[NSNumber numberWithInt:office]];
        //[spaceType replaceObjectAtIndex:2 withObject:[NSNumber numberWithBool:YES]];
    if (quietButton.selected)
        [listing.types addObject:[NSNumber numberWithInt:quiet]];
        //[spaceType replaceObjectAtIndex:3 withObject:[NSNumber numberWithBool:YES]];

    // Save input to a temporarily created listing
    listing.price = 10;
    listing.title = titleTextField.text;
    listing.information = descriptionTextField.text;
    listing.address = locationTextField.text;
    listing.ratingValue = 0;
    listing.totalRaters = 0;
    listing.totalRating= 0;
}



@end
