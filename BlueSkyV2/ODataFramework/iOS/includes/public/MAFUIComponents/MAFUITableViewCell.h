//
//  MAFUITableViewCell.h
//  MAFUIComponents
//
//  Copyright (c) 2012 SAP. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MAFStyling.h"

/**
 * Subclass of Native UITableViewCell, adding MAF Syling capability through  @MAFStyling delegate.
 *
 * The MAFUITableViewCell supports visualstates, if no visualstate is defined it will be assigned as default (Unselected).
 * supported visualstates: Selected, SelectedEditable.
 *
 * @param Background : Color for the TableViewCell background, it can only be a solid color,
 *  free gradient, ios style backgroundcolor, Colors are difined as RGBA (red,green,blue,alpha). Available in iOS 2.0 and later.
 * @param Foreground: The tableviewcell's textcolor. Available in iOS 2.0 and later.
 * @param FontFamily: The tableviewcell's fontfamily. Available in iOS 2.0 and later.
 * @param FontSize: The tableviewcell's fontsize. Available in iOS 2.0 and later.
 * Every tableviewcell can have 2 textsLabels, the secondary is called detailsTextlabel. It can be styled also.
 * @param DetailsForeground: The tableviewcell's detailtextcolor ( the textcolor of the secondary text). Available in iOS 2.0 and later.
 * @param DetailsFontFamily: The tableviewcell's detailfontfamily. Available in iOS 2.0 and later.
 * @param DetailsFontSize: The tableviewcell's detailfontsize. Available in iOS 2.0 and later.
 * @param HorizontalContentAlignment : The horizontal alignment for the tableviewcell's text. Available in iOS 2.0 and later.
 * @param VerticalContentAlignment : The vertical alignment for the tableviewcell's text. Available in iOS 2.0 and later.
 * @param Border : The border attributes for the Tableviewcell. Borderbrush defines color. BorderThickness is the width of the border. CornerRadius is the angle of the edge. 
 * Available in iOS 2.0 and later.
 *
 *Minimal iOS requirement: 2.0
 *
 * @Example:
 * <pre>
 *<Style TargetType="ListBoxItem" platform="ios">
 *      <VisualStates>
 *          <VisualState Name="Selected">
 *              <Setter Property="Background">
 *                  <Setter.Value>
 *                      <LinearGradientBrush EndPoint="0.5,1" StartPoint="0.5,0">
 *                          <LinearGradientBrush.GradientStops>
 *                              <GradientStop Color="#007AB6" Offset="0.0"/>
 *                              <GradientStop Color="#0062A9" Offset="0.5"/>
 *                              <GradientStop Color="#00599A" Offset="1.0"/>
 *                          </LinearGradientBrush.GradientStops>
 *                      </LinearGradientBrush>
 *                      </Setter.Value>
 *                 </Setter>
 *                 <Setter Property="Foreground" Value="#FFFFFF"/>
 *                  <Setter Property="DetailsForeground" Value="#FFFFFF"/>
 *          </VisualState>
 *          <VisualState Name="SelectedEditable">
 *              <Setter Property="Background" Value="#EBF4F7"/>
 *              <Setter Property="Foreground" Value="#0074BB"/>
 *              <Setter Property="DetailsForeground" Value="#FFFFFF"/>
 *          </VisualState>
 *      </VisualStates>
 *      <Setter Property="SeparatorColor" Value="#FF0000"/>
 *      <Setter Property="Background" Value="#FFFFFF"/>
 *      <Setter Property="FontFamily" Value="Helvetica-Bold"/>
 *      <Setter Property="FontSize" Value="17"/>
 *      <Setter Property="Foreground" Value="#000000"/>
 *      <Setter Property="DetailsForeground" Value="#000000"/>
 *      <Setter Property="DetailsFontFamily" Value="Helvetica-Bold"/>
 *      <Setter Property="DetailsFontSize" Value="13"/>
 *      <Border BorderBrush="#FF0000" BorderThickness="2"/>
 *      </Style>
 * </pre>
 */

typedef enum  {
    CustomCellBackgroundViewPositionTop,
    CustomCellBackgroundViewPositionMiddle,
    CustomCellBackgroundViewPositionBottom,
    CustomCellBackgroundViewPositionSingle,
    CustomCellBackgroundViewPositionPlain
} CustomCellBackgroundViewPosition;



@interface MAFUITableViewCell : UITableViewCell <MAFStyling>


@end
