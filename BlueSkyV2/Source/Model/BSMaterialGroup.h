//
//  BSMaterialGroup.h
//  BlueSky
//
//  Created by Jones, Jeffry on 6/14/13.
//  Copyright (c) 2013 SAP MIC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BSMaterialGroup : NSObject

@property (nonatomic, strong) NSString *groupID;
@property (nonatomic, strong) NSString *name;

- (UIImage *) iconImage;

@end
