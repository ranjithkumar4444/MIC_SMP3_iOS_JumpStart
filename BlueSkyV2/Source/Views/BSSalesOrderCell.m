//
//  BSMaterialGroupCell.m
//  BlueSky
//
//  Created by Ivan Reyes on 10/3/13.
//  Copyright (c) 2013 SAP MIC. All rights reserved.
//

#import "BSSalesOrderCell.h"
#import "BSSalesOrderItem.h"
#import "BSUtils.h"

@implementation BSSalesOrderCell

+ (UINib *) nibFile {
    return [UINib nibWithNibName: @"BSSalesOrderCell"
                          bundle: nil];
}

- (id) initWithFrame: (CGRect) frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void) awakeFromNib {
}

- (void) populate: (BSSalesOrderItem *) salesOrder {
    if (salesOrder) {
        self.lblOrderID.text = salesOrder.orderId;
        self.lblQuantity.text = salesOrder.quantity;
        self.lblOrderValue.text = salesOrder.value;
        self.lblDescription.text = salesOrder.description;
        self.lblDate.text = salesOrder.updated;
        self.lblStatus.text = salesOrder.itemDlvyStaTx;
    } else {
        self.lblOrderID.text = @"Unknown";
        self.lblQuantity.text = @"0";
        self.lblOrderValue.text = @"$0.00";
        self.lblDescription.text = @"Unknown";
        self.lblDate.text = @"--/--/--";
        self.lblStatus.text = @"NA";
    }
}


- (void) prepareForReuse {
    [super prepareForReuse];
    self.lblOrderID.text = nil;
    self.lblQuantity.text = nil;
    self.lblOrderValue.text = nil;
    self.lblDescription.text = nil;
    self.lblDate.text = nil;
    self.lblStatus.text = nil;
    self.backgroundColor = [UIColor grayColor];
}

@end
