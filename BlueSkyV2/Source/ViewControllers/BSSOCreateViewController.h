//
//  BSMapViewController.h
//  BlueSky
//
//  Created by Jones, Jeffry on 7/10/13.
//  Copyright (c) 2013 SAP MIC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BSBaseVC.h"

@class BSMaterial;

@interface BSSOCreateViewController : BSBaseVC

@property (nonatomic, strong) BSMaterial *material;

@property (nonatomic, retain) IBOutlet UITextField *txtCustomerID, *txtSalesOrg, *txtDistChannel, *txtDivision, *txtItem, *txtMaterial, *txtPlant, *txtQuantity, *txtValue;

@end
