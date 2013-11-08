//
//  BSCategoryCell.h
//  BlueSky
//
//  Created by Ivan Reyes on 10/3/13.
//  Copyright (c) 2013 SAP MIC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BSCategory.h"

@interface BSCategoryCell : UICollectionViewCell

@property (nonatomic, weak) IBOutlet UIImageView   *iconView;
@property (nonatomic, weak) IBOutlet UILabel       *groupNameLabel;
@property (nonatomic,weak) NSString *categoryID;


+ (UINib *) nibFile;

- (void) populate: (BSCategory *) matGroup;

@end
