//
//  ViewController.m
//  QuickSpace
//
//  Created by Jordan on 1/22/15.
//  Copyright (c) 2015 Jordan. All rights reserved.
//

#import "ViewController.h"
#import <Parse/Parse.h>
#import "ListingDetailViewController.h"

@interface ViewController ()

@end

@implementation ViewController

NSArray *listings;
NSArray *images;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    listings = [NSArray arrayWithObjects:@"Genes room", @"Tonys room", @"Jordans room", nil];
    images = [NSArray arrayWithObjects:@"room1.jpg", @"room2.jpg", @"room3.jpg", nil];
    
    
    // Just a quick test to make sure that parse is working
    PFObject *testObject = [PFObject objectWithClassName:@"TestObject"];
    testObject[@"foo"] = @"bar";
    [testObject saveInBackground];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [listings count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"ListingCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    UIImageView *image = (UIImageView *)[cell viewWithTag:1];
    image.image = [UIImage imageNamed:[images objectAtIndex:indexPath.row]];
    
    UILabel *title = (UILabel *)[cell viewWithTag:2];
    title.text = [listings objectAtIndex:indexPath.row];
//    cell.textLabel.text = [listings objectAtIndex:indexPath.row];
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryCheckmark;
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"ShowListingDetail"]){
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        ListingDetailViewController *destViewController = segue.destinationViewController;
        destViewController.titleName = [listings objectAtIndex:indexPath.row];
        destViewController.imageName = [images objectAtIndex:indexPath.row];
    }
}
@end
