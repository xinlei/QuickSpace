//
//  BookingConfirmationViewController.m
//  QuickSpace
//
//  Created by Tony Wang on 2/3/15.
//  Copyright (c) 2015 Jordan. All rights reserved.
//

#import "BookingConfirmationViewController.h"
#import <Parse/Parse.h>

@interface BookingConfirmationViewController () {
    Booking *booking;
}
@end

@implementation BookingConfirmationViewController

@synthesize cancelButton;
@synthesize booking;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)cancelBooking:(UIButton *)sender {
    //[booking cancel];
}

@end
