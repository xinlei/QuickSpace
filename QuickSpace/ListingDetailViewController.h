//
//  ListingDetailViewController.h
//  QuickSpace
//
//  Created by Gene Oetomo on 1/23/15.
//  Copyright (c) 2015 Jordan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ListingDetailViewController : UIViewController

@property (nonatomic, strong) NSString *imageName;
@property (nonatomic, strong) NSString *titleName;
@property (nonatomic, strong) IBOutlet UILabel *titleLabel;
@property (nonatomic, strong) IBOutlet UIImageView *image;

@end
