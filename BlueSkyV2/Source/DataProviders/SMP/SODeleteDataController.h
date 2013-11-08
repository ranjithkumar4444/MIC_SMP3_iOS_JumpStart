//
//  BSSMPMaterialGroupDataController.h
//  BlueSky
//
//  Created by Jones, Jeffry on 7/11/13.
//  Copyright (c) 2013 SAP MIC. All rights reserved.
//

#import "ODataController.h"
#import "Cache.h"
#import "RequestDelegate.h"
#import "Requesting.h"
#import "ODataFeed.h"


@interface SODeleteDataController : ODataController

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


- (void)deleteSOItemWithSOItem:(ODataEntry *)SOItem;


-(void)updateCache;

-(void)setupCache;


@end