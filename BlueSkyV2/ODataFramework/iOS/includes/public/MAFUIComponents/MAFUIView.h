//
//  MAFUIView.h
//  MAFUIComponents
//
//  Copyright (c) 2012 SAP. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MAFStyling.h"

/**
 * Subclass of Native UIView, adding MAF Syling capability through  @MAFStyling delegate.
 *
 * @param Background : Color for the UIView's background, it can be a freegradient too. Colors are difined as RGBA (red,green,blue,alpha). Available in iOS 2.0 and later.
 * @param Border : The border attributes for the UIView's. Borderbrush defines color. BorderThickness is the width of the border. CornerRadius is the angle of the edge. Available in iOS 2.0 and later.
 *
 * @Example:
 * <pre>
 *
 *<Style Key="mafUIViewSampleStyle" TargetType="Window" platform="ios">
 *<Setter Property="Background">
 *  <Setter.Value>
 *      <LinearGradientBrush EndPoint="0.5,1" StartPoint="0.5,0">
 *          <LinearGradientBrush.GradientStops>
 *              <GradientStop Color="#00296A" Offset="0.0"/>
 *              <GradientStop Color="#0062A9" Offset="0.5"/>
 *              <GradientStop Color="#007AB6" Offset="1.0"/>
 *          </LinearGradientBrush.GradientStops>
 *      </LinearGradientBrush>
 *  </Setter.Value>
 *</Setter>
* <Border BorderBrush="#007AB6" BorderThickness="4"/>
 *</Style>
 *
 * </pre>
 *
 *
 *Minimal iOS requirement: 2.0
 *
 */

@interface MAFUIView : UIView <MAFStyling>

@end
