//
//  BSCategory.m
//  BlueSky
//
//  Created by Ivan Reyes on 10/3/13.
//  Copyright (c) 2013 SAP MIC. All rights reserved.
//

#import "BSCategory.h"
#import "BSUtils.h"

@implementation BSCategory

- (UIImage *) iconImage {
    return [BSUtils iconForGroup: self.groupID];
}

@end
