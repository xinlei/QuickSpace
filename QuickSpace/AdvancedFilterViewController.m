//
//  AdvancedFilterViewController.m
//  QuickSpace
//
//  Created by Tony Wang on 1/27/15.
//  Copyright (c) 2015 Jordan. All rights reserved.
//

#import "AdvancedFilterViewController.h"

@interface AdvancedFilterViewController ()
@property (weak, nonatomic) IBOutlet UILabel *wifiLabel;
@property (weak, nonatomic) IBOutlet UILabel *refrigeratorLabel;
@property (weak, nonatomic) IBOutlet UILabel *deskLabel;
@property (weak, nonatomic) IBOutlet UILabel *monitorLabel;
@property (weak, nonatomic) IBOutlet UILabel *servicesLabel;

@end

@implementation AdvancedFilterViewController

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)sliderValueChanged:(UISlider *)sender {
    self.priceLabel.text = [NSString stringWithFormat:@"$%d", (int)sender.value];
}

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    /*
    if ([segue.identifier isEqualToString:@"DisplayResults"]) {
        AdvancedFilterViewController *destViewController = segue.destinationViewController;
 
        destViewController.spaceType = self.spaceType;
        destViewController.startDate = self.startDate;
        destViewController.endDate = self.endDate;
    }
    */
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSArray *keys = [NSArray arrayWithObjects:
                     @"wifi",
                     @"refrigerator",
                     @"studyDesk",
                     @"monitor",
                     @"services",
                     nil];
    
    NSArray *objects = [NSArray arrayWithObjects:[NSNumber numberWithBool:self.wifiSwitch.on], [NSNumber numberWithBool:self.refrigeratorSwitch.on], [NSNumber numberWithBool:self.studySwitch.on], [NSNumber numberWithBool:self.computerSwitch.on], [NSNumber numberWithBool:self.janitorSwitch.on], nil];
    NSMutableDictionary *additionalFilters = [NSMutableDictionary dictionaryWithObjects:objects forKeys:keys];
    
    
    [defaults setObject:additionalFilters forKey:@"additionalFilters"];
    [defaults setInteger:(int)self.priceSlider.value forKey:@"maxPrice"];
}


@end
