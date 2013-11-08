//
//  BSLocationListVC.h
//  BlueSky
//
//  Created by Ivan Reyes on 10/3/13.
//  Copyright (c) 2013 SAP MIC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BSBaseVC.h"
#import "BSPlantWithStock.h"
#import "ODataEntry.h"
#import "PlantWithStockDataController.h"


@class BSProduct, BSATPRecord,BSPlantWithStock;

@interface BSLocationListVC : BSBaseVC <UICollectionViewDataSource, UICollectionViewDelegate, UIAlertViewDelegate>
{
    int available;
    id loadCompletedObserver;
}
@property (nonatomic, strong) PlantWithStockDataController *plantWithStockDataController;
@property (nonatomic, strong) NSMutableArray *plantWithStockList;
@property (nonatomic, strong) NSString *username;
@property (nonatomic, strong) NSString *password;
@property (nonatomic, strong) NSString *selectedProduct;

@property (nonatomic, weak) IBOutlet UICollectionView *gridView;
@property (nonatomic, strong) UIColor         *bgColor;
@property (nonatomic, strong) IBOutlet UIView *loadingView;
@property (nonatomic, strong) NSArray *locationArray;
@property (nonatomic, strong) NSArray *pwsRecordsArray;

@property (nonatomic, strong) BSProduct *product;
@property (nonatomic, strong) BSATPRecord *atpRecord;
@property (nonatomic, strong) BSPlantWithStock *pwsRecord;

@property (nonatomic, strong) NSString  *selectedProductID;
@property (nonatomic,strong) ODataEntry *productEntry;
@property (nonatomic,strong) ODataEntry *plantWithStockEntry;

//- (void)populatePlantWithStock;
-(IBAction)mapViewClicked:(id)sender;
-(void)reload;

@end
