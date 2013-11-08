//
//  MAFUIButton.h
//  MAFUIComponents
//
//  Copyright (c) 2012 SAP. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MAFStyling.h"

/**
 * Subclass of Native UIButton, adding MAF Syling capability through  @MAFStyling delegate.
 *
 * The MAFUIButton supports visualstates, if no visualstate is defined it will be assigned as default (Unselected).
 * supported visualstates: Highlighted, Disabled.
 *
 * @param Background : Color for the control's background, it can be a free gradient also. Colors are difined as RGBA (red,green,blue,alpha). Available in iOS 2.0 and later.
 * @param TextColor: The control's textcolor. Available in iOS 3.0 and later.
 * @param FontFamily: The control's fontfamily. Available in iOS 3.0 and later.
 * @param FontSize: The control's fontsize. Available in iOS 3.0 and later.
 * @param HorizontalContentAlignment : The horizontal alignment for the control's text. Available in iOS 2.0 and later.
 * @param VerticalContentAlignment : The vertical alignment for the control's text. Available in iOS 2.0 and later.
 * @param Border : The border attributes for the MAFUIButton. Borderbrush defines color. BorderThickness is the width of the border. CornerRadius is the angle of the edge. Available in iOS 2.0 and later.
  * @param Shadow : The upper shadow (1px horizontal line) for the button. Available in iOS 5.0 and later.
 *
 * Minimal iOS requirement: 5.0
 *
 * @Example:
 * <pre>
 *<Style TargetType="Button" platform="ios">
 *      <VisualStates>
 *          <VisualState Name="Highlighted">
 *              <Setter Property="Shadow" Value="#D6D6D6"/>
 *                  <Setter Property="Background">
 *                      <Setter.Value>
 *                          <LinearGradientBrush EndPoint="0.5,1" StartPoint="0.5,0">
 *                          <LinearGradientBrush.GradientStops>
 *                              <GradientStop Color="#EFEFEF" Offset="0.0"/>
 *                              <GradientStop Color="#DDDDDD" Offset="0.65"/>
 *                              <GradientStop Color="#DDDDDD" Offset="1.0"/>
 *                          </LinearGradientBrush.GradientStops>
 *                          </LinearGradientBrush>
 *                  </Setter.Value>
 *          </Setter>
 *          <Border BorderBrush="#666666" BorderThickness="1"/>
 *      </VisualState>
 *      <VisualState Name="Disabled">
 *          <Setter Property="TextColor" Value="#666666"/>
 *          <Setter Property="Shadow" Value="#D6D6D6"/>
 *          <Setter Property="Background">
 *              <Setter.Value>
 *                  <LinearGradientBrush EndPoint="0.5,1" StartPoint="0.5,0">
 *                      <LinearGradientBrush.GradientStops>
 *                          <GradientStop Color="#FFFFFF" Offset="0.0"/>
 *                          <GradientStop Color="#EFEFEF" Offset="0.65"/>
 *                          <GradientStop Color="#DDDDDD" Offset="1.0"/>
 *                      </LinearGradientBrush.GradientStops>
 *                  </LinearGradientBrush>
 *              </Setter.Value>
 *          </Setter>
 *      <Border BorderBrush="#666666" BorderThickness="1"/>
 *  </VisualState>
 *  </VisualStates>
 *  <Setter Property="Background">
 *      <Setter.Value>
 *          <LinearGradientBrush EndPoint="0.5,1" StartPoint="0.5,0">
 *              <LinearGradientBrush.GradientStops>
 *                  <GradientStop Color="#FFFFFF" Offset="0.0"/>
 *                  <GradientStop Color="#EFEFEF" Offset="0.65"/>
 *                  <GradientStop Color="#EFEFEF" Offset="1.0"/>
 *              </LinearGradientBrush.GradientStops>
 *          </LinearGradientBrush>
 *      </Setter.Value>
 *     </Setter>
 *  <Setter Property="Shadow" Value="#FFFFFF"/>
 *  <Setter Property="FontFamily" Value="Helvetica-Bold"/>
 *  <Setter Property="FontSize" Value="15"/>
 *  <Setter Property="HorizontalContentAlignment" Value="Center"/>
 *  <Setter Property="VerticalContentAlignment" Value="Center"/>
 *  <Setter Property="TextColor" Value="#333333"/>
 *  <Border BorderBrush="#666666" BorderThickness="1" CornerRadius="8"/>
 *</Style>
 * </pre>
 */


@interface MAFUIButton : UIButton <MAFStyling>

@end
