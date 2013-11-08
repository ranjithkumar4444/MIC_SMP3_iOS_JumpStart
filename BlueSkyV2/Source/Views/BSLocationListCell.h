//
//  BSMaterialGroupCell.h
//  BlueSky
//
//  Created by Ivan Reyes on 10/3/13.
//  Copyright (c) 2013 SAP MIC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BSPlantWithStock.h"

@interface BSLocationListCell : UICollectionViewCell 

@property (nonatomic, weak) IBOutlet UILabel *skuLabel;
@property (nonatomic, weak) IBOutlet UILabel *nameLabel;
@property (nonatomic, weak) IBOutlet UILabel *quantityLabel;
@property (nonatomic, weak) IBOutlet UILabel *addressLabel;
@property (nonatomic, strong) IBOutlet UIButton *orderBtn;


+ (UINib *) nibFile;

- (void) populate: (BSPlantWithStock*)location;

@end
