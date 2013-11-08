//
//  BSMaterialGroupCell.h
//  BlueSky
//
//  Created by Ivan Reyes on 10/3/13.
//  Copyright (c) 2013 SAP MIC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BSSalesOrder.h"

@interface BSSOCell : UICollectionViewCell 

@property (nonatomic, weak) IBOutlet UILabel       *label;
@property (nonatomic, weak) IBOutlet UILabel       *value;
@property (nonatomic, weak) IBOutlet UITextField   *txtValue;

+ (UINib *) nibFile;

- (void) populate: (NSString *) label value:(NSString *)value;

@end
