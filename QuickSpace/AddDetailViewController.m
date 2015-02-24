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
    
    // Load previous user inputs
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary *amenities = [defaults objectForKey:@"newListingAmenities"];
    NSInteger price = [defaults integerForKey:@"newListingPrice"];
    
    // Set previous configuration
    if (amenities != nil) {
        wifiSwitch.on = [amenities[@"wifi"] boolValue];
        refrigeratorSwitch.on = [amenities[@"refrigerator"] boolValue];
        studyDeskSwitch.on = [amenities[@"studyDesk"] boolValue];
        monitorSwitch.on = [amenities[@"monitor"] boolValue];
        servicesSwitch.on = [amenities[@"services"] boolValue];
        if(wifiSwitch.on)
            NSLog(@"Wifi on(?)");
    }
    //Set previous price; otherwise default to 10
    if (price != -1){
        priceTextField.text = [@(price) stringValue];
    } else {
        priceTextField.text = [@(10) stringValue];
    }
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
    NSMutableDictionary *amenities = [[NSMutableDictionary alloc] init];
    [amenities setObject:[NSNumber numberWithBool:wifiSwitch.on] forKey:@"wifi"];
    [amenities setObject:[NSNumber numberWithBool:refrigeratorSwitch.on] forKey:@"refrigerator"];
    [amenities setObject:[NSNumber numberWithBool:studyDeskSwitch.on] forKey:@"studyDesk"];
    [amenities setObject:[NSNumber numberWithBool:monitorSwitch.on] forKey:@"monitor"];
    [amenities setObject:[NSNumber numberWithBool:servicesSwitch.on] forKey:@"services"];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:amenities forKey:@"newListingAmenities"];
    [defaults setInteger:[priceTextField.text intValue] forKey:@"newListingPrice"];
}


@end
