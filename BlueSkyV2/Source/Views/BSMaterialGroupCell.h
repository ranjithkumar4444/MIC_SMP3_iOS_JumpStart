//
//  BSMaterialGroupCell.h
//  BlueSky
//
//  Created by Jones, Jeffry on 6/14/13.
//  Copyright (c) 2013 SAP MIC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BSMaterialGroup.h"

@interface BSMaterialGroupCell : UICollectionViewCell

@property (nonatomic, weak) IBOutlet UIImageView   *iconView;
@property (nonatomic, weak) IBOutlet UILabel       *groupNameLabel;

+ (UINib *) nibFile;

- (void) populate: (BSMaterialGroup *) matGroup;

@end
