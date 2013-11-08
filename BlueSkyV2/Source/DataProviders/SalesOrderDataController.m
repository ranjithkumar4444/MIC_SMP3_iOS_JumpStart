//
//  SalesOrderDataController.m
///  OfflineSample
//
//  Copyright (c) 2013 SAP AG. All rights reserved.
//

#import "SalesOrderDataController.h"
#import "RequestBuilder.h"
#import "Request.h"
#import "ConnectivitySettings.h"
#import "Constants.h"
#import "KeychainHelper.h"
#import "CredentialsData.h"
#import "ODataDataParser.h"
#import "ODataServiceDocumentParser.h"
#import "ODataMetaDocumentParser.h"
#import "ODataParser.h"
//#import "OnboardingHandler.h"
#import "BSAppDelegate.h"

#import "SettingsUtilities.h"


//static CredentialsData *credentials;
static NSString *applicationConnectionID;


@interface SalesOrderDataController ()
//@property (nonatomic, retain) OnboardingHandler *onboardingHandler;

@end

@implementation SalesOrderDataController


@synthesize applicationConnectionID;
@synthesize salesOrderEntry;
@synthesize salesOrderItemEntry;


- (id)init {
    if (self = [super init]) {
        
        /* Get the Application Connection Id from the users stored settings */
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString *appConnectionId = [defaults stringForKey:kApplicationConnectionId];
        NSLog(@"A: appConnectionId: %@",appConnectionId);
        
        
        /* Check that we have a valid Application connection ID */
        if ([appConnectionId length] > 0) {
            NSLog(@"ODataDataController: APPCID is: %@", appConnectionId);
            self.applicationConnectionID = appConnectionId;
        } else {
            NSLog(@"ODataDataController: Application Connnection ID empty. Register user first.");
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Registration Error"
                                                            message:@"Application Connnection ID empty. Register user first."
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
        }

        NSError *error = nil;

        /* Endpoint credentials (Load them from storage if possible) */
        //NSError *error = nil;
        _credentials = [KeychainHelper loadCredentialsAndReturnError: &error];
        
        if (error) {
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            NSString *username = [defaults stringForKey:@"username"];
            NSString *password = [defaults stringForKey:@"password"];
            _credentials = [[CredentialsData alloc] initWithUsername:username andPassword:password];
        }

        //Initialize Cache
        [self setupCache];
        
        // Add listener for cache.
        [self.cache addNotificationDelegate:self withListener:@selector(onMergeComplete:) forUrlKey:kSalesOrderCollection];
        
        
        //Array for server copy from cache
        self.serverEntriesCopyList = [[NSArray alloc] init];
        //Array for local copy from cache.Will contain locally changed entries.
        self.locallyModifiedEntriesList = [[NSArray alloc] init];
        // Helper array for display
        self.displayRowsArray = [[NSMutableArray alloc] init];
        self.serverEntriesCopyList = [self.cache readEntriesForUrlKey:kSalesOrderCollection withError:&error];
        self.locallyModifiedEntriesList = [self.cache readEntriesLocalForEntryId:nil forEntityType:kSalesOrderCollection withError:&error];
        [self.displayRowsArray setArray:self.serverEntriesCopyList];

        BOOL result = [self loadServiceDocumentAndMetaData];
        if (!result) {
            NSLog(@"Error loading service document and/or metadata.");
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Service document/metadata error"
                                                            message:@"Error loading service document and/or metadata."
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
            return nil;
        }
        
        //Initialize salesOrderList and salesOrder
        self.salesOrderList = [[NSMutableArray alloc] init];
        self.salesOrderEntry = [[ODataEntry alloc] initWithEntitySchema:self.salesOrderCollection.entitySchema];
        
        self.salesOrderItemEntry = [[ODataEntry alloc] initWithEntitySchema:self.salesOrderItemCollection.entitySchema];
        
        
        //The parser creates the schema of the input service document's collections and returns a collection by name
        self.salesOrderCollection = [self.serviceDocument.schema getCollectionByName:kSalesOrderCollection];
        
        
        //The parser schema for Sales Order Items
        self.salesOrderItemCollection = [self.serviceDocument.schema getCollectionByName:kSOItemCollection];

        NSLog(@"self.salesOrderCollection: %@",self.salesOrderCollection);
 
        [RequestBuilder setDelegate:self];
        [RequestBuilder setDidFinishSelector:@selector(reqFin:)];
        [RequestBuilder setDidFailSelector:@selector(reqFail:)];

        return self;
    }
    return nil;
}



- (void)setCategoryList:(NSMutableArray *)newList {
    if (_salesOrderList != newList) {
        _salesOrderList = [newList mutableCopy];
    }
}

#pragma mark - Singleton

+ (SalesOrderDataController *)uniqueInstance
{
    static SalesOrderDataController *instance;
	
    @synchronized(self) {
        if (!instance) {
            instance = [[SalesOrderDataController alloc] init];
        }
        return instance;
    }
}


#pragma mark - Data service calls
- (BOOL)loadServiceDocumentAndMetaData {
    BOOL result = YES;
    
    NSError *error;
    self.serviceDocument = [self.cache readDocumentForUrlKey:kSalesOrderCollection forDocType:0 withError:&error];
    self.metaDataDoc = [self.cache readDocumentForUrlKey:kSalesOrderCollection forDocType:1 withError:&error];
    
    
    if (!self.serviceDocument || !self.metaDataDoc)
    {
        //Get Service Document
        [RequestBuilder setRequestType:HTTPRequestType];
        [RequestBuilder enableXCSRF:YES];
        id<Requesting> svcDocRequest = [RequestBuilder requestWithURL:[[NSURL alloc] initWithString:[ConnectivitySettings serviceURL]]];
        //MAFLogonRegistrationData* registrationData = [self.onboardingHandler.logonManager registrationDataWithError:&error];
        
        [svcDocRequest setRequestMethod:@"GET"];
        [svcDocRequest addRequestHeader:kX_SMP_APPCID value:self.applicationConnectionID];
        [svcDocRequest setUsername:_credentials.username];
        [svcDocRequest setPassword:_credentials.password];

        [svcDocRequest startSynchronous];
        int svcDocRequestStatusCode = [svcDocRequest responseStatusCode];
        NSData *svcDoc = [svcDocRequest responseData];
        
        //Get Metadata
        NSString *metaDataURL = [NSString stringWithFormat:@"%@%@",[ConnectivitySettings serviceURL], kMetadata];
        //NSLog(@"B Metadata URL is: %@", metaDataURL);
        [RequestBuilder setRequestType:HTTPRequestType];
        [RequestBuilder enableXCSRF:YES];
        id<Requesting> metaDocRequest = [RequestBuilder requestWithURL:[[NSURL alloc] initWithString:metaDataURL]];

        [metaDocRequest setRequestMethod:@"GET"];
        [metaDocRequest addRequestHeader:kX_SMP_APPCID value:self.applicationConnectionID];
        [metaDocRequest setUsername:_credentials.username];
        [metaDocRequest setPassword:_credentials.password];

        [metaDocRequest startSynchronous];
        int metaDocRequestStatusCode = [metaDocRequest responseStatusCode];
        NSData *metaDoc = [metaDocRequest responseData];

        if (svcDocRequestStatusCode == 200 && metaDocRequestStatusCode == 200) {
            @try {
                // Get service Doc
                self.serviceDocument = parseODataServiceDocumentXML(svcDoc);
                
                //Get MetaDataDoc
                self.metaDataDoc = parseODataSchemaXML(metaDoc,self.serviceDocument);
                
                // Store both in cache. The service doc msut be stored only after the metadatadoc is parsed.( as in the line above)
                [self.cache storeDocument:self.serviceDocument forDocType:0 forUrlKey:kCategoryCollection withError:&error];
                [self.cache storeDocument:self.metaDataDoc forDocType:1 forUrlKey:kCategoryCollection withError:&error];
                
                
                NSString *message = nil;
                NSString *token = [svcDocRequest responseHeaders][kx_csrf_token];
                if ([token length] > 0) {
                    message = [NSString stringWithFormat:@"Service document and metadata loaded.\nX-CSRF token fetched: %@", token];
                } else {
                    message = @"Service document and metadata loaded.\nHowever, X-CSRF token not found!";
                }
                NSLog(@"%@", message);
            }
            @catch(ODataParserException *e) {
                NSString *exceptionMessage = e.detailedError ? e.detailedError : [e description];
                NSString *errorMessage = [NSString stringWithFormat:@"Exception during parsing Service Document or Metadata: %@", exceptionMessage];
                NSLog(@"%@", errorMessage);
                result = NO;
            }
        } else {
            NSLog(@"DD Request for service document and/or metadata failed. Service document response code is: %d.  Metadata response status code is: %d", svcDocRequestStatusCode, metaDocRequestStatusCode);
            
            //Delete bad credentials from keychain if 401 unauthorized //TODO - do we still need this if we are using MAF?
            if (svcDocRequestStatusCode == 401 || metaDocRequestStatusCode == 401) {
                NSError *error = nil;
                [KeychainHelper deleteCredentialsAndReturnError:&error];
                if (error) {
                    NSLog(@"ERROR: Credentials could not be deleted from keychain - %@", [error localizedDescription]);
                }
            }
            result = NO;
        }
    }
    return result;
    
}

// This method is called the very first time the agencies are retrieved with a GET.
- (void)loadSalesOrderCollectionCompleted:(id <Requesting>)request {

    NSLog(@"******************* Request for SalesOrders succeeded!");

    //Instantiate parser for salesOrder entity
    ODataDataParser *dataParser=[[ODataDataParser alloc] initWithEntitySchema:self.salesOrderCollection.entitySchema andServiceDocument:self.serviceDocument];
    
    //Parses a feed or an entry or json
    [dataParser parse:[request responseData]];
    
    //The array of parsed entry/entries can be accessed via the "entries" property of the parser after parsing.
    //Array of OData Entries can be iterated and diplay the requisite data in tableview
    self.salesOrderList = dataParser.entries;
    self.feed = dataParser.feed;
    
     NSLog(@"%d", [self.feed entries].count);
    
    [self updateCache];
    
    
    
    
    
    
    
}


- (void)loadSalesOrderCollectionWithDidFinishSelector:(SEL)aFinishSelector forUrl:(NSString *)url{
    NSLog(@"Get Sales Order Collection");
    
    
    if (!url)
        url = [NSString stringWithFormat:@"%@%@",[ConnectivitySettings serviceURL], kSalesOrderCollection];
    
    NSLog(@"%@\n",url);
    
    [RequestBuilder setRequestType:HTTPRequestType];
    [RequestBuilder enableXCSRF:YES];
    id<Requesting> request = [RequestBuilder requestWithURL:[[NSURL alloc] initWithString:url]];
    [request setRequestMethod:@"GET"];

    //Use JSON if set
    if ([ConnectivitySettings useJSON]) {
        [request addRequestHeader:@"Accept" value:kApplicationJSON];
    }
    
    [request addRequestHeader:kX_SMP_APPCID value:applicationConnectionID];
    
    //NSError *error;
    // MAFLogonRegistrationData* registrationData = [self.onboardingHandler.logonManager registrationDataWithError:&error];
    [request setUsername:_credentials.username];
    [request setPassword:_credentials.password];

    if (aFinishSelector != nil)
    {
        [request setDelegate:self];
        
        //Set finish selector for request
        if (aFinishSelector) {
            request.didFinishSelector = aFinishSelector;
        }
        
        NSLog(@"Starting initial asynchronous GET request for salesOrder Collection");
        [request startAsynchronous];
    }else  // All requests for GET after CUD operation (other than the first GET)
    {
        
        [request startSynchronous];
        
        NSLog(@"%d\n,%@\n, %@\n %@\n",[request responseStatusCode],[request responseStatusMessage],[[request error] description],[request responseString]);
        ODataDataParser *dataParser=[[ODataDataParser alloc] initWithEntitySchema:self.salesOrderCollection.entitySchema andServiceDocument:self.serviceDocument];

        [dataParser parse:[request responseData]];
        self.categoryList = dataParser.entries;
        self.feed = dataParser.feed;
        
        NSLog(@"%d", [self.feed entries].count);
    }
}



-(void)createSalesOrderComplete:(id<Requesting>)request {
    NSLog(@"SalesOrderDataController : createSalesOrderComplete!!");
}



- (void)loadSalesOrderCompleted:(id <Requesting>)request {
    //NSLog(@"Request for salesOrder succeeded!");
    
    //Instantiate parser for salesOrder entity
    ODataDataParser *dataParser=[[ODataDataParser alloc] initWithEntitySchema:self.salesOrderCollection.entitySchema andServiceDocument:self.serviceDocument];
    
    //FOR DEBUG
    //NSData *responseData = [request responseData];
    //NSString *responseString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
    //NSLog(@"Getting Response string: %@", responseString);
    
    //Parses a feed or an entry xml or json.
    [dataParser parse:[request responseData]];
    
    //The array of parsed entry/entries can be accessed via the "entries" property of the parser after parsing.
    //Array of OData Entries can be iterated and diplay the requisite data in tableview
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kLoadSalesOrderCompletedNotification object:self userInfo:nil];
}

- (void)loadSalesOrderWithID:(NSString *)agencyID andDidFinishSelector:(SEL)aFinishSelector {
    NSLog(@"Get SalesOrder Collection");
    
    NSString *salesOrderURL = [NSString stringWithFormat:@"%@%@('%@')",[ConnectivitySettings serviceURL], kSalesOrderCollection, agencyID];
    [RequestBuilder setRequestType:HTTPRequestType];
    [RequestBuilder enableXCSRF:YES];
    id<Requesting> request = [RequestBuilder requestWithURL:[[NSURL alloc] initWithString:salesOrderURL]];
    [request setRequestMethod:@"GET"];
    
    [request addRequestHeader:kX_SMP_APPCID value:applicationConnectionID];
    
    //Use JSON if set
    if ([ConnectivitySettings useJSON]) {
        [request addRequestHeader:@"Accept" value:kApplicationJSON];
    }
    
    [request setDelegate:self];
    
    //Set finish selector for request
    if (aFinishSelector) {
        request.didFinishSelector = aFinishSelector;
    }
    
    NSLog(@"Starting initial asynchronous GET request for salesOrder");
    [request startAsynchronous];
}


- (void)createSalesOrderWithOrder:(ODataEntry *)salesOrder withTempEntryId:(NSString *)tempEntryId {
    
    NSLog(@"Call salesOrder Create");
    NSError *error;
    NSString *salesOrderCollectionURL = [NSString stringWithFormat:@"%@%@",[ConnectivitySettings serviceURL], kSalesOrderCollection];

    /* Get XCSRF TOKEN */
    [RequestBuilder setRequestType:HTTPRequestType];
    [RequestBuilder enableXCSRF:YES];
    id<Requesting> tokenRequest = [RequestBuilder requestWithURL:[[NSURL alloc] initWithString:salesOrderCollectionURL]];
    [tokenRequest setRequestMethod:@"GET"];
    [tokenRequest setUseCookiePersistence:YES];
    [tokenRequest addRequestHeader:kX_SMP_APPCID value:applicationConnectionID];
    [tokenRequest addRequestHeader:@"X-CSRF-Token" value:@"Fetch"];
    [tokenRequest setUsername:_credentials.username];
    [tokenRequest setPassword:_credentials.password];
    [tokenRequest startSynchronous];
    
    int tokenRequestStatusCode = [tokenRequest responseStatusCode];
    NSData *tokenRequestResponseData = [tokenRequest responseData];
    NSString* tokenResponseString = [NSString stringWithUTF8String:[tokenRequestResponseData bytes]];
    NSString *tokenCookie = [tokenRequest requestHeaders][kx_cookie];
    NSArray *tokenCookieArray = [tokenCookie componentsSeparatedByString:@"; "];
    NSMutableDictionary *tokenCookieDictionary = [[NSMutableDictionary alloc] init];
    
    for (NSString *keyValuePair in tokenCookieArray)
    {
        NSArray *pairComponents = [keyValuePair componentsSeparatedByString:@"="];
        NSString *key = [pairComponents objectAtIndex:0];
        NSString *value = [pairComponents objectAtIndex:1];
        [tokenCookieDictionary setObject:value forKey:key];
    }

    NSLog(@"tokenCookieDictionary: %@",tokenCookieDictionary);
    NSLog(@"tokenRequest responseHeaders: %@",[tokenRequest responseHeaders]);
    NSLog(@"+++++++++++ tokenRequest responseCookies: %@",[tokenRequest responseCookies]);
    
    NSString *tokenA = [tokenRequest responseHeaders][kx_csrf_token];
    if ([tokenA length] > 0) {
        NSLog(@"%@",[NSString stringWithFormat:@"X-CSRF token fetched: %@", tokenA]);
    } else {
        NSLog(@"Service document and metadata loaded.\nHowever, X-CSRF token not found!");
    }

    [RequestBuilder setRequestType:HTTPRequestType];
    [RequestBuilder enableXCSRF:YES];
    
    NSString *salesOrderCollectionURLB = [NSString stringWithFormat:@"%@%@",[ConnectivitySettings serviceURL], kSalesOrderCollection];
    
    id<Requesting> request = [RequestBuilder requestWithURL:[[NSURL alloc] initWithString:salesOrderCollectionURLB]];
    [request setRequestMethod:@"POST"];

    [request setUsername:_credentials.username];
    [request setPassword:_credentials.password];
    
    [tokenRequest setUseCookiePersistence:YES];

    [request addRequestHeader:kX_SMP_APPCID value:applicationConnectionID];
    

    NSString *payload = nil;
    NSString *contentType = nil;
    
    /* GET DATA FROM SALESORDER ENTRY */

        NSLog(@"let's Inspect the SalesOrder: %@",salesOrder);
    
    
        NSString *customerID = [[salesOrder getPropertyValueByPath:@"CustomerId"] getValue];
        NSString *orderID = [[salesOrder getPropertyValueByPath:@"OrderId"] getValue];
        NSString *orderValue = [[salesOrder getPropertyValueByPath:@"OrderValue"] getValue];
    
    /* GET INLINE ENTRY SalesOrderItem */
    NSMutableDictionary *salesOrderEntryDict = [salesOrder getInlinedRelatedEntries];
    
    NSLog(@"salesOrderEntryDict: %@",salesOrderEntryDict);
    
    
    NSArray *tempArray = [salesOrderEntryDict allValues];
    
    NSLog(@"tempArray: %@",tempArray);
    
    
    NSLog(@"[tempArray[0] objectAtIndex:0] : %@",[tempArray objectAtIndex:0]);
    
    
    
    ODataEntry *soie = (id)[tempArray objectAtIndex:0];
    
    NSLog(@"soie: %@",soie);
    
    
    
    NSString *itemNo = [[soie getPropertyValueByPath:@"Item"] getValue];
    NSString *plant = [[soie getPropertyValueByPath:@"Plant"] getValue];
    NSString *material = [[soie getPropertyValueByPath:@"Material"] getValue];
    NSString *description = [[soie getPropertyValueByPath:@"Description"] getValue];
    NSString *quantity = [[soie getPropertyValueByPath:@"Quantity"] getValue];
    NSString *itemValue = [[soie getPropertyValueByPath:@"Value"]getValue];
    
    NSLog(@"HOLD:");

    /* Construct JSON payload if set */
    if ([ConnectivitySettings useJSON]) {
        [request addRequestHeader:@"Accept" value:kApplicationJSON];
        payload = [self getJSONForEntry:salesOrder andOperation:ENTRY_OPERATION_CREATE error:&error];
        contentType = [NSString stringWithFormat:@"%@; %@", kApplicationJSON, kCharSetUTF8];
        }
    /* Construct XML payload */
    else {
        
        NSString *path = [[NSBundle mainBundle] pathForResource:@"soxml" ofType:@"xml"];
        NSString *content = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
        
        payload = content;
        
        payload = [payload stringByReplacingOccurrencesOfString:@"{SALESORDERNUMBER}" withString:orderID];
        payload = [payload stringByReplacingOccurrencesOfString:@"{ITEMNO}" withString:itemNo];
        payload = [payload stringByReplacingOccurrencesOfString:@"{MATERIAL}" withString:material];
        payload = [payload stringByReplacingOccurrencesOfString:@"{PLANT}" withString:plant];
        payload = [payload stringByReplacingOccurrencesOfString:@"{VALUE}" withString:itemValue];
        payload = [payload stringByReplacingOccurrencesOfString:@"{ORDERVALUE}" withString:orderValue];
        payload = [payload stringByReplacingOccurrencesOfString:@"{CUSTOMER}" withString:customerID];
        payload = [payload stringByReplacingOccurrencesOfString:@"{DESCRIPTION}" withString:description];
        payload = [payload stringByReplacingOccurrencesOfString:@"{QUANTITY}" withString:quantity];
        
        NSLog(@"show xml:***************************** \n\n%@\n\n*****************************",payload);
        
        contentType = @"application/atom+xml;type=entry";
        
    }


    [request addRequestHeader:@"Content-Type" value:contentType];

    NSMutableData *data = [NSMutableData dataWithData:[payload dataUsingEncoding:NSUTF8StringEncoding]];
    [request setPostBody:data];


    [request setRequestTag:2];

    NSMutableArray *entryIdArray = [NSMutableArray array];
    [entryIdArray addObject:tempEntryId];
    [request setCacheEntryIdList:entryIdArray];
    
    
    NSLog(@"CHeck cookie: %@",[request requestCookies]);
    NSLog(@"CHeck header: %@",[request requestHeaders]);
    

    NSLog(@"Starting initial asynchronous POST request for SalesOrder Create");

    //CreateSalesOrderTag is 4
    [request setRequestTag:4];

    [request setDelegate:self];
    [request setDidFinishSelector:@selector(createSalesOrderComplete:)];
    [request setDidFailSelector:@selector(reqFail:)];
   // [request setDidReceiveDataSelector:@selector(reqRecData:)];
    [request startAsynchronous];
}


- (void)deleteSalesOrderWithOrder:(ODataEntry *)SalesOrder WithSelector:(SEL)aSelector  {
    NSLog(@"Call SalesOrder Delete");
    NSString *metaDataURL = [NSString stringWithFormat:@"%@%@",[ConnectivitySettings serviceURL], kMetadata];
    [RequestBuilder setRequestType:HTTPRequestType];
    [RequestBuilder enableXCSRF:YES];
    id<Requesting> tokenRequest = [RequestBuilder requestWithURL:[[NSURL alloc] initWithString:metaDataURL]];
    [tokenRequest setRequestMethod:@"GET"];
    [tokenRequest addRequestHeader:kX_SMP_APPCID value:self.applicationConnectionID];
    [tokenRequest setUsername:_credentials.username];
    [tokenRequest setPassword:_credentials.password];
    [tokenRequest startSynchronous];

    NSString *token = [tokenRequest responseHeaders][kx_csrf_token];
    NSLog(@"token: %@", token);
    NSString *orderID = [[SalesOrder getPropertyValueByPath:@"OrderId"] getValue];

    NSString *salesOrderURL = [NSString stringWithFormat:@"%@%@('%@')",[ConnectivitySettings serviceURL], kSalesOrderCollection,orderID];
    NSLog(@"salesOrderURL: %@",salesOrderURL);
    
    [RequestBuilder setRequestType:HTTPRequestType];
    [RequestBuilder enableXCSRF:YES];
    
    id<Requesting> request = [RequestBuilder requestWithURL:[[NSURL alloc] initWithString:salesOrderURL]];
    [request setRequestMethod:@"DELETE"];
    
    [request setUsername:_credentials.username];
    [request setPassword:_credentials.password];

    [request addRequestHeader:kX_SMP_APPCID value:applicationConnectionID];
    
    [request applyCookieHeader];
    

    if ([ConnectivitySettings useJSON]) {
        [request addRequestHeader:@"Accept" value:kApplicationJSON];
    }

    NSMutableArray *entryIdArray = [NSMutableArray array];
    [entryIdArray addObject:[SalesOrder getEntryID]];

    [request setCacheEntryIdList:entryIdArray];

    
    //Set finish selector for request

    request.didFinishSelector = aSelector;

    [request setRequestTag:6];
    

    NSLog(@"Starting initial asynchronous PUT request for Sales Order Delete");
    [request startAsynchronous];
}




- (void)finishedDelete:(SEL)selector  {
    NSLog(@"finished: in DataController");
}



#pragma mark - Category List


- (ODataEntry *)objectInListAtIndex:(NSUInteger)theIndex {
    return [self.displayRowsArray objectAtIndex:theIndex];
}

- (void)addSalesOrderWithOrder:(ODataEntry *)salesOrder {
    [self.displayRowsArray addObject:salesOrder];
}

- (void)removeTravelAgencyAtIndex:(NSUInteger)theIndex {
    [self.displayRowsArray removeObjectAtIndex:theIndex];
}

- (void)replaceTravelAgencyWithAgency:(ODataEntry *)travelAgency atIndex:(NSUInteger)theIndex {
    [self.displayRowsArray replaceObjectAtIndex:theIndex withObject:travelAgency];
}

#pragma mark - Entry Helpers

- (void)setStringValueForEntry:(ODataEntry *)aSDMEntry withValue:(NSString *)aValue forSDMPropertyWithName:(NSString *)aName {
    ODataPropertyValueString *property = (ODataPropertyValueString *)[aSDMEntry getPropertyValueByPath:aName];
    [property setValue:aValue];
}


- (NSString *)getXMLForEntry:(ODataEntry *)entry andOperation:(const enum TEN_ENTRY_OPERATIONS) operation error:(NSError * __autoreleasing *)error {
    if ([entry isValid]) {
        ODataEntryBody *entryXml = nil;
        @try {
            entryXml = buildODataEntryRequestBody(entry, operation, self.serviceDocument, YES,0);
            
            NSString *noticeMsg = [NSString stringWithFormat:@"xml:\n %@\nmethod: %@", entryXml.body, entryXml.method];
            NSLog(@"%@", noticeMsg);
            
            return [entryXml body];
        }
        @catch (ODataParserException *e) {
        	NSString *localizedMessage = NSLocalizedString(@"Exception during building entry xml: %@", @"Exception during building entry xml: %@");
            NSString *exceptionMsg = [NSString stringWithFormat:localizedMessage, e.detailedError];
            NSLog(@"%@", exceptionMsg);
        }
    }
    else {
        NSString *errorMsg = @"The entry is not a valid entry";
        NSLog(@"%@", errorMsg);
    }
}

- (NSString *)getJSONForEntry:(ODataEntry *)entry andOperation:(const enum TEN_ENTRY_OPERATIONS) operation error:(NSError * __autoreleasing *)error {
    if ([entry isValid]) {
        ODataEntryBody *entryJSON = nil;
        @try {
            entryJSON = buildODataEntryRequestBody(entry, operation,self.serviceDocument,NO,2);
            
            NSString *noticeMsg = [NSString stringWithFormat:@"json:\n %@\nmethod: %@", entryJSON.body, entryJSON.method];
            NSLog(@"%@", noticeMsg);
            
            return [entryJSON body];
        }
        @catch (ODataParserException *e) {
        	NSString *localizedMessage = NSLocalizedString(@"Exception during building entry json: %@", @"Exception during building entry json: %@");
            NSString *exceptionMsg = [NSString stringWithFormat:localizedMessage, e.detailedError];
            NSLog(@"%@", exceptionMsg);
        }
    }
    else {
        NSString *errorMsg = @"The entry is not a valid entry";
        NSLog(@"%@", errorMsg);
    }
}

#pragma mark - Cache

-(void)setupCache {
    id<Caching> cacheLocal = [[Cache alloc] init];
    NSError* error = nil;
    if (![cacheLocal initializeCacheWithError:&error])
    {
        NSLog(@"Initialize Error : %@@", error);
        return;
    }
    self.cache = cacheLocal;
}


-(void)clearTheCache {
    
    NSError *error;
    [self.cache clearCacheForUrlKey:kSalesOrderCollection withError:&error ];
    NSLog(@"error: %@",error);
    
    
}



-(void)updateCache {
    //After the initial load of entries, populate the server cache for the first time.
    NSError* error;
    
    
    //   [self.cache mergeEntriesFromFeed:self.feed forUrlKey:kCategoryCollection withError:&error withCompletionBlock:nil];
    
    
    [self.cache mergeEntriesFromFeed:self.feed forUrlKey:kSalesOrderCollection withError:&error withCompletionBlock:^(NSNotification *notif) {
        NSError* error;
        self.serverEntriesCopyList = [self.cache readEntriesForUrlKey:kSalesOrderCollection withError:&error];
        self.locallyModifiedEntriesList = [self.cache readEntriesLocalForEntryId:nil  forEntityType:kSalesOrderCollection withError:&error];
        
        
        [self.displayRowsArray setArray:self.serverEntriesCopyList];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:kLoadSalesOrderCompletedNotification object:self userInfo:nil];
        
    }];
}

-(void)onMergeComplete:(NSNotification *)notification {
    
    NSLog(@"In listener\n");
    NSError* error;
    self.serverEntriesCopyList = [self.cache readEntriesForUrlKey:kSalesOrderCollection withError:&error];
    self.locallyModifiedEntriesList = [self.cache readEntriesLocalForEntryId:nil  forEntityType:kSalesOrderCollection withError:&error];
    [self.displayRowsArray setArray:self.serverEntriesCopyList];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kLoadSalesOrderCompletedNotification object:self userInfo:nil];
    
}



#pragma mark - RequestDelegate

- (void)requestFailed:(Request *)request {
    NSLog(@"Request failed!");
    NSError* error = [request error];
    NSLog(@"ERROR: @%@", [error localizedDescription]);
    
    int statusCode = request.responseStatusCode;
    NSLog(@"Response status code is: %d", statusCode);
    NSData *responseData = [request responseData];
    
    NSString *responseString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
    NSLog(@"Getting error response string: %@", responseString);
    
    NSString *errorMessage = [NSString stringWithFormat:@"ERROR: %@. Response status code is: %d.",[request error], statusCode];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Request Failed!"
                                                    message:errorMessage
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
}


-(void)reqRecData:(id<Requesting>)request {
    NSLog(@"didReceiveDataSelector");
}


-(void)reqFin:(id<Requesting>)request {
    NSLog(@"request: made it to reqFin");
    NSLog(@"reqFin requestCookies: %@",[request requestCookies]);
    NSLog(@"reqFin requestHeaders: %@",[request requestHeaders]);
    NSError *error;
    NSMutableArray *entryIdArray = [ request cacheEntryIdList];
    for (NSString *entryId in entryIdArray) {
        [self.cache clearLocalEntryForEntryId:entryId withError:&error];
    }

    NSLog(@"******************************************************************************\n");
    NSLog(@"REQUEST COMPLETED SUCCESSFULLY SODC \n");
    NSLog(@"******************************************************************************\n");
    
    int myTag = [request requestTag];
    
    if(myTag == 4) {
    
        NSLog(@"request is tag : %d",myTag);
     [[NSNotificationCenter defaultCenter] postNotificationName:@"createSalesOrderNotification" object:self userInfo:nil];
        [self updateCache];
        
    }
    
    else if(myTag == 6) {
        
        NSLog(@"request is tag : %d",myTag);
        [[NSNotificationCenter defaultCenter] postNotificationName:@"deleteSalesOrderNotification" object:self userInfo:nil];
        [self updateCache];
        
    }
    else {
        NSLog(@"NOT create : request is tag : %d",myTag);
    }
    
}

-(void)reqFail:(id<Requesting>)request {
    NSLog(@"reqFail: made it to reqFail");
    NSLog(@"reqFail requestHeaders: %@",[request requestHeaders]);
    NSLog(@"reqFail requestCookies: %@",[request requestCookies]);
    NSLog(@"reqFail: responseStatusCode: %d",[request responseStatusCode]);
    NSLog(@"reqFail responseStatusMessage: %@",[request responseStatusMessage]);
    NSLog(@"reqFail request error description: %@",[[request error] description]);
    NSLog(@"reqFail responseString: %@",[request responseString]);
}

@end
