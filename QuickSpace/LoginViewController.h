//
//  LoginViewController.h
//  QuickSpace
//
//  Created by Jordan on 1/27/15.
//  Copyright (c) 2015 Jordan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginViewController : UIViewController <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;

- (void) showErrorMessage: (NSString *) message;

@end
