//
//  MAFUITextField.h
//  MAFUIComponents
//
//  Copyright (c) 2012 SAP. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MAFStyling.h"
#import "MAFUILabel.h"

/**
 * Subclass of Native UITextField.h, adding MAF Syling capability through  @MAFStyling delegate.
 *
 * The MAFUITextField supports visualstates, if no visualstate is defined it will be assigned as default (enabled).
 * supported visualstates: Disabled,Editing.
 *
 * @param Background : Color for the TextField background, it can only be a solid color, no free gradient, Colors are difined as RGBA (red,green,blue,alpha). Available in iOS 2.0 and later.
 * @param FontFamily: The family of the Font. Available in iOS 2.0 and later.
 * @param FontSize: The Size of the TextField's Font. Available in iOS 2.0 and later.
 * @param Foreground : The Color of the TextField's text. Available in iOS 2.0 and later.
 * @param HorizontalContentAlignment : The horizontal alignment for the TextField's text. Available in iOS 2.0 and later.
 * @param Border : The border attributes for the TextView. Borderbrush defines color. BorderThickness is the width of the border. CornerRadius is the angle of the edge. Available in iOS 2.0 and later.
 *
 * @Example:
 *  <pre>
 *  <Style TargetType="TextBox" Key="3StateTextField" platform="ios">
 *  <Setter Property="Background" Value="#000000"/>
 *  <Setter Property="FontFamily" Value="Helvetica"/>
 *  <Setter Property="FontSize" Value="12"/>
 *  <Setter Property="HorizontalContentAlignment" Value="Left"/>
 *  <Setter Property="VerticalContentAlignment" Value="Center"/>
 *  <Setter Property="TextColor" Value="#ffffff"/>
 *  <Border BorderBrush="#bababa" BorderThickness="2" CornerRadius="0"/>
 *  <VisualStates>
 *      <VisualState Name="Editing">
 *          <Setter Property="Background" Value="#00ff0055"/>
 *          <Setter Property="TextColor" Value="#ff000055"/>
 *          <Setter Property="HorizontalContentAlignment" Value="Left"/>
 *          <Setter Property="VerticalContentAlignment" Value="Center"/>
 *      </VisualState>
 *      <VisualState Name="Disabled">
 *          <Setter Property="Background" Value="#22222266"/>
 *          <Setter Property="TextColor" Value="#33333366"/>
 *      </VisualState>
 *  </VisualStates>
 *</Style>
 * </pre>
 *
 *
 *Minimal iOS requirement: 2.0
 *
 */
@interface MAFUITextField : UITextField <MAFStyling>

/**
 Helper property for MAFUITableViewCellWithControl for accessibility
 */
@property (nonatomic, assign) UILabel* controlLabel;

@end
