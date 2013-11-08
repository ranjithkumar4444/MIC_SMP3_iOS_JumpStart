//
//  MAFUIActivityIndicator.h
//  MAFUIComponents
//  Copyright (c) 2012 SAP. All rights reserved.

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreGraphics/CoreGraphics.h>
#import "MAFStyling.h"
#import "MAFUIView.h"

/**
 * Subclass of Native UIWindow, adding MAF Syling capability through  @MAFStyling delegate.
 *
 * @param boxColor : Color for the control's background, it can only be a solid color. Available in iOS 5.0 and later. Available in iOS 2.0 and later.
 * @param spinnerColor : Color for the control's spinner, it can only be a solid color. Available in iOS 5.0 and later. Available in iOS 5.0 and later.
 * @param coverColor : Color for the control's cover, it can only be a solid color. Available in iOS 5.0 and later. Available in iOS 2.0 and later.
 * @param FontFamily: The family of the Font. Available in iOS 2.0 and later.
 * @param FontSize: The Size of the control's Font. Available in iOS 2.0 and later.
 * @param TextColor : The Color of the control's text. Available in iOS 2.0 and later.
 *
 * Note:  Images can be local images, images from url and images base64 encoded.
 *
 *Minimal iOS requirement: 5.0
 *
 * @Example:
 * <pre>
 *<Style TargetType="ActivityIndicator" platform="ios">
 *      <Setter Property="spinnerColor" Value="#F0AB00"/>
 *      <Setter Property="boxColor" Value="#666666"/>
 *      <Setter Property="coverColor" Value="#ff4488"/>
 *      <Setter Property="FontFamily" Value="Helvetica" />
 *      <Setter Property="FontSize" Value="16" />
 *      <Setter Property="TextColor" Value="#F0AB00"/>
 *</Style>
 * </pre>
 */

@interface MAFUIActivityIndicator : UIWindow <MAFStyling>

- (id)initWithFrame:(CGRect)frame labelText:(NSString*)aLabelText;
- (void)showWithParentViewController:(UIViewController*)aParent;
- (void)hide;

@end

