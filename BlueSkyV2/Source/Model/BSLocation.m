//
//  BSLocation.m
//  BlueSky
//
//  Created by Jones, Jeffry on 6/14/13.
//  Copyright (c) 2013 SAP MIC. All rights reserved.
//

#import "BSLocation.h"

static NSMutableDictionary *cache;

@implementation BSLocation

+ (void) initialize {
    cache = [NSMutableDictionary new];
}

+ (BSLocation *) findInCache: (NSString *) locID {
    return [cache objectForKey: locID];
}

- (void) addToCache {
    [cache setObject: self
              forKey: self.locationID];
}

@end
