//
//  BSMapViewController.h
//  BlueSky
//
//  Created by Jones, Jeffry on 7/10/13.
//  Copyright (c) 2013 SAP MIC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BSBaseViewController.h"

@class BSSalesOrder, BSSalesOrderViewController;

@interface BSSOListViewController : BSBaseViewController <UICollectionViewDelegate> {
    id loadCompletedObserver; ///< Observer for load action completed.
}

@property (nonatomic, strong) BSSalesOrder *salesOrder;

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

@property (nonatomic, retain) BSSalesOrderViewController *realParent;
-(IBAction)btnEditClicked:(id)sender;
-(IBAction)btnDeleteClicked:(id)sender;
-(void)updateNetStatusLabel:(NSNotification *) notification;
@end
