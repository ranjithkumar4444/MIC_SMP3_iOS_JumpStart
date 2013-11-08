//
//  MAFUINavigationBar.h
//  MAFUIComponents
//
//  Copyright (c) 2012 SAP. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "MAFStyling.h"
/**
 * Subclass of Native UINavigationBar.h, adding MAF Syling capability through  @MAFStyling delegate.
 *
 * @param TintColor : Color of the Control's background, it can only be a solid color, no free gradient, Colors are difined as RGBA (red,green,blue,alpha). Available in iOS 2.0 and later.
 * @param FontFamily: The family of the Font. Available in iOS 5.0 and later.
 * @param FontSize: The Size of the Control's Font. Available in iOS 5.0 and later.
 * @param TextColor : The Color of the Control's text. Available in iOS 5.0 and later.
 * @param ShadowImage: The Shadowimage of the Control at the bottom. Available in iOS 6.0 and later.
 * @param BackgroundImage : The Background image of the control. Only set if not using Tintcolor. Available in iOS 5.0 and later.
 * @param BackgroundImageLanscapePhone : The Background image of the control for Iphone, Lanscape. Only set if not using Tintcolor. Available in iOS 5.0 and later.
 * @param iosStyle: The iOS Style for the control. Available in iOS 2.0 and later.
 * Possible Values: UIBarStyleDefault  ,UIBarStyleBlack
 *
 * @Example using images:
 * <pre>
 *<Style TargetType="NavigationBar" platform="ios">
 *      <BackgroundImage Height="30"  ImageSource="backgroundimage.png" Width="30"/>
 *      <BackgroundImageLanscapePhone Height="30"  ImageSource="backgroundimageLandscapePhone.png" Width="30"/>
 *      <ShadowImage ImageSource="navBarShadow.png"/>
 *      <Setter Property="FontFamily" Value="Helvetica-Bold"/>
 *      <Setter Property="TextColor" Value="#FF3333"/>
 *      <Setter Property="TextShadow" Value="#FFFFFF"/>
 *</Style>
 * </pre>
 *
 * @Example using tintcolor:
 * <pre>
 *<Style TargetType="NavigationBar" platform="ios">
 *      <Setter Property="TintColor" Value="#007AB6"/>  -->
 *      <ShadowImage ImageSource="navBarShadow.png"/>
 *      <Setter Property="FontFamily" Value="Helvetica-Bold"/>
 *      <Setter Property="TextColor" Value="#FF3333"/>
 *      <Setter Property="TextShadow" Value="#FFFFFF"/>
 *</Style>
 * </pre>
 */


@interface MAFUINavigationBar : UINavigationBar <MAFStyling>

@end
