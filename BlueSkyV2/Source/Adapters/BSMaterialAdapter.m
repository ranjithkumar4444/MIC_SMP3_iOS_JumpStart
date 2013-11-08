//
//  BSMaterialAdapter.m
//  BlueSky
//
//  Created by Jones, Jeffry on 6/14/13.
//  Copyright (c) 2013 SAP MIC. All rights reserved.
//

#import "BSMaterialAdapter.h"
#import "BSMaterialCell.h"
#import "BSMaterial.h"
#import "BSUtils.h"

@implementation BSMaterialAdapter
- (id) init {
    if (self = [super init]) {
    }
    return self;
}

- (NSInteger) collectionView: (UICollectionView *) collectionView
      numberOfItemsInSection: (NSInteger) section {
    return [self.materials count];
}

- (UICollectionViewCell *) collectionView: (UICollectionView *) collectionView
                   cellForItemAtIndexPath: (NSIndexPath *) indexPath {
    BSMaterialCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier: BS_MATERIAL_CELL_ID
                                                                     forIndexPath: indexPath];

    if (indexPath.row < [self.materials count]) {
        BSMaterial *mat = [self.materials objectAtIndex: indexPath.row];
        cell.matNameLabel.text = mat.name;
        cell.matSubtitleLabel.text = mat.materialID;
        cell.imgView.image = [BSUtils imageForMaterial: mat.materialID];
        cell.backgroundColor = self.color;
        
        [BSUtils addCellShadow:cell];
    }

    return cell;
}


@end
