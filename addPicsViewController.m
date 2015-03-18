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

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    allPhotos = [[NSMutableArray alloc] initWithArray:listing.images];
    NSLog(@"Count: %d", allPhotos.count);
//    [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
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
    NSLog(@"Final Count: %d", listing.images.count);
    [listing saveInBackgroundWithBlock:^(BOOL success, NSError *error){
        if(success)
            [self.navigationController popViewControllerAnimated:YES];
        else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"There was an error saving" message:@"Go Back" delegate:self cancelButtonTitle:@"Back" otherButtonTitles: nil];
            [alert show];
        }
    }];

}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    // After closing alert go back to previous view
    if (buttonIndex == 0)
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
