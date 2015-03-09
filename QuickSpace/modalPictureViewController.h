//
//  modalPictureViewController.h
//  QuickSpace
//
//  Created by Jordan on 3/5/15.
//  Copyright (c) 2015 Jordan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface modalPictureViewController : UIViewController <UIScrollViewDelegate, UIGestureRecognizerDelegate>
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (nonatomic) NSArray *imageData;
@end
