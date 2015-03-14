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
    // Do any additional setup after loading the view.
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
            
            // New user
            PFUser *user = [PFUser user];
            user.username = email;
            user.email = email;
            user.password = password1;
            //Need to make sure that particular email address doesn't already exist in our user database.
            // if it does, give the person the option to reset the password (?)
            if(![user signUp]){
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Email address is invalid" delegate:nil cancelButtonTitle:@"Try Again" otherButtonTitles: nil];
                [alert show];
            } else {
                AppDelegate *appDelegateTemp = [[UIApplication sharedApplication]delegate];
                appDelegateTemp.window.rootViewController = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateInitialViewController];
            }

        }
    }

}

-(BOOL) textFieldShouldReturn:(UITextField *)textField
{
    if(textField == confirmPasswordTextField) {
        [textField resignFirstResponder];
    } else if (textField == emailTextField) {
        [passwordTextField becomeFirstResponder];
    } else if (textField == passwordTextField){
        [confirmPasswordTextField becomeFirstResponder];
    }
    return NO;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
