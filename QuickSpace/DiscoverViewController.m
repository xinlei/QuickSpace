//
//  DiscoverViewController.m
//  QuickSpace
//
//  Created by Tony Wang on 1/25/15.
//  Copyright (c) 2015 Jordan. All rights reserved.
//

#import "DiscoverViewController.h"

@interface DiscoverViewController ()

@end

@implementation DiscoverViewController

NSArray *popularPlaces;
NSArray *popularPlacesImg;

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
    
    popularPlaces = [NSArray arrayWithObjects:@"Stanford", @"San Francisco", nil];
    popularPlacesImg = [NSArray arrayWithObjects:@"san_fran.jpg", @"stanford.jpg", nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [popularPlaces count];
}

- (UITableViewCell *)tableView:(UITableView *) tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *simpleTableIdentifier = @"popularPlaces";
    
    UITableViewCell *viewCell = [tableView dequeueReusableCellWithIdentifier: simpleTableIdentifier];
    
    if(viewCell == nil) {
        viewCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier: simpleTableIdentifier];
    }
    
    NSString *imgName = [popularPlacesImg objectAtIndex:indexPath.row];
    UIImageView *img = (UIImageView *)[viewCell viewWithTag:1];
    img.image = [UIImage imageNamed:imgName];
    
    return viewCell;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
