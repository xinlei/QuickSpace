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
#import "deletePicsViewController.h"

@interface editListingViewController ()

@end

@implementation editListingViewController{
    int pageNumber;
}

@synthesize picScrollView;
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
@synthesize listing;
@synthesize priceLabel;
@synthesize priceTextField;

- (void)viewDidLoad {
    [super viewDidLoad];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];
    
//    UITapGestureRecognizer *picTap = [[UITapGestureRecognizer alloc]
//                                      initWithTarget:self
//                                      action:@selector(showPic:)];
//    [picScrollView addGestureRecognizer:picTap];
    
    [self loadPage];
}

-(void) loadPage{
    // Set up side scroll for pictures
    picScrollView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.width);
    picScrollView.pagingEnabled = YES;
    for(int i = 0; i < listing.images.count; i++){
        CGFloat myOrigin = i*self.view.frame.size.width;
        
        UIButton *deleteButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [deleteButton setFrame:CGRectMake(myOrigin + self.view.frame.size.width - 48, 12, 36, 36)];
        [deleteButton setImage:[UIImage imageNamed:@"trash_can.png"] forState:UIControlStateNormal];
        [deleteButton addTarget:self action:@selector(deleteButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        
        UIButton *addButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [addButton setFrame:CGRectMake(myOrigin + 12, 12, 36, 36)];
        [addButton setImage:[UIImage imageNamed:@"add_button.png"] forState:UIControlStateNormal];
        [addButton addTarget:self action:@selector(addButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        
        UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(myOrigin, 0, self.view.frame.size.width, self.view.frame.size.width)];
        image.image = [UIImage imageWithData:[[listing.images objectAtIndex:i] getData]];
        
        picScrollView.delegate = self;
        [picScrollView addSubview:image];
        [picScrollView addSubview:addButton];
        [picScrollView addSubview:deleteButton];
    }
    
    picScrollView.contentSize = CGSizeMake(self.view.frame.size.width * listing.images.count, self.view.frame.size.width);
    
    addressTextField.text = listing.address;
    titleText.text = listing.title;
    priceTextField.text = [@(listing.price) stringValue];
    
    // update the description
    NSString *descripString = listing.information;
    if([descripString length] != 0)
        descriptionTextField.text = descripString;
    
    // update the space type
    if([listing.types containsObject: [NSNumber numberWithInt:rest]])
        restSwitch.on = YES;
    if([listing.types containsObject: [NSNumber numberWithInt:closet]])
        closetSwitch.on = YES;
    if([listing.types containsObject: [NSNumber numberWithInt:office]])
        quietSwitch.on = YES;
    if([listing.types containsObject: [NSNumber numberWithInt:quiet]])
        officeSwitch.on = YES;
    
    // update the amenities
    if([listing.amenities containsObject:[NSNumber numberWithInt:wifi]])
        wifiSwitch.on = YES;
    if([listing.amenities containsObject:[NSNumber numberWithInt:refrigerator]])
        fridgeSwitch.on = YES;
    if([listing.amenities containsObject:[NSNumber numberWithInt:studyDesk]])
        deskSwitch.on = YES;
    if([listing.amenities containsObject:[NSNumber numberWithInt:monitor]])
        monitorSwitch.on = YES;
    if([listing.amenities containsObject:[NSNumber numberWithInt:services]])
        servicesSwitch.on = YES;
    
    //initiate scroll view
    scrollView.frame = self.view.frame;
    scrollView.contentSize = CGSizeMake(self.view.frame.size.width, 1000);
    CGRect viewFrame = scrollView.frame;
    CGFloat mid = viewFrame.size.width/2;
    
    //set image
    CGRect frame = picScrollView.frame;
    
    
    
    //set title
    [ListingDetailViewController setItemLocation:titleLabel withPrev:picScrollView apartBy:10 atX:titleLabel.frame.origin.x];
    frame = titleText.frame;
    frame.size.width = viewFrame.size.width - frame.origin.x - 8;
    titleText.frame = frame;
    [ListingDetailViewController setItemLocation:titleText withPrev:picScrollView apartBy:10 atX:titleText.frame.origin.x];
    
    [ListingDetailViewController setItemLocation:priceLabel withPrev:titleText apartBy:15 atX:priceLabel.frame.origin.x];
    frame = priceTextField.frame;
    frame.size.width = viewFrame.size.width - frame.origin.x - 8;
    priceTextField.frame = frame;
    [ListingDetailViewController setItemLocation:priceTextField withPrev:titleText apartBy:15 atX:priceTextField.frame.origin.x];
    
    
    //set address
    [ListingDetailViewController setItemLocation:addressLabel withPrev:priceTextField apartBy:15 atX:addressLabel.frame.origin.x];
    frame = addressTextField.frame;
    frame.size.width = viewFrame.size.width - frame.origin.x - 8;
    addressTextField.frame = frame;
    [ListingDetailViewController setItemLocation:addressTextField withPrev:priceTextField apartBy:15 atX:addressTextField.frame.origin.x];
    
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
    //CGFloat asdf = mid+1;
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
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:self.view.window];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:self.view.window];

}

