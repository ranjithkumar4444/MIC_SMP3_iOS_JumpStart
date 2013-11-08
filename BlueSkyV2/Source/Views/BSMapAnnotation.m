//
//  BSMapAnnotation.m
//  BlueSky
//
//  Created by Ivan Reyes on 10/3/13.
//  Copyright (c) 2013 SAP MIC. All rights reserved.
//

#import "BSMapAnnotation.h"
//#import "BSLocation.h"
#import "BSPlantWithStock.h"


@interface BSMapAnnotation ()

@property (nonatomic, assign, readwrite) CLLocationCoordinate2D  coordinate;
@property (nonatomic, strong, readwrite) BSPlantWithStock *location;

@end

@implementation BSMapAnnotation

@synthesize BSPlantWithStockEntry;


- (id) initWithLocation: (BSPlantWithStock *) location {
    if (self = [super init]) {
        self.location = location;
        self.coordinate = location.latlon;
    }
    return self;
}

- (NSString *) title {
    return [self.location.Name copy];
}


@end
