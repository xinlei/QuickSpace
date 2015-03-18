//
//  addPicsViewController.m
//  QuickSpace
//
//  Created by Jordan on 3/18/15.
//  Copyright (c) 2015 Jordan. All rights reserved.
//

#import "addPicsViewController.h"

@interface addPicsViewController ()

@end

@implementation addPicsViewController{
    NSMutableArray *allPhotos;
}

@synthesize takePhotoButton;
@synthesize submitButton;
@synthesize listing;

- (void)viewDidLoad {
    [super viewDidLoad];
    allPhotos = [[NSMutableArray alloc] initWithArray:listing.images];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (IBAction)takePhotoClicked:(id)sender {
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = YES;
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:picker animated:YES completion:NULL];
    }
}
- (IBAction)submitClicked:(id)sender {
    listing.images = allPhotos;
    [listing save];
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)selectPhotoClicked:(id)sender {
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = YES;
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:picker animated:YES completion:NULL];
    }
}

// Add new photo to the collection. Change button text to reflect that a photo has been added
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    self.imageView.image = chosenImage;
    NSData *currImage = UIImagePNGRepresentation(chosenImage);
    PFFile *imageFile = [PFFile fileWithName:@"listingImage.png" data:currImage];
    [allPhotos addObject:imageFile];
    [takePhotoButton setTitle:@"Take Another Photo" forState:UIControlStateNormal];
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}
@end
