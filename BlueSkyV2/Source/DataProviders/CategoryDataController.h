/*
 
 CategoryDataController.h
 Created by Ivan Reyes
 Copyright (c) 2013 MIC. All rights reserved.
 
 */

#import <Foundation/Foundation.h>

#import "RequestDelegate.h"
#import "ODataServiceDocument.h"
#import "ODataCollection.h"
#import "ODataEntry.h"
#import "Requesting.h"
#import "Request.h"
#import "Constants.h"
#import "KeychainHelper.h"
#import "CredentialsData.h"
#import "ConnectivitySettings.h"
#import "ODataXMLBuilder.h"
#import "RequestBuilder.h"
#import "Cache.h"
#import "ODataFeed.h"

@interface CategoryDataController : NSObject <RequestDelegate>
{
    CredentialsData *_credentials;
}

@property (nonatomic, copy) NSMutableArray *categoryList;
@property (nonatomic, strong) ODataServiceDocument *serviceDocument;
@property (nonatomic, strong) ODataCollection *categoryCollection;


@property (nonatomic, copy) NSArray *serverEntriesCopyList;
@property (nonatomic, copy) NSArray *locallyModifiedEntriesList;

@property (nonatomic, strong) NSMutableArray *displayRowsArray;
@property (nonatomic, strong) id<Caching> cache;
@property (nonatomic, strong) ODataFeed * feed;
@property (nonatomic, strong) ODataServiceDocument *storedServiceDocument;
@property (nonatomic, strong) ODataSchema* metaDataDoc;

@property (nonatomic, strong)UIAlertView *m_activityIndicatorView;

/* Application Connection ID */
@property (nonatomic, strong) NSString *applicationConnectionID;

// BSDataController singleton instance.
+ (CategoryDataController *)uniqueInstance;

- (BOOL)loadServiceDocumentAndMetaData;
- (void)loadCategoryCollectionCompleted:(id <Requesting>)request;
- (void)loadCategoryCollectionWithDidFinishSelector:(SEL)aFinishSelector forUrl:(NSString *)url;

-(void)setupCache;
-(void)updateCache;
-(void)onMergeComplete:(NSNotification *)notification;

-(void)reqFin:(id<Requesting>)request;
-(void)reqFail:(id<Requesting>)request;
-(void)requestFailed:(Request *)request;



@end