//
//  ViewController.h
//  QuickSpace
//
//  Created by Jordan on 1/22/15.
//  Copyright (c) 2015 Jordan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate>

@property (nonatomic, strong) IBOutlet UITableView * tableView;
@property (strong, nonatomic) NSMutableArray *spaceType;
@property (weak, nonatomic) NSDate *startDate;
@property (weak, nonatomic) NSDate *endDate;

-(void) populateListings;
@end

