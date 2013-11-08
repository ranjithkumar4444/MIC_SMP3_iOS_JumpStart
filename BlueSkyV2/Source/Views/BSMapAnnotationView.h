//
//  BSMapAnnotationView.h
//  BlueSky
//
//  Created by Ivan Reyes on 10/3/13.
//  Copyright (c) 2013 SAP MIC. All rights reserved.
//

#import <MapKit/MapKit.h>
#import "BSMapAnnotation.h"

@interface BSMapAnnotationView : MKAnnotationView

- (void) showSelectedState: (BOOL) selected;

@end
