//
//  BSProductCell.h
//  BlueSky
//
//  Created by Ivan Reyes on 10/3/13.
//  Copyright (c) 2013 SAP MIC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BSProduct.h"

@interface BSProductCell : UICollectionViewCell

@property (nonatomic, weak) IBOutlet UIImageView   *imgView;
@property (nonatomic, weak) IBOutlet UILabel       *matNameLabel;
@property (nonatomic, weak) IBOutlet UILabel       *matSubtitleLabel;

+ (UINib *) nibFile;

- (void) populate: (BSProduct *) product;

@end
