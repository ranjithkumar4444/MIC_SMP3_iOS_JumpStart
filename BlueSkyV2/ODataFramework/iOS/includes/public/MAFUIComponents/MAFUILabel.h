//
//  MAFUILabel.h
//  MAFUIComponents
//
//  Copyright (c) 2012 SAP. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MAFStyling.h"
/**
 * Subclass of Native UILabel, adding MAF Syling capability through  @MAFStyling delegate.
 *
 * The MAFUILabel supports visualstates, if no visualstate is defined it will be assigned as default (enabled).
 * supported visualstates: Disabled.
 *
 * @param Background : Color for the Label's background, it can only be a solid color, no free gradient, Colors are difined as RGBA (red,green,blue,alpha). Available in iOS 2.0 and later.
 * @param FontFamily: The family of the Font. Available in iOS 2.0 and later.
 * @param FontSize: The Size of the Label's Font. Available in iOS 2.0 and later.
 * @param TextColor : The Color of the Label's text. Available in iOS 2.0 and later.
 * @param Shadow: The Shadowcolor of the Label's textshadow ( shifted 2px*2px on x and y axis ). Available in iOS 2.0 and later.
 * @param HorizontalContentAlignment : The horizontal alignment for the Label's text. Available in iOS 2.0 and later.
 * @param VerticalContentAlignment : The vertical alignment for the Label's text. Available in iOS 2.0 and later.
 * @param Border : The border attributes for the Label. Borderbrush defines color. BorderThickness is the width of the border. CornerRadius is the angle of the edge. Available in iOS 2.0 and later.
 *
 * @Example: 
 * <pre>
 *  <Style Key="ExampleLabel" TargetType="Label" platform="ios">
*       <Setter Property="Background" Value="#4444FF77"/>
 *      <Setter Property="FontFamily" Value="Helvetica-Bold"/>
 *      <Setter Property="FontSize" Value="11"/>
 *      <Setter Property="TextColor" Value="#666666FF"/>
 *      <Setter Property="Shadow" Value="#FF0000FF"/>
 *      <Setter Property="HorizontalContentAlignment" Value="Right"/>
 *      <Setter Property="VerticalContentAlignment" Value="Top"/>
 *      <Border BorderBrush="#ABAB9F" BorderThickness="2.5" CornerRadius="8"/>
 *</Style>
 * </pre>
 */
@interface MAFUILabel : UILabel <MAFStyling>
@end
