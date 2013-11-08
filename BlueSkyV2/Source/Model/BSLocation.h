//
//  BSLocation.h
//  BlueSky
//
//  Created by Jones, Jeffry on 6/14/13.
//  Copyright (c) 2013 SAP MIC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "BSMaterial.h"
#import "BSATPRecord.h"

@interface BSLocation : NSObject

@property (nonatomic, strong) NSString      *locationID;
@property (nonatomic, strong) NSString      *name;
@property (nonatomic, strong) NSString      *address;
@property (nonatomic, strong) NSString      *city;
@property (nonatomic, strong) NSString      *state;
@property (nonatomic, strong) NSString      *postalcode;
@property (nonatomic, strong) NSString      *country;

@property (nonatomic) CLLocationCoordinate2D latlon;

@property (nonatomic) int      quantity;
@property (nonatomic, strong) BSMaterial *material;
@property (nonatomic, strong) BSATPRecord *atpRecord;

- (void) addToCache;

+ (BSLocation *) findInCache: (NSString *) locID;

@end
