//
//  BSProduct.m
//  BlueSky
//
//  Created by Ivan Reyes on 10/3/13.
//  Copyright (c) 2013 SAP MIC. All rights reserved.
//

#import "BSProduct.h"

static NSMutableDictionary *cache;

@implementation BSProduct

@synthesize materialID;
@synthesize groupID;
@synthesize productName;


+ (void) initialize {
    cache = [NSMutableDictionary new];
}

+ (BSProduct *) findInCache: (NSString *) matID {
    return [cache objectForKey: matID];
}

- (void) addToCache {
    [cache setObject: self
              forKey: self.materialID];
}

@end
