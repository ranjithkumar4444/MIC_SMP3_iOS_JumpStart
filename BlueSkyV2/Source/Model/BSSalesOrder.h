//
//  BSSalesOrder.h
//  BlueSkyV2
//
//  Created by Murphy, Damien on 8/9/13.
//  Copyright (c) 2013 SAP MIC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BSSalesOrder : NSObject

@property (nonatomic, strong) NSString *salesOrderId;
@property (nonatomic, strong) NSString *documentType;
@property (nonatomic, strong) NSString *documentDate;
@property (nonatomic, strong) NSString *customerId;
@property (nonatomic, strong) NSString *salesOrg;
@property (nonatomic, strong) NSString *distChannel;
@property (nonatomic, strong) NSString *division;
@property (nonatomic, strong) NSString *orderValue;
@property (nonatomic, strong) NSString *currency;

//Array of BSSalesOrder
@property (nonatomic, strong) NSArray *soItems;

@end