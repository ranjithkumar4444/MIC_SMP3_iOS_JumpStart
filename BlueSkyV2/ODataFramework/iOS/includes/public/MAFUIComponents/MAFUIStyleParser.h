//
//  MAFUIStyleParser.h
//  MAFUIComponents
//
//  Created by Farkas, Zoltan on 11/04/11.
//  Copyright 2011 SAP AG. All rights reserved.
//
// XXX: PROTOTYPE/TEST ONLY, WILL BE CHANGED!

#import <Foundation/Foundation.h>
#import "MAFGenericParser.h"

@interface MAFUIStyleParser : MAFGenericParser {
}
-(id) init;
+(BOOL)loadStyleWithPath:(NSString*)filePath withError:(NSError **)anError;
+(BOOL)loadSAPDefaultStyle;
@end
