//
//  MAFStyledUIFactory.h
//  MAFUIComponentsTest
//
//  Created by Farkas, Zoltan on 11/03/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MAFUIStyle.h"
#import "MAFStyling.h"

/**
 * Creates a simple control or a screen with controls with a style applied. 
 * To create a complex screen use the "Page." prefix and the name of the UI defined in the xml.
 * DEPRECATED! MAF UI Components are self-styling components.
 */
UIView<MAFStyling>* mafCreateStyledUI(NSString* uiClassName, MAFUIStyle* style, CGRect frame) DEPRECATED_ATTRIBUTE;

/**
 * Applies a style on a view and all of its subviews.
 * DEPRECATED! MAF UI Components are self-styling components.
 */
BOOL mafApplyStyleOnUI(UIView* uiView, MAFUIStyle* style) DEPRECATED_ATTRIBUTE;

/**
 * Users of the framework should use this resize function to resize views that have styles applied.
 * DEPRECATED! MAF UI Components are self-styling components.
 */
void mafResizeView(UIView* view, CGRect frame) DEPRECATED_ATTRIBUTE;

/* * Downloads an image from the input path, can be URL, bundle path and encoded data too */
UIImage* mafLoadImage(NSString* image, BOOL synchronous, UIView* view, id delegate) DEPRECATED_ATTRIBUTE;




