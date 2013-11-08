//
//  MAFUIStyle.h
//  MAFUIComponentsTest
//
//  Created by Farkas, Zoltan on 11/03/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>
#import <mach/mach_time.h>

//helper to create UIColor instances
UIColor* mafUIColorFromRGBA(const uint32_t color);


enum TEN_MAF_UI_STYLES {
	MAF_UI_STYLE_DEFAULT				= 0x00000000,	//Platform default colors are used
	MAF_UI_STYLE_BACKGROUND				= 0x00000001, //Background color(s) is/are redefined	(UIView)
	MAF_UI_STYLE_HORIZONTAL_ALIGNMENT	= 0x00000002,	//Horizontal alignment is redefined		(UIControl)
	MAF_UI_STYLE_VERTICAL_ALIGNMENT		= 0x00000004, //Vertial alignment is redefined		(UIControl)
	MAF_UI_STYLE_BORDER					= 0x00000008, //Border width, colors are redefined	(CALayer)
	MAF_UI_STYLE_FONT					= 0x00000010,	//Font and font color are redefined
	MAF_UI_STYLE_DETAILS_FONT			= 0x00000020,	//Secondary font and secondary font color are redefined
	MAF_UI_STYLE_BARSTYLE				= 0x00000040,	//Bar style defined
    MAF_UI_STYLE_PROGRESS_BAR           = 0x00000080,
    MAF_UI_STYLE_PROGRESS_BAR_BG        = 0x00000100,
    MAF_UI_STYLE_COLORSLOT1             = 0x00000200,
    MAF_UI_STYLE_COLORSLOT2             = 0x00000400,
    MAF_UI_STYLE_COLORSLOT3             = 0x00000800,
    MAF_UI_STYLE_IOS_STYLE              = 0x00001000,
    MAF_UI_STYLE_IMAGE                  = 0X00002000,
    MAF_UI_STYLE_IMAGE2                 = 0X00004000,
    MAF_UI_STYLE_IMAGE3                 = 0X00008000,
    MAF_UI_STYLE_IMAGE4                 = 0X00010000,
    MAF_UI_STYLE_IMAGE5                 = 0X00020000,
    MAF_UI_STYLE_IMAGE6                 = 0X00040000,
    MAF_UI_STYLE_IMAGE7                 = 0X00080000,
    MAF_UI_STYLE_IMAGE8                 = 0X00100000,
    MAF_UI_STYLE_IMAGE9                 = 0X00200000,
    MAF_UI_STYLE_IMAGE10                = 0X00400000,
    MAF_UI_STYLE_IMAGE11                = 0X00800000,
    MAF_UI_STYLE_IMAGE12                = 0X01000000,
    MAF_UI_STYLE_IMAGE13                = 0X02000000,
    MAF_UI_STYLE_IMAGE14                = 0X04000000,
    MAF_UI_STYLE_IMAGE15                = 0X08000000,
    MAF_UI_STYLE_IMAGE16                = 0X10000000,
    MAF_UI_STYLE_IMAGE17                = 0X20000000,
    MAF_UI_STYLE_IMAGE18                = 0X40000000,
    MAF_UI_STYLE_BOOL                   = 0x80000000
};

enum TEN_MAF_UI_BACKGROUND_STYLES {
	MAF_UI_BACKGROUND_STYLE_COLOR		= 0x01,
	MAF_UI_BACKGROUND_STYLE_GRAD		= 0x02, 
    
};

enum TEN_MAF_UI_BORDER_STYLES {
	MAF_UI_BORDER_STYLE_COLOR			= 0x01,
	MAF_UI_BORDER_STYLE_WIDTH			= 0x02,
	MAF_UI_BORDER_STYLE_CORNER_RADIUS	= 0x04
};

enum TEN_MAF_UI_FONT_STYLES {
	MAF_UI_FONT_STYLE_FONT				= 0x01,
	MAF_UI_FONT_STYLE_COLOR				= 0x02,
	MAF_UI_FONT_STYLE_DETAILS_FONT		= 0x04,
	MAF_UI_FONT_STYLE_DETAILS_COLOR		= 0x08
};



