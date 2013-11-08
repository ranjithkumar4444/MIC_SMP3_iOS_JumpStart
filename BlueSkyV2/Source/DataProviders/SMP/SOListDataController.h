//
//  BSSMPMaterialGroupDataController.h
//  BlueSky
//
//  Created by Jones, Jeffry on 7/11/13.
//  Copyright (c) 2013 SAP MIC. All rights reserved.
//

#import "ODataController.h"

#import <Foundation/Foundation.h>
#import "RequestDelegate.h"
#import "ODataServiceDocument.h"
#import "ODataCollection.h"
#import "ODataEntry.h"
#import "Requesting.h"
#import "ODataXMLBuilder.h"

#import "Cache.h"
#import "ODataFeed.h"


@interface SOListDataController : ODataController

//OFFLINE STUFF

@property (nonatomic,copy) NSMutableArray *SOList;
@property (nonatomic,strong) ODataCollection *SOCollection;
@property (nonatomic,copy) NSArray *serverEntriesCopyList;
@property (nonatomic,copy) NSArray *locallyModifiedEntriesList;
@property (nonatomic,strong) NSMutableArray *displayRowsArray;
@property (nonatomic, strong) id<Caching> cache;
@property (nonatomic,strong) ODataFeed *feed;
@property (nonatomic,strong) ODataSchema *metaDataDoc;





//Implementation Specific Functions
- (void)getOData:(NSDictionary *)params onCompletion: (BSDataResponseBlock) responseBlock onError: (BSErrorResponseBlock) errorBlock;





@end