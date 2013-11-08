//
//  BSMaterialGroupCell.m
//  BlueSky
//
//  Created by Jones, Jeffry on 6/14/13.
//  Copyright (c) 2013 SAP MIC. All rights reserved.
//

#import "BSMaterialGroupCell.h"
#import "BSUtils.h"

@implementation BSMaterialGroupCell

+ (UINib *) nibFile {
    return [UINib nibWithNibName: @"BSMaterialGroupCell"
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

- (void) populate: (BSMaterialGroup *) matGroup {
    if (matGroup) {
        self.iconView.image = [BSUtils iconForGroup: matGroup.groupID];
        self.groupNameLabel.text = matGroup.name;
    } else {
        self.iconView.image = nil;
        self.groupNameLabel.text = @"Unknown";
    }
}


- (void) prepareForReuse {
    [super prepareForReuse];
    self.iconView.image = nil;
    self.groupNameLabel.text = nil;
    self.backgroundColor = [UIColor grayColor];
}

@end
