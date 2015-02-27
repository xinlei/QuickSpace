//
//  editListingViewController.m
//  QuickSpace
//
//  Created by Jordan on 2/17/15.
//  Copyright (c) 2015 Jordan. All rights reserved.
//

#import "editListingViewController.h"
#import <Parse/Parse.h>

@interface editListingViewController ()

@end

@implementation editListingViewController

@synthesize descriptionTextField;
@synthesize addressTextField;
@synthesize officeSwitch;
@synthesize closetSwitch;
@synthesize restSwitch;
@synthesize quietSwitch;
@synthesize wifiSwitch;
@synthesize monitorSwitch;
@synthesize servicesSwitch;
@synthesize deskSwitch;
@synthesize fridgeSwitch;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _image.image = [UIImage imageWithData: [_listing.allImageData firstObject]];
    addressTextField.text = _listing.address;
    
    _titleText.text = _listing.title;
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
    if(textField == _titleText) {
      [textField resignFirstResponder];
    } else if (textField == addressTextField){
        [textField resignFirstResponder];
    } else if (textField == descriptionTextField)
        [textField resignFirstResponder];
    return NO;
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

    if([segue.identifier isEqualToString:@"submitChangesSegue"]){
        PFQuery *query = [PFQuery queryWithClassName:@"Listing"];
        [query getObjectInBackgroundWithId:_listing.object_id block:^(PFObject *object, NSError *error){
            object[@"title"] = _titleText.text;
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

        
            [object saveInBackground];
        }];
    }
}

@end
