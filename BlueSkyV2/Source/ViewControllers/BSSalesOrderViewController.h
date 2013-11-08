//
//  BSMaterialGroupViewController.h
//  BlueSky
//
//  Created by Jones, Jeffry on 6/14/13.
//  Copyright (c) 2013 SAP MIC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BSBaseViewController.h"
#import "Reachability.h"

@interface BSSalesOrderViewController : BSBaseViewController <UICollectionViewDelegate, UIAlertViewDelegate>

@property (nonatomic, weak) IBOutlet UICollectionView *gridView;
@property (nonatomic, strong) UIColor         *bgColor;
@property (nonatomic, strong) IBOutlet UIView *loadingView;
@property (nonatomic,strong) IBOutlet UIImageView *statusIcon;


-(void) reload;
-(void)updateNetStatusLabel:(NSNotification *) notification;
@end
