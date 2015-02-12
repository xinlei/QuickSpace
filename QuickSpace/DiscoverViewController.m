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
    
    popularPlaces = [NSArray arrayWithObjects:@"Stanford", @"San Francisco", @"Los Angeles", nil];
    popularPlacesImg = [NSArray arrayWithObjects:@"stanford.png", @"san_francisco.png", @"los_angeles.png", nil];
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
    
    UILabel *title = (UILabel *)[viewCell viewWithTag:2];
    title.text = [popularPlaces objectAtIndex:indexPath.row];
    

    return viewCell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    NSString *city = [popularPlaces objectAtIndex:indexPath.row];
    NSLog(@"City: %@ Row: %lu", city, (long)indexPath.row);
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSNumber *latitude;
    NSNumber *longitude;
    if([city isEqualToString:@"Stanford"]){
        latitude = [NSNumber numberWithDouble:37.4300];
        longitude = [NSNumber numberWithDouble:-122.1700];
    }
    else if([city isEqualToString:@"San Francisco"]){
        latitude = [NSNumber numberWithDouble:37.7833];
        longitude = [NSNumber numberWithDouble:-122.4167];
    }
    else if([city isEqualToString:@"Los Angeles"]){
        latitude = [NSNumber numberWithDouble:34.0500];
        longitude = [NSNumber numberWithDouble:-118.2500];
    }
    [defaults setObject:latitude forKey:@"latitude"];
    [defaults setObject:longitude forKey:@"longitude"];
    [defaults synchronize];
}


@end
