//
//  BSMaterialGroupCell.h
//  BlueSky
//
//  Created by Ivan Reyes on 10/3/13.
//  Copyright (c) 2013 SAP MIC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BSSalesOrder.h"

@interface BSSalesOrderCell : UICollectionViewCell

@property (nonatomic, weak) IBOutlet UILabel       *lblOrderID;
@property (nonatomic, weak) IBOutlet UILabel       *lblQuantity;
@property (nonatomic, weak) IBOutlet UILabel       *lblDescription;
@property (nonatomic, weak) IBOutlet UILabel       *lblDate;
@property (nonatomic, weak) IBOutlet UILabel       *lblStatus;
@property (nonatomic, weak) IBOutlet UILabel       *lblOrderValue;

+ (UINib *) nibFile;

- (void) populate: (BSSalesOrder *) salesOrder;

@end
