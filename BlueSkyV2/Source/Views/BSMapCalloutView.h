//
//  BSMapCalloutView.h
//  BlueSky
//
//  Created by Ivan Reyes on 10/3/13.
//  Copyright (c) 2013 SAP MIC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BSMapCalloutView : UIView <UITextFieldDelegate>

+ (BSMapCalloutView *) calloutView;

@property (nonatomic, weak) IBOutlet UILabel *skuLabel;
@property (nonatomic, weak) IBOutlet UILabel *nameLabel;
@property (nonatomic, weak) IBOutlet UILabel *quantityLabel;
@property (nonatomic, weak) IBOutlet UILabel *addressLabel;
@property (nonatomic, strong) IBOutlet UIButton *orderBtn;
@property (nonatomic, strong) IBOutlet UITextField *txtQuantity;

-(void)setTextFieldDelegate;

@end
