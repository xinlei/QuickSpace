//
//  AddDetailViewController.m
//  QuickSpace
//
//  Created by Tony Wang on 1/29/15.
//  Copyright (c) 2015 Jordan. All rights reserved.
//

#import "AddDetailViewController.h"
#import "AddPhotoViewController.h"

@interface AddDetailViewController ()

@end

@implementation AddDetailViewController

@synthesize wifiSwitch;
@synthesize refrigeratorSwitch;
@synthesize studyDeskSwitch;
@synthesize monitorSwitch;
@synthesize servicesSwitch;
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
    
    // To detect when tapped outside of the key board
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];
    priceTextField.text = [@(listing.price) stringValue];
    
    
    //Used to get the keyboard height and trigger moving the view up / down
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:self.view.window];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:self.view.window];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// Moves the view up so the keyboard doesn't cover the textfield
-(void) keyboardWillShow:(NSNotification *)n {
    NSDictionary *userInfo = [n userInfo];
    CGFloat keyboardHeight = [[userInfo objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size.height;
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:0.3f];
    self.view.frame = CGRectOffset(self.view.frame, 0, -(keyboardHeight - self.tabBarController.tabBar.frame.size.height));
    [UIView commitAnimations];
}

// Moves the view down after the keyboard is dismissed
-(void) keyboardWillHide:(NSNotification *)n {
    NSDictionary *userInfo = [n userInfo];
    CGFloat keyboardHeight = [[userInfo objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size.height;
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:0.3f];
    self.view.frame = CGRectOffset(self.view.frame, 0, keyboardHeight - self.tabBarController.tabBar.frame.size.height);
    [UIView commitAnimations];
}

// Make sure price input is a valid number
- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender{
    NSString *error = [NewListing isValidPrice:priceTextField.text];
    if (error) {
        UIAlertView *notPermitted = [[UIAlertView alloc]
                                     initWithTitle:@"Error"
                                     message:error
                                     delegate:nil
                                     cancelButtonTitle:@"OK"
                                     otherButtonTitles:nil];
        
        [notPermitted show];
        return NO;
    } else return YES;
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
    
    AddPhotoViewController *destViewController = segue.destinationViewController;
    destViewController.listing = listing;
}

- (void) dismissKeyboard {
    [priceTextField resignFirstResponder];
}

-(BOOL) textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

@end
