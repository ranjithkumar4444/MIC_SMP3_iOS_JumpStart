//
//  BSSalesOrderItemVC.h
//  BlueSkyV2
//
//  Created by Murphy, Damien on 8/26/13.
//  Copyright (c) 2013 SAP MIC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SalesOrderDataController.h"
#import "ODataEntry.h"


@class BSProduct, BSATPRecord;

@interface BSSalesOrderItemVC : UIViewController <UITextFieldDelegate>

@property (nonatomic, strong) SalesOrderDataController *salesOrderDataController;
@property (nonatomic,strong) NSMutableArray *salesOrderList;
@property (nonatomic, strong) ODataEntry *SOEntry;
@property (nonatomic, weak) IBOutlet UILabel *skuLabel;
@property (nonatomic, weak) IBOutlet UILabel *nameLabel;
@property (nonatomic, weak) IBOutlet UILabel *quantityLabel;
@property (nonatomic, weak) IBOutlet UILabel *addressLabel;
@property (nonatomic, strong) IBOutlet UIButton *orderBtn;
@property (nonatomic, strong) IBOutlet UITextField *txtQuantity;
@property (nonatomic, strong) BSProduct *product;
@property (nonatomic, strong) BSATPRecord *atpRecord;
@property (nonatomic,strong) ODataEntry *productEntry;

@property (nonatomic, strong) UIViewController * realParent;
@property (nonatomic, retain) NSString *username;
@property (nonatomic, retain) NSString *password;
@property (nonatomic,retain) IBOutlet UIActivityIndicatorView *activity;

-(IBAction)orderClicked:(id)sender;
-(IBAction)dismissClicked:(id)sender;

@end
