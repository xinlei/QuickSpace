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

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    image.image = [UIImage imageWithData: [_listing.allImageData firstObject]];
    addressTextField.text = _listing.address;
    
    titleText.text = _listing.title;
    quietSwitch.on = NO;
    restSwitch.on = NO;
    officeSwitch.on = NO;
    closetSwitch.on = NO;
    fridgeSwitch.on = NO;
    deskSwitch.on = NO;
    servicesSwitch.on = NO;
    monitorSwitch.on = NO;
    wifiSwitch.on = NO;
        
        //update the amenities in the listing view
//        _amenitiesLabel.text = _listing.amenities;
    
        //update the description
        NSString *descripString = _listing.description;
        if([descripString length] != 0)
            descriptionTextField.text = descripString;
    
        //update the space type

        NSArray *spaceType = _listing.types;
        for (NSString *listingType in spaceType){
            if([listingType isEqualToString:@"Rest"])
                restSwitch.on = YES;
            else if([listingType isEqualToString:@"Closet"])
                closetSwitch.on = YES;
            else if([listingType isEqualToString:@"Quiet"])
                quietSwitch.on = YES;
            else if([listingType isEqualToString:@"Office"])
                officeSwitch.on = YES;
        }
    
    NSArray *amenities = _listing.amenitiesArray;
    for(NSString *amenity in amenities){
        if([amenity isEqualToString:@"wifi"])
            wifiSwitch.on = YES;
        else if([amenity isEqualToString:@"refrigerator"])
            fridgeSwitch.on = YES;
        else if([amenity isEqualToString:@"monitor"])
            monitorSwitch.on = YES;
        else if([amenity isEqualToString:@"services"])
            servicesSwitch.on = YES;
        else if([amenity isEqualToString:@"studyDesk"])
            deskSwitch.on = YES;
    }
    
    //initiate scroll view
    scrollView.frame = self.view.frame;
    scrollView.contentSize = CGSizeMake(self.view.frame.size.width, 1000);
    CGRect viewFrame = scrollView.frame;
    
    //set title
    [ListingDetailViewController setItemLocation:titleLabel withPrev:image apartBy:10];
    [ListingDetailViewController setItemLocation:titleText withPrev:image apartBy:10];
    
    //set address
    [ListingDetailViewController setItemLocation:addressLabel withPrev:titleText apartBy:15];
    [ListingDetailViewController setItemLocation:addressTextField withPrev:titleText apartBy:15];
    
    //set spacetype
    [ListingDetailViewController setItemLocation:typeLabel withPrev:addressTextField apartBy:15];
    //set rest
    [ListingDetailViewController setItemLocation:restLabel withPrev:typeLabel apartBy:5];
    [editListingViewController centerLeft:restLabel inFrame:viewFrame];
    [ListingDetailViewController setItemLocation:restSwitch withPrev:typeLabel apartBy:5];
    [editListingViewController centerRight:restSwitch inFrame:viewFrame];
    //set closet
    [ListingDetailViewController setItemLocation:closetLabel withPrev:restSwitch apartBy:5];
    [editListingViewController centerLeft:closetLabel inFrame:viewFrame];
    [ListingDetailViewController setItemLocation:closetSwitch withPrev:restSwitch apartBy:5];
    [editListingViewController centerRight:closetSwitch inFrame:viewFrame];
    //set quiet
    [ListingDetailViewController setItemLocation:quietLabel withPrev:closetSwitch apartBy:5];
    [editListingViewController centerLeft:quietLabel inFrame:viewFrame];
    [ListingDetailViewController setItemLocation:quietSwitch withPrev:closetSwitch apartBy:5];
    [editListingViewController centerRight:quietSwitch inFrame:viewFrame];
    //set office
    [ListingDetailViewController setItemLocation:officeLabel withPrev:quietSwitch apartBy:5];
    [editListingViewController centerLeft:officeLabel inFrame:viewFrame];
    [ListingDetailViewController setItemLocation:officeSwitch withPrev:quietSwitch apartBy:5];
    [editListingViewController centerRight:officeSwitch inFrame:viewFrame];
