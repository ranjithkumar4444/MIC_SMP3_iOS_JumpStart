//
//  BSCategory.h
//  BlueSky
//
//  Created by Ivan Reyes on 10/3/13.
//  Copyright (c) 2013 SAP MIC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BSCategory : NSObject

@property (nonatomic, strong) NSString *groupID;
@property (nonatomic, strong) NSString *name;

- (UIImage *) iconImage;

@end
