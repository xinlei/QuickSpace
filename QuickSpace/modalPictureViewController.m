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
    
    // For exiting the view
    UITapGestureRecognizer *close = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeModal:)];
    [close setDelegate:self];
    [scrollView addGestureRecognizer:close];
    
    self.view.backgroundColor = [UIColor blackColor];
    scrollView.frame = self.view.frame;
    scrollView.pagingEnabled = YES;
    
    // Add all pics to the scroll view
    for (int i = 0; i < imageFiles.count; i++) {
        CGFloat myOrigin = i*self.view.frame.size.width;
        
        UIImageView *myImageView = [[UIImageView alloc] initWithFrame:CGRectMake(myOrigin, (self.view.frame.size.height - self.view.frame.size.width) / 2, self.view.frame.size.width, self.view.frame.size.width)];

        myImageView.image = [UIImage imageWithData:[[imageFiles objectAtIndex:i] getData]];
        scrollView.delegate = self;
        [scrollView addSubview:myImageView];
    }
    
    scrollView.contentSize = CGSizeMake(self.view.frame.size.width * imageFiles.count, self.view.frame.size.height);
}


-(BOOL) gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    return YES;
}

// Close modal if user clicks anywhere but the image
-(void)closeModal:(UITapGestureRecognizer *)sender{
    if([sender locationInView:self.view].y < (self.view.frame.size.height - self.view.frame.size.width) / 2 || [sender locationInView:self.view].y > (self.view.frame.size.width + (self.view.frame.size.height - self.view.frame.size.width) / 2)){
            [self dismissViewControllerAnimated: YES completion:nil];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
