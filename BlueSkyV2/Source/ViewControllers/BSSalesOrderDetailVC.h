//
//  BSSalesOrderDetailVC.h
//  BlueSky
//
//  Created by Ivan Reyes on 10/3/13.
//  Copyright (c) 2013 SAP MIC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BSBaseVC.h"
#import "ODataEntry.h"
#import "BSSalesOrder.h"
#import "BSSalesOrderItem.h"
#import "SalesOrderDataController.h"


@class BSSalesOrderItem, BSSalesOrderListVC;

@interface BSSalesOrderDetailVC : BSBaseVC <UICollectionViewDelegate,UICollectionViewDataSource> {
    id loadCompletedObserver; ///< Observer for load action completed.
}

@property (nonatomic,strong) SalesOrderDataController *salesOrderDataController;
@property (nonatomic, strong) BSSalesOrderItem *salesOrderItem;
@property (nonatomic,strong) BSSalesOrder *salesOrder;
@property (nonatomic,strong) ODataEntry *salesOrderItemEntry;
@property (nonatomic,strong) ODataEntry *salesOrderEntry;
@property (nonatomic, strong) UIColor         *bgColor;
@property (nonatomic, strong) IBOutlet UIView *loadingView;
@property (nonatomic, weak) IBOutlet UICollectionView *gridView;
@property (nonatomic, weak) IBOutlet UIView *uiView;
@property (nonatomic, strong) IBOutlet UIButton *btnDelete;
@property (nonatomic, strong) IBOutlet UIButton *btnEdit;
@property (nonatomic, weak) IBOutlet UIView *uiViewShadow;
@property (nonatomic, weak) IBOutlet UIImageView *productImg;
@property (nonatomic, weak) IBOutlet UILabel *productDescription;
@property (nonatomic,strong) IBOutlet UIImageView *statusIcon;

@property (nonatomic, retain) BSSalesOrderListVC *realParent;

@property (nonatomic) BOOL isEditing;


-(IBAction)btnEditClicked:(id)sender;
-(IBAction)btnDeleteClicked:(id)sender;
-(void)updateNetStatusLabel:(NSNotification *) notification;

-(void)didFinishCreateSalesOrder:(id)sender;

@end
