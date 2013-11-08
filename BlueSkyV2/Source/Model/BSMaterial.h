//
//  BSMaterial.h
//  BlueSky
//
//  Created by Jones, Jeffry on 6/14/13.
//  Copyright (c) 2013 SAP MIC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BSMaterial : NSObject

@property (nonatomic, strong) NSString *materialID;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *groupID;

- (void) addToCache;

+ (BSMaterial *) findInCache: (NSString *) matID;


@end
