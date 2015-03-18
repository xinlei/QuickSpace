//
//  ViewController.h
//  QuickSpace
//
//  Created by Jordan on 1/22/15.
//  Copyright (c) 2015 Jordan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewListing.h"

@interface ViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UISegmentedControl *viewSwitcher;
@property (nonatomic, strong) IBOutlet UITableView * tableView;

-(void) populateListings;
@end

