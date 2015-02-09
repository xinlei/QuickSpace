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

//spacetype buttons
@property (weak, nonatomic) IBOutlet UIButton *restButton;
@property (weak, nonatomic) IBOutlet UIButton *closetButton;
@property (weak, nonatomic) IBOutlet UIButton *officeButton;
@property (weak, nonatomic) IBOutlet UIButton *quietButton;
- (IBAction)restSelected:(id)sender;
- (IBAction)closetSelected:(id)sender;
- (IBAction)officeSelected:(id)sender;
- (IBAction)quietSelected:(id)sender;

//start/end;
- (IBAction)selectStart:(id)sender;
- (IBAction)selectEnd:(id)sender;

@property (weak, nonatomic) IBOutlet UIDatePicker *startPicker;
@property (weak, nonatomic) IBOutlet UIDatePicker *endPicker;
@property (weak, nonatomic) IBOutlet UIView *asdf;


@end
