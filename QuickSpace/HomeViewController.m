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
    // Do any additional setup after loading the view.
    UITapGestureRecognizer *screenTouch = [[UITapGestureRecognizer alloc]
                                      initWithTarget:self
                                           action:@selector(touched:)];
    [self.view addGestureRecognizer:screenTouch];
}

-(BOOL) gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    return YES;
}

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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
