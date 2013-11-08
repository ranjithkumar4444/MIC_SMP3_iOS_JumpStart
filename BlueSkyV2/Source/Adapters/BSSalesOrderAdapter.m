//
//  BSMaterialGroupAdapter.m
//  BlueSky
//
//  Created by Jones, Jeffry on 6/14/13.
//  Copyright (c) 2013 SAP MIC. All rights reserved.
//

#import "BSSalesOrderAdapter.h"
#import "BSSalesOrder.h"
#import "BSSalesOrderCell.h"
#import "BSUtils.h"


@implementation BSSalesOrderAdapter
- (id) init {
    if (self = [super init]) {
    }
    return self;
}

- (NSInteger) collectionView: (UICollectionView *) collectionView
      numberOfItemsInSection: (NSInteger) section {
    return [self.salesOrders count];
}

- (UICollectionViewCell *) collectionView: (UICollectionView *) collectionView
                   cellForItemAtIndexPath: (NSIndexPath *) indexPath {
    
    BSSalesOrderCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier: BS_SALES_ORDER_CELL_ID
                                                                          forIndexPath: indexPath];
    if (indexPath.row < [self.salesOrders count]) {
        BSSalesOrder *so = [self.salesOrders objectAtIndex: indexPath.row];
        cell.lblDate.text = so.updated;
        cell.lblStatus.text = so.itemDlvyStaTx;
        cell.lblDescription.text = so.description;
        cell.lblOrderID.text = [NSString stringWithFormat:@"#%@", so.orderId ];
        cell.lblQuantity.text = [NSString stringWithFormat:@"%dX", [so.quantity intValue] ];
        cell.lblOrderValue.text = [NSString stringWithFormat:@"$%@", so.value ];
        
        [BSUtils addCellShadow:cell];
        
        cell.backgroundColor = [BSUtils colorForIndex: 1];
    }

    return cell;
}

@end
