//
//  FilterViewController.m
//  QuickSpace
//
//  Created by Tony Wang on 1/27/15.
//  Copyright (c) 2015 Jordan. All rights reserved.
//

#import "FilterViewController.h"

@interface FilterViewController (){
    NSMutableArray *spaceType;
}

@end

@implementation FilterViewController

@synthesize spaceType;
@synthesize restButton;
@synthesize closetButton;
@synthesize officeButton;
@synthesize quietButton;

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
    // Do any additional setup after loading the view.
    NSNumber *space = [NSNumber numberWithBool:NO];
    NSNumber *closet = [NSNumber numberWithBool:NO];
    NSNumber *office = [NSNumber numberWithBool:NO];
    NSNumber *quiet = [NSNumber numberWithBool:NO];
    
    spaceType = [NSMutableArray arrayWithObjects:space, closet, office, quiet, nil];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


// Remove the keyboard after typing
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return NO;
}

// On tap send filters to model and update the listings
// Currently no effect on the listings
- (IBAction)sendFilterValues:(UIButton *)sender {
    if (restButton.selected)
        [spaceType replaceObjectAtIndex:0 withObject:[NSNumber numberWithBool:YES]];
    if (closetButton.selected)
        [spaceType replaceObjectAtIndex:1 withObject:[NSNumber numberWithBool:YES]];
    if (officeButton.selected)
        [spaceType replaceObjectAtIndex:2 withObject:[NSNumber numberWithBool:YES]];
    if (quietButton.selected)
        [spaceType replaceObjectAtIndex:3 withObject:[NSNumber numberWithBool:YES]];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

//spacetype buttons
- (IBAction)restSelected:(id)sender {
    UIButton *button = (UIButton *)sender;
    button.selected = !button.selected;
}

- (IBAction)closetSelected:(id)sender {
    UIButton *button = (UIButton *)sender;
    button.selected = !button.selected;
}

- (IBAction)officeSelected:(id)sender {
    UIButton *button = (UIButton *)sender;
    button.selected = !button.selected;
}

- (IBAction)quietSelected:(id)sender {
    UIButton *button = (UIButton *)sender;
    button.selected = !button.selected;
}

//date selection
- (IBAction)selectStart:(id)sender {
}

- (IBAction)selectEnd:(id)sender {
}
@end
