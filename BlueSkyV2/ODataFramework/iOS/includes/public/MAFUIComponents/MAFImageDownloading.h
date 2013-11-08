//
//  MAFImageDownloading.h
//  MAFUIComponents
//

//  Copyright (c) 2012 SAP. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol MAFImageDownloading <NSObject>

@required

/*
 * implement this method if you would like to be notified when the download is completed
 * params: first element of the array is the url of the image, the second element is image downloaded
 */
-(void) imageDownloaded: (NSDictionary*) params;

@end
