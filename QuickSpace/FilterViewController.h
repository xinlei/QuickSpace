//
//  FilterViewController.h
//  QuickSpace
//
//  Created by Tony Wang on 1/27/15.
//  Copyright (c) 2015 Jordan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AdvancedFilterViewController.h"

@interface FilterViewController : UIViewController 

@property (nonatomic, strong) NSMutableArray *spaceType;
@property (weak, nonatomic) IBOutlet UIView *line1;
@property (weak, nonatomic) IBOutlet UIView *line2;
@property (weak, nonatomic) IBOutlet UIView *line3;

//spacetype buttons
@property (weak, nonatomic) IBOutlet UIButton *restButton;
@property (weak, nonatomic) IBOutlet UIButton *closetButton;
@property (weak, nonatomic) IBOutlet UIButton *officeButton;
@property (weak, nonatomic) IBOutlet UIButton *quietButton;
@property (weak, nonatomic) IBOutlet UIDatePicker *startPicker;
@property (weak, nonatomic) IBOutlet UIDatePicker *endPicker;
@property (weak, nonatomic) IBOutlet UIView *timePickerContainer;

- (IBAction)restSelected:(id)sender;
- (IBAction)closetSelected:(id)sender;
- (IBAction)officeSelected:(id)sender;
- (IBAction)quietSelected:(id)sender;
@end
