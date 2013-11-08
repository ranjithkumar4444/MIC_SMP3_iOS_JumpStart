//
//  MAFUISegmentedControl.h
//  MAFUIComponents
//
//  Copyright (c) 2012 SAP. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "MAFUIView.h"
/**
 * Subclass of Native UISegmentedControl.h, adding MAF Syling capability through  @MAFStyling delegate.
 *
 * @param FontFamily: The family of the Font. Available in iOS 2.0 and later.
 * @param FontSize: The Size of the Label's Font. Available in iOS 2.0 and later.
 * @param TextColor : The Color of the Label's text. Available in iOS 2.0 and later.
 * @param TintColor : The color used to tint the Control. Tint color only works if the style is UISegmentedControlStyleBar and no image applied . Available in iOS 2.0 and later.
 * @param UnSelectedBackgroundImage : The image used to set the backgroundimage of the Control when a segment is not selected. Available in iOS 5.0 and later.
 * @param SelectedBackgroundImage :  The image used to set the backgroundimage of the Control when a segment is selected. Available in iOS 5.0 and later.
 * @param DividerImageSelUns : The image used to set the dividerimage of the Control between the selected segment on the left and the unselected on the right. Available in iOS 5.0 and later.
 * @param DividerImageUnsSel :  The image used to set the dividerimage of the Control between the unselected segment on the left and the selected on the right. AAvailable in iOS 5.0 and later.
 * @param DividerImageUnsUns : The image used to set the dividerimage of the Control between 2 unselected segments. Available in iOS 5.0 and later.
 * @param iosStyle : The iOS style of the control.
 * Possible values:
 *      UISegmentedControlStylePlain (Available in iOS 2.0 ),
 *      UISegmentedControlStyleBordered (Available in iOS 2.0 ),
 *      UISegmentedControlStyleBar (Available in iOS 2.0 ),
 *      UISegmentedControlStyleBezeled (Available in iOS 4.0 ).
 *
 * @Example for using images:
 * <pre>
 *<Style TargetType="SegmentedControl" platform="ios">
 *      <UnSelectedBackgroundImage Height="30"  ImageSource="segcontrol_uns.png" Width="30"/>
 *      <SelectedBackgroundImage Height="30"  ImageSource="segcontrol_sel.png" Width="30"/>
 *      <DividerImageSelUns Height="30"  ImageSource="segcontrol_sel-uns.png" Width="30"/>
 *      <DividerImageUnsSel Height="30"  ImageSource="segcontrol_uns-sel.png" Width="30"/>
 *       <DividerImageUnsUns Height="30"  ImageSource="segcontrol_uns-uns.png" Width="30"/>
 *       <Setter Property="iosStyle" Value="UISegmentedControlStylPlain"/>
 *       <Setter Property="TextColor" Value="#333333"/>
 *</Style>
 * </pre>
 *
 * @Example for using only tint:
 * <pre>
 * <Style TargetType="SegmentedControl" platform="ios">
 *    <Setter Property="iosStyle" Value="UISegmentedControlStyleBar"/>
 *    <Setter Property="TintColor" Value="#ff0000"/>
 * </Style>
 * </pre>
 */


@interface MAFUISegmentedControl : UISegmentedControl <MAFStyling>

@end