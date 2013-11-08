//
//  BSMaterialGroupCell.m
//  BlueSky
//
//  Created by Ivan Reyes on 10/3/13.
//  Copyright (c) 2013 SAP MIC. All rights reserved.
//

#import "BSSOCell.h"
#import "BSUtils.h"

@implementation BSSOCell

+ (UINib *) nibFile {
    return [UINib nibWithNibName: @"BSSOCell"
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
