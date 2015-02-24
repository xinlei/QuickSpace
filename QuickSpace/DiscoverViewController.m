//
//  DiscoverViewController.m
//  QuickSpace
//
//  Created by Tony Wang on 1/25/15.
//  Copyright (c) 2015 Jordan. All rights reserved.
//

#import "DiscoverViewController.h"
#import <MapKit/MapKit.h>
#import <AddressBookUI/AddressBookUI.h>

@interface DiscoverViewController ()

@end

@implementation DiscoverViewController {
    NSArray *popularPlaces;
    NSArray *popularPlacesImg;
    NSArray *resultPlaces;
    BOOL didUseSearch;
}

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
    didUseSearch = NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope
{
    CLGeocoder *location = [[CLGeocoder alloc] init];
    [location geocodeAddressString:searchText completionHandler:^(NSArray* placemarks, NSError* error){
        if (placemarks && placemarks.count > 0) {
            resultPlaces = placemarks;
        }
    }];
    [self.tableView reloadData];
}

-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    [self filterContentForSearchText:searchString scope:[[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:[self.searchDisplayController.searchBar selectedScopeButtonIndex]]];
    return YES;
}

- (void)searchDisplayControllerDidEndSearch:(UISearchDisplayController *)controller
{
    didUseSearch = NO;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.searchDisplayController.searchResultsTableView){
        return [resultPlaces count]; 
    } else {
        return [popularPlaces count];
    }
}

- (UITableViewCell *)tableView:(UITableView *) tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *simpleTableIdentifier = @"popularPlaces";
    
    UITableViewCell *viewCell = [tableView dequeueReusableCellWithIdentifier: simpleTableIdentifier];
    
    if (viewCell == nil) {
        viewCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier: simpleTableIdentifier];
    }
    
    UIImageView *img = (UIImageView *)[viewCell viewWithTag:1];
    UILabel *title = (UILabel *)[viewCell viewWithTag:2];
    if (tableView == self.searchDisplayController.searchResultsTableView){
        CLPlacemark *item = [resultPlaces objectAtIndex:indexPath.row];
        NSArray *lines = item.addressDictionary[@"FormattedAddressLines"];
        NSString *addressString = [lines componentsJoinedByString:@", "];
        [viewCell.textLabel setText:addressString];
    } else {
        NSString *imgName = [popularPlacesImg objectAtIndex:indexPath.row];
        img.image = [UIImage imageNamed:imgName];
        title.text = [popularPlaces objectAtIndex:indexPath.row];
    }
    return viewCell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.searchDisplayController.searchResultsTableView){
        didUseSearch = YES;
        [self performSegueWithIdentifier:@"ShowListings" sender:self];
    } else {
        didUseSearch = NO;
    }
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSNumber *latitude;
    NSNumber *longitude;
    
    // Set to the location user queried
    if (didUseSearch){
        CLPlacemark *item = [resultPlaces objectAtIndex:indexPath.row];
        MKPlacemark *placemark = [[MKPlacemark alloc] initWithPlacemark:item];
        latitude = [NSNumber numberWithDouble:placemark.coordinate.latitude];
        longitude = [NSNumber numberWithDouble:placemark.coordinate.longitude];
    } else {
        NSString *city = [popularPlaces objectAtIndex:indexPath.row];
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
    }
    [defaults setObject:latitude forKey:@"latitude"];
    [defaults setObject:longitude forKey:@"longitude"];
    [defaults synchronize];
}


@end
