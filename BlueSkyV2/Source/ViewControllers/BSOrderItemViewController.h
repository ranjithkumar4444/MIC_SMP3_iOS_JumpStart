//
//  BSOrderItemController.h
//  BlueSkyV2
//
//  Created by Murphy, Damien on 8/26/13.
//  Copyright (c) 2013 SAP MIC. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BSMaterial, BSATPRecord;

@interface BSOrderItemViewController : UIViewController <UITextFieldDelegate>

@property (nonatomic, weak) IBOutlet UILabel *skuLabel;
@property (nonatomic, weak) IBOutlet UILabel *nameLabel;
@property (nonatomic, weak) IBOutlet UILabel *quantityLabel;
@property (nonatomic, weak) IBOutlet UILabel *addressLabel;
@property (nonatomic, strong) IBOutlet UIButton *orderBtn;
@property (nonatomic, strong) IBOutlet UITextField *txtQuantity;
@property (nonatomic, strong) BSMaterial *material;
@property (nonatomic, strong) BSATPRecord *atpRecord;
@property (nonatomic, strong) UIViewController * realParent;

-(IBAction)orderClicked:(id)sender;
-(IBAction)dismissClicked:(id)sender;

@end
