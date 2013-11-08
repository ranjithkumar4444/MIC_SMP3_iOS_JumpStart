//
//  BSMaterialCell.m
//  BlueSky
//
//  Created by Jones, Jeffry on 6/14/13.
//  Copyright (c) 2013 SAP MIC. All rights reserved.
//

#import "BSMaterialCell.h"
#import "BSUtils.h"

@implementation BSMaterialCell

+ (UINib *) nibFile {
    return [UINib nibWithNibName: @"BSMaterialCell"
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

- (void) populate: (BSMaterial *) material {
    if (material) {
        self.imgView.image = [BSUtils imageForMaterial: material.materialID];
        self.matNameLabel.text = material.name;
        self.matSubtitleLabel.text = material.materialID;
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
