//
//  MAFUISlider.h
//  MAFUIComponents
//
//  Copyright (c) 2012 SAP. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MAFStyling.h"

/**
 * Subclass of Native UISlider.h, adding MAF Syling capability through  @MAFStyling delegate.
 *
 * The MAFUISlider supports visualstates, if no visualstate is defined it will be assigned as default (enabled).
 * supported visualstates: Disabled.
 * @param minimumTrackTintColor :The color used to tint the standard minimum track images. Available in iOS 5.0 and later.
 * @param maximumTrackTintColor : The color used to tint the standard maximum track images. Available in iOS 5.0 and later. 
  * @param thumbTintColor : The color used to tint the standard thumb images. Can only be used if no thumbimages is used. Available in iOS 5.0 and later.
  * @param CurrentThumbImage: Contains the thumb image currently being used to render the receiver. Overwrites thumbTintColor.  Available in iOS 2.0 and later.
  * @param MinimumValueImage : Contains the image that is drawn on the side of the slider representing the minimum value. Available in iOS 2.0 and later.
  * @param MaximumValueImage : Contains the image that is drawn on the side of the slider representing the maximum value. Available in iOS 2.0 and later.
 *
 * @Example 1 : Customizing the native thumb color with tint:
 * <pre>
 *<Style TargetType="Slider" platform="ios">
 *      <Setter Property="minimumTrackTintColor" Value="#FFFFFF"/>
 *      <Setter Property="maximumTrackTintColor" Value="#FFFF00"/>
 *      <Setter Property="thumbTintColor" Value="#FF0000"/>
 *      <CurrentThumbImage Height="30"  ImageSource="thumb" Width="30"/>
 *      <MinimumValueImage Height="30"  ImageSource="noSwitch.png" Width="30"/>
 *      <MaximumValueImage Height="30"  ImageSource="yesSwitch.png" Width="30"/>
 *      <VisualStates>
 *          <VisualState Name="Disabled">
 *              <Setter Property="minimumTrackTintColor" Value="#ff0000"/>
 *              <Setter Property="maximumTrackTintColor" Value="#00ffff"/>
 *              <Setter Property="thumbTintColor" Value="#00ffff"/>
 *          </VisualState>
 *      </VisualStates>
 * </Style>
 * </pre>
 *
 * @Example 2 Customizing the whole control with images:
 * <pre>
 *<Style Key="SampleSlider" TargetType="Slider" platform="ios">
 *      <Setter Property="minimumTrackTintColor" Value="#FFFFFF"/>
 *      <Setter Property="maximumTrackTintColor" Value="#FFFF00"/>
 *      <CurrentThumbImage Height="30"  ImageSource="thumb.png" Width="30"/>
 *      <MinimumValueImage Height="30"  ImageSource="minSwitch.png" Width="30"/>
 *      <MaximumValueImage Height="30"  ImageSource="maxSwitch.png" Width="30"/>
 * </Style>
 * </pre>
 *
 */

@interface MAFUISlider : UISlider <MAFStyling>

@end
