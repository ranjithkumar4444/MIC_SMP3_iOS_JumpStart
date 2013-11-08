//
//  MAFUIStyleCatalog.h
//  MAFUIComponentsTest
//
//  Created by Farkas, Zoltan on 11/03/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MAFUIStyle.h"

extern NSString* MAF_BASE_STYLE_NAME;

@interface MAFUIStyleCatalog : NSObject {
}

#pragma mark -
#pragma mark Public API
+(MAFUIStyleCatalog*) uiStyleCatalog;

-(MAFUIStyle*) styleByName:(NSString*)styleName;
-(void) addStyle:(MAFUIStyle*)style styleName:(NSString*)styleName;
-(void) removeStyle:(NSString*)styleName;

@end
