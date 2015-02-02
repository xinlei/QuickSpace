//
//  FilterViewController.h
//  QuickSpace
//
//  Created by Tony Wang on 1/27/15.
//  Copyright (c) 2015 Jordan. All rights reserved.
//

#import <UIKit/UIKit.h>

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

//start/end labels
@property (weak, nonatomic) IBOutlet UILabel *startDate;
@property (weak, nonatomic) IBOutlet UILabel *startTime;
@property (weak, nonatomic) IBOutlet UILabel *endDate;
@property (weak, nonatomic) IBOutlet UILabel *endTime;

//start/end buttons
@property (weak, nonatomic) IBOutlet UIButton *startButton;
@property (weak, nonatomic) IBOutlet UIButton *endButton;
- (IBAction)selectStart:(id)sender;
- (IBAction)selectEnd:(id)sender;

@end
