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



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end