//- (void)viewWillAppear:(BOOL)animated {
//    [super viewWillAppear:animated];
//    [listing fetchIfNeeded];
//}

// Keep track of which image is being displayed so that we know which to delete
-(void)scrollViewDidScroll:(UIScrollView *)thisscrollView{
    pageNumber = lround(thisscrollView.contentOffset.x / self.view.frame.size.width);
}

-(BOOL) gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    return YES;
}

//-(void) showPic:(UITapGestureRecognizer *) sender{
//    if([sender locationInView:self.view].y < self.view.frame.size.width){
//        [self performSegueWithIdentifier:@"viewPic" sender:self];
//    }
//}

// Move up view so that keyboard doesn't obscure any textfields
-(void) keyboardWillShow:(NSNotification *)n {
    
    // Get keyboard height from NSNotification
    NSDictionary *userInfo = [n userInfo];
    CGFloat keyboardHeight = [[userInfo objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size.height;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    self.view.frame = CGRectOffset(self.view.frame, 0, -(keyboardHeight - self.tabBarController.tabBar.frame.size.height));
    [UIView commitAnimations];
}

// Move view back into place
-(void) keyboardWillHide:(NSNotification *)n {
    NSDictionary *userInfo = [n userInfo];
    CGFloat keyboardHeight = [[userInfo objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size.height;
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    self.view.frame = CGRectOffset(self.view.frame, 0, keyboardHeight - self.tabBarController.tabBar.frame.size.height);
    [UIView commitAnimations];
}


-(void) addButtonClick:(id) sender{
    [self performSegueWithIdentifier:@"addPics" sender:self];
}

-(void) deleteButtonClick:(id) sender{
    NSMutableArray *set = [[NSMutableArray alloc] initWithArray:listing.images];
    [set removeObjectAtIndex:pageNumber];
    if (set.count == 0){
        NSData *currImage = UIImagePNGRepresentation([UIImage imageNamed:@"no-image4.jpg"]);
        PFFile *imageFile = [PFFile fileWithName:@"listingImage.png" data:currImage];
        [set addObject: imageFile];
    }
    listing.images = set;
    [listing save];
    [self loadPage];
}

- (void) dismissKeyboard {
    [titleText resignFirstResponder];
    [descriptionTextField resignFirstResponder];
    [addressTextField resignFirstResponder];
}

- (IBAction)saveButtonClick:(id)sender {
    listing.price = [priceTextField.text intValue];
    listing.title = titleText.text;
    listing.address = addressTextField.text;
    listing.information = descriptionTextField.text;
    [listing.amenities removeAllObjects];
    [listing.types removeAllObjects];
    
    if(wifiSwitch.on)[listing.amenities addObject:[NSNumber numberWithInt:wifi]];
    if(fridgeSwitch.on)[listing.amenities addObject:[NSNumber numberWithInt:refrigerator]];
    if(deskSwitch.on)[listing.amenities addObject:[NSNumber numberWithInt:studyDesk]];
    if(monitorSwitch.on)[listing.amenities addObject:[NSNumber numberWithInt:monitor]];
    if(servicesSwitch.on)[listing.amenities addObject:[NSNumber numberWithInt:services]];
    
    if (restSwitch.on)[listing.types addObject:[NSNumber numberWithInt:rest]];
    if (closetSwitch.on)[listing.types addObject:[NSNumber numberWithInt:closet]];
    if (officeSwitch.on)[listing.types addObject:[NSNumber numberWithInt:office]];
    if (quietSwitch.on)[listing.types addObject:[NSNumber numberWithInt:quiet]];
    
    // Check to ensure that the price and address are valid
    NSString *error = nil;
    if ([NewListing isValidPrice:priceTextField.text] != nil)
        error = [NewListing isValidPrice:priceTextField.text];
    if([NewListing isValidAddress:addressTextField.text] != nil)
        error = [NewListing isValidAddress:addressTextField.text];
    if (error){
        UIAlertView *notPermitted = [[UIAlertView alloc]
                                 initWithTitle:@"Error"
                                 message:error
                                 delegate:nil
                                 cancelButtonTitle:@"OK"
                                 otherButtonTitles:nil];
        [notPermitted show];
    } else {
        [listing save];
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
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
    [textField resignFirstResponder];
    return YES;
}

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.identifier isEqualToString:@"viewPic"]){
        deletePicsViewController *destViewController = segue.destinationViewController;
        destViewController.pic = [UIImage imageWithData: [[listing.images objectAtIndex:pageNumber] getData]];
        destViewController.listing = listing;
        destViewController.index = pageNumber;
    }
}

@end
