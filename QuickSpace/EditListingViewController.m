//
//  editListingViewController.m
//  QuickSpace
//
//  Created by Jordan on 2/17/15.
//  Copyright (c) 2015 Jordan. All rights reserved.
//

#import "editListingViewController.h"
#import <Parse/Parse.h>
#import "SVProgressHUD.h"
#import "Amenity.h"
#import "Type.h"

@interface editListingViewController ()

@end

@implementation editListingViewController

@synthesize image;
@synthesize titleLabel;
@synthesize titleText;
@synthesize typeLabel;
@synthesize restLabel;
@synthesize closetLabel;
@synthesize quietLabel;
@synthesize officeLabel;
@synthesize officeSwitch;
@synthesize closetSwitch;
@synthesize restSwitch;
@synthesize quietSwitch;
@synthesize addressLabel;
@synthesize addressTextField;
@synthesize amenitiesLabel;
@synthesize wifiLabel;
@synthesize fridgeLabel;
@synthesize deskLabel;
@synthesize servicesLabel;
@synthesize monitorLabel;
@synthesize wifiSwitch;
@synthesize monitorSwitch;
@synthesize servicesSwitch;
@synthesize deskSwitch;
@synthesize fridgeSwitch;
@synthesize descriptionLabel;
@synthesize descriptionTextField;
@synthesize saveButton;
@synthesize scrollView;
@synthesize listing_id;
@synthesize listing;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    image.image = [UIImage imageWithData: [[listing.images firstObject] getData]];
    addressTextField.text = listing.address;
    titleText.text = listing.title;
 
    // update the description
    NSString *descripString = listing.information;
    if([descripString length] != 0)
        descriptionTextField.text = descripString;
    
    // update the space type
    restSwitch.on = [listing.types[rest] boolValue];
    closetSwitch.on = [listing.types[closet] boolValue];
    quietSwitch.on = [listing.types[quiet] boolValue];
    officeSwitch.on = [listing.types[office] boolValue];
    
    // update the amenities
    wifiSwitch.on = [listing.amenities[wifi] boolValue];
    fridgeSwitch.on = [listing.amenities[refrigerator] boolValue];
    monitorSwitch.on = [listing.amenities[monitor] boolValue];
    servicesSwitch.on = [listing.amenities[services] boolValue];
    deskSwitch.on = [listing.amenities[studyDesk] boolValue];
    
    //initiate scroll view
    scrollView.frame = self.view.frame;
    scrollView.contentSize = CGSizeMake(self.view.frame.size.width, 1000);
    CGRect viewFrame = scrollView.frame;
    CGFloat mid = viewFrame.size.width/2;
    
    //set image
    CGRect frame = image.frame;
    frame.origin.y = 0;
