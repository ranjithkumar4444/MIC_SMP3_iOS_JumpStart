//
//  BSProductVC.h
//  BlueSky
//
//  Created by Ivan Reyes on 10/3/13.
//  Copyright (c) 2013 SAP MIC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BSBaseVC.h"
#import "ODataEntry.h"
#import "ProductDataController.h"


@class BSCategory;

@interface BSProductVC : BSBaseVC <UICollectionViewDelegate,UICollectionViewDataSource, UIAlertViewDelegate>{
    id loadCompletedObserver;
}

@property (nonatomic, strong) ProductDataController *productDataController;
@property (nonatomic, strong) NSMutableArray *productList;
@property (nonatomic, weak) IBOutlet UICollectionView *gridView;
@property (nonatomic, strong) IBOutlet UIView *loadingView;
@property (nonatomic, strong) NSArray *products;
@property (nonatomic, retain) UIColor * color;
@property (nonatomic, strong) BSCategory *matGroup;
@property (nonatomic,strong) ODataEntry *matGroupEntry;
@property (nonatomic,strong) NSString *selectedCategory;
@property (nonatomic, strong) UIColor *bgColor;
@property (nonatomic, weak) IBOutlet UILabel *subtitleLabel;
@property (nonatomic, retain) NSString *username;
@property (nonatomic, retain) NSString *password;
@property (nonatomic,strong) IBOutlet UIImageView *statusIcon;
@property (nonatomic,strong) NSString *statusText;


@property (nonatomic,strong) IBOutlet UIButton *clearCacheButton;

-(void)clearCacheAction:(id)sender;

@end
