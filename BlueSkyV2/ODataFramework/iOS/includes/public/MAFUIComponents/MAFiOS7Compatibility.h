//
//  MAFiOS7Compatibility.h
//  MAFUIComponents
//
//  Created by Metzing, Daniel on 8/14/13.
//
//

#import <Foundation/Foundation.h>

#if __IPHONE_OS_VERSION_MAX_ALLOWED < 70000
#warning UIRectEdge defined

typedef NS_OPTIONS(NSUInteger, UIRectEdge) {
    UIRectEdgeNone   = 0,
    UIRectEdgeTop    = 1 << 0,
    UIRectEdgeLeft   = 1 << 1,
    UIRectEdgeBottom = 1 << 2,
    UIRectEdgeRight  = 1 << 3,
    UIRectEdgeAll    = UIRectEdgeTop | UIRectEdgeLeft | UIRectEdgeBottom | UIRectEdgeRight
};

#endif


@interface MAFiOS7Compatibility : NSObject

+ (BOOL) isIOS7;

@end
