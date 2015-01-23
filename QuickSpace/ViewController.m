//
//  ViewController.m
//  QuickSpace
//
//  Created by Jordan on 1/22/15.
//  Copyright (c) 2015 Jordan. All rights reserved.
//

#import "ViewController.h"
#import <Parse/Parse.h>

@interface ViewController ()

@end

@implementation ViewController

NSArray * listings;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    listings = [NSArray arrayWithObjects:@"Gene's Room", @"Tony's Room", "Jordan's Room", nil];
    
    
    
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
    UILabel * title = (UILabel *)[cell viewWithTag:1];
    title.text = [listings objectAtIndex:indexPath.row];
//    cell.textLabel.text = [listings objectAtIndex:indexPath.row];
    return cell;
}

@end
