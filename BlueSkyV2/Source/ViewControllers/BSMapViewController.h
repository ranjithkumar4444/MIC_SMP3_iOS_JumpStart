//
//  BSMapViewController.h
//  BlueSky
//
//  Created by Jones, Jeffry on 7/10/13.
//  Copyright (c) 2013 SAP MIC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "BSBaseViewController.h"

@class BSMaterial, BSATPRecord, BSMapCalloutView;

@interface BSMapViewController : BSBaseViewController <MKMapViewDelegate>
{
    BSMapCalloutView * calloutView;
    int available;
}
@property (nonatomic, strong) BSMaterial *material;
@property (nonatomic, strong) BSATPRecord *atpRecord;
@property (nonatomic, weak) IBOutlet UILabel          *subtitleLabel;
@property (nonatomic, weak) IBOutlet MKMapView *mapView;
@property (nonatomic, strong) IBOutlet UIView          *loadingView;
-(IBAction)orderClicked:(id)sender;
-(IBAction)gridViewClicked:(id)sender;
-(void)reload;
@end
