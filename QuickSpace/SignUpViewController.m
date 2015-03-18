//
//  SignUpViewController.m
//  QuickSpace
//
//  Created by Jordan on 1/27/15.
//  Copyright (c) 2015 Jordan. All rights reserved.
//

#import "SignUpViewController.h"
#import <Parse/Parse.h>
#import <SystemConfiguration/SCNetworkConfiguration.h>

@interface SignUpViewController ()

@end

@implementation SignUpViewController
@synthesize emailTextField;
@synthesize passwordTextField;
@synthesize confirmPasswordTextField;


- (void)viewDidLoad {
    [super viewDidLoad];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)onSubmit:(UIButton *)sender {
    
    // Check network connection
    SCNetworkReachabilityFlags flags;
    SCNetworkReachabilityRef address = SCNetworkReachabilityCreateWithName(NULL, "www.apple.com" );
    Boolean success = SCNetworkReachabilityGetFlags(address, &flags);
    CFRelease(address);
    bool canReachOnExistingConnection = success && !(flags & kSCNetworkReachabilityFlagsConnectionRequired) && (flags & kSCNetworkReachabilityFlagsReachable);
    
    // If connection is not available
    if(!canReachOnExistingConnection){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No Internet Connection" message:@"Try Again" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        [alert show];
    } else {
        NSString* email = self.emailTextField.text;
        NSString* password1 = self.passwordTextField.text;
        NSString* password2 = self.confirmPasswordTextField.text;
        
        if(password1.length < 4){
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Password too short" message:@"Please enter at least 4 characters" delegate:nil cancelButtonTitle:@"Try Again" otherButtonTitles: nil];
            [alert show];
        }
        else if(![password1 isEqualToString:password2]){
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Sign Up Error" message:@"Your Passwords don't match!" delegate:nil cancelButtonTitle:@"Try Again" otherButtonTitles: nil];
            [alert show];
        }
        else {
            
            // Create new user
            PFUser *user = [PFUser user];
            user.username = email;
            user.email = email;
            user.password = password1;

            // [user signUp] returns NO if there was an error during the sign up process, including if email address was already taken
            
            if(![user signUp]){
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Email address is invalid or already in use" delegate:nil cancelButtonTitle:@"Try Again" otherButtonTitles: nil];
                [alert show];
            } else {
                AppDelegate *appDelegateTemp = [[UIApplication sharedApplication]delegate];
                appDelegateTemp.window.rootViewController = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateInitialViewController];
            }

        }
    }

}

-(void)dismissKeyboard {
    [emailTextField resignFirstResponder];
    [passwordTextField resignFirstResponder];
    [confirmPasswordTextField resignFirstResponder];
}

-(BOOL) textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}


@end
