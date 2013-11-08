//
//  PWSDataController.h
//  Flights
//
//  Created by Damien Murphy
//  Copyright (c) 2013 MIC. All rights reserved.
//

#import "ODataController.h"

@interface PWSDataController : ODataController

//Implementation Specific Functions
- (void)getOData:(NSDictionary *)params onCompletion: (BSDataResponseBlock) responseBlock onError: (BSErrorResponseBlock) errorBlock;

@end
