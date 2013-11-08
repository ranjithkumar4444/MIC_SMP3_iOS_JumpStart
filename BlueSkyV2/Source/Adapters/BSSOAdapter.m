//
//  BSMaterialGroupAdapter.m
//  BlueSky
//
//  Created by Jones, Jeffry on 6/14/13.
//  Copyright (c) 2013 SAP MIC. All rights reserved.
//

#import "BSSOAdapter.h"
#import "BSSalesOrder.h"
#import "BSSOCell.h"
#import "BSUtils.h"


@implementation BSSOAdapter
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
    
    BSSOCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier: BS_SO_CELL_ID
                                                                          forIndexPath: indexPath];
    if (self.salesOrder) {
        if(indexPath.row == 0){
            cell.label.text = @"Requested Date";
            if(self.isEditing){
                [cell.value setHidden:YES];
                [cell.txtValue setHidden:NO];
                cell.txtValue.text = self.salesOrder.updated;
            }else{
                [cell.value setHidden:NO];
                [cell.txtValue setHidden:YES];
                cell.value.text = self.salesOrder.updated;
            }
            
        }else if(indexPath.row == 1){
            cell.label.text = @"Material";
            if(self.isEditing){
                [cell.value setHidden:YES];
                [cell.txtValue setHidden:NO];
                cell.txtValue.text = self.salesOrder.material;
            }else{
                [cell.value setHidden:NO];
                [cell.txtValue setHidden:YES];
                cell.value.text = self.salesOrder.material;
            }
        }else if(indexPath.row == 2){
            cell.label.text = @"Quantity";
            if(self.isEditing){
                [cell.value setHidden:YES];
                [cell.txtValue setHidden:NO];
                cell.txtValue.text = self.salesOrder.quantity;
            }else{
                [cell.value setHidden:NO];
                [cell.txtValue setHidden:YES];
                cell.value.text = self.salesOrder.quantity;
            }
        }else if(indexPath.row == 3){
            [cell.value setHidden:NO];
            [cell.txtValue setHidden:YES];
            cell.label.text = @"Price/Unit";
            float tmp = [self.salesOrder.value floatValue]/[self.salesOrder.quantity floatValue];
            cell.value.text = [NSString stringWithFormat:@"$%.2f",tmp];
        }else if(indexPath.row == 4){
            [cell.value setHidden:NO];
            [cell.txtValue setHidden:YES];
            cell.label.text = @"Total Value";
            cell.value.text = [NSString stringWithFormat:@"$%.2f",[self.salesOrder.value floatValue]];
        }else if(indexPath.row == 5){
            [cell.value setHidden:NO];
            [cell.txtValue setHidden:YES];
            cell.label.text = @"Status";
            cell.value.text = self.salesOrder.itemDlvyStaTx;
        }
    }

    return cell;
}

@end
