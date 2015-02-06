//
//  HostViewController.h
//  QuickSpace
//
//  Created by Tony Wang on 1/29/15.
//  Copyright (c) 2015 Jordan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Listing.h"

@interface HostViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *descriptionTextField;
@property (weak, nonatomic) IBOutlet UITextField *locationTextField;
@property (weak, nonatomic) IBOutlet UITextField *titleTextField;

@property (nonatomic, strong) NSMutableArray *spaceType;

//spacetype buttons
@property (weak, nonatomic) IBOutlet UIButton *restButton;
@property (weak, nonatomic) IBOutlet UIButton *closetButton;
@property (weak, nonatomic) IBOutlet UIButton *officeButton;
@property (weak, nonatomic) IBOutlet UIButton *quietButton;
- (IBAction)restSelected:(id)sender;
- (IBAction)closetSelected:(id)sender;
- (IBAction)officeSelected:(id)sender;
- (IBAction)quietSelected:(id)sender;

@end
