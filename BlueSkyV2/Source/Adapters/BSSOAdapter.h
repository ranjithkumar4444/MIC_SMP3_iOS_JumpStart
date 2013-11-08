//
//  BSMaterialGroupAdapter.h
//  BlueSky
//
//  Created by Jones, Jeffry on 6/14/13.
//  Copyright (c) 2013 SAP MIC. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BSSalesOrder;

@interface BSSOAdapter : NSObject <UICollectionViewDataSource>

@property (nonatomic, strong) BSSalesOrder *salesOrder;
@property (nonatomic) BOOL isEditing;
@end
