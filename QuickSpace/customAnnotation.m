//
//  customAnnotation.m
//  QuickSpace
//
//  Created by Jordan on 3/18/15.
//  Copyright (c) 2015 Jordan. All rights reserved.
//

#import "customAnnotation.h"

@implementation customAnnotation
-(id)initWithTitle:(NSString *)title Location:(CLLocationCoordinate2D)coordinate{
    self = [super init];
    if(self){
        _title = title;
        _coordinate = coordinate;
    }
    return self;
}

-(MKAnnotationView *)annotationView{
    MKAnnotationView *annotationView = [[MKAnnotationView alloc] initWithAnnotation:self reuseIdentifier:@"customAnnotation"];
    annotationView.enabled = YES;
    annotationView.canShowCallout = YES;
    annotationView.image = [UIImage imageNamed:@"pin.png"];
    annotationView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    return annotationView;
}

-(void) setListing:(NewListing *)listing{
    _listing = listing;
}

-(void) setSubTitle:(NSString *)subtitle{
    _subtitle = subtitle;
}
@end
