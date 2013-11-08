//
//  BSPlantWithStock.h
//  BlueSkyV2
//
//  Created by Reyes, Ivan on 10/1/13.
//  Copyright (c) 2013 SAP MIC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "BSProduct.h"


@interface BSPlantWithStock : NSObject

@property (nonatomic, strong) NSString *UnitOfMeasure;
@property (nonatomic, strong) NSString *MaterialID;
@property (nonatomic, strong) NSString *Location;
@property (nonatomic, strong) NSString *Name;
@property (nonatomic, strong) NSString *Street;
@property (nonatomic, strong) NSString *PostalCode;
@property (nonatomic, strong) NSString *City;
@property (nonatomic, strong) NSString *CountryKey;
@property (nonatomic, strong) NSString *State;
@property float zLat;
@property float zLng;
@property (nonatomic,strong) NSNumber *Quantity;
@property (nonatomic) CLLocationCoordinate2D latlon;

@property (nonatomic, strong) BSProduct *product;


- (void) addToCache;

+ (BSPlantWithStock *) findInCache: (NSString *) locID;

@end