//
//  BSSMPMaterialGroupDataController.m
//  BlueSky
//
//  Created by Jones, Jeffry on 7/11/13.
//  Copyright (c) 2013 SAP MIC. All rights reserved.
//

#import "SOCreateDataController.h"
#import "BSMaterialGroup.h"
#import "Constants.h"
#import "ODataLink.h"
#import "BSSalesOrderCreate.h"
#import "BSSalesOrder.h"


#import "RequestBuilder.h"
#import "Request.h"



@implementation SOCreateDataController

- (id) init {
    if (self = [super init]) {
        
        //Endpoint credentials (Load them from storage if possible)
        NSError *error = nil;
        _credentials = [KeychainHelper loadCredentialsAndReturnError: &error];
        if (error) {
            _credentials = [[CredentialsData alloc] initWithUsername: @"MICDEMO" andPassword: @"welcome"];
        }

        //OData Collection Name
        _odataCollectionName = kSOHeadersCollection;

        //Build the Service Document URL ( http://<smp_server>:<smp_port>/<application_id>/ )
        _serviceDocumentURL = [[[ConnectivitySettings serviceURL] substringToIndex:[[ConnectivitySettings serviceURL] length]-1] stringByAppendingString:@"/"];
        
        //Build the Metadata Document URL ( http://<smp_server>:<smp_port>/<application_id>.grp/$metadata )
        _metadataDocumentURL = [NSString stringWithFormat:@"%@%@", _serviceDocumentURL, kMetadata];

        
        // ADDED FOR OFFLINE
        [RequestBuilder setDelegate:self];
        [RequestBuilder setDidFinishSelector:@selector(reqFin:)];
        [RequestBuilder setDidFailSelector:@selector(reqFail:)];
        
        
        
        //call the super class setup method
        [self setup];

        
        
        // OFFLINE STUFF
        [self setupCache];
        self.serverEntriesCopyList = [[NSArray alloc] init];
        self.locallyModifiedEntriesList = [[NSArray alloc] init];
        
        self.displayRowsArray = [[NSMutableArray alloc] init];
        
        self.serverEntriesCopyList = [self.cache readEntriesForUrlKey:@"SalesOrderItems" withError:&error];//SOItems
        self.locallyModifiedEntriesList = [self.cache readEntriesLocalForEntryId:nil forEntityType:@"SalesOrderItems" withError:&error];//SOItems
        [self.displayRowsArray setArray:self.serverEntriesCopyList];
        NSLog(@"what's in self.serverEntriesCopyList?: %@",self.serverEntriesCopyList);
        NSLog(@"what's in self.locallyModifiedEntriesList?: %@",self.locallyModifiedEntriesList);
        NSLog(@"what's in displayRowsArray?: %@",self.displayRowsArray);
        
        
        self.soItemsCollection = [self.serviceDocument.schema getCollectionByName:@"SalesOrderItems"]; //SOItems
    }
    return self;
}

/*
 This is our request builder and request sender
 */
- (void)getOData:(NSDictionary *)params onCompletion: (BSDataResponseBlock) responseBlock onError: (BSErrorResponseBlock) errorBlock {
    NSLog(@"Get Sales Order Reuqest Called");
    
    BSSalesOrderCreate * salesOrder = [params objectForKey:@"salesOrders"];
    
    ODataEntry * salesOrderEntry = [[ODataEntry alloc]initWithEntitySchema:self.odataCollection.entitySchema];
    BSSalesOrder *salesOrderIn = (BSSalesOrder *)salesOrder.soItems[0];
    
    ODataEntry *newOrder = [[ODataEntry alloc] initWithEntitySchema:self.odataCollection.entitySchema];
    [((ODataPropertyValueString*)[newOrder getPropertyValueByPath:kSalesOrderId ]) setValue:@"0"];
    [((ODataPropertyValueString*)[newOrder getPropertyValueByPath:kDocumentType ]) setValue:@"TA"];
    [((ODataPropertyValueString*)[newOrder getPropertyValueByPath:kCustomerId ]) setValue:@"0000006677"];
    [((ODataPropertyValueString*)[newOrder getPropertyValueByPath:kSalesOrg ]) setValue:@"3000"];
    [((ODataPropertyValueString*)[newOrder getPropertyValueByPath:kDistChannel ]) setValue:@"10"];
    [((ODataPropertyValueString*)[newOrder getPropertyValueByPath:kDivision ]) setValue:@"00"];    
    [((ODataPropertyValueDecimal*)[newOrder getPropertyValueByPath:kOrderValue ]) setDecimalValue:[[NSDecimalNumber alloc] initWithDouble:600.00]];
    

    
    ODataEntry *newItem1 = [[ODataEntry alloc] initWithEntitySchema:self.soItemsCollection.entitySchema];
    [((ODataPropertyValueString*)[newItem1 getPropertyValueByPath:kSalesOrderId ]) setValue:@"0"];
    [((ODataPropertyValueString*)[newItem1 getPropertyValueByPath:kItem ]) setValue:@"000010"];
    [((ODataPropertyValueString*)[newItem1 getPropertyValueByPath:kMaterial ]) setValue:salesOrderIn.material];
    [((ODataPropertyValueString*)[newItem1 getPropertyValueByPath:kPlant ]) setValue:salesOrderIn.plant];
    [((ODataPropertyValueDecimal*)[newItem1 getPropertyValueByPath:kQuantity ]) setDecimalValue:[[NSDecimalNumber alloc] initWithDouble:[salesOrderIn.quantity intValue]]];
    [((ODataPropertyValueDecimal*)[newItem1 getPropertyValueByPath:kValue ]) setDecimalValue:[[NSDecimalNumber alloc] initWithDouble:0.00]];
    
    /*
    ODataEntry *newItem2 = [[ODataEntry alloc] initWithEntitySchema:self.soItemsCollection.entitySchema];
    [self setStringValueForEntry:newItem2 withValue:@"0" forSDMPropertyWithName:kSalesOrderId];
    [self setStringValueForEntry:newItem2 withValue:@"00020" forSDMPropertyWithName:kItem];
    [self setStringValueForEntry:newItem2 withValue:@"M-06" forSDMPropertyWithName:kMaterial];
    [self setStringValueForEntry:newItem2 withValue:@"1200" forSDMPropertyWithName:kPlant];
    [self setDecimalValueForEntry:newItem2 withValue:[[NSDecimalNumber alloc] initWithDouble:200.000] forSDMPropertyWithName:kQuantity];
    [self setDecimalValueForEntry:newItem2 withValue:[[NSDecimalNumber alloc] initWithDouble:400.00] forSDMPropertyWithName:kValue];
    
    */
    NSMutableArray *itemEntries = [[NSMutableArray alloc] init];
    
    NSLog(@"newItem1: %@",newItem1);
    
    [itemEntries addObject:newItem1];
    //[itemEntries addObject:newItem2];
    
    NSMutableDictionary *itemsDictionary = [[NSMutableDictionary alloc] init];
    itemsDictionary[@"SalesOrderItems"] = itemEntries; //SOItems
    
    salesOrderEntry = [self addRelativeLinksToEntry:newOrder fromDictionary:itemsDictionary];
    
    //Create the request url to call the OData REST service
    NSString *url = [NSString stringWithFormat:@"%@%@",_serviceDocumentURL , kSOHeadersCollection];
    
    NSLog(@"Sales Order Request URL=%@", url);
    
    id<Requesting> request = [RequestBuilder requestWithURL:[[NSURL alloc] initWithString:url]];
    [request setRequestMethod:@"POST"];
    [RequestBuilder setRequestType:HTTPRequestType];
    [RequestBuilder enableXCSRF:YES];
    
    NSString *payload = nil;
    NSError *error = nil;
    NSString *contentType = nil;
    //Construct JSON payload if set
    if ([ConnectivitySettings useJSON]) {
        [request addRequestHeader:@"Accept" value:kApplicationJSON];
        payload = [self getJSONForEntry:salesOrderEntry andOperation:ENTRY_OPERATION_CREATE error:&error];
        contentType = [NSString stringWithFormat:@"%@; %@", kApplicationJSON, kCharSetUTF8];
    } else {
        payload = [self getXMLForEntry:salesOrderEntry andOperation:ENTRY_OPERATION_CREATE error:&error];
        contentType = [NSString stringWithFormat:@"%@; %@", kApplicationAtom, kCharSetUTF8];
    }
    NSLog(@"*****************************");
    NSLog(@"SO CREATE Print Payload: %@", payload);
    NSLog(@"*****************************");
    
    [request addRequestHeader:@"Content-Type" value:contentType];
    
    NSMutableData *data = [NSMutableData dataWithData:[payload dataUsingEncoding:NSUTF8StringEncoding]];
    [request setPostBody:data];
    [request addRequestHeader:kX_SMP_APPCID value:self.applicationConnectionID];
    [request setDelegate:self];
    
    
    //Set this class as the request delegate
    [request setDelegate: self];
    
    //Set the response and error callbacks
    _odataResponseBlock = responseBlock;
    _odataErrorBlock = errorBlock;
    


    NSLog(@"salesOrder: %@",salesOrder);
    NSLog(@"salesOrder class: %@",[salesOrder class ]);
    
    NSLog(@"salesOrderEntry : %@", salesOrderEntry );
    
    NSLog(@"salesOrderEntryID : %@", [salesOrderEntry getEntryID] );
    
    NSLog(@"salesOrderEntry class: %@",[ salesOrderEntry class]);
    
    // OFFLINE STUFF
    NSMutableArray *entryIdArray = [NSMutableArray array];
    
   // [entryIdArray addObject:salesOrder];
    
    NSLog(@"salesOrderEntry ID: %@",[salesOrderEntry getEntryID]);
    
    [entryIdArray addObject: salesOrderEntry ];
    

    
    NSLog(@"entryIdArray : %@", entryIdArray );
    
    [request setCacheEntryIdList:entryIdArray];
    
 
    //Set finish selector for request to that of the super class
    request.didFinishSelector = @selector(getODataCompleted:);
    
    
    
    NSLog(@"Starting initial asynchronous GET request for HANA");
    [request startAsynchronous];
    
}

