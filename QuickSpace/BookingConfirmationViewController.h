//
//  BookingConfirmationViewController.h
//  QuickSpace
//
//  Created by Tony Wang on 2/3/15.
//  Copyright (c) 2015 Jordan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Listing.h"

@interface BookingConfirmationViewController : UIViewController

@property (nonatomic, strong) Listing *listing;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;

@end
