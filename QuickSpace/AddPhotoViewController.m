//
//  AddPhotoViewController.m
//  QuickSpace
//
//  Created by Tony Wang on 2/3/15.
//  Copyright (c) 2015 Jordan. All rights reserved.
//

#import "AddPhotoViewController.h"
#import "ConfirmationViewController.h"

@interface AddPhotoViewController ()

@property NSMutableArray *allPhotos;

@end

@implementation AddPhotoViewController

@synthesize takePhotoButton;
@synthesize selectPhotoButton;
@synthesize listing;

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
    self.allPhotos = [[NSMutableArray alloc] init];
    self.imageView.image = [UIImage imageNamed:@"no-image4.jpg"];
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        UIAlertView *noCameraAlert = [[UIAlertView alloc] initWithTitle:@"Error"
            message:@"Unsupported feature. Device has no camera"
            delegate:nil
            cancelButtonTitle:@"OK"
            otherButtonTitles: nil];
        [noCameraAlert show];
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// Allow the user to take a new photo
- (IBAction)takePhoto:(UIButton *)sender {
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = YES;
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    
        [self presentViewController:picker animated:YES completion:NULL];
    }
}
// Add a image from the photo library
- (IBAction)selectButton:(UIButton *)sender {
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = YES;
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
        [self presentViewController:picker animated:YES completion:NULL];
    }
}

// Add new photo to the collection
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    self.imageView.image = chosenImage;
    
    NSData *currImage = UIImagePNGRepresentation(chosenImage);
    PFFile *imageFile = [PFFile fileWithName:@"listingImage.png" data:currImage];
   
    [self.allPhotos addObject:imageFile];
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([self.allPhotos count] == 0){
        NSData *currImage = UIImagePNGRepresentation([UIImage imageNamed:@"no-image4.jpg"]);
        PFFile *imageFile = [PFFile fileWithName:@"listingImage.png" data:currImage];
        [self.allPhotos addObject:imageFile];
    }
    if ([segue.identifier isEqualToString:@"ShowAddBookingConfirmation"]){
        ConfirmationViewController *destViewController = segue.destinationViewController;
        destViewController.theImage = self.imageView.image;
        listing.images = self.allPhotos;
        destViewController.listing = listing;
    }
}

@end
