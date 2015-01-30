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
    // Do any additional setup after loading the view.
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
    NSArray *keys = [NSArray arrayWithObjects:@"title", @"description", @"location", nil];
    NSArray *objects = [NSArray arrayWithObjects:titleTextField.text, descriptionTextField.text, locationTextField.text, nil];
    NSDictionary *newListing = [NSDictionary dictionaryWithObjects:objects forKeys:keys];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:newListing forKey:@"newListing"];
}



@end
