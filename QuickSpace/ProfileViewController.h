//
//  ProfileViewController.h
//  QuickSpace
//
//  Created by Tony Wang on 1/31/15.
//  Copyright (c) 2015 Jordan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProfileViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UIActionSheetDelegate>

@property (weak, nonatomic) IBOutlet UISegmentedControl *listingSegments;
@property (strong, nonatomic) IBOutlet UITableView *listingTable;
@property (strong, nonatomic) IBOutlet UIActionSheet *popup;
@property (weak, nonatomic) IBOutlet UIButton *logoutButton;

@end
