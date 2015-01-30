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

@end
