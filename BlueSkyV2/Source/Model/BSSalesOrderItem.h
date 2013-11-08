//
//  BSSalesOrderItem.h
//  BlueSkyV2
//
//  Created by Reyes, Ivan on 10/3/13.
//  Copyright (c) 2013 SAP MIC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BSSalesOrderItem : NSObject

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *updated;
@property (nonatomic, strong) NSString *orderId;
@property (nonatomic, strong) NSString *item;
@property (nonatomic, strong) NSString *material;
@property (nonatomic, strong) NSString *description;
@property (nonatomic, strong) NSString *plant;
@property (nonatomic, strong) NSString *quantity;
@property (nonatomic, strong) NSString *uoM;
@property (nonatomic, strong) NSString *value;
@property (nonatomic, strong) NSString *itemDlvyStaTx;
@property (nonatomic, strong) NSString *itemDlvyStatus;
@property (nonatomic, strong) NSString *requestedDate;

@end
