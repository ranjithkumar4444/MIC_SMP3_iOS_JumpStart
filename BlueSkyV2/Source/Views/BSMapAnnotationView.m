//
//  BSMapAnnotationView.m
//  BlueSky
//
//  Created by Ivan Reyes on 10/3/13.
//  Copyright (c) 2013 SAP MIC. All rights reserved.
//

#import "BSMapAnnotationView.h"

@implementation BSMapAnnotationView

- (id) initWithAnnotation: (BSMapAnnotation *) annotation
          reuseIdentifier: (NSString *) reuseIdentifier {
    
    self = [super initWithAnnotation: annotation
                     reuseIdentifier: reuseIdentifier];
    if (self) {
        [self setup];
    }
    return self;
}

- (id) initWithFrame: (CGRect) frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (void) setup {
    self.canShowCallout = NO;
    [self showSelectedState: NO];
}

- (void) prepareForReuse {
    [super prepareForReuse];
    [self showSelectedState: NO];
}

- (void) showSelectedState: (BOOL) selected {
    self.image = (selected) ? [UIImage imageNamed: @"map_pin_on"] : [UIImage imageNamed: @"map_pin_off"];
    self.centerOffset = CGPointMake(0.0f, -self.image.size.height / 2.0f);
}

@end
