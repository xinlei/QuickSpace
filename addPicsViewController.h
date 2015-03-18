//
//  addPicsViewController.h
//  QuickSpace
//
//  Created by Jordan on 3/18/15.
//  Copyright (c) 2015 Jordan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewListing.h"

@interface addPicsViewController : UIViewController  <UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIAlertViewDelegate>

@property (strong, nonatomic) IBOutlet UIButton *takePhotoButton;
@property (strong, nonatomic) IBOutlet UIButton *submitButton;
@property (nonatomic) NewListing *listing;
- (IBAction)takePhotoClicked:(id)sender;

- (IBAction)submitClicked:(id)sender;
- (IBAction)selectPhotoClicked:(id)sender;
@property (strong, nonatomic) IBOutlet UIImageView *imageView;

@end
