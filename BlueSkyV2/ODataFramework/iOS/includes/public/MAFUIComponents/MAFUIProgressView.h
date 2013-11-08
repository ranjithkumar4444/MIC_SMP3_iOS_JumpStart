//
//  MAFUIProgressView.h
//  MAFUIComponents
//
//  Copyright (c) 2012 SAP. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MAFStyling.h"

/**
 * Subclass of Native UIProgressView.h, adding MAF Syling capability through  @MAFStyling delegate.
 *
 * @param progressTintColor :The color shown for the portion of the progress bar that is filled.. Colors are difined as RGBA (red,green,blue,alpha). Available in iOS 5.0 and later.
 * @param trackTintColor : The color shown for the portion of the progress bar that is not filled. Available in iOS 5.0 and later.
 * @param ProgressImage: An image to use for the portion of the progress bar that is filled.
 * @param TrackImage: An image to use for the portion of the track that is not filled.
 *
 * MAFUIProgressView supports 2 themes:
 *      One is customizing the color of the native look by TintColors.
 *      The second uses images to replace the native images.
 *
 * When using 1 theme, you should NOT mix with the other theme's properties. See example below.
 *
 * @Example:
 * <pre>
 *
 *<Style TargetType="ProgressView" platform="ios">
 *      <Setter Property="progressTintColor" Value="#7762A9"/>
 *      <Setter Property="trackTintColor" Value="#000000"/>
 *</Style>
 *
 * </pre>
 *
 * @Example 2:
 * <pre>
 * <Style TargetType="ProgressView" platform="ios">
 *      <ProgressImage Height="30"  ImageSource="segcontrol_uns.png" Width="30"/>
 *      <TrackImage Height="30"  ImageSource="segcontrol_sel.png" Width="30"/>
 *</Style>
 */

@interface MAFUIProgressView : UIProgressView <MAFStyling>

@end
