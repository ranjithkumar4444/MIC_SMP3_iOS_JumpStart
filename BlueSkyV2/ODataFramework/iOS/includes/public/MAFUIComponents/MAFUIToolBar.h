//
//  MAFUIToolBar.h
//  MAFUIComponents
//
//  Copyright (c) 2012 SAP. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MAFStyling.h"
/**
 * Subclass of Native UIToolBar, adding MAF Syling capability through  @MAFStyling delegate.
 *
 * @param TintColor : The color used to tint the bar. Colors are difined as RGBA (red,green,blue,alpha).Available in iOS 2.0 and later.
 * @param IosStyle: The toolbar style that specifies its appearance. Possible Values: UIBarStyleDefault, UIBarStyleBlack.  Available in iOS 2.0 and later.
 * @param ShadowImage: The image used for the shadow. !!! Available in iOS 6.0 and later. !!!
 * @param BackgroundImage : Sets the image used as background. Available in iOS 5.0 and later.
 *
 * @Example:
 * <pre>
 *  <Style TargetType="ToolBar" platform="ios">
 *      <Setter Property="TintColor" Value="#666666"/>
 *      <Setter Property="IosStyle" Value="UIBarStyleBlackOpaque"/>
 *      <ShadowImage ImageSource="navBarShadow.png"/>
 *      <BackgroundImage Height="30"  ImageSource="backgroundImage.png" Width="30"/>
 *  </Style>
 * </pre>
 */


@interface MAFUIToolBar : UIToolbar <MAFStyling>

@end
