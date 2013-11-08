//
//  BSMaterialGroupViewController.h
//  BlueSky
//
//  Created by Jones, Jeffry on 6/14/13.
//  Copyright (c) 2013 SAP MIC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BSBaseViewController.h"

@interface BSMaterialGroupViewController : BSBaseViewController <UICollectionViewDelegate, UIAlertViewDelegate> {
    id loadCompletedObserver;
    
}



@property (nonatomic, weak) IBOutlet UICollectionView *gridView;
@property (nonatomic, strong) IBOutlet UIView *loadingView;
@property (nonatomic, strong) IBOutlet UILabel *loadingLabel;
@property (nonatomic, strong) IBOutlet UIButton *retryBtn;

@property (nonatomic, retain) NSString *username;
@property (nonatomic, retain) NSString *password;

@property (nonatomic,strong) IBOutlet UIImageView *statusIcon;
@property (nonatomic,strong) NSString *statusText;

-(IBAction)btnSalesOrdersClicked:(id)sender;
-(IBAction)btnRetryClicked:(id)sender;


-(void)updateCache;

@end
