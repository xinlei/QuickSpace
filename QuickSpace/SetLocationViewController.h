//
//  SetLocationViewController.h
//  QuickSpace
//
//  Created by Jordan on 2/8/15.
//  Copyright (c) 2015 Jordan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewListing.h"

@interface SetLocationViewController : UIViewController<UIAlertViewDelegate>
@property (nonatomic, strong) NewListing *listing;
@end
