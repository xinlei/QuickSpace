//
//  modalPictureViewController.m
//  QuickSpace
//
//  Created by Jordan on 3/5/15.
//  Copyright (c) 2015 Jordan. All rights reserved.
//

#import "modalPictureViewController.h"
#import <Parse/Parse.h>

@interface modalPictureViewController ()

@end


@implementation modalPictureViewController
@synthesize scrollView;
@synthesize imageFiles;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UITapGestureRecognizer *close = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeModal:)];
    [close setDelegate:self];
    [scrollView addGestureRecognizer:close];
    
    self.view.backgroundColor = [UIColor blackColor];
    scrollView.frame = self.view.frame;
    scrollView.pagingEnabled = YES;
    
    for (int i = 0; i < imageFiles.count; i++) {
        CGFloat myOrigin = i*self.view.frame.size.width;
        
        UIImageView *myImageView = [[UIImageView alloc] initWithFrame:CGRectMake(myOrigin, self.view.frame.size.height / 3, self.view.frame.size.width, self.view.frame.size.height / 3)];

        myImageView.image = [UIImage imageWithData:[[imageFiles objectAtIndex:i] getData]];
        scrollView.delegate = self;
        [scrollView addSubview:myImageView];
        
        
    }
    
    scrollView.contentSize = CGSizeMake(self.view.frame.size.width * imageFiles.count, self.view.frame.size.height);
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{

}

-(BOOL) gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    return YES;
}

-(void)closeModal:(UITapGestureRecognizer *)sender{
    if([sender locationInView:self.view].y < self.view.frame.size.height / 3 || [sender locationInView:self.view].y > 2* self.view.frame.size.height / 3){
            [self dismissViewControllerAnimated: YES completion:nil];
    }
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