- (ODataEntry *)addRelativeLinksToEntry:(ODataEntry *)entry fromDictionary:(NSMutableDictionary *)aDictionary
{
    NSString *relLinkBaseUrl = @"http://schemas.microsoft.com/ado/2007/08/dataservices/related/";
    NSMutableDictionary *allRelativeLinks = [@{}mutableCopy];
    // Iterate all key-values in the dictionary and for each add a relative link to the SDMODataEntry object
    for (NSString *key in [aDictionary allKeys]) {
        NSArray *inlinedSDMEntriesArray = aDictionary[key];
        if ([inlinedSDMEntriesArray count] > 0) {
            NSString *relLinkUrl = [relLinkBaseUrl stringByAppendingString:key];
            // add links
            ODataLink *link = [[ODataLink alloc] initWithHRef:relLinkUrl
                                                   andLinkRel:relLinkUrl
                                                  andLinkType:@"application/atom+xml;type=feed"
                                                 andLinkTitle:key];
            // add entries to dictionary
            [entry addLink:link];
            allRelativeLinks[relLinkUrl] = inlinedSDMEntriesArray;
        }
    }
    
    if ([allRelativeLinks count] > 0) {
        [entry setInlinedRelatedEntries:allRelativeLinks];
    }
    return entry;
}

//Here we convert the ODataEntry Array into our business objects
//This method gets called internally from the super classes 'getODataCompleted:' method which parses the raw data into an ODataEntry Array
-(NSArray *)createBusinessObjects:(NSArray *)oDataEntries
{
    
    
    
    NSMutableArray *businessObjects = [NSMutableArray new];
    // Create business objects to be consumed by the response block
    if (oDataEntries && [oDataEntries count] > 0) {
        int count = 0;
        
        //MaterialGroup Business Object
        BSSalesOrderCreate *so;
        
        
        
        for(ODataEntry * entry in oDataEntries){
            
            NSString * orderID = [[entry getPropertyValueByPath:kSalesOrderId] getValue];
            NSString * documentType = [[entry getPropertyValueByPath:kDocumentType] getValue];
            NSString * documentDate = [[entry getPropertyValueByPath:kDocumentDate] getValue];
            NSString * customerID = [[entry getPropertyValueByPath:kCustomerId] getValue];
            NSString * salesOrg = [[entry getPropertyValueByPath:kSalesOrg] getValue];
            NSString * distChannel = [[entry getPropertyValueByPath:kDistChannel] getValue];
            NSString * division = [[entry getPropertyValueByPath:kDivision] getValue];
            NSString * orderValue = [[entry getPropertyValueByPath:kOrderValue] getValue];
            NSString * currency = [[entry getPropertyValueByPath:kCurrency] getValue];
            
            NSString * salesOrderID = [[entry getPropertyValueByPath:kSalesOrderId] getValue];
            NSString * item = [[entry getPropertyValueByPath:kItem] getValue];
            NSString * material = [[entry getPropertyValueByPath:kMaterial] getValue];
            NSString * description = [[entry getPropertyValueByPath:kDescription] getValue];
            NSString * plant = [[entry getPropertyValueByPath:kPlant] getValue];
            NSString * quantity = [[entry getPropertyValueByPath:kQuantity] getValue];
            NSString * uoM = [[entry getPropertyValueByPath:kUoM] getValue];
            NSString * itemDlvyStaTx = [[entry getPropertyValueByPath:kItemDlvyStaTx] getValue];
            NSString * itemDlvyStatus = [[entry getPropertyValueByPath:kItemDlvyStatus] getValue];
            
            so = [BSSalesOrderCreate new];
            so.salesOrderId = orderID;
            so.documentType = documentType;
            so.documentDate = documentDate;
            so.customerId = customerID;
            so.salesOrg = salesOrg;
            so.distChannel = distChannel;
            so.division = division;
            so.orderValue = orderValue;
            so.currency = currency;

            
            [businessObjects addObject: so];
            
            NSLog(@"SO[%d] Item=%@ Quantity=%@", count++, item, quantity);
        }
    }
    [self updateCache];
    return businessObjects;
}

- (NSString *)getXMLForEntry:(ODataEntry *)entry andOperation:(const enum TEN_ENTRY_OPERATIONS) operation error:(NSError * __autoreleasing *)error {
    //if ([entry isValid]) {
    ODataEntryBody *entryXml = nil;
    @try {
        
        for(ODataLink * link in entry.inlinedRelatedEntries)
        {
            NSLog(@"Link: ");
        }
        entryXml = buildODataEntryRequestBody(entry, operation, self.serviceDocument, YES, BUILD_STYLE_ATOM_XML);
        
        NSString *noticeMsg = [NSString stringWithFormat:@"xml:\n %@\nmethod: %@", entryXml.body, entryXml.method];
        NSLog(@"%@", noticeMsg);
        
        return [entryXml body];
    }
    @catch (ODataParserException *e) {
        NSString *localizedMessage = NSLocalizedString(@"ODataDataController: Exception during building entry xml: %@", @"Exception during building entry xml: %@");
        NSString *exceptionMsg = [NSString stringWithFormat:localizedMessage, e.detailedError];
        NSLog(@"%@", exceptionMsg);
    }
    /*}
     else {
     NSString *errorMsg = @"The entry is not a valid entry";
     NSLog(@"%@", errorMsg);
     }*/
}

- (NSString *)getJSONForEntry:(ODataEntry *)entry andOperation:(const enum TEN_ENTRY_OPERATIONS) operation error:(NSError * __autoreleasing *)error {
    if ([entry isValid]) {
        ODataEntryBody *entryJSON = nil;
        @try {
            entryJSON = buildODataEntryRequestBody(entry, operation, self.serviceDocument, YES, BUILD_STYLE_JSON);
            
            NSString *noticeMsg = [NSString stringWithFormat:@"json:\n %@\nmethod: %@", entryJSON.body, entryJSON.method];
            NSLog(@"%@", noticeMsg);
            
            return [entryJSON body];
        }
        @catch (ODataParserException *e) {
        	NSString *localizedMessage = NSLocalizedString(@"ODataDataController: Exception during building entry json: %@", @"Exception during building entry json: %@");
            NSString *exceptionMsg = [NSString stringWithFormat:localizedMessage, e.detailedError];
            NSLog(@"%@", exceptionMsg);
        }
    }
    else {
        NSString *errorMsg = @"ODataDataController: The entry is not a valid entry";
        NSLog(@"%@", errorMsg);
    }
}








-(void)reqFin:(id<Requesting>)request
{
    NSLog(@"T13");
    //NSError *error;
    
    
    NSMutableArray *entryIdArray = [ request cacheEntryIdList];
    for (NSString *entryId in entryIdArray)
    {
        //[self.cache clearLocalEntryForEntryId:entryId withError:&error];
    }
    
    NSLog(@"******************************************************************************\n");
    NSLog(@"CREATE REQUEST COMPLETED SUCCESSFULLY DF\n");
    NSLog(@"******************************************************************************\n");
    
}




-(void)reqFail:(id<Requesting>)request
{
    NSLog(@"T14");
    NSLog(@"%d\n,%@\n, %@\n %@\n",[request responseStatusCode],[request responseStatusMessage],[[request error] description],[request responseString]);
}




-(void)updateCache {
    NSLog(@"T24");
    NSError *error;
    [self.cache mergeEntriesFromFeed:self.feed forUrlKey:@"SalesOrderItems" withError:&error withCompletionBlock:^(NSNotification *notif) { //SOItems
        NSError *error;
        self.serverEntriesCopyList = [self.cache readEntriesForUrlKey:@"SalesOrderItems" withError:&error]; //SOItems
        self.locallyModifiedEntriesList = [self.cache readEntriesLocalForEntryId:nil forEntityType:@"SalesOrderItems" withError:&error]; //SOItems
        [self.displayRowsArray setArray:self.serverEntriesCopyList];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"blah" object:self userInfo:nil];
    }];
    
}


-(void)setupCache
{
    NSLog(@"T25");
    id<Caching> cacheLocal = [[Cache alloc] init];
    NSError* error = nil;
    if (![cacheLocal initializeCacheWithError:&error])
    {
        NSLog(@"Initialize Error : %@@", error);
        return;
    }
    self.cache = cacheLocal;
}



@end
