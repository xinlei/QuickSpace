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

@interface LoginViewController ()
@property bool canSegue;
@end

@implementation LoginViewController

@synthesize emailTextField;
@synthesize passwordTextField;



- (void)viewDidLoad {
    [super viewDidLoad];
    self.canSegue = NO;
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)onSubmit:(UIButton *)sender {
//    __block PFUser *user = [[PFUser alloc] init];
//    [SVProgressHUD show];
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        PFUser *user = [PFUser logInWithUsername: self.emailTextField.text password: self.passwordTextField.text];
//        dispatch_async(dispatch_get_main_queue(), ^{
//            [SVProgressHUD dismiss];
//        });
//    });
    if(user){
        self.canSegue = YES;
        NSLog(@"Can Segue");
        AppDelegate *appDelegateTemp = [[UIApplication sharedApplication]delegate];
        appDelegateTemp.window.rootViewController = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateInitialViewController];
    } else{
        self.canSegue = NO;
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Incorrect Login" message:@"Try Again" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        [alert show];
    }
}

-(BOOL) textFieldShouldReturn:(UITextField *)textField
{
    if(textField == emailTextField) {
        [passwordTextField becomeFirstResponder];
    } else if (textField == passwordTextField) {
        [textField resignFirstResponder];
    }
    return NO;
}

-(BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender{
    if (![identifier isEqualToString:@"loginSegue"]){
        return YES;
    }
    return self.canSegue;
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
