//
//  AddDetailViewController.m
//  QuickSpace
//
//  Created by Tony Wang on 1/29/15.
//  Copyright (c) 2015 Jordan. All rights reserved.
//

#import "AddDetailViewController.h"

@interface AddDetailViewController ()

@end

@implementation AddDetailViewController

@synthesize wifiSwitch;
@synthesize refrigeratorSwitch;
@synthesize studyDeskSwitch;
@synthesize monitorSwitch;
@synthesize servicesSwitch;
@synthesize priceLabel;
@synthesize priceTextField;
@synthesize listing;

typedef enum {
    wifi = 0,
    refrigerator,
    studyDesk,
    monitor,
    services,
} Amenities;

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
    listing = [NewListing retrieveNewListing];
    [listing fetchFromLocalDatastore];
    
    // Update view with values from the previous listing
    wifiSwitch.on = [listing.amenities[wifi] boolValue];
    refrigeratorSwitch.on = [listing.amenities[refrigerator] boolValue];
    studyDeskSwitch.on = [listing.amenities[studyDesk] boolValue];
    monitorSwitch.on = [listing.amenities[monitor] boolValue];
    servicesSwitch.on = [listing.amenities[services] boolValue];
    priceTextField.text = [@(listing.price) stringValue];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender{
    NSCharacterSet* notDigits = [[NSCharacterSet decimalDigitCharacterSet] invertedSet];
    if ([priceTextField.text rangeOfCharacterFromSet:notDigits].location == NSNotFound){
        return YES;
    } else {
        UIAlertView *notPermitted = [[UIAlertView alloc]
                                     initWithTitle:@"Error"
                                     message:@"Price Must a Number"
                                     delegate:nil
                                     cancelButtonTitle:@"OK"
                                     otherButtonTitles:nil];
        
        [notPermitted show];
        return NO;
    }
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    listing.price = [priceTextField.text intValue];
    listing.amenities = [[NSMutableArray alloc]initWithObjects:
                                 [NSNumber numberWithBool:wifiSwitch.on],
                                 [NSNumber numberWithBool:refrigeratorSwitch.on],
                                 [NSNumber numberWithBool:studyDeskSwitch.on],
                                 [NSNumber numberWithBool:monitorSwitch.on],
                                 [NSNumber numberWithBool:servicesSwitch.on],nil];
}


@end
