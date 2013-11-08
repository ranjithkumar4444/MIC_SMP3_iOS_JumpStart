//
//  MAFStyling.h
//  MAFUIComponents
//
//  Copyright (c) 2013 SAP. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 MAFStyling declares the methods and properties what a styleable control should support.
 */
@protocol MAFStyling <NSObject>

/** 
 The style name of the control defined in the styling xml.
 Default is nil which means to use the default style for the control.
 Setting this property automatically calls mafApplyStyle.
 */
@property (copy) NSString *mafStyleName;

/**
 Applies the style on the control. Should be called if a new styling xml loaded in runtime.
 */
- (void) mafApplyStyle;

@end
