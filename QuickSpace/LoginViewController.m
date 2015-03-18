//
//  LoginViewController.m
//  QuickSpace
//
//  Created by Jordan on 1/27/15.
//  Copyright (c) 2015 Jordan. All rights reserved.
//

#import "LoginViewController.h"
#import "SVProgressHUD.h"
#import <Parse/Parse.h>
#import "AppDelegate.h"
#import <SystemConfiguration/SCNetworkConfiguration.h>

@interface LoginViewController ()
@end

@implementation LoginViewController{
    bool canSegue;
}

@synthesize emailTextField;
@synthesize passwordTextField;



- (void)viewDidLoad {
    [super viewDidLoad];
    canSegue = NO;
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
    PFUser *user = [PFUser logInWithUsername: self.emailTextField.text password: self.passwordTextField.text];
    
    // Check network connection
    SCNetworkReachabilityFlags flags;
    SCNetworkReachabilityRef address = SCNetworkReachabilityCreateWithName(NULL, "www.apple.com" );
    Boolean success = SCNetworkReachabilityGetFlags(address, &flags);
    CFRelease(address);
    bool canReachOnExistingConnection = success && !(flags & kSCNetworkReachabilityFlagsConnectionRequired) && (flags & kSCNetworkReachabilityFlagsReachable);
    
    if(!canReachOnExistingConnection){
        [self showErrorMessage:@"No Internet Connection"];
        canSegue = NO;
    } else {
        if(user){
            
            /* Email verification turned off for testing and demo
            if (![[user objectForKey:@"emailVerified"] boolValue]) {
                // Refresh to make sure the user did not recently verify
                [user fetch];
                if (![[user objectForKey:@"emailVerified"] boolValue]) {
                    [self showErrorMessage:@"Email Unverified"];
                }
                canSegue = NO;
            } else {
             */
                canSegue = YES;
                AppDelegate *appDelegateTemp = [[UIApplication sharedApplication]delegate];
                appDelegateTemp.window.rootViewController = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateInitialViewController];
            //}
        } else {
            canSegue = NO;
            [self showErrorMessage:@"Invalid Login"];
        }
    }
}

// Dismiss keyboard when touching outside of textfield
-(void)dismissKeyboard {
    [emailTextField resignFirstResponder];
    [passwordTextField resignFirstResponder];
}

-(BOOL) textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

-(BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender{
    if (![identifier isEqualToString:@"loginSegue"]){
        return YES;
    }
    return canSegue;
}

- (void)showErrorMessage: (NSString *) message {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:message message:@"" delegate:nil cancelButtonTitle:@"Try Again" otherButtonTitles: nil];
    [alert show];
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
