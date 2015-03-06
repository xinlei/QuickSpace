//
//  modalPictureViewController.m
//  QuickSpace
//
//  Created by Jordan on 3/5/15.
//  Copyright (c) 2015 Jordan. All rights reserved.
//

#import "modalPictureViewController.h"

@interface modalPictureViewController ()

@end


@implementation modalPictureViewController
@synthesize scrollView;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSArray *imageNames = [[NSArray alloc] initWithObjects:@"room1.jpg", @"room3.jpg", @"room2.jpg", nil];
    
    
//    scrollView.frame = self.view.frame;
//    scrollView.contentSize = CGSizeMake(self.view.frame.size.width + 20, self.view.frame.size.height / 2);
    
    self.view.backgroundColor = [UIColor blackColor];
    scrollView.frame = self.view.frame;
    scrollView.pagingEnabled = YES;
    
    for (int i = 0; i < imageNames.count; i++) {
        CGFloat myOrigin = i*self.view.frame.size.width;
        
        UIImageView *myImageView = [[UIImageView alloc] initWithFrame:CGRectMake(myOrigin, self.view.frame.size.height / 3, self.view.frame.size.width, self.view.frame.size.height / 3)];
        
        myImageView.image = [UIImage imageNamed:[imageNames objectAtIndex:i]];

        scrollView.delegate = self;
        [scrollView addSubview:myImageView];
        
        
    }
    
    scrollView.contentSize = CGSizeMake(self.view.frame.size.width * imageNames.count, self.view.frame.size.height);
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{

}

-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [touches anyObject];
//    if([touch view] != image){
//        NSLog(@"I clicked the black!");
//        [self performSegueWithIdentifier:@"modalPics" sender:self];
//    }
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
