//
//  BSSMPMaterialGroupDataController.h
//  BlueSky
//
//  Created by Jones, Jeffry on 7/11/13.
//  Copyright (c) 2013 SAP MIC. All rights reserved.
//

#import "ODataDataController.h"

@interface PLANTDataController : ODataDataController

//Implementation Specific Functions
- (void)getODataCompleted:(id <Requesting>)request;
- (void)getOData:(NSDictionary *)params andDidFinishSelector:(SEL)aFinishSelector;

@end
