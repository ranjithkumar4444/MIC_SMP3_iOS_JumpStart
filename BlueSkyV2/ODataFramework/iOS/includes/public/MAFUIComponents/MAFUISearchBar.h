//
//  MAFUISearchBar.h
//  MAFUIComponents
//
//  Copyright (c) 2012 SAP. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MAFStyling.h"


/**
 * Subclass of Native UISearchBar.h, adding MAF Syling capability through  @MAFStyling delegate.
 *
 * @param BackgroundImage : The background image of the search bar. Available in iOS 5.0 and later.
 * @param SearchBarIconSearchNormal : Search icon for normal state. Available in iOS 5.0 and later.
 * @param SearchBarIconSearchDisabled : Search icon for disabled state. Available in iOS 5.0 and later.
 * @param SearchBarIconBookmarkNormal : Bookmark icon for normal state. Available in iOS 5.0 and later.
 * @param SearchBarIconBookmarkDisabled : Bookmark icon for disabled state. Available in iOS 5.0 and later.
 * @param SearchBarIconClearNormal : Clear icon for normal state. Available in iOS 5.0 and later.
 * @param SearchBarIconClearDisabled : Clear icon for disabled state. Available in iOS 5.0 and later.
 * @param SearchBarIconResultsListNormal : ResultsList icon for normal state. Available in iOS 5.0 and later.
 * @param SearchBarIconResultsListDisabled : ResultsList icon for disabled state. Available in iOS 5.0 and later.
 * @param SearchFieldBackgroundImageNormal : Background image of the input field, for normal state. Available in iOS 5.0 and later.
 * @param SearchFieldBackgroundImageDisabled : Background image of the input field, for disabled state. Available in iOS 5.0 and later.
 * @param ScopeBarBackgroundImage : The background image of the ScopeBar. Available in iOS 5.0 and later.
 * @param ScopeBarButtonBackgroundImageNormal : The background image of the ScopeBar button, for normal state. Available in iOS 5.0 and later.
 * @param ScopeBarButtonBackgroundImageDisabled : The background image of the ScopeBar button, for disabled state. Available in iOS 5.0 and later.
 * @param ScopeBarButtonBackgroundImageHighlighted : The background image of the ScopeBar button, for highlighted state. Available in iOS 5.0 and later.
 * @param ScopeBarButtonDividerImageLeftDisabledRightNormal : The divider image between 2 ScopeBar buttons. Left button is disabled, right button in normal state.  Available in iOS 5.0 and later.
 * @param ScopeBarButtonDividerImageLeftNormalRightNormal : The divider image between 2 ScopeBar buttons. Left and  right button in normal state.  Available in iOS 5.0 and later.
 * @param ScopeBarButtonDividerImageLeftNormalRightDisabled : The divider image between 2 ScopeBar buttons. Left button in normal state, right button is disabled.  Available in iOS 5.0 and later.
 
 
 
 * @param TextColor : The Searchbar's textcolor. Available in iOS 2.0 and later.
 * @param FontFamily : The Fontfamily for the SearchBar's text. Available in iOS 2.0 and later.
 * @param FontSize : The size of the Searchbar's text. Available in iOS 2.0 and later.
 * @param BarStyle : The style that specifies the receiver’s appearance. Values: UIBarStyleDefault , UIBarStyleBlack , UIBarStyleBlackOpaque. Available in iOS 2.0 and later.
 * @param TintColor : The color used to tint the bar. Available in iOS 2.0 and later.
 * @param Translucent :  Specifies whether the receiver is translucent. Set's the navite property of the searchbar.Available in iOS 3.0 and later.
 *
 *@Example:
 * <pre>
 *<Style TargetType="SearchBar" Key="SampleSearchBar" platform="ios">
 *  <BackgroundImage Height="30"  ImageSource="tabBarBackgroundImage.png" Width="30"/>
 *  <SearchBarIconSearchNormal Height="30"  ImageSource="accept_24.png" Width="30"/>
 *  <SearchBarIconClearNormal ImageSource="decline_24.png"/>
 *  <SearchBarIconBookmarkNormal ImageSource="lead_grey_24.png"/>
 *  <SearchFieldBackgroundImageNormal ImageSource="surf_gradient_textured_32.png"/>
 *  <ScopeBarBackgroundImage ImageSource="tabBarBackgroundImage.png" />
 *  <ScopeBarButtonBackgroundImageNormal ImageSource="button_textured_30.png" />
 *  <Setter Property="TextColor" Value="#006666"/>
 *  <Setter Property="FontFamily" Value="Helvetica-Bold"/>
 *  <Setter Property="FontSize" Value="14"/>
 *  <Setter Property="BarStyle" Value="1"/>
 *  <Setter Property="TintColor" Value="#330099"/>
 *  <Setter Property="Translucent" Value="NO"/>
 </Style>
* </pre>
*/

@interface MAFUISearchBar : UISearchBar <MAFStyling>

@end
