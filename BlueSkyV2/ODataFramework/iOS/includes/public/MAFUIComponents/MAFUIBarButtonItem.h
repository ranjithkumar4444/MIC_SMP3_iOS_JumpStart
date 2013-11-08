

#import <UIKit/UIKit.h>
#import "MAFStyling.h"

/**
 * Subclass of Native UIBarButtonItem, adding MAF Syling capability through  @MAFStyling delegate.
 *
 * @param Background : Color of the Control's background, it can only be a solid color, no free gradient, Colors are difined as RGBA (red,green,blue,alpha). Available in iOS 5.0 and later.
 * @param BackgroundImage : The Background image of the control. Only set if not using Tintcolor. Available in iOS 5.0 and later.
 * @param iosStyle: The iOS Style for the control. Available in iOS 2.0 and later.
 * Possible Values: UIBarButtonItemStylePlain, UIBarButtonItemStyleBordered, UIBarButtonItemStyleDone. Available in iOS 2.0 and later.
 *
 * @Example using image:
 * <pre>
 *<Style TargetType="BarButtonItem" Key="SampleBarButton" platform="ios">
 *      <BackgroundImage Height="30"  ImageSource="up.png" Width="30"/>
 *</Style>
 * </pre>
 *
 * @Example using tintcolor:
 * <pre>
 *<Style TargetType="BarButtonItem" Key="SampleBarButton" platform="ios">
 *      <Setter Property="iosStyle" Value="UIBarButtonItemStylePlain"/>
 *      <Setter Property="Background" Value="#333333"/>
 *</Style>
 * </pre>
 */


@interface MAFUIBarButtonItem : UIBarButtonItem <MAFStyling>

@end
