//
//  BSProductCell.m
//  BlueSky
//
//  Created by Ivan Reyes on 10/3/13.
//  Copyright (c) 2013 SAP MIC. All rights reserved.
//

#import "BSProductCell.h"
#import "BSUtils.h"

@implementation BSProductCell

+ (UINib *) nibFile {
    return [UINib nibWithNibName: @"BSProductCell"
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

- (void) populate: (BSProduct *) product {
    if (product) {
        self.imgView.image = [BSUtils imageForMaterial: product.materialID];
        self.matNameLabel.text = product.productName;
        self.matSubtitleLabel.text = product.materialID;
    } else {
        self.imgView.image = nil;
        self.matNameLabel.text = @"Unknown";
        self.matSubtitleLabel.text = nil;
    }
}

- (void) prepareForReuse {
    [super prepareForReuse];
    self.imgView.image = nil;
    self.matNameLabel.text = nil;
    self.matSubtitleLabel.text = nil;
}

@end
