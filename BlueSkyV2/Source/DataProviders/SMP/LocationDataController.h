//
//  BSSMPMaterialGroupDataController.h
//  BlueSky
//
//  Created by Jones, Jeffry on 7/11/13.
//  Copyright (c) 2013 SAP MIC. All rights reserved.
//

#import "ODataController.h"

@interface LocationDataController : ODataController

//Implementation Specific Functions
- (void)getOData:(NSDictionary *)params onCompletion: (BSDataResponseBlock) responseBlock onError: (BSErrorResponseBlock) errorBlock;

@end
