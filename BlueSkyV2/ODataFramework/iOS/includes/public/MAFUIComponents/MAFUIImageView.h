//
//  MAFUIImageView.h
//  MAFUIComponents
//
//  Copyright (c) 2012 SAP. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "MAFStyling.h"

/**
 * Subclass of Native UIImageView, adding MAF Syling capability through  @MAFStyling delegate.
 *
 *@param Background : Color for the UIImageView's background, it can't be a freegradient. This covers the area where the image is transparent or not present. 
 * Colors are difined as RGBA (red,green,blue,alpha). Available in iOS 2.0 and later.
 *@param Border : The border attributes for the UIImageView's. Borderbrush defines color. BorderThickness is the width of the border. CornerRadius is the angle of the edge. Available in iOS 2.0 and later.
 *@param BackgroundImage: The background image for the control. Available in iOS 2.0 and later.
 *
 *NOTE: The BackgroundImage's imageSource can be from URL, Local File or base64 encoded image.
 *
 * @Example:
 * <pre>
 *
 *<Style TargetType="Image" id="sapimage">
 *      <Setter Property="Background" Value="#446688"/>
 *      <Border BorderBrush="#FF4A4A" BorderThickness="2" CornerRadius="8"/>
 *      <BackgroundImage Height="33" *ImageSource="http://www.sap.com/global/ui/images/global/sap-logo.png" Width="66"/>
 *</Style>
 *
 * </pre>
 *
 *
 *Minimal iOS requirement: 2.0
 *
 */

@interface MAFUIImageView : UIImageView <MAFStyling>




@end
