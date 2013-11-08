//
//  BSUtils.h
//  BlueSky
//
//  Created by Ivan Reyes on 10/3/13.
//  Copyright (c) 2013 SAP MIC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BSUtils : NSObject

+ (UIColor *) colorForIndex: (NSUInteger) index;

+ (UIImage *) iconForGroup: (NSString *) groupID;

+ (UIImage *) imageForMaterial: (NSString *) matID;

+(void)addCellShadow:(UICollectionViewCell *)cell;

@end
