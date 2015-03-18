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
@synthesize scrollView;

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
    priceTextField.text = [@(listing.price) stringValue];
    
    scrollView.frame = self.view.frame;
    scrollView.contentSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height + 300);
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:self.view.window];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:self.view.window];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) keyboardWillShow:(NSNotification *)n {
    NSDictionary *userInfo = [n userInfo];
    CGFloat keyboardSize = [[userInfo objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size.height;
    CGRect frame = scrollView.frame;
    frame.size.height -= keyboardSize;
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [scrollView setFrame:frame];
    [UIView commitAnimations];
}

-(void) keyboardWillHide:(NSNotification *)n {
    NSDictionary *userInfo = [n userInfo];
    CGFloat keyboardSize = [[userInfo objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size.height;
    CGRect frame = scrollView.frame;
    frame.size.height += keyboardSize;
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [scrollView setFrame:frame];
    [UIView commitAnimations];
}

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender{
    NSCharacterSet* notDigits = [[NSCharacterSet decimalDigitCharacterSet] invertedSet];
    bool isPermitted = YES;
    NSString *error = [[NSString alloc] init];
    if ([priceTextField.text rangeOfCharacterFromSet:notDigits].location != NSNotFound || [priceTextField.text length] == 0){
        error = @"Price must be a whole number";
        isPermitted = NO;
    } else if ([priceTextField.text intValue] < 0 || [priceTextField.text intValue] > 500){
        isPermitted = NO;
        error = @"Set price between 0-500";
    } else {
        isPermitted = YES;
        return isPermitted;
    }
    UIAlertView *notPermitted = [[UIAlertView alloc]
                             initWithTitle:@"Error"
                             message:error
                             delegate:nil
                             cancelButtonTitle:@"OK"
                             otherButtonTitles:nil];

    [notPermitted show];
    return isPermitted;
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
