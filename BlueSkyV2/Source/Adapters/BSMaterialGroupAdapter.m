//
//  BSMaterialGroupAdapter.m
//  BlueSky
//
//  Created by Jones, Jeffry on 6/14/13.
//  Copyright (c) 2013 SAP MIC. All rights reserved.
//

#import "BSMaterialGroupAdapter.h"
#import "BSMaterialGroup.h"
#import "BSMaterialGroupCell.h"
#import "BSUtils.h"


@implementation BSMaterialGroupAdapter
- (id) init {
    if (self = [super init]) {
    }
    return self;
}

- (NSInteger) collectionView: (UICollectionView *) collectionView
      numberOfItemsInSection: (NSInteger) section {
    return [self.materialGroups count];
}

- (UICollectionViewCell *) collectionView: (UICollectionView *) collectionView
                   cellForItemAtIndexPath: (NSIndexPath *) indexPath {
    
    BSMaterialGroupCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier: BS_MATGROUP_CELL_ID
                                                                          forIndexPath: indexPath];
    if (indexPath.row < [self.materialGroups count]) {
        BSMaterialGroup *group = [self.materialGroups objectAtIndex: indexPath.row];
        cell.groupNameLabel.text = group.name;
        cell.iconView.image = [group iconImage];
        cell.backgroundColor = [BSUtils colorForIndex: indexPath.row];
        
        [BSUtils addCellShadow:cell];
    }

    return cell;
}

@end
