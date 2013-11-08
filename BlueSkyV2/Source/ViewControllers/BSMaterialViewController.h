//
//  BSMaterialViewController.h
//  BlueSky
//
//  Created by Jones, Jeffry on 6/14/13.
//  Copyright (c) 2013 SAP MIC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BSBaseViewController.h"

@class BSMaterialGroup;

@interface BSMaterialViewController : BSBaseViewController <UICollectionViewDelegate>

@property (nonatomic, strong) BSMaterialGroup *matGroup;
@property (nonatomic, strong) UIColor         *bgColor;
@property (nonatomic, weak) IBOutlet UILabel          *subtitleLabel;
@property (nonatomic, strong) IBOutlet UIView *loadingView;
@property (nonatomic, weak) IBOutlet UICollectionView *gridView;

@end
