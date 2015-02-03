//
//  SignUpViewController.m
//  QuickSpace
//
//  Created by Jordan on 1/27/15.
//  Copyright (c) 2015 Jordan. All rights reserved.
//

#import "SignUpViewController.h"
#import <Parse/Parse.h>

@interface SignUpViewController ()

@end

@implementation SignUpViewController

@synthesize emailTextField;
@synthesize passwordTextField;
@synthesize confirmPasswordTextField;

bool shouldSegue = YES;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)onSubmit:(UIButton *)sender {
    
    NSString* email = self.emailTextField.text;
    NSString* password1 = self.passwordTextField.text;
    NSString* password2 = self.confirmPasswordTextField.text;
    
    if(password1.length < 4){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Password too short" message:@"Please enter at least 4 characters" delegate:nil cancelButtonTitle:@"Try Again" otherButtonTitles: nil];
        [alert show];
        shouldSegue = NO;
    }
    
    else if(![password1 isEqualToString:password2]){
        shouldSegue = NO;
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Sign Up Error" message:@"Your Passwords don't match!" delegate:nil cancelButtonTitle:@"Try Again" otherButtonTitles: nil];
        [alert show];
    }
    //    else if(email is not valid){
    //
    //    }
    else {
        PFUser *user = [PFUser user];
        user.username = email;
        user.password = password1;
        
        //Need to make sure that particular email address doesn't already exist in our user database.
        // if it does, give the person the option to reset the password (?)
        shouldSegue = [user signUp];
        if(shouldSegue == NO){
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Email address is already taken" delegate:nil cancelButtonTitle:@"Try Again" otherButtonTitles: @"Forgot Password?", nil];
            [alert show];
        }

    }
    
    NSLog(@"Email: %@, Password: %@, Password2: %@", email, password1, password2);
}

-(BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender{
    return shouldSegue;
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