//    frame.origin.x = mid - frame.size.width/2;
    image.frame = frame;
    
    //set title
    [ListingDetailViewController setItemLocation:titleLabel withPrev:image apartBy:10 atX:titleLabel.frame.origin.x];
    frame = titleText.frame;
    frame.size.width = viewFrame.size.width - frame.origin.x - 8;
    titleText.frame = frame;
    [ListingDetailViewController setItemLocation:titleText withPrev:image apartBy:10 atX:titleText.frame.origin.x];
    
    //set address
    [ListingDetailViewController setItemLocation:addressLabel withPrev:titleText apartBy:15 atX:addressLabel.frame.origin.x];
    frame = addressTextField.frame;
    frame.size.width = viewFrame.size.width - frame.origin.x - 8;
    addressTextField.frame = frame;
    [ListingDetailViewController setItemLocation:addressTextField withPrev:titleText apartBy:15 atX:addressTextField.frame.origin.x];
    
    //set spacetype
    [ListingDetailViewController setItemLocation:typeLabel withPrev:addressTextField apartBy:15 atX:typeLabel.frame.origin.x];
    //set rest
    [ListingDetailViewController setItemLocation:restLabel withPrev:typeLabel apartBy:5 atX:restLabel.frame.origin.x];
    [editListingViewController centerLeft:restLabel inFrame:viewFrame];
    [ListingDetailViewController setItemLocation:restSwitch withPrev:typeLabel apartBy:5 atX:mid+1];
    //set closet
    [ListingDetailViewController setItemLocation:closetLabel withPrev:restSwitch apartBy:5 atX:closetLabel.frame.origin.x];
    [editListingViewController centerLeft:closetLabel inFrame:viewFrame];
    [ListingDetailViewController setItemLocation:closetSwitch withPrev:restSwitch apartBy:5 atX:mid+1];
    //set quiet
    [ListingDetailViewController setItemLocation:quietLabel withPrev:closetSwitch apartBy:5 atX:quietLabel.frame.origin.x];
    [editListingViewController centerLeft:quietLabel inFrame:viewFrame];
    [ListingDetailViewController setItemLocation:quietSwitch withPrev:closetSwitch apartBy:5 atX:mid+1];
    CGFloat asdf = mid+1;
    //set office
    [ListingDetailViewController setItemLocation:officeLabel withPrev:quietSwitch apartBy:5 atX:officeLabel.frame.origin.x];
    [editListingViewController centerLeft:officeLabel inFrame:viewFrame];
    [ListingDetailViewController setItemLocation:officeSwitch withPrev:quietSwitch apartBy:5 atX:mid+1];
//    [ListingDetailViewController addSeparatorOnto:scrollView at:officeSwitch.frame.origin.y + officeSwitch.frame.size.height + 8];
    
    //set amenities
    [ListingDetailViewController setItemLocation:amenitiesLabel withPrev:officeSwitch apartBy:15 atX:amenitiesLabel.frame.origin.x];
    //wifi
    [ListingDetailViewController setItemLocation:wifiLabel withPrev:amenitiesLabel apartBy:5 atX:wifiLabel.frame.origin.x];
    [editListingViewController centerLeft:wifiLabel inFrame:viewFrame];
    [ListingDetailViewController setItemLocation:wifiSwitch withPrev:amenitiesLabel apartBy:5 atX:mid+1];
    //fridge
    [ListingDetailViewController setItemLocation:fridgeLabel withPrev:wifiSwitch apartBy:5 atX:fridgeLabel.frame.origin.x];
    [editListingViewController centerLeft:fridgeLabel inFrame:viewFrame];
    [ListingDetailViewController setItemLocation:fridgeSwitch withPrev:wifiSwitch apartBy:5 atX:mid+1];
    //desk
    [ListingDetailViewController setItemLocation:deskLabel withPrev:fridgeSwitch apartBy:5 atX:deskLabel.frame.origin.x];
    [editListingViewController centerLeft:deskLabel inFrame:viewFrame];
    [ListingDetailViewController setItemLocation:deskSwitch withPrev:fridgeSwitch apartBy:5 atX:mid+1];
    //janitorial
    [ListingDetailViewController setItemLocation:servicesLabel withPrev:deskSwitch apartBy:5 atX:servicesLabel.frame.origin.x];
    [editListingViewController centerLeft:servicesLabel inFrame:viewFrame];
    [ListingDetailViewController setItemLocation:servicesSwitch withPrev:deskSwitch apartBy:5 atX:mid+1];
    //monitor
    [ListingDetailViewController setItemLocation:monitorLabel withPrev:servicesSwitch apartBy:5 atX:monitorLabel.frame.origin.x];
    [editListingViewController centerLeft:monitorLabel inFrame:viewFrame];
    [ListingDetailViewController setItemLocation:monitorSwitch withPrev:servicesSwitch apartBy:5 atX:mid+1];
    
    //other descriptions
    [ListingDetailViewController setItemLocation:descriptionLabel withPrev:monitorSwitch apartBy:10 atX:descriptionLabel.frame.origin.x];
    [ListingDetailViewController setItemLocation:descriptionTextField withPrev:descriptionLabel apartBy:5 atX:mid - descriptionTextField.frame.size.width/2];
    
    //adjust button width
    frame = saveButton.frame;
    frame.size.width = viewFrame.size.width;
    saveButton.frame = frame;
    
    //if the page is longer than one page, move the book button down
    CGFloat endOfPage = descriptionTextField.frame.origin.y + descriptionTextField.frame.size.height + 10 + saveButton.frame.size.height;
    CGFloat bottomOfView = self.view.frame.size.height - self.navigationController.navigationBar.frame.size.height - self.tabBarController.tabBar.frame.size.height - [UIApplication sharedApplication].statusBarFrame.size.height;
    frame = saveButton.frame;
    if (endOfPage > bottomOfView){
        frame.origin.y = descriptionTextField.frame.origin.y + descriptionTextField.frame.size.height + 10;
        saveButton.frame = frame;
    } else {
        frame.origin.y = bottomOfView - saveButton.frame.size.height;
        saveButton.frame = frame;
    }
    
    //resize scrollview frame
    scrollView.contentSize = CGSizeMake(self.view.frame.size.width, saveButton.frame.size.height + saveButton.frame.origin.y);
}

