//
//  BSMaterialGroup.m
//  BlueSky
//
//  Created by Jones, Jeffry on 6/14/13.
//  Copyright (c) 2013 SAP MIC. All rights reserved.
//

#import "BSMaterialGroup.h"
#import "BSUtils.h"

@implementation BSMaterialGroup

- (UIImage *) iconImage {
    return [BSUtils iconForGroup: self.groupID];
}

@end
