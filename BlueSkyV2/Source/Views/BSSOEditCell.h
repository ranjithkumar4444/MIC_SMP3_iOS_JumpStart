//
//  BSMaterialGroupCell.h
//  BlueSky
//
//  Created by Jones, Jeffry on 6/14/13.
//  Copyright (c) 2013 SAP MIC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BSSalesOrder.h"

@interface BSSOEditCell : UICollectionViewCell

@property (nonatomic, weak) IBOutlet UILabel       *label;
@property (nonatomic, weak) IBOutlet UITextField       *value;


+ (UINib *) nibFile;

- (void) populate: (NSString *) label value:(NSString *)value;

@end
