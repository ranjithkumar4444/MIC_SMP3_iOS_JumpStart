//
//  BSATPRecord.h
//  BlueSky
//
//  Created by Jones, Jeffry on 6/14/13.
//  Copyright (c) 2013 SAP MIC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BSATPRecord : NSObject

@property (nonatomic, strong) NSString *materialID;
@property (nonatomic, strong) NSString *locationID;
@property (nonatomic, strong) NSString *units;
@property (nonatomic, strong) NSString *plant;
@property (nonatomic, assign) CGFloat   quantity;

@end
