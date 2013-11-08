#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>

//XXX: TEMPORARLY PUBLIC, move UIView(...) to a separate header and switch MAFExtensions back to project

/**
 * Extending UIView with style ref
 */

extern char* mafStyleNameKey;

@interface UIView(MAFExtensions)

-(void) resizeFrame:(CGRect)frame;

/**
 Recursively walks through all the subviews (and their subviews etc.) and if the subview conforms to UIStyling protocol calls the mafApplyStyle method on it
 This method helps to apply a new loaded style in runtime
 */
-(void) mafApplyStyleOnMafSubviews;

@end


@interface UITextField(MAFExtensions)

@property (nonatomic, assign) BOOL isCorrect;

@property (nonatomic, assign) BOOL mandatoryIndicatorEnabled;
@property (nonatomic, assign) BOOL errorIndicatorEnabled;

@property (nonatomic,assign) UIImage* mandatoryImage;
@property (nonatomic,assign) UIImage* errorImage;

/**
 * Method for setting the texfield for mandatory and enabling to apply the error style.
 * @param mandatory Set if the field is mandatory
 * @param error Set if the textfield can have error. If set to NO the isCorrect property will not have effect.
 * @param useControlNames Set if default welter style should be applied on the textfield if it does not have a mafStyleName
*/
-(void) applyMAFStyleWithMandatoryIcon:(BOOL)mandatory WithErrorIcon:(BOOL)error UseControlNames:(BOOL)useControlNames;

/**
 * Method for setting the texfield for mandatory and enabling to apply the error style.
 * @param mandatory Set if the field is mandatory
 * @param error Set if the textfield can have error. If set to NO the isCorrect property will not have effect.
 * @param useControlNames Set if default welter style should be applied on the textfield if it does not have a mafStyleName
 * @param errorStyle Custom error style to be applied in case of error.
 * @param defaultStyle Default style to be applied if the field is correct.
*/
-(void) applyMAFStyleWithMandatoryIcon:(BOOL)mandatory withErrorIcon:(BOOL)error useControlNames:(BOOL)useControlNames errorStyle:(NSString*)errorStyle defaultStyle:(NSString*)defaultStyle;


-(BOOL)getIsCorrect DEPRECATED_ATTRIBUTE;
-(void)setCorrect:(BOOL)isCorrectin DEPRECATED_ATTRIBUTE;
-(BOOL)getMandatoryIndicatorEnabled DEPRECATED_ATTRIBUTE;
-(BOOL)getErrorIndicatorEnabled DEPRECATED_ATTRIBUTE;
-(UIImage*)getMandatoryImage DEPRECATED_ATTRIBUTE;
-(UIImage*)getErrorImage DEPRECATED_ATTRIBUTE;

@end





@interface MAFGradientLayer : CAGradientLayer

-(id) init;

@end

@interface MAFLayer : CALayer

-(id) init;

@end

@interface MAFTableViewCellSeparator : UIView

-(id) init;
-(id) initWithColor:(UIColor*)sepColor andWidth:(CGFloat)sepWidth forCell:(UITableViewCell*)cell;

@end
