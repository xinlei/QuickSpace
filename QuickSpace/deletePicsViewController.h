//
//  deletePicsViewController.h
//  QuickSpace
//
//  Created by Tony Wang on 3/18/15.
//  Copyright (c) 2015 Jordan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewListing.h"

@interface deletePicsViewController : UIViewController <UIGestureRecognizerDelegate>
@property (nonatomic) NewListing* listing;
@property int index;
@property (nonatomic) UIImage *pic;
- (IBAction)deletePic:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *deleteButton;

@end
