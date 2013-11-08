//
//  ODataDataController.h
//  Flights
//
//  Created by Damien Murphy
//  Copyright (c) 2013 MIC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RequestDelegate.h"
#import "ODataServiceDocument.h"
#import "ODataCollection.h"
#import "ODataEntry.h"
#import "Requesting.h"
#import "ODataXMLBuilder.h"
#import "CredentialsData.h"

#import "RequestBuilder.h"
#import "Request.h"
#import "ConnectivitySettings.h"
#import "Constants.h"
#import "KeychainHelper.h"
#import "CredentialsData.h"
#import "ODataDataParser.h"
#import "ODataServiceDocumentParser.h"
#import "ODataMetaDocumentParser.h"

#import "BSDataProvider.h"
#import "Cache.h"
#import "RequestDelegate.h"
#import "Requesting.h"
#import "ODataFeed.h"
#import "ODataController.h"


@interface ODataController : NSObject <RequestDelegate>
{
@protected
    NSString * _serviceDocumentURL;
    NSString * _metadataDocumentURL;
    NSString * _requestURL;
    NSString * _odataCollectionName;
    CredentialsData *_credentials;
    
    BSDataResponseBlock _odataResponseBlock;
    BSDataResponseBlock _odataErrorBlock;
}
//Implementation Specific Variables
@property (nonatomic, strong) NSString *serviceDocumentURL;
@property (nonatomic, strong) NSString *metadataDocumentURL;
@property (nonatomic, strong) NSString *requestURL;
@property (nonatomic, strong) NSString *odataCollectionName;

//Application Connection ID
@property (nonatomic, strong) NSString *applicationConnectionID;

//Internal Variables
@property (nonatomic, strong) ODataServiceDocument *serviceDocument;
@property (nonatomic, strong) ODataCollection      *odataCollection;
@property (nonatomic, strong) ODataDataParser      *odataParser;

@property (nonatomic, strong) CredentialsData      *credentials;

@property (nonatomic, strong) BSDataResponseBlock odataResponseBlock;
@property (nonatomic, strong) BSDataResponseBlock odataErrorBlock;

@property (nonatomic,strong) ODataFeed *feed;

@property (nonatomic, strong) id<Caching> cache;

//Implementation Specific Functions
- (void) setup;

- (BOOL) loadServiceDocumentAndMetaData;

- (void)getOData:(NSDictionary *)params onCompletion: (BSDataResponseBlock) responseBlock onError: (BSErrorResponseBlock) errorBlock;

- (void) getODataCompleted: (id <Requesting>) request;

-(void)setupCache;

@end
