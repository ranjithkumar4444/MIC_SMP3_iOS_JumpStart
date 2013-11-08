//
//  MAFUITabBar.h
//  MAFUIComponents
//
//  Copyright (c) 2012 SAP. All rights reserved.
//



#import <UIKit/UIKit.h>
#import "MAFStyling.h"
/**
 * Subclass of Native UITabBar, adding MAF Syling capability through  @MAFStyling delegate.
 *
 * @param Background : Color for the TabBar background Tint, it can only be a solid color. Available in iOS 5.0 and later.
 * @param BackgroundImage : Image for the TabBar's background. Available in iOS 5.0 and later.
 * @param IndicatorImage : Image for the TabBar's Indicator. Images can be local images, images from url and images base64 encoded. Available in iOS 5.0 and later.
 * @param ShadowImage : Image for the TabBar's shadow at the top of the control. Available in iOS 6.0 and later. !!!
 * @param selectedImageTintColor : The tint color to apply to the gradient image used when creating the selected image. Available in iOS 5.0 and later.
 *
 * Note:  Images can be local images, images from url and images base64 encoded.
 *
 *Minimal iOS requirement: 2.0
 *
 * @Example:
 * <pre>
 *<Style TargetType="TabBar" platform="ios">
 *      <Setter Property="Background" Value="#339955"/>
 *      <BackgroundImage Height="40"        ImageSource="tabBarBackgroundImage.png" Width="40"/>
 *      <IndicatorImage Height="40"        ImageSource="tabSelectIndicator.png" Width="40"/>
 *      <ShadowImage Height="40"        ImageSource="tabBarUpperShadowImage.png" Width="40"/>
 *      <Setter Property="selectedImageTintColor" Value="#FF0000"/>
 *</Style>
 * </pre>
 */

@interface MAFUITabBar : UITabBar <MAFStyling>
@end
