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
#import "Listing.h"

@interface ViewController ()

@end

@implementation ViewController

NSMutableArray *listings;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.



//    
//        Listing *listing1 = [[Listing alloc] init];
//        listing1.title = @"Genes room";
//        listing1.type = @"Resting Space";
//        listing1.location = @"Palo Alto";
//        listing1.imageName = @"room1.jpg";
//    
//        Listing *listing2 = [[Listing alloc] init];
//        listing2.title = @"Tonys room";
//        listing2.type = @"Sex Space";
//        listing2.location = @"Palo Alto";
//        listing2.imageName = @"room2.jpg";
//    
//        Listing *listing3 = [[Listing alloc] init];
//        listing3.title = @"Jordans room";
//        listing3.type = @"Resting Space";
//        listing3.type = @"Mountain View";
//        listing3.imageName = @"room3.jpg";
//    
//        listings = [NSMutableArray arrayWithObjects:listing1, listing2, listing3, nil];
    
    listings = [[NSMutableArray alloc] init];
    
    PFQuery *query = [PFQuery queryWithClassName:@"Listing"];
    [query whereKey:@"title" notEqualTo:@"Dan Stemkoski"];
    NSArray* AllListings = [query findObjects];
    
            // The find succeeded.
            NSLog(@"Successfully retrieved %d listings.", AllListings.count);
            // Do something with the found objects
            for (PFObject *object in AllListings) {
                Listing *lister = [[Listing alloc] init];
                lister.title = object[@"title"];
                lister.type = object[@"type"];
                lister.location = object[@"location"];
                lister.imageName = object[@"imageName"];
                [listings addObject:lister];
            }
//                        Listing* hey = [listings objectAtIndex:1];
//                        NSLog(@"%@", hey.title);
//                        Listing* hey1 = [listings objectAtIndex:0];
//                        NSLog(@"%@", hey1.title);
//                        Listing* hey2 = [listings objectAtIndex:2];
//                        NSLog(@"%@", hey2.title);


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
    
    Listing *thisListing = [listings objectAtIndex:indexPath.row];
    UIImageView *image = (UIImageView *)[cell viewWithTag:1];
    image.image = [UIImage imageNamed:thisListing.imageName];
    
    UILabel *title = (UILabel *)[cell viewWithTag:2];
    title.text = thisListing.title;
    
    UILabel *type = (UILabel *)[cell viewWithTag:3];
    type.text = thisListing.type;
    
    UILabel *location = (UILabel *)[cell viewWithTag:4];
    location.text = thisListing.location;
    
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
        destViewController.listing = [listings objectAtIndex:indexPath.row];
    }
}
@end