- (IBAction)saveButtonClick:(id)sender {
    
    listing.title = titleText.text;
    listing.address = addressTextField.text;
    listing.information = descriptionTextField.text;

    
    listing.amenities = [[NSMutableArray alloc]initWithObjects:
                         [NSNumber numberWithBool:wifiSwitch.on],
                         [NSNumber numberWithBool:fridgeSwitch.on],
                         [NSNumber numberWithBool:deskSwitch.on],
                         [NSNumber numberWithBool:monitorSwitch.on],
                         [NSNumber numberWithBool:servicesSwitch.on],nil];

    listing.types = [[NSMutableArray alloc]initWithObjects:
                     [NSNumber numberWithBool:restSwitch.on],
                     [NSNumber numberWithBool:closetSwitch.on],
                     [NSNumber numberWithBool:quietSwitch.on],
                     [NSNumber numberWithBool:officeSwitch.on], nil];
    /*
    NSMutableArray *typeArray = [[NSMutableArray alloc] init];
    if(restSwitch.on) [typeArray addObject: @"Rest"];
    if(closetSwitch.on) [typeArray addObject: @"Closet"];
    if(quietSwitch.on) [typeArray addObject: @"Quiet"];
    if(officeSwitch.on) [typeArray addObject: @"Office"];
    object[@"type"] = typeArray;
    
    NSMutableArray *amenitiesArray = [[NSMutableArray alloc] init];
    if(wifiSwitch.on) [amenitiesArray addObject: @"wifi"];
    if(fridgeSwitch.on) [amenitiesArray addObject: @"refrigerator"];
    if(deskSwitch.on) [amenitiesArray addObject: @"studyDesk"];
    if(monitorSwitch.on) [amenitiesArray addObject: @"monitor"];
    if(servicesSwitch.on) [amenitiesArray addObject: @"services"];
    object[@"amenities"] = amenitiesArray;
        
    NSLog(@"say wha?!?");
    [object save];
    }];
    */
    [listing save];

//        dispatch_async(dispatch_get_main_queue(), ^{
//            [SVProgressHUD dismiss];
//            NSLog(@"Hey");
            [self.navigationController popToRootViewControllerAnimated:YES];
//        });

//    });
    NSLog(@"Ho");
    
}

+ (void) centerLeft:(UIView *)item inFrame:(CGRect)viewFrame
{
    CGRect frame = item.frame;
    frame.origin.x = viewFrame.size.width/2 - item.frame.size.width - 1;
    item.frame = frame;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(BOOL) textFieldShouldReturn:(UITextField *)textField
{
    if(textField == titleText) {
        [addressTextField becomeFirstResponder];
    } else if (textField == addressTextField){
        [descriptionTextField becomeFirstResponder];
    } else
        [textField resignFirstResponder];
    return NO;
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

//    if([segue.identifier isEqualToString:@"submitChangesSegue"]){
//
//    }
}

@end
