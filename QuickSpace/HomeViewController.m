//
//  HomeViewController.m
//  QuickSpace
//
//  Created by Jordan on 3/18/15.
//  Copyright (c) 2015 Jordan. All rights reserved.
//

#import "HomeViewController.h"

@interface HomeViewController ()

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
 
    UITapGestureRecognizer *screenTouch = [[UITapGestureRecognizer alloc]
                                      initWithTarget:self
                                           action:@selector(touched:)];
    [self.view addGestureRecognizer:screenTouch];
}

-(BOOL) gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    return YES;
}

// If top image is clicked trigger appropriate segue and same for bottom image
-(void) touched:(UITapGestureRecognizer *) sender{
    if([sender locationInView:self.view].y < self.view.frame.size.height / 2){
        [self performSegueWithIdentifier:@"findSpaceSegue" sender:self];
    } else if ([sender locationInView:self.view].y > self.view.frame.size.height / 2)
        [self performSegueWithIdentifier:@"listSpaceSegue" sender:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
