//
//  BSMaterialCell.h
//  BlueSky
//
//  Created by Jones, Jeffry on 6/14/13.
//  Copyright (c) 2013 SAP MIC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BSMaterial.h"

@interface BSMaterialCell : UICollectionViewCell

@property (nonatomic, weak) IBOutlet UIImageView   *imgView;
@property (nonatomic, weak) IBOutlet UILabel       *matNameLabel;
@property (nonatomic, weak) IBOutlet UILabel       *matSubtitleLabel;

+ (UINib *) nibFile;

- (void) populate: (BSMaterial *) material;

@end