@interface MAFUIStyle : NSObject {
	uint64_t								m_TimeStamp;
	uint64_t								m_StyleFlags;
	uint8_t									m_BackgroundFlags;
	uint8_t									m_BorderFlags;
	
    // BACKGROUND
	UIColor*								m_BackgroundColor;
	
    //ALIGNMENT
	UIControlContentHorizontalAlignment		m_HorizontalAlignment;
	UIControlContentVerticalAlignment		m_VerticalAlignment;
	
    //BORDERS
	CGFloat									m_BorderWidth;
	UIColor*								m_BorderColor;
	CGFloat									m_BorderCornerRadius;
    
    //ColorSlots
    UIColor*                                m_ColorSlot1;
	UIColor*								m_ColorSlot2;
	UIColor*								m_ColorSlot3;
    
    //TABLEVIEW_CELL_STYLE
    NSString*                               m_iosStyle;
	
    //IOS_SYTLES
	UIBarStyle								m_BarStyle;
    
    //IMAGESLOT 1 PARAMS
    NSString*                               m_ImageUrl;
    NSInteger                               m_ImageHeight;
    NSInteger                               m_ImageWidth;
    
    //IMAGESLOT 2 PARAMS   
    NSString*                               m_ImageUrl2;
    NSInteger                               m_ImageHeight2;
    NSInteger                               m_ImageWidth2;
    
    
    //IMAGESLOT 3 PARAMS   
    NSString*                               m_ImageUrl3;
    NSInteger                               m_ImageHeight3;
    NSInteger                               m_ImageWidth3;
    
    //IMAGESLOT 4 PARAMS
    NSString*                               m_ImageUrl4;
    NSInteger                               m_ImageHeight4;
    NSInteger                               m_ImageWidth4;
    
    //IMAGESLOT 5 PARAMS
    NSString*                               m_ImageUrl5;
    NSInteger                               m_ImageHeight5;
    NSInteger                               m_ImageWidth5;
    
    //IMAGESLOT 6 PARAMS
    NSString*                               m_ImageUrl6;
    NSInteger                               m_ImageHeight6;
    NSInteger                               m_ImageWidth6;

    //IMAGESLOT 7 PARAMS
    NSString*                               m_ImageUrl7;
    NSInteger                               m_ImageHeight7;
    NSInteger                               m_ImageWidth7;

    //IMAGESLOT 8 PARAMS
    NSString*                               m_ImageUrl8;
    NSInteger                               m_ImageHeight8;
    NSInteger                               m_ImageWidth8;

    //IMAGESLOT 9 PARAMS
    NSString*                               m_ImageUrl9;
    NSInteger                               m_ImageHeight9;
    NSInteger                               m_ImageWidth9;

    //IMAGESLOT 10 PARAMS
    NSString*                               m_ImageUrl10;
    NSInteger                               m_ImageHeight10;
    NSInteger                               m_ImageWidth10;

    //IMAGESLOT 11 PARAMS
    NSString*                               m_ImageUrl11;
    NSInteger                               m_ImageHeight11;
    NSInteger                               m_ImageWidth11;

    //IMAGESLOT 12 PARAMS
    NSString*                               m_ImageUrl12;
    NSInteger                               m_ImageHeight12;
    NSInteger                               m_ImageWidth12;

    //IMAGESLOT 13 PARAMS
    NSString*                               m_ImageUrl13;
    NSInteger                               m_ImageHeight13;
    NSInteger                               m_ImageWidth13;

    //IMAGESLOT 14 PARAMS
    NSString*                               m_ImageUrl14;
    NSInteger                               m_ImageHeight14;
    NSInteger                               m_ImageWidth14;

    //IMAGESLOT 15 PARAMS
    NSString*                               m_ImageUrl15;
    NSInteger                               m_ImageHeight15;
    NSInteger                               m_ImageWidth15;

    //IMAGESLOT 16 PARAMS
    NSString*                               m_ImageUrl16;
    NSInteger                               m_ImageHeight16;
    NSInteger                               m_ImageWidth16;

