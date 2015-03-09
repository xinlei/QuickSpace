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
     
    // Load previous user inputs
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *newListingBasicInfo = [defaults objectForKey:@"newListingBasicInfo"];
    
    
    // Load previous space types
    NSArray *newListingSpaceType = [defaults objectForKey:@"newListingSpaceType"];
    if (newListingSpaceType != nil){
        restButton.selected = [newListingSpaceType[0] boolValue];
        closetButton.selected = [newListingSpaceType[1] boolValue];
        officeButton.selected = [newListingSpaceType[2] boolValue];
        quietButton.selected = [newListingSpaceType[3] boolValue];
    }
    // Load previous basic space information
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

//spacetype buttons
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
    
    if ([segue.identifier isEqualToString:@"ShowBookingConfirmation"]){
        SetLocationViewController *destViewController = segue.destinationViewController;
        destViewController.address = locationTextField.text;
    }
    
    if (restButton.selected)
        [spaceType replaceObjectAtIndex:0 withObject:[NSNumber numberWithBool:YES]];
    if (closetButton.selected)
        [spaceType replaceObjectAtIndex:1 withObject:[NSNumber numberWithBool:YES]];
    if (officeButton.selected)
        [spaceType replaceObjectAtIndex:2 withObject:[NSNumber numberWithBool:YES]];
    if (quietButton.selected)
        [spaceType replaceObjectAtIndex:3 withObject:[NSNumber numberWithBool:YES]];

    
    NSArray *keys = [NSArray arrayWithObjects:
                     @"title",
                     @"description",
                     @"location",
                     nil];
   
    NSArray *objects = [NSArray arrayWithObjects:titleTextField.text, descriptionTextField.text, locationTextField.text, nil];
    NSMutableDictionary *newListingBasicInfo = [NSMutableDictionary dictionaryWithObjects:objects forKeys:keys];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    [defaults setObject:spaceType forKey:@"newListingSpaceType"];
    [defaults setObject:newListingBasicInfo forKey:@"newListingBasicInfo"];
    [defaults setInteger:-1 forKey:@"price"];
}



@end
