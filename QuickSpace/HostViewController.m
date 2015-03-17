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
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];
    listing = [NewListing object];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) dismissKeyboard {
    [titleTextField resignFirstResponder];
    [descriptionTextField resignFirstResponder];
    [locationTextField resignFirstResponder];
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
        
        if (!locationTextField || locationTextField.text.length == 0){
            canSegue = NO;
            alertText = @"Please locate your space.";
        }
        
        if (!titleTextField || titleTextField.text.length == 0){
            canSegue = NO;
            alertText = @"Please name your space.";
        }
        if (canSegue)return YES;
        UIAlertView *notPermitted = [[UIAlertView alloc]
                                        initWithTitle:@"Alert"
                                        message:alertText
                                        delegate:nil
                                        cancelButtonTitle:@"OK"
                                        otherButtonTitles:nil];
        [notPermitted show];
    }
    return NO;
}

// Space type buttons
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
    listing.types = [[NSMutableArray alloc] init];
    if (restButton.selected) [listing.types addObject:[NSNumber numberWithInt:rest]];
    if (closetButton.selected)[listing.types addObject:[NSNumber numberWithInt:closet]];
    if (officeButton.selected)[listing.types addObject:[NSNumber numberWithInt:office]];
    if (quietButton.selected)[listing.types addObject:[NSNumber numberWithInt:quiet]];
    
    listing.title = titleTextField.text;
    listing.information = descriptionTextField.text;
    listing.address = locationTextField.text;
    listing.ratingValue = 0;
    listing.totalRaters = 0;
    listing.totalRating= 0;
    listing.price = 10;
    
    SetLocationViewController *destViewController = segue.destinationViewController;
    destViewController.listing = listing;
}



@end
