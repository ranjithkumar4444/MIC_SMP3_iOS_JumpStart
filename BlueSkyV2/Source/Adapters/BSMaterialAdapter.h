//
//  BSMaterialAdapter.h
//  BlueSky
//
//  Created by Jones, Jeffry on 6/14/13.
//  Copyright (c) 2013 SAP MIC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BSMaterialAdapter : NSObject <UICollectionViewDataSource>

@property (nonatomic, strong) NSArray *materials;
@property (nonatomic, retain) UIColor * color;

@end
