//
//  BSCategoryCell.m
//  BlueSky
//
//  Created by Ivan Reyes on 10/3/13.
//  Copyright (c) 2013 SAP MIC. All rights reserved.
//

#import "BSCategoryCell.h"
#import "BSUtils.h"

@implementation BSCategoryCell

+ (UINib *) nibFile {
    return [UINib nibWithNibName: @"BSCategoryCell"
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

- (void) populate: (BSCategory *) matGroup {
    if (matGroup) {
        self.iconView.image = [BSUtils iconForGroup: matGroup.groupID];
        self.categoryID = matGroup.groupID;
        self.groupNameLabel.text = matGroup.name;
    } else {
        self.iconView.image = nil;
        self.categoryID = nil;
        self.groupNameLabel.text = @"Unknown";
    }
}


- (void) prepareForReuse {
    [super prepareForReuse];
    self.iconView.image = nil;
    self.groupNameLabel.text = nil;
    self.categoryID = nil;
    self.backgroundColor = [UIColor grayColor];
}

@end
