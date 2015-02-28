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
@synthesize startPicker;
@synthesize endPicker;

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
    
    CGRect frame = startPicker.frame;
    frame.size.height = 83;
    frame.size.height = 239;
    [startPicker setFrame:frame];
    [endPicker setFrame:frame];
    
    
    CGFloat viewX = self.timePickerContainer.frame.size.width;
    CGFloat viewY = self.timePickerContainer.frame.size.height;
    NSLog(@"%f %f", viewX, viewY);
    
    //    UIDatePicker *datePicker = [[UIDatePicker alloc] init];
    //    datePicker.frame = CGRectMake(0, 0, viewX, viewY/2);
    //    datePicker.transform = CGAffineTransformMakeScale(.7, 0.7);
    //    [self.asdf addSubview:datePicker];
    
    startPicker.frame = CGRectMake(0, 0, viewX, viewY/2);
    startPicker.transform = CGAffineTransformMakeScale(.7, .7);
    
    endPicker.frame = CGRectMake(0, viewY/2, viewX, viewY/2);
    endPicker.transform = CGAffineTransformMakeScale(.7, .7);
    
    endPicker.minimumDate = startPicker.date; 
}
- (IBAction)limitEndTime:(UIDatePicker *)sender {
    endPicker.minimumDate = startPicker.date;
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

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"ShowAvailableListings"]) {
        ViewController *destViewController = segue.destinationViewController;
        
        // Set space types
        [spaceType replaceObjectAtIndex:0 withObject:[NSNumber numberWithBool:restButton.selected]];
        [spaceType replaceObjectAtIndex:1 withObject:[NSNumber numberWithBool:closetButton.selected]];
        [spaceType replaceObjectAtIndex:2 withObject:[NSNumber numberWithBool:officeButton.selected]];
        [spaceType replaceObjectAtIndex:3 withObject:[NSNumber numberWithBool:quietButton.selected]];
        destViewController.spaceType = spaceType;
        
        // Set start and end time
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:startPicker.date forKey:@"startTime"];
        [defaults setObject:endPicker.date forKey:@"endTime"];
    }
}

// spacetype buttons
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
@end
