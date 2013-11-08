//
//  BSMaterialGroupViewController.h
//  BlueSky
//
//  Created by Jones, Jeffry on 6/14/13.
//  Copyright (c) 2013 SAP MIC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BSBaseViewController.h"

@class BSMaterial, BSATPRecord;

@interface BSLocationListViewController : BSBaseViewController <UICollectionViewDataSource, UIAlertViewDelegate>
{
    int available;
}
@property (nonatomic, weak) IBOutlet UICollectionView *gridView;
@property (nonatomic, strong) UIColor         *bgColor;
@property (nonatomic, strong) IBOutlet UIView *loadingView;
@property (nonatomic, strong) NSArray *locationArray;
@property (nonatomic, strong) BSMaterial *material;
@property (nonatomic, strong) BSATPRecord *atpRecord;

-(IBAction)mapViewClicked:(id)sender;
-(void)reload;
@end
