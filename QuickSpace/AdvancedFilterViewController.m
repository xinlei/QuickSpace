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
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSMutableArray *amenityType = [[NSMutableArray alloc] init];
    if(self.wifiSwitch.on)[amenityType addObject:[NSNumber numberWithInt:wifi]];
    if(self.refrigeratorSwitch.on)[amenityType addObject:[NSNumber numberWithInt:refrigerator]];
    if(self.studySwitch.on)[amenityType addObject:[NSNumber numberWithInt:studyDesk]];
    if(self.computerSwitch.on)[amenityType addObject:[NSNumber numberWithInt:monitor]];
    if(self.janitorSwitch.on)[amenityType addObject:[NSNumber numberWithInt:services]];
    
    [defaults setObject:amenityType forKey:@"amenityType"];
    [defaults setInteger:(int)self.priceSlider.value forKey:@"maxPrice"];
}


@end
