/*
 
 ProductDataController.h
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

@interface ProductDataController : NSObject <RequestDelegate> {
    CredentialsData *_credentials;
}


@property (nonatomic, copy) NSMutableArray *productList;
@property (nonatomic, strong) ODataServiceDocument *serviceDocument;
@property (nonatomic, strong) ODataCollection *productCollection;
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

/* BSDataController singleton instance. */
+ (ProductDataController *)uniqueInstance;

- (BOOL)loadServiceDocumentAndMetaData;
- (void)loadProductCollectionCompleted:(id <Requesting>)request;
- (void)loadProductCollectionWithDidFinishSelector:(SEL)aFinishSelector forUrl:(NSString *)url;
- (void)loadProductWithID:(NSString *)productID andDidFinishSelector:(SEL)aFinishSelector;

- (ODataEntry *)objectInListAtIndex:(NSUInteger)theIndex;

- (void)setStringValueForEntry:(ODataEntry *)aSDMEntry withValue:(NSString *)aValue forSDMPropertyWithName:(NSString *)aName;
- (NSString *)getXMLForEntry:(ODataEntry *)entry andOperation:(const enum TEN_ENTRY_OPERATIONS) operation error:(NSError * __autoreleasing *)error;
- (NSString *)getJSONForEntry:(ODataEntry *)entry andOperation:(const enum TEN_ENTRY_OPERATIONS) operation error:(NSError * __autoreleasing *)error;

-(void)setupCache;
-(void)updateCache;
-(void)clearTheCache;
-(void)onMergeComplete:(NSNotification *)notification;

-(void)reqFin:(id<Requesting>)request;
-(void)reqFail:(id<Requesting>)request;
-(void)requestFailed:(Request *)request;



@end