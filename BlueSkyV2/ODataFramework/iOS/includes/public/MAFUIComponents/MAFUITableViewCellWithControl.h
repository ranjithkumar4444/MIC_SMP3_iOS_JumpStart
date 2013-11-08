//
//  MAFUITableViewCellWithControl.h
//  MAFUIComponents
//
//
//  Copyright 2013 SAP AG. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MAFUIStyle.h"
#import "MAFUITableViewCell.h"
#import "MAFUILabel.h"

/**
 * Subclass of MAFUITableViewCell, providing MAF Syling capability through @MAFStyling delegate and advanced features.
 *
 * The MAFUITableViewCellWithControl supports visualstates, if no visualstate is defined it will be assigned as default (Unselected).
 * supported visualstates: Selected, SelectedEditable.
 *
 * @param Background : Color for the TableViewCellWithControl background, it can only be a solid color,
 *  free gradient, ios style backgroundcolor, Colors are difined as RGBA (red,green,blue,alpha). Available in iOS 2.0 and later.
 * @param Foreground: The TableViewCellWithControl's textcolor. Available in iOS 2.0 and later.
 * @param FontFamily: The TableViewCellWithControl's fontfamily. Available in iOS 2.0 and later.
 * @param FontSize: The TableViewCellWithControl's fontsize. Available in iOS 2.0 and later.
 * Every TableViewCellWithControl can have 2 textsLabels, the secondary is called detailsTextlabel. It can be styled also.
 * @param DetailsForeground: The TableViewCellWithControl's detailtextcolor ( the textcolor of the secondary text). Available in iOS 2.0 and later.
 * @param DetailsFontFamily: The TableViewCellWithControl's detailfontfamily. Available in iOS 2.0 and later.
 * @param DetailsFontSize: The TableViewCellWithControl's detailfontsize. Available in iOS 2.0 and later.
 * @param HorizontalContentAlignment : The horizontal alignment for the TableViewCellWithControl's text. Available in iOS 2.0 and later.
 * @param VerticalContentAlignment : The vertical alignment for the TableViewCellWithControl's text. Available in iOS 2.0 and later.
 * @param Border : The border attributes for the TableViewCellWithControl. Borderbrush defines color. BorderThickness is the width of the border. CornerRadius is the angle of the edge.
 * @param SubStyle : Style definition for the control in TableViewCellWithControl. Refers to the relevant style definition.
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
 *      <Setter Property="SubStyle" TargetType="<control type>" Value="<style key>"/>
 *      </Style>
 * </pre>
 */

/**
 A MAFUITableViewCell that contains a label and a control.
 */
@interface MAFUITableViewCellWithControl : MAFUITableViewCell 
/**
 The control view of the cell (e.g. MAFUITextField)
 */
@property (nonatomic, readonly) UIView<MAFStyling> *control;

/**
 Native skin
 Call the styling with the given style and CellStyle with nil and ControlStyle with nil.
 @param reuseIdentifier If the cell can be reused, you must pass in a reuse identifier. You should use the same reuse identifier for all cells of the same form.
 @param controlName <MAF Control Name> like MAFUITextField, MAFUISwitch, MAFUIButton

 */
-(id) initWithReuseIdentifier:(NSString*)reuseIdentifier
               andControlName:(NSString*)controlName;


/**
 DESIGNATED INITIALIZER
 @param reuseIdentifier If the cell can be reused, you must pass in a reuse identifier. You should use the same reuse identifier for all cells of the same form.
 @param controlName <MAF Control Name> like MAFUITextField, MAFUISwitch, MAFUIButton
 @param cellStyle Style of the cell.
 */
-(id) initWithReuseIdentifier:(NSString*)reuseIdentifier
               andControlName:(NSString*)controlName
                 andCellStyle:(NSString*)cellStyle;

/**
 User defined skin
 @param reuseIdentifier If the cell can be reused, you must pass in a reuse identifier. You should use the same reuse identifier for all cells of the same form.
 @param controlName <MAF Control Name> like MAFUITextField, MAFUISwitch, MAFUIButton
 @param cellStyle Style of the cell.
 @param controlStyle Style of the control.
 */
-(id) initWithReuseIdentifier:(NSString*)reuseIdentifier
               andControlName:(NSString*)controlName
                 andCellStyle:(MAFUIStyle*)cellStyle
              andControlStyle:(MAFUIStyle*)controlStyle DEPRECATED_ATTRIBUTE;

/**
 User defined skin
 This initializer sets UserInteractionEnabled = NO for containing UITextField because of Apple limitation in hit zone.
 To set containing UITextField FirstResponder you first need to set UserInteractionEnabled = YES in didSelectRowAtIndexPath method of your UITableViewController.
 After containing UITextField resignes being FirstResponder you need to set UserInteractionEnabled back to NO.
 This way you can achieve desirable hit zone when handling touch events.
 @param style An enumeration for the various styles of cells.
 @param reuseIdentifier If the cell can be reused, you must pass in a reuse identifier. You should use the same reuse identifier for all cells of the same form.
 @param controlName <MAF Control Name> like MAFUITextField, MAFUISwitch, MAFUIButton
 @param cellStyle Style of the cell.
 @param controlStyle Style of the control.
 TODO : MAKE PRIVATE AFTER 2 RELEASES
 */
-(id) initWithStyle:(UITableViewCellStyle)style
    reuseIdentifier:(NSString*)reuseIdentifier
     andControlName:(NSString*)controlName
       andCellStyle:(MAFUIStyle*)cellStyle
    andControlStyle:(MAFUIStyle*)controlStyle DEPRECATED_ATTRIBUTE;

/**
 Native skin
 Call the styling with the given style and CellStyle with nil and ControlStyle with nil.
 @param style An enumeration for the various styles of cells.
 @param reuseIdentifier If the cell can be reused, you must pass in a reuse identifier. You should use the same reuse identifier for all cells of the same form.
 @param controlName <MAF Control Name> like MAFUITextField, MAFUISwitch, MAFUIButton
 TODO : MAKE PRIVATE AFTER 2 RELEASES
 */
-(id) initWithStyle:(UITableViewCellStyle)style
    reuseIdentifier:(NSString*)reuseIdentifier
     andControlName:(NSString*)controlName DEPRECATED_ATTRIBUTE;


/**
 Does the cell's control (UITextField) hold any (non-null and empty) content.
 
 @return flag whether (non-null and empty) content is stored
 */
-(BOOL) controlHasValue DEPRECATED_ATTRIBUTE;

@end
