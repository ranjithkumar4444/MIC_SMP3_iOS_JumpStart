//
//  BSMaterialGroupCell.m
//  BlueSky
//
//  Created by Jones, Jeffry on 6/14/13.
//  Copyright (c) 2013 SAP MIC. All rights reserved.
//

#import "BSSOEditCell.h"
#import "BSUtils.h"

@implementation BSSOEditCell

+ (UINib *) nibFile {
    return [UINib nibWithNibName: @"BSSOEditCell"
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

- (void) populate: (NSString *) label value:(NSString *)value {
    self.label.text = label;
    
    if(value && ![value isEqualToString:@""]){
        self.value.text = value;
    }else{
        self.value.text = @"---";
    }
}


- (void) prepareForReuse {
    [super prepareForReuse];
    self.label.text = nil;
    self.value.text = nil;

    //self.backgroundColor = [UIColor grayColor];
}

@end
