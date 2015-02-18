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

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    _titleLabel.text = _listing.title;
    _image.image = [UIImage imageWithData: _listing.imageData];
    _locationLabel.text = _listing.address;
    
    _titleText.text = _listing.title;
        
        //update the amenities in the listing view
        _amenitiesLabel.text = _listing.amenities;
    
        //update the description
        NSString *descripString = _listing.description;
        _descriptionLabel.text = descripString;
    
        //update the space type
        NSMutableString *typeDesc = [[NSMutableString alloc] init];
        NSArray *spaceType = _listing.types;
        for (NSString *listingType in spaceType){
            [typeDesc appendString:@"- "];
            [typeDesc appendString:listingType];
            [typeDesc appendString:@" "];
        }
        
        [typeDesc appendString:@"-"];
//        _typeLabel.text = typeDesc;
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    _locationLabel.text = _locationTextField.text;
    return YES;
}

-(BOOL) textFieldShouldReturn:(UITextField *)textField
{
    if(textField == _titleText) {
      [textField resignFirstResponder];
    } else if (textField == _locationTextField){
        [textField resignFirstResponder];
    }
    return NO;
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    PFQuery *query = [PFQuery queryWithClassName:@"Listing"];
    [query getObjectInBackgroundWithId:_listing.object_id block:^(PFObject *object, NSError *error){
        object[@"title"] = _titleText.text;
        object[@"address"] = _locationLabel.text;
        object[@"description"] = _descriptionLabel.text;
        [object saveInBackground];
    }];
    
}

@end
