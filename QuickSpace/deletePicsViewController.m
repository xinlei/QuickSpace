//
//  deletePicsViewController.m
//  QuickSpace
//
//  Created by Tony Wang on 3/18/15.
//  Copyright (c) 2015 Jordan. All rights reserved.
//

#import "deletePicsViewController.h"

@interface deletePicsViewController ()

@end

@implementation deletePicsViewController
@synthesize listing;
@synthesize index;
@synthesize pic;
@synthesize deleteButton;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Add image
    UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(0, (self.view.frame.size.height - self.view.frame.size.width) / 3, self.view.frame.size.width, self.view.frame.size.width)];
    image.image = pic;
    
    // Arbitrarily determined constants that are just large enough to hold the text within the button
    int width = 100;
    int height = 50;
    
    // Place button in middle horizontally and just below the image.
    [deleteButton setFrame:CGRectMake((self.view.frame.size.width - width) / 2, (self.view.frame.size.width + (self.view.frame.size.height - self.view.frame.size.width) / 3) + height / 2, width, height)];
    [self.view addSubview:image];
    

    UITapGestureRecognizer *close = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeModal:)];
    [close setDelegate:self];
    [self.view addGestureRecognizer:close];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(BOOL) gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    return YES;
}

// Go back if user clicks anywhere but photo or delete button
-(void)closeModal:(UITapGestureRecognizer *)sender{
    if([sender locationInView:self.view].y < (self.view.frame.size.height - self.view.frame.size.width) / 2 || [sender locationInView:self.view].y > (self.view.frame.size.width + (self.view.frame.size.height - self.view.frame.size.width) / 3)){
        [self dismissViewControllerAnimated: YES completion:nil];
    }
}


// Delete photo and go back to edit page
- (IBAction)deletePic:(id)sender {
    NSMutableArray *set = [[NSMutableArray alloc] initWithArray:listing.images];
    [set removeObjectAtIndex:index];
    if (set.count == 0){
        NSData *currImage = UIImagePNGRepresentation([UIImage imageNamed:@"no-image4.jpg"]);
        PFFile *imageFile = [PFFile fileWithName:@"listingImage.png" data:currImage];
        [set addObject: imageFile];
    }
    listing.images = set;
    [listing saveInBackground];
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
