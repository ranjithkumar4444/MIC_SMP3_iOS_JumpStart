//
//  BSMaterialGroupCell.m
//  BlueSky
//
//  Created by Ivan Reyes on 10/3/13.
//  Copyright (c) 2013 SAP MIC. All rights reserved.
//

#import "BSLocationListCell.h"
#import "BSUtils.h"
#import "BSPlantWithStock.h"

@implementation BSLocationListCell

+ (UINib *) nibFile {
    return [UINib nibWithNibName: @"BSLocationListCell"
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

- (void) populate:(BSPlantWithStock *)location {
    self.skuLabel.text = nil;
    self.nameLabel.text = nil;
    self.quantityLabel.text = nil;
    self.addressLabel.text = nil;
}

- (void) prepareForReuse {
    [super prepareForReuse];
    self.skuLabel.text = nil;
    self.nameLabel.text = nil;
    self.quantityLabel.text = nil;
    self.addressLabel.text = nil;

}


@end
