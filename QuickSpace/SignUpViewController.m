//
//  SignUpViewController.m
//  QuickSpace
//
//  Created by Jordan on 1/27/15.
//  Copyright (c) 2015 Jordan. All rights reserved.
//

#import "SignUpViewController.h"

@interface SignUpViewController ()
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UITextField *confirmPasswordTextField;

@end

@implementation SignUpViewController

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
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Sign Up Error" message:@"Your Passwords don't match!" delegate:nil cancelButtonTitle:@"Try Again" otherButtonTitles: nil];
        [alert show];
        shouldSegue = NO;
    }
    //    else if(email is not valid){
    //
    //    }
    else {
        //    PFUser *user = [PFUser user];
        //    user.username = email;
        //    user.password = password1;
        //
        //
        //    [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        //        if (!error) {
        //            // Move to the next page. Decide if this should be the profile page to complete that part or let them go straight to browsing
        //        } else {
        //            NSString *errorString = [error userInfo][@"error"];
        //            // Show the errorString somewhere and let the user try again.
        //        }
        //    }];
        shouldSegue = YES;
    }
    
    NSLog(@"Email: %@, Password: %@, Password2: %@", email, password1, password2);
}

-(BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender{
    return shouldSegue;
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
