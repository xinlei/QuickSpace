//
//  HostViewController.m
//  QuickSpace
//
//  Created by Tony Wang on 1/29/15.
//  Copyright (c) 2015 Jordan. All rights reserved.
//

#import "HostViewController.h"
#import <Bolts/BFTask.h>

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
    
    NSNumber *space = [NSNumber numberWithBool:NO];
    NSNumber *closet = [NSNumber numberWithBool:NO];
    NSNumber *office = [NSNumber numberWithBool:NO];
    NSNumber *quiet = [NSNumber numberWithBool:NO];
    spaceType = [NSMutableArray arrayWithObjects:space, closet, office, quiet, nil];
    
    // Retrieve temporary created listing
    PFQuery *query = [[NewListing query] fromPinWithName:@"newListing"];
    NSArray *objects = [query findObjects];
    if([objects count] >= 1) listing = [objects objectAtIndex:0];
    
    // Update view with values from the previous listing
    if(listing != nil){
        restButton.selected = [listing.types[0] boolValue];
        closetButton.selected = [listing.types[1] boolValue];
        officeButton.selected = [listing.types[2] boolValue];
        quietButton.selected = [listing.types[3] boolValue];
        titleTextField.text = listing.title;
        descriptionTextField.text = listing.information;
        locationTextField.text = listing.address;
    } else {
        [listing pinWithName:@"newListing"];
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
    [spaceType replaceObjectAtIndex:0 withObject:[NSNumber numberWithBool:restButton.selected]];
    [spaceType replaceObjectAtIndex:1 withObject:[NSNumber numberWithBool:closetButton.selected]];
    [spaceType replaceObjectAtIndex:2 withObject:[NSNumber numberWithBool:officeButton.selected]];
    [spaceType replaceObjectAtIndex:3 withObject:[NSNumber numberWithBool:quietButton.selected]];

    // Save input to a temporarily created listing
    listing.price = -1;
    listing.title = titleTextField.text;
    listing.information = descriptionTextField.text;
    listing.address = locationTextField.text;
    listing.types = spaceType;
}



@end
