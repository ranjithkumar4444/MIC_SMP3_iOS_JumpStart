//
//  BSMapAnnotation.h
//  BlueSky
//
//  Created by Ivan Reyes on 10/3/13.
//  Copyright (c) 2013 SAP MIC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import "ODataEntry.h"



@class BSPlantWithStock;
//@class BSATPRecord;

@interface BSMapAnnotation : NSObject <MKAnnotation>

@property (nonatomic, strong, readonly)  BSPlantWithStock  *location;
@property (nonatomic,strong) ODataEntry *BSPlantWithStockEntry;

//@property (nonatomic, strong, readwrite) BSATPRecord *atpRecord;

- (id) initWithLocation: (BSPlantWithStock *) location;

@end