//    [ListingDetailViewController addSeparatorOnto:scrollView at:officeSwitch.frame.origin.y + officeSwitch.frame.size.height + 8];
    
    //set amenities
    [ListingDetailViewController setItemLocation:amenitiesLabel withPrev:officeSwitch apartBy:15];
    //wifi
    [ListingDetailViewController setItemLocation:wifiLabel withPrev:amenitiesLabel apartBy:5];
    [editListingViewController centerLeft:wifiLabel inFrame:viewFrame];
    [ListingDetailViewController setItemLocation:wifiSwitch withPrev:amenitiesLabel apartBy:5];
    [editListingViewController centerRight:wifiSwitch inFrame:viewFrame];
    //fridge
    [ListingDetailViewController setItemLocation:fridgeLabel withPrev:wifiSwitch apartBy:5];
    [editListingViewController centerLeft:fridgeLabel inFrame:viewFrame];
    [ListingDetailViewController setItemLocation:fridgeSwitch withPrev:wifiSwitch apartBy:5];
    [editListingViewController centerRight:fridgeSwitch inFrame:viewFrame];
    //desk
    [ListingDetailViewController setItemLocation:deskLabel withPrev:fridgeSwitch apartBy:5];
    [editListingViewController centerLeft:deskLabel inFrame:viewFrame];
    [ListingDetailViewController setItemLocation:deskSwitch withPrev:fridgeSwitch apartBy:5];
    [editListingViewController centerRight:deskSwitch inFrame:viewFrame];
    //janitorial
    [ListingDetailViewController setItemLocation:servicesLabel withPrev:deskSwitch apartBy:5];
    [editListingViewController centerLeft:servicesLabel inFrame:viewFrame];
    [ListingDetailViewController setItemLocation:servicesSwitch withPrev:deskSwitch apartBy:5];
    [editListingViewController centerRight:servicesSwitch inFrame:viewFrame];
    //monitor
    [ListingDetailViewController setItemLocation:monitorLabel withPrev:servicesSwitch apartBy:5];
    [editListingViewController centerLeft:monitorLabel inFrame:viewFrame];
    [ListingDetailViewController setItemLocation:monitorSwitch withPrev:servicesSwitch apartBy:5];
    [editListingViewController centerRight:monitorSwitch inFrame:viewFrame];
    
    //other descriptions
    [ListingDetailViewController setItemLocation:descriptionLabel withPrev:monitorSwitch apartBy:10];
    [ListingDetailViewController setItemLocation:descriptionTextField withPrev:descriptionLabel apartBy:5];
    
    //if the page is longer than one page, move the book button down
    CGFloat endOfPage = descriptionTextField.frame.origin.y + descriptionTextField.frame.size.height + 10 + saveButton.frame.size.height;
    CGFloat bottomOfView = self.view.frame.size.height - self.navigationController.navigationBar.frame.size.height - self.tabBarController.tabBar.frame.size.height - [UIApplication sharedApplication].statusBarFrame.size.height;
    CGRect frame = saveButton.frame;
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
    [SVProgressHUD show];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{

        PFQuery *query = [PFQuery queryWithClassName:@"Listing"];
        PFObject *object = [query getObjectWithId:_listing.object_id];
//        [query getObjectInBackgroundWithId:_listing.object_id block:^(PFObject *object, NSError *error){
            object[@"title"] = titleText.text;
            object[@"address"] = addressTextField.text;
            object[@"description"] = descriptionTextField.text;
        
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
//        }];
        

        dispatch_async(dispatch_get_main_queue(), ^{
            [SVProgressHUD dismiss];
            NSLog(@"Hey");
            [self.navigationController popToRootViewControllerAnimated:YES];
        });

    });
    NSLog(@"Ho");
    
}

+ (void) centerLeft:(UIView *)item inFrame:(CGRect)viewFrame
{
    CGRect frame = item.frame;
    frame.origin.x = viewFrame.size.width/2 - item.frame.size.width - 1;
    item.frame = frame;
}

+ (void) centerRight:(UIView *)item inFrame:(CGRect)viewFrame
{
    CGRect frame = item.frame;
    frame.origin.x = viewFrame.size.width/2 + 1;
    item.frame = frame;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//
//- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
//{
//    _locationLabel.text = _locationTextField.text;
//    return YES;
//}

-(BOOL) textFieldShouldReturn:(UITextField *)textField
{
    if(textField == titleText) {
      [textField resignFirstResponder];
    } else if (textField == addressTextField){
        [textField resignFirstResponder];
    } else if (textField == descriptionTextField)
        [textField resignFirstResponder];
    return NO;
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

//    if([segue.identifier isEqualToString:@"submitChangesSegue"]){
//
//    }
}

@end
