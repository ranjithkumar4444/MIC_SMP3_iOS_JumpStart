//
//  BSMaterialGroupAdapter.m
//  BlueSky
//
//  Created by Jones, Jeffry on 6/14/13.
//  Copyright (c) 2013 SAP MIC. All rights reserved.
//

#import "BSSOEditAdapter.h"
#import "BSSalesOrder.h"
#import "BSUtils.h"


@implementation BSSOEditAdapter
- (id) init {
    if (self = [super init]) {
    }
    return self;
}

- (NSInteger) collectionView: (UICollectionView *) collectionView
      numberOfItemsInSection: (NSInteger) section {
    return 6;
}

- (UICollectionViewCell *) collectionView: (UICollectionView *) collectionView
                   cellForItemAtIndexPath: (NSIndexPath *) indexPath {
    
    BSSOEditCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier: BS_SO_EDIT_CELL_ID
                                                                          forIndexPath: indexPath];
    if (self.salesOrder) {
        if(indexPath.row == 0){
            cell.label.text = @"Requested Date";
            cell.value.text = self.salesOrder.requestedDate;
        }else if(indexPath.row == 1){
            cell.label.text = @"Material";
            cell.value.text = self.salesOrder.material;
        }else if(indexPath.row == 2){
            cell.label.text = @"Quantity";
            cell.value.text = self.salesOrder.quantity;
        }else if(indexPath.row == 3){
            cell.label.text = @"Price/Unit";
            cell.value.text = [NSString stringWithFormat:@"%f",([self.salesOrder.value floatValue]/[self.salesOrder.quantity floatValue])];
            cell.value.enabled = NO;
        }else if(indexPath.row == 4){
            cell.label.text = @"Total";
            cell.value.text = self.salesOrder.value;
            cell.value.enabled = NO;
        }else if(indexPath.row == 5){
            cell.label.text = @"Status";
            cell.value.text = self.salesOrder.itemDlvyStaTx;
            cell.value.enabled = NO;
        }
    }

    return cell;
}

@end
