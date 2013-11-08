//
//  MAFUISwitch.h
//  MAFUIComponents
//
//  Created by SAP on 6/25/12.
//  Copyright (c) 2012 SAP. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MAFStyling.h"

/**
 * Subclass of Native UISwitch.h, adding MAF Syling capability through  @MAFStyling delegate.
 * Switch supports 2 themes. 
 * One is customizing the colors of the native look by TintColors. 
 * The second uses images to replace the native images.
 * When using 1 theme, you should NOT mix with the other theme's properties. See example below.
 *
 * @param thumbTintColor : The color of the thumb icon. It can be set with both themes. Available in iOS 6.0 and later.
 * @param onTintColor : The hue/color of the ON switch, when using this property don't use OnImage property. Available in iOS 5.0 and later.
 * @param offTintColor : The hue/color of the OFF switch, when using this property don't use OffImage property Available in iOS 6.0 and later.
 * @param OnImage : The image for the ON switch, when using this property don't use onTintColor property. Available in iOS 6.0 and later.
 * @param OffImage : The image for the OFF switch, when using this property don't use offTintColor property. Available in iOS 6.0 and later.
 *
 * @Example for coloring:
 * <pre>
 *<Style TargetType="Switch" Key="SampleSwitch1" platform="ios">
 *      <Setter Property="onTintColor" Value="#05FF1A"/>
 *      <Setter Property="offTintColor" Value="#F20202"/>
 *      <Setter Property="thumbTintColor" Value="#FABA00"/>
 *</Style>
 *</pre>
 *
  * @Example for using images:
 *<pre>
 *<Style TargetType="Switch" Key="SampleSwitch2" platform="ios">
 *      <Setter Property="thumbTintColor" Value="#FABA00"/>
 *      <OnImage Height="30"  ImageSource="accept_24.png" Width="30"/>
 *      <OffImage Height="30"  ImageSource="decline_24.png" Width="30"/>
 *</Style>
 * </pre>
 */

@interface MAFUISwitch : UISwitch <MAFStyling>

@end