    //IMAGESLOT 17 PARAMS
    NSString*                               m_ImageUrl17;
    NSInteger                               m_ImageHeight17;
    NSInteger                               m_ImageWidth17;

    //IMAGESLOT 18 PARAMS
    NSString*                               m_ImageUrl18;
    NSInteger                               m_ImageHeight18;
    NSInteger                               m_ImageWidth18;

    NSMutableDictionary*                    m_VisualStates;
	        
    // FREEGRADIENT
	NSMutableArray*                         m_GradientColors;
    
    //SubStyles
     NSMutableDictionary*                    m_subStyles;
    
    //SearchBar transcluent
    BOOL                                    m_BoolSlot;
    
}

-(uint64_t)getStyleFlags DEPRECATED_ATTRIBUTE;
-(uint8_t)getBackgroundFlags DEPRECATED_ATTRIBUTE;
-(uint8_t)getBorderFlags DEPRECATED_ATTRIBUTE;
-(UIColor*)getBackgroundColor DEPRECATED_ATTRIBUTE;
-(UIControlContentHorizontalAlignment)getHorizontalAlignment DEPRECATED_ATTRIBUTE;
-(UIControlContentVerticalAlignment)getVerticalAlignment DEPRECATED_ATTRIBUTE;
-(CGFloat)getBorderWidth DEPRECATED_ATTRIBUTE;
-(UIColor*)getBorderColor DEPRECATED_ATTRIBUTE;
-(CGFloat)getBorderCornerRadius DEPRECATED_ATTRIBUTE;
-(UIBarStyle)getBarStyle DEPRECATED_ATTRIBUTE;
-(UIColor*)getColorSlot1 DEPRECATED_ATTRIBUTE;
-(UIColor*)getColorSlot2 DEPRECATED_ATTRIBUTE;
-(UIColor*)getColorSlot3 DEPRECATED_ATTRIBUTE;
-(NSString*)getIosStyle DEPRECATED_ATTRIBUTE;
-(BOOL)getBoolSlot DEPRECATED_ATTRIBUTE;

@property (nonatomic, readonly, assign) uint64_t styleFlags;
@property (nonatomic, readonly, assign) uint8_t backgroundFlags;
@property (nonatomic, readonly, assign) uint8_t borderFlags;
@property (nonatomic, readonly, assign) uint64_t timeStamp;
@property (nonatomic, retain) UIColor* backgroundColor;
@property (nonatomic, retain) NSMutableArray* gradientColors;
@property (nonatomic, assign) UIControlContentHorizontalAlignment horizontalAlignment;
@property (nonatomic, assign) UIControlContentVerticalAlignment verticalAlignment;
@property (nonatomic, assign) CGFloat borderWidth;
@property (nonatomic, retain) UIColor* borderColor;
@property (nonatomic, assign) CGFloat borderCornerRadius;
@property (nonatomic, assign) UIBarStyle barStyle;
@property (nonatomic, retain) UIColor* colorSlot1;
@property (nonatomic, retain) UIColor* colorSlot2;
@property (nonatomic, retain) UIColor* colorSlot3;
@property (nonatomic, retain) NSString* iosStyle;
@property (nonatomic, assign) BOOL boolSlot;
@property (nonatomic, retain) NSString* imageUrl;
@property (nonatomic, assign) NSInteger imageHeight;
@property (nonatomic, assign) NSInteger imageWidth;

@property (nonatomic, retain) NSString* imageUrl2;
@property (nonatomic, assign) NSInteger imageHeight2;
@property (nonatomic, assign) NSInteger imageWidth2;

@property (nonatomic, retain) NSString* imageUrl3;
@property (nonatomic, assign) NSInteger imageHeight3;
@property (nonatomic, assign) NSInteger imageWidth3;

@property (nonatomic, retain) NSString* imageUrl4;
@property (nonatomic, assign) NSInteger imageHeight4;
@property (nonatomic, assign) NSInteger imageWidth4;

@property (nonatomic, retain) NSString* imageUrl5;
@property (nonatomic, assign) NSInteger imageHeight5;
@property (nonatomic, assign) NSInteger imageWidth5;

