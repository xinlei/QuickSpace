//
//  CancelViewController.h
//  QuickSpace
//
//  Created by Jordan on 1/31/15.
//  Copyright (c) 2015 Jordan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewListing.h"

@interface CancelViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (nonatomic) NewListing *listing;
- (IBAction)homeButton:(id)sender;
- (IBAction)cancelButton:(id)sender;

@end
