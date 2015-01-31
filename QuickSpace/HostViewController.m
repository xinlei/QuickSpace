//
//  HostViewController.m
//  QuickSpace
//
//  Created by Tony Wang on 1/29/15.
//  Copyright (c) 2015 Jordan. All rights reserved.
//

#import "HostViewController.h"

@interface HostViewController ()

@end

@implementation HostViewController

@synthesize titleTextField;
@synthesize descriptionTextField;
@synthesize locationTextField;

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
    NSDictionary *newListingBasicInfo = [defaults objectForKey:@"newListingBasicInfo"];
    if (newListingBasicInfo != nil){
        titleTextField.text = newListingBasicInfo[@"title"];
        descriptionTextField.text = newListingBasicInfo[@"description"];
        locationTextField.text = newListingBasicInfo[@"location"];
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

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
 
    NSArray *keys = [NSArray arrayWithObjects:
                     @"title",
                     @"description",
                     @"location",
                     nil];
   
    NSArray *objects = [NSArray arrayWithObjects:titleTextField.text, descriptionTextField.text, locationTextField.text, nil];
    NSMutableDictionary *newListingBasicInfo = [NSMutableDictionary dictionaryWithObjects:objects forKeys:keys];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    [defaults setObject:newListingBasicInfo forKey:@"newListingBasicInfo"];
    [defaults setInteger:-1 forKey:@"price"];
}



@end