@property (nonatomic, retain) NSString* imageUrl6;
@property (nonatomic, assign) NSInteger imageHeight6;
@property (nonatomic, assign) NSInteger imageWidth6;

@property (nonatomic, retain) NSString* imageUrl7;
@property (nonatomic, assign) NSInteger imageHeight7;
@property (nonatomic, assign) NSInteger imageWidth7;

@property (nonatomic, retain) NSString* imageUrl8;
@property (nonatomic, assign) NSInteger imageHeight8;
@property (nonatomic, assign) NSInteger imageWidth8;

@property (nonatomic, retain) NSString* imageUrl9;
@property (nonatomic, assign) NSInteger imageHeight9;
@property (nonatomic, assign) NSInteger imageWidth9;

@property (nonatomic, retain) NSString* imageUrl10;
@property (nonatomic, assign) NSInteger imageHeight10;
@property (nonatomic, assign) NSInteger imageWidth10;

@property (nonatomic, retain) NSString* imageUrl11;
@property (nonatomic, assign) NSInteger imageHeight11;
@property (nonatomic, assign) NSInteger imageWidth11;

@property (nonatomic, retain) NSString* imageUrl12;
@property (nonatomic, assign) NSInteger imageHeight12;
@property (nonatomic, assign) NSInteger imageWidth12;

@property (nonatomic, retain) NSString* imageUrl13;
@property (nonatomic, assign) NSInteger imageHeight13;
@property (nonatomic, assign) NSInteger imageWidth13;

@property (nonatomic, retain) NSString* imageUrl14;
@property (nonatomic, assign) NSInteger imageHeight14;
@property (nonatomic, assign) NSInteger imageWidth14;

@property (nonatomic, retain) NSString* imageUrl15;
@property (nonatomic, assign) NSInteger imageHeight15;
@property (nonatomic, assign) NSInteger imageWidth15;

@property (nonatomic, retain) NSString* imageUrl16;
@property (nonatomic, assign) NSInteger imageHeight16;
@property (nonatomic, assign) NSInteger imageWidth16;

@property (nonatomic, retain) NSString* imageUrl17;
@property (nonatomic, assign) NSInteger imageHeight17;
@property (nonatomic, assign) NSInteger imageWidth17;

@property (nonatomic, retain) NSString* imageUrl18;
@property (nonatomic, assign) NSInteger imageHeight18;
@property (nonatomic, assign) NSInteger imageWidth18;

@property (nonatomic, retain) NSMutableDictionary* subStyles;
@property (nonatomic, retain) NSMutableDictionary* visualStates;
@property (nonatomic, retain) UIColor* shadowColor;

-(id) init;

-(id) copyWithZone:(NSZone*)zone;

@end

/**
 * applied on controls that have a font property
 */
@interface MAFUIStyleWithFont : MAFUIStyle {
	uint8_t			m_FontFlags;
	UIFont*			m_Font;
	UIColor*		m_ForegroundColor;

	UIFont*			m_DetailsFont;
	UIColor*		m_DetailsForegroundColor;
}

@property (nonatomic, retain) UIFont* font;
@property (nonatomic, retain) UIColor* foregroundColor;
@property (nonatomic, retain) UIFont* detailsFont;
@property (nonatomic, retain) UIColor* detailsForegroundColor;
@property (nonatomic, readonly, assign) uint8_t fontFlags;

-(id) init;
-(id) copyWithZone:(NSZone*)zone;

-(UIFont*)getFont DEPRECATED_ATTRIBUTE;
-(UIColor*)getForegroundColor DEPRECATED_ATTRIBUTE;
-(UIFont*)getDetailsFont DEPRECATED_ATTRIBUTE;
-(UIColor*)getDetailsForegroundColor DEPRECATED_ATTRIBUTE;
-(uint8_t)getFontFlags DEPRECATED_ATTRIBUTE;

@end


@interface MAFGradientStop : NSObject {
    UIColor* m_Color;
    float m_Location;
}

-(id) initWithColor:(UIColor*) color location:(float) location;

@property (nonatomic, retain) UIColor* color;
@property (nonatomic, assign) float location;

@end
