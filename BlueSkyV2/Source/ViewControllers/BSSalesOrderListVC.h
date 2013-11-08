//
//  BSSalesOrderListVC.h
//  BlueSky
//
//  Created by Ivan Reyes on 10/3/13.
//  Copyright (c) 2013 SAP MIC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BSBaseVC.h"
#import "Reachability.h"
#import "BSSalesOrderItem.h"
#import "SalesOrderDataController.h"

@interface BSSalesOrderListVC : BSBaseVC <UICollectionViewDelegate,UICollectionViewDataSource, UIAlertViewDelegate> {
    id loadCompletedObserver;
    
}

@property (nonatomic,strong) SalesOrderDataController *salesOrderDataController;
@property (nonatomic, weak) IBOutlet UICollectionView *gridView;
@property (nonatomic, strong) UIColor         *bgColor;
@property (nonatomic, strong) IBOutlet UIView *loadingView;
@property (nonatomic,strong) IBOutlet UIImageView *statusIcon;
@property (nonatomic,strong) NSString *statusText;
@property (nonatomic,strong) NSMutableArray *salesOrderList;
@property (nonatomic, strong) NSArray *salesOrders;
@property (nonatomic,strong) IBOutlet UIButton *refreshButton;
@property (nonatomic, retain) NSString *username;
@property (nonatomic, retain) NSString *password;



+ (NSString *)dateStringFromString:(NSString *)sourceString
                      sourceFormat:(NSString *)sourceFormat
                 destinationFormat:(NSString *)destinationFormat;


-(void) reload;
-(void)updateNetStatusLabel:(NSNotification *) notification;
-(IBAction)reloadSO:(id)sender;
@end
