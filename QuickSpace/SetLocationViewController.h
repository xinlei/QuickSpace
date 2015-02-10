//
//  SetLocationViewController.h
//  QuickSpace
//
//  Created by Jordan on 2/8/15.
//  Copyright (c) 2015 Jordan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SetLocationViewController : UIViewController
- (IBAction)search:(id)sender;
@property (strong, nonatomic) IBOutlet UITextField *addressTextField;

@end
