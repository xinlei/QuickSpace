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
    if([listing.amenities containsObject:[NSNumber numberWithInt:wifi]])
        wifiSwitch.on = YES;
    if([listing.amenities containsObject:[NSNumber numberWithInt:refrigerator]]) refrigeratorSwitch.on = YES;
    if([listing.amenities containsObject:[NSNumber numberWithInt:studyDesk]]) studyDeskSwitch.on = YES;
    if([listing.amenities containsObject:[NSNumber numberWithInt:monitor]]) monitorSwitch.on = YES;
    if([listing.amenities containsObject:[NSNumber numberWithInt:services]]) servicesSwitch.on = YES;
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
    listing.amenities = [[NSMutableArray alloc] init];
    if(wifiSwitch.on)[listing.amenities addObject:[NSNumber numberWithInt:wifi]];
    if(refrigeratorSwitch.on)[listing.amenities addObject:[NSNumber numberWithInt:refrigerator]];
    if(studyDeskSwitch.on)[listing.amenities addObject:[NSNumber numberWithInt:studyDesk]];
    if(monitorSwitch.on)[listing.amenities addObject:[NSNumber numberWithInt:monitor]];
    if(servicesSwitch.on)[listing.amenities addObject:[NSNumber numberWithInt:services]];
}


@end
