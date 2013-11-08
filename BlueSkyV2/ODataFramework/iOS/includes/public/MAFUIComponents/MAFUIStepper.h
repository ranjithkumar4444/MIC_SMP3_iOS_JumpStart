//
//  MAFUIStepper.h
//  MAFUIComponents
//
//  Copyright (c) 2012 SAP. All rights reserved.
//




#import <UIKit/UIKit.h>
#import "MAFStyling.h"

/**
 * Subclass of Native UIStepper.h, adding MAF Syling capability through  @MAFStyling delegate.
 *
 * The MAFUIStepper supports visualstates, if no visualstate is defined it will be assigned as default (enabled).
 * supported visualstates: Disabled.
 * Stepper supports 3 themes:
 *      One is customizing the color of the native look by TintColors.
 *      The second uses images to replace the native images.
 *      The third one uses a common background and a separator image
 *
 * When using 1 theme, you should NOT mix with the other theme's properties. See example below.
 *
 * @param TintColor : The color used to tint the Stepper. Available in iOS 6.0 and later.
 * @param BackgroundImage : The image for the background for normal state. Available in iOS 6.0 and later.
 * @param BackgroundImageDisabled : The image for the background for disabled state. Available in iOS 6.0 and later.
 * @param BackgroundImageHighlighted : The image for the background for highlighted state.  Available in iOS 6.0 and later.
 
 * @param DividerLeftNormalRightNormal : The image for the divider image that separates the right and the left stepper of the control. Left stepper in normal state, right stepper in normal state.  Available in iOS 6.0 and later.
 * @param DividerLeftHighlightedRightNormal : The image for the divider image that separates the right and the left stepper of the control. Left stepper in highlighted state, right stepper in normal state.  Available in iOS 6.0 and later.
 * @param DividerLeftDisabledRightNormal : The image for the divider image that separates the right and the left stepper of the control. Left stepper in disabled state, right stepper in normal state.  Available in iOS 6.0 and later.
 * @param DividerLeftNormalRightHighlighted : The image for the divider image that separates the right and the left stepper of the control. Left stepper in normal state, right stepper in highlighted state.  Available in iOS 6.0 and later.
 * @param DividerLeftHighlightedRightHighlighted : The image for the divider image that separates the right and the left stepper of the control. Left stepper in highlighted state, right stepper in highlighted state.  Available in iOS 6.0 and later.
 * @param DividerLeftDisabledRightHighlighted : The image for the divider image that separates the right and the left stepper of the control. Left stepper in disabled state, right stepper in highlighted state.  Available in iOS 6.0 and later.
 * @param DividerLeftNormalRightDisabled : The image for the divider image that separates the right and the left stepper of the control. Left stepper in normal state, right stepper in disabled state.  Available in iOS 6.0 and later.
 * @param DividerLeftHighlightedRightDisabled : The image for the divider image that separates the right and the left stepper of the control. Left stepper in highlighted state, right stepper in disabled state.  Available in iOS 6.0 and later.
 * @param DividerLeftDisabledRightDisabled : The image for the divider image that separates the right and the left stepper of the control. Left stepper in disabled state, right stepper in disabled state.  Available in iOS 6.0 and later.

 * @param IncrementImageNormal : The image for the increment button of the stepper for normal state. Available in iOS 6.0 and later.
 * @param IncrementImageDisabled : The image for the increment button of the stepper for disabled state. Available in iOS 6.0 and later.
 * @param IncrementImageHighlighted : The image for the increment button of the stepper for highlighted state. Available in iOS 6.0 and later.
 
 * @param DecrementImageNormal :  The image for the decrement button of the stepper for normal state. Available in iOS 6.0 and later.
 * @param DecrementImageDisabled :  The image for the decrement button of the stepper for disabled state. Available in iOS 6.0 and later.
 * @param DecrementImageHighlighted :  The image for the decrement button of the stepper for highlighted state. Available in iOS 6.0 and later.
 *
 * @Example for coloring:
 * <pre>
 *<Style TargetType="Stepper" Key="TintStepper" platform="ios">
 *  <Setter Property="TintColor" Value="#00FF99"/>
 *</Style>
 * </pre>
 *
 * @Example for styling with images:
 * <pre>
 *<Style TargetType="Stepper" Key="ImageStepper" platform="ios">
 *   <IncrementImageNormal Height="30"  ImageSource="up.png" Width="30"/>
 *   <DecrementImageNormal Height="30"  ImageSource="down.png" Width="30"/>
 *</Style>
 * </pre>
 *
 * @Example for styling with backgroundimage and divider image:
 * <pre>
 *<Style TargetType="Stepper" Key="backgroundImageStepper" platform="ios">
 *  <BackgroundImage ImageSource="surf_gradient_textured_32.png"/>
 *  <DividerLeftNormalRightNormal ImageSource="navBarShadow.png"/>
 *  <DecrementImageDisabled ImageSource="decline_24.png"/>
 *  <DecrementImageNormal ImageSource="down.png"/>
 *  <IncrementImageDisabled ImageSource="decline_24.png"/>
 *  <IncrementImageNormal ImageSource="up.png"/>
 *</Style>
 * </pre>
 */

@interface MAFUIStepper : UIStepper <MAFStyling>

@end
