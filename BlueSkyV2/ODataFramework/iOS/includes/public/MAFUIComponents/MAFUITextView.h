//
//  MAFUITextView.h
//  MAFUIComponents
//
//  Copyright (c) 2012 SAP. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MAFStyling.h"

/**
 * Subclass of Native UITextView.h, adding MAF Syling capability through  @MAFStyling delegate.
 *
 * The MAFUITextView supports visualstates, if no visualstate is defined it will be assigned as default (Editable).
 * supported visualstates: NonEditable.
 *
 * @param Background : Color for the TextView's background, it can only be a solid color, no free gradient, Colors are difined as RGBA (red,green,blue,alpha). Available in iOS 2.0 and later.
 * @param FontFamily: The family of the Font. Available in iOS 2.0 and later.
 * @param FontSize: The Size of the TextView's Font. Available in iOS 2.0 and later.
 * @param TextColor : The Color of the TextView's text. Available in iOS 2.0 and later.
 * @param HorizontalContentAlignment : The horizontal alignment for the Textview's text. Available in iOS 2.0 and later.
 * @param Border : The border attributes for the TextView. Borderbrush defines color. BorderThickness is the width of the border. CornerRadius is the angle of the edge. Available in iOS 2.0 and later.
 *
 * @Example:
 * <pre>
 *<Style TargetType="TextView" Key="SampleTextView" platform="ios">
 *  <VisualStates>
 *     <VisualState Name="NonEditable">
 *         <Setter Property="TextColor" Value="#aaffaa"/>
 *         <Setter Property="Background" Value="#555555"/>
 *         <Setter Property="FontFamily" Value="AmericanTypewriter"/>
 *         <Setter Property="FontSize" Value="6"/>
 *     </VisualState>
 * </VisualStates>
 * <Setter Property="TextColor" Value="#FFAAAA"/>
 * <Setter Property="Background" Value="#333333"/>
 * <Setter Property="FontFamily" Value="AmericanTypewriter-Bold"/>
 * <Setter Property="FontSize" Value="5"/>
 * <Setter Property="HorizontalContentAlignment" Value="Center"/>
 *</Style>
 * </pre>
 *
 *Minimal iOS requirement: 2.0
 *
 */

@interface MAFUITextView : UITextView <MAFStyling>

@end
