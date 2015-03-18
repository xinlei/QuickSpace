//
//  CancelViewController.m
//  QuickSpace
//
//  Created by Jordan on 1/31/15.
//  Copyright (c) 2015 Jordan. All rights reserved.
//

#import "CancelViewController.h"
#import <Parse/Parse.h>


@interface CancelViewController ()
@end


@implementation CancelViewController
@synthesize listing;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.hidesBackButton = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)homeButton:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (IBAction)cancelButton:(id)sender {
    [listing delete];
    [self.navigationController popToRootViewControllerAnimated:YES];
}
@end
