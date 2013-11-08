//
//  BSCategoryVC.h
//  BlueSky
//
//  Created by Ivan Reyes on 10/3/13.
//  Copyright (c) 2013 SAP MIC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CategoryDataController.h"
#import "BSBaseVC.h"

@interface BSCategoryVC : BSBaseVC <UICollectionViewDelegate,UICollectionViewDataSource, UIAlertViewDelegate> {
    id loadCompletedObserver;
}

@property (nonatomic, strong) CategoryDataController *categoryDataController;
@property (nonatomic, strong) NSMutableArray *categoryList;
@property (nonatomic, retain) NSString *username;
@property (nonatomic, retain) NSString *password;
@property (nonatomic,strong) NSString *statusText;
@property (nonatomic, weak) IBOutlet UICollectionView *gridView;
@property (nonatomic, strong) IBOutlet UIView *loadingView;
@property (nonatomic, strong) IBOutlet UILabel *loadingLabel;
@property (nonatomic, strong) IBOutlet UIButton *retryBtn;
@property (nonatomic,strong) IBOutlet UIImageView *statusIcon;


-(IBAction)btnSalesOrdersClicked:(id)sender;
-(IBAction)btnRetryClicked:(id)sender;

-(void)updateCache;

@end
