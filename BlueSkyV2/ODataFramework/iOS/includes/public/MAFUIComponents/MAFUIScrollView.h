//
//  MAFUIScrollView.h
//  MAFUIComponents
//
//  Copyright (c) 2013 SAP. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MAFStyling.h"

/**
 * Subclass of Native UIScrollView, adding MAF Syling capability through  @MAFStyling delegate.
 *
 * @param Background : Color for the MAFUIScrollView's background. Colors are defined as RGBA (red,green,blue,alpha). Available in iOS 2.0 and later.
 * @param Border : The border attributes for the MAFUIScrollView's. Borderbrush defines color. BorderThickness is the width of the border. CornerRadius is the angle of the edge. Available in iOS 2.0 and later.
 *
 * @Example:
 * <pre>
 *
 *<Style Key="mafUIViewSampleStyle" TargetType="ScrollView" platform="ios">
 * <Setter Property="Background" Value="#4400AA"/>
 * <Border BorderBrush="#007AB6" BorderThickness="4"/>
 *</Style>
 *
 * </pre>
 *
 *
 *Minimal iOS requirement: 2.0
 *
 */

@interface MAFUIScrollView : UIScrollView <MAFStyling>

@end
