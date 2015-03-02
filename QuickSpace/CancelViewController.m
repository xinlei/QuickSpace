//
//  CancelViewController.m
//  QuickSpace
//
//  Created by Jordan on 1/31/15.
//  Copyright (c) 2015 Jordan. All rights reserved.
//

#import "CancelViewController.h"
#import <Parse/Parse.h>
#import "Listing.h"

@interface CancelViewController ()
@end

@implementation CancelViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([segue.identifier isEqualToString:@"cancelListingSegue"]){
        
        [Listing cancelListingForHost:[defaults objectForKey:@"object_id"]];
    }
    [defaults removeObjectForKey:@"object_id"];
    [defaults removeObjectForKey:@"newListingAmenities"];
    [defaults removeObjectForKey:@"newListingBasicInfo"];
    [defaults removeObjectForKey:@"newListingPrice"];
    [defaults removeObjectForKey:@"Latitude"];
    [defaults removeObjectForKey:@"Longitude"];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)homeButton:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}
@end
