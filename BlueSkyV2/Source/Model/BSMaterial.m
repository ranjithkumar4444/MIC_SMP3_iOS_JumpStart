//
//  BSMaterial.m
//  BlueSky
//
//  Created by Jones, Jeffry on 6/14/13.
//  Copyright (c) 2013 SAP MIC. All rights reserved.
//

#import "BSMaterial.h"

static NSMutableDictionary *cache;

@implementation BSMaterial

+ (void) initialize {
    cache = [NSMutableDictionary new];
}

+ (BSMaterial *) findInCache: (NSString *) matID {
    return [cache objectForKey: matID];
}

- (void) addToCache {
    [cache setObject: self
              forKey: self.materialID];
}

@end
