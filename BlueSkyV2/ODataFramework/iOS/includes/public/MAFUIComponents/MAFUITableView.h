//
//  MAFUITableView.h
//  MAFUIComponents
//
//  Copyright (c) 2012 SAP. All rights reserved.
//



#import <UIKit/UIKit.h>
#import "MAFStyling.h"

/**
 * Subclass of Native UITableView, adding MAF Syling capability through  @MAFStyling delegate.
 *
 * The MAFUITableView supports visualstates, if no visualstate is defined it will be assigned as default (Unselected).
 * supported visualstates: Selected, SelectedEditable.
 *
 * @param Background : Color for the TableViewCell background, it can only be a solid color,
 * no free gradient, Colors are difined as RGBA (red,green,blue,alpha). Available in iOS 2.0 and later.
 * @param SeparatorColor: The tableviewl's textcolor. Available in iOS 2.0 and later.
 * @param Border : The border attributes for the Tableviewl. Borderbrush defines color. BorderThickness is the width of the border. CornerRadius is the angle of the edge. Available in iOS 2.0 and later.
 *
 *Minimal iOS requirement: 2.0
 *
 * @Example:
 * <pre>
 *      <Style Key="TableView" TargetType="ListBox" platform="ios">
 *          <Setter Property="Background" Value="#0000FF"/>
 *          <Setter Property="SeparatorColor" Value="#ff0000"/>
 *          <Border BorderBrush="#00AA00" BorderThickness="4" CornerRadius="1" />
 *      </Style>
 * </pre>
 */

@interface MAFUITableView : UITableView <MAFStyling>
@end
