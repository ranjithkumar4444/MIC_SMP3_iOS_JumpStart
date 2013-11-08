//
//  BSProduct.h
//  BlueSky
//
//  Created by Ivan Reyes on 10/3/13.
//  Copyright (c) 2013 SAP MIC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BSProduct : NSObject

@property (nonatomic, strong) NSString *materialID;
@property (nonatomic, strong) NSString *productName;
@property (nonatomic, strong) NSString *groupID;

- (void) addToCache;

+ (BSProduct *) findInCache: (NSString *) matID;


@end
