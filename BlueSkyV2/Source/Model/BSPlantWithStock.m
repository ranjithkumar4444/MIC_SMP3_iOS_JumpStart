//
//  BSPlantWithStock.m
//  BlueSkyV2
//
//  Created by Reyes, Ivan on 10/1/13.
//  Copyright (c) 2013 SAP MIC. All rights reserved.
//

#import "BSPlantWithStock.h"

static NSMutableDictionary *cache;

@implementation BSPlantWithStock

+ (void) initialize {
    cache = [NSMutableDictionary new];
}

+ (BSPlantWithStock *) findInCache: (NSString *) locID {
    return [cache objectForKey: locID];
}

- (void) addToCache {
    [cache setObject: self
              forKey: self.Location];
}


@end
