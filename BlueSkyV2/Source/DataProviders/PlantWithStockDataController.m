//
//  PlantWithStockDataController.m
///  OfflineSample
//
//  Copyright (c) 2013 SAP AG. All rights reserved.
//

#import "PlantWithStockDataController.h"
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


@interface PlantWithStockDataController ()
//@property (nonatomic, retain) OnboardingHandler *onboardingHandler;

@end

@implementation PlantWithStockDataController


@synthesize applicationConnectionID;


- (id)init {
    if (self = [super init]) {
        
        /* Get the Application Connection Id from the users stored settings */
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString *appConnectionId = [defaults stringForKey:kApplicationConnectionId];
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
        // AppDelegate* appDelegate = [[UIApplication sharedApplication] delegate];

        
        /* Endpoint credentials (Load them from storage if possible) */
        //NSError *error = nil;
        _credentials = [KeychainHelper loadCredentialsAndReturnError: &error];
        
        if (error) {
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            NSString *username = [defaults stringForKey:@"username"];
            NSString *password = [defaults stringForKey:@"password"];
            _credentials = [[CredentialsData alloc] initWithUsername:username andPassword:password];
        }
        
        NSLog(@"init  _credentials: %@: %@",_credentials.username,_credentials.password);
        
        //Initialize Cache
        [self setupCache];
        
        // Add listener for cache.
        [self.cache addNotificationDelegate:self withListener:@selector(onMergeComplete:) forUrlKey:kPlantWithStockCollection];
        
        
        //Array for server copy from cache
        self.serverEntriesCopyList = [[NSArray alloc] init];
        //Array for local copy from cache.Will contain locally changed entries.
        self.locallyModifiedEntriesList = [[NSArray alloc] init];
        // Helper array for display
        self.displayRowsArray = [[NSMutableArray alloc] init];
        self.serverEntriesCopyList = [self.cache readEntriesForUrlKey:kPlantWithStockCollection withError:&error];
        self.locallyModifiedEntriesList = [self.cache readEntriesLocalForEntryId:nil forEntityType:kPlantWithStockCollection withError:&error];
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
        
        BOOL resultB = [self getSOSchema];
        if (!resultB) {
            NSLog(@"Error loading SO service document and/or metadata.");
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Service document/metadata error"
                                                            message:@"Error loading service document and/or metadata."
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
            return nil;
        }

        //Initialize travelAgencyList and travelAgency
        self.plantWithStockList = [[NSMutableArray alloc] init];
        //  ODataEntry *agencyEntry = [[ODataEntry alloc] initWithEntitySchema:self.travelAgencyCollection.entitySchema];
        
        //The parser creates the schema of the input service document's collections and returns a collection by name
        self.plantWithStockCollection = [self.serviceDocument.schema getCollectionByName:kPlantWithStockCollection];
        
        /* */
        self.salesOrderCollection = [self.serviceDocument.schema getCollectionByName:kSalesOrderCollection];

        [RequestBuilder setDelegate:self];
        [RequestBuilder setDidFinishSelector:@selector(reqFin:)];
        [RequestBuilder setDidFailSelector:@selector(reqFail:)];

        return self;
    }
    return nil;
}



- (void)setPlantWithStockList:(NSMutableArray *)newList {
    if (_plantWithStockList != newList) {
        _plantWithStockList = [newList mutableCopy];
    }
}

#pragma mark - Singleton

+ (PlantWithStockDataController *)uniqueInstance {
    static PlantWithStockDataController *instance;
    @synchronized(self) {
        if (!instance) {
            instance = [[PlantWithStockDataController alloc] init];
        }
        return instance;
    }
}


#pragma mark - Data service calls
- (BOOL)loadServiceDocumentAndMetaData {
    BOOL result = YES;
    
    NSError *error;
    self.serviceDocument = [self.cache readDocumentForUrlKey:kPlantWithStockCollection forDocType:0 withError:&error];
    self.metaDataDoc = [self.cache readDocumentForUrlKey:kPlantWithStockCollection forDocType:1 withError:&error];

    if (!self.serviceDocument || !self.metaDataDoc)
    {
        //Get Service Document
        //NSLog(@"****************************** A1 SERVICE DOC:%@",[ConnectivitySettings serviceURL]);
        NSLog(@"Service URL is: %@", [ConnectivitySettings serviceURL]);
        [RequestBuilder setRequestType:HTTPRequestType];
        [RequestBuilder enableXCSRF:YES];
        id<Requesting> svcDocRequest = [RequestBuilder requestWithURL:[[NSURL alloc] initWithString:[ConnectivitySettings serviceURL]]];
        //MAFLogonRegistrationData* registrationData = [self.onboardingHandler.logonManager registrationDataWithError:&error];
        
        [svcDocRequest setRequestMethod:@"GET"];
        [svcDocRequest addRequestHeader:kX_SMP_APPCID value:applicationConnectionID];
        
        [svcDocRequest setUsername:_credentials.username];
        [svcDocRequest setPassword:_credentials.password];
        
        NSLog(@"Starting initial synchronous GET request for service document");
        [svcDocRequest startSynchronous];
        int svcDocRequestStatusCode = [svcDocRequest responseStatusCode];
        NSData *svcDoc = [svcDocRequest responseData];
        
        //Get Metadata
        NSString *metaDataURL = [NSString stringWithFormat:@"%@%@",[ConnectivitySettings serviceURL], kMetadata];
        NSLog(@"********************************* Metadata URL is: %@", metaDataURL);
        [RequestBuilder setRequestType:HTTPRequestType];
        [RequestBuilder enableXCSRF:YES];
        id<Requesting> metaDocRequest = [RequestBuilder requestWithURL:[[NSURL alloc] initWithString:metaDataURL]];
        
        
        [metaDocRequest setRequestMethod:@"GET"];
        [metaDocRequest addRequestHeader:kX_SMP_APPCID value:applicationConnectionID];
        [metaDocRequest setUsername:_credentials.username];
        [metaDocRequest setPassword:_credentials.password];
        
        NSLog(@"************* B current u:p :%@ : %@",_credentials.username, _credentials.password);
        
        NSLog(@"Starting initial synchronous GET request for metadata document");
        [metaDocRequest startSynchronous];
        int metaDocRequestStatusCode = [metaDocRequest responseStatusCode];
        NSData *metaDoc = [metaDocRequest responseData];
        
        if (svcDocRequestStatusCode == 200 && metaDocRequestStatusCode == 200) {
            @try {
                
                // Get service Doc
                self.serviceDocument = parseODataServiceDocumentXML(svcDoc);
                
                NSLog(@"****************************** Trying:%@",self.serviceDocument);
                
                //Get MetaDataDoc
                self.metaDataDoc = parseODataSchemaXML(metaDoc,self.serviceDocument);
                
                NSLog(@"****************************** Trying:%@",self.metaDataDoc);
                
                // Store both in cache. The service doc msut be stored only after the metadatadoc is parsed.( as in the line above)
                [self.cache storeDocument:self.serviceDocument forDocType:0 forUrlKey:kPlantWithStockCollection withError:&error];
                [self.cache storeDocument:self.metaDataDoc forDocType:1 forUrlKey:kPlantWithStockCollection withError:&error];
                
                NSLog(@"aaasfdsf sdddd dfdfdfsaf dsa");
                
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
            NSLog(@"Request for service document and/or metadata failed. Service document response code is: %d.  Metadata response status code is: %d", svcDocRequestStatusCode, metaDocRequestStatusCode);
            
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



- (BOOL)getSOSchema {
    BOOL result = YES;

    NSError *error;
    self.SOserviceDocument = [self.cache readDocumentForUrlKey:kSalesOrderCollection forDocType:0 withError:&error];
    self.SOmetaDataDoc = [self.cache readDocumentForUrlKey:kSalesOrderCollection forDocType:1 withError:&error];
    
    if (!self.SOserviceDocument || !self.SOmetaDataDoc)
    {
        //Get Service Document
         NSLog(@"****************************** Loading SO Service DOc and MetaDataDOc:%@",[ConnectivitySettings serviceURL]);
        NSLog(@"Service URL is: %@", [ConnectivitySettings serviceURL]);
        [RequestBuilder setRequestType:HTTPRequestType];
        [RequestBuilder enableXCSRF:YES];
        id<Requesting> svcDocRequest = [RequestBuilder requestWithURL:[[NSURL alloc] initWithString:[ConnectivitySettings serviceURL]]];
        //MAFLogonRegistrationData* registrationData = [self.onboardingHandler.logonManager registrationDataWithError:&error];
        
        [svcDocRequest setRequestMethod:@"GET"];
        [svcDocRequest addRequestHeader:kX_SMP_APPCID value:applicationConnectionID];
        
        NSLog(@"A current u:p :%@ : %@",_credentials.username, _credentials.password);
        
        
        [svcDocRequest setUsername:_credentials.username];
        [svcDocRequest setPassword:_credentials.password];
        
        
        NSLog(@"Starting initial synchronous GET request for service document");
        [svcDocRequest startSynchronous];
        int svcDocRequestStatusCode = [svcDocRequest responseStatusCode];
        NSData *svcDoc = [svcDocRequest responseData];
        
        //Get Metadata
        NSString *metaDataURL = [NSString stringWithFormat:@"%@%@",[ConnectivitySettings serviceURL], kMetadata];
        NSLog(@"********************************* Metadata URL is: %@", metaDataURL);
        [RequestBuilder setRequestType:HTTPRequestType];
        [RequestBuilder enableXCSRF:YES];
        id<Requesting> metaDocRequest = [RequestBuilder requestWithURL:[[NSURL alloc] initWithString:metaDataURL]];
        
        
        [metaDocRequest setRequestMethod:@"GET"];
        [metaDocRequest addRequestHeader:kX_SMP_APPCID value:applicationConnectionID];
        [metaDocRequest setUsername:_credentials.username];
        [metaDocRequest setPassword:_credentials.password];
        
        NSLog(@"************* B current u:p :%@ : %@",_credentials.username, _credentials.password);
        
        NSLog(@"Starting initial synchronous GET request for metadata document");
        [metaDocRequest startSynchronous];
        int metaDocRequestStatusCode = [metaDocRequest responseStatusCode];
        NSData *metaDoc = [metaDocRequest responseData];
        
        if (svcDocRequestStatusCode == 200 && metaDocRequestStatusCode == 200) {
            @try {
                
                // Get service Doc
                self.SOserviceDocument = parseODataServiceDocumentXML(svcDoc);
                
                NSLog(@"****************************** Trying:%@",self.SOserviceDocument);
                
                //Get MetaDataDoc
                self.SOmetaDataDoc = parseODataSchemaXML(metaDoc,self.SOserviceDocument);
                
                NSLog(@"****************************** Trying:%@",self.metaDataDoc);
                
                // Store both in cache. The service doc msut be stored only after the metadatadoc is parsed.( as in the line above)
                [self.cache storeDocument:self.SOserviceDocument forDocType:0 forUrlKey:kSalesOrderCollection withError:&error];
                [self.cache storeDocument:self.SOmetaDataDoc forDocType:1 forUrlKey:kSalesOrderCollection withError:&error];
                
                NSLog(@"Stored!");
                
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
            NSLog(@"Request for service document and/or metadata failed. Service document response code is: %d.  Metadata response status code is: %d", svcDocRequestStatusCode, metaDocRequestStatusCode);
            
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


- (void)loadPlantWithStockCompleted:(id <Requesting>)request {
    NSLog(@"********************** loadPlantWithStockCompleted Request for PlantWithStock succeeded!");
    
    //Instantiate parser for Travel Agency entity
    ODataDataParser *dataParser=[[ODataDataParser alloc] initWithEntitySchema:self.plantWithStockCollection.entitySchema andServiceDocument:self.serviceDocument];
    
    //FOR DEBUG
    NSData *responseData = [request responseData];
    NSString *responseString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
    NSLog(@"Getting Response string: %@", responseString);
    
    //Parses a feed or an entry xml or json.
    [dataParser parse:[request responseData]];
    
    /*  The array of parsed entry/entries can be accessed via the "entries" property of the parser after parsing.
        Array of OData Entries can be iterated and diplay the requisite data in tableview */
    
    self.plantWithStockList = dataParser.entries;
    self.feed = dataParser.feed;
    
    NSLog(@"%d", [self.feed entries].count);
    
    [self updateCache];

    [[NSNotificationCenter defaultCenter] postNotificationName:kLoadPlantWithStockCompletedNotification object:self userInfo:nil];
}


// This method is called the very first time the agencies are retrieved with a GET.
- (void)loadPlantWithStockCollectionCompleted:(id <Requesting>)request {
    //Instantiate parser for Travel Agency entity
    ODataDataParser *dataParser=[[ODataDataParser alloc] initWithEntitySchema:self.plantWithStockCollection.entitySchema andServiceDocument:self.serviceDocument];
    
    //Parses a feed or an entry or json
    [dataParser parse:[request responseData]];
    
    //The array of parsed entry/entries can be accessed via the "entries" property of the parser after parsing.
    //Array of OData Entries can be iterated and diplay the requisite data in tableview
    self.plantWithStockList = dataParser.entries;
    self.feed = dataParser.feed;
    
    NSLog(@"%d", [self.feed entries].count);
    
    [self updateCache];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kLoadPlantWithStockCompletedNotification object:self userInfo:nil];

}



- (void)createSalesOrderWithOrder:(ODataEntry *)salesOrder withTempEntryId:(NSString *)tempEntryId {
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
    //[request setRequestCookies:[tokenCookieArray mutableCopy] ];
    
    //[request setUseCookiePersistence:YES];
    [request addRequestHeader:kX_SMP_APPCID value:applicationConnectionID];
    
    //[request setRequestCookies:[tokenCookieArray mutableCopy] ];
    // [request addRequestHeader:@"x-csrf-token" value:tokenA];
    
    
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

    ODataEntry *soie = (id)[tempArray objectAtIndex:0];


    NSString *itemNo = [[soie getPropertyValueByPath:@"Item"] getValue];
    NSString *plant = [[soie getPropertyValueByPath:@"Plant"] getValue];
    NSString *material = [[soie getPropertyValueByPath:@"Material"] getValue];
    NSString *description = [[soie getPropertyValueByPath:@"Description"] getValue];
    NSString *quantity = [[soie getPropertyValueByPath:@"Quantity"] getValue];
    
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

    
    NSLog(@"Starting initial asynchronous POST request for SalesOrder Create");

    [request setDelegate:self];
    [request setDidFinishSelector:@selector(reqFin:)];
    [request setDidFailSelector:@selector(reqFail:)];
    // [request setDidReceiveDataSelector:@selector(reqRecData:)];
    [request startAsynchronous];
}


- (void)loadPlantWithStockCollectionWithDidFinishSelector:(SEL)aFinishSelector forUrl:(NSString *)url{
    NSLog(@"***************** Get PlantWithStock Collection");

    if (!url)
        url = [NSString stringWithFormat:@"%@%@",[ConnectivitySettings serviceURL], kPlantWithStockCollection];
    
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
    NSLog(@"C current u:p :%@ : %@ : %@",_credentials.username, _credentials.password, applicationConnectionID );
    [request setUsername:_credentials.username];
    [request setPassword:_credentials.password];

    if (aFinishSelector != nil)
    {
        [request setDelegate:self];
        
        //Set finish selector for request
        if (aFinishSelector) {
            request.didFinishSelector = aFinishSelector;
        }
        
        NSLog(@"Starting initial asynchronous GET request for Travel Agency Collection");
        [request startAsynchronous];
    }else  // All requests for GET after CUD operation (other than the first GET)
    {
        
        [request startSynchronous];
        
        NSLog(@"%d\n,%@\n, %@\n %@\n",[request responseStatusCode],[request responseStatusMessage],[[request error] description],[request responseString]);
        ODataDataParser *dataParser=[[ODataDataParser alloc] initWithEntitySchema:self.plantWithStockCollection.entitySchema andServiceDocument:self.serviceDocument];
        [dataParser parse:[request responseData]];
        self.plantWithStockList = dataParser.entries;
        self.feed = dataParser.feed;
        
        NSLog(@"%d", [self.feed entries].count);
    }
}


- (void)loadPlantWithStockWithProductID:(NSString *)productID andDidFinishSelector:(SEL)aFinishSelector {
    NSLog(@"dc *********************** Get PlantWithStockCollection By ID");
    
    NSString *plantWithStockURL = [NSString stringWithFormat:@"%@%@?$filter=Material+eq+'%@'+and+UnitOfMeasure+eq+'EA'",[ConnectivitySettings serviceURL], kPlantWithStockCollection, productID];
    [RequestBuilder setRequestType:HTTPRequestType];
    [RequestBuilder enableXCSRF:YES];
    
    NSLog(@"plantWithStockURL: %@",plantWithStockURL);
    
    
    id<Requesting> request = [RequestBuilder requestWithURL:[[NSURL alloc] initWithString:plantWithStockURL]];
    [request setRequestMethod:@"GET"];
    
    [request addRequestHeader:kX_SMP_APPCID value:applicationConnectionID];
    
    //Use JSON if set
    if ([ConnectivitySettings useJSON]) {
        [request addRequestHeader:@"Accept" value:kApplicationJSON];
    }
    
    [request setUsername:_credentials.username];
    [request setPassword:_credentials.password];
    
    [request setDelegate:self];
    
    //Set finish selector for request
    if (aFinishSelector) {
        request.didFinishSelector = aFinishSelector;
    }
    
    NSLog(@"Starting initial asynchronous GET request for Travel Agency");
    [request startAsynchronous];
}


#pragma mark - Plant With Stock List


- (ODataEntry *)objectInListAtIndex:(NSUInteger)theIndex {
    return [self.displayRowsArray objectAtIndex:theIndex];
}

- (void)addTravelAgencyWithAgency:(ODataEntry *)travelAgency {
    [self.displayRowsArray addObject:travelAgency];
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

-(void)setupCache
{
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
    [self.cache clearCacheForUrlKey:kPlantWithStockCollection withError:&error ];
    NSLog(@"error: %@",error);
}


-(void)updateCache {
    /* After the initial load of entries, populate the server cache for the first time. */
    NSError* error;
    
    [self.cache mergeEntriesFromFeed:self.feed
                           forUrlKey:kPlantWithStockCollection
                           withError:&error
                 withCompletionBlock:^(NSNotification *notif) {
        NSError* error;
        self.serverEntriesCopyList = [self.cache readEntriesForUrlKey:kPlantWithStockCollection withError:&error];
        self.locallyModifiedEntriesList = [self.cache readEntriesLocalForEntryId:nil  forEntityType:kPlantWithStockCollection withError:&error];
        [self.displayRowsArray setArray:self.serverEntriesCopyList];
        [[NSNotificationCenter defaultCenter] postNotificationName:kLoadPlantWithStockCompletedNotification object:self userInfo:nil];
    }];
}

-(void)onMergeComplete:(NSNotification *)notification {
    
    NSLog(@"In listener\n");
    NSError* error;
    self.serverEntriesCopyList = [self.cache readEntriesForUrlKey:kPlantWithStockCollection withError:&error];
    self.locallyModifiedEntriesList = [self.cache readEntriesLocalForEntryId:nil  forEntityType:kPlantWithStockCollection withError:&error];
    [self.displayRowsArray setArray:self.serverEntriesCopyList];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kLoadPlantWithStockCompletedNotification object:self userInfo:nil];
}



#pragma mark - RequestDelegate

- (void)requestFailed:(Request *)request {
    NSLog(@"PlantWithStock Request failed!");
    NSError* error = [request error];
    NSLog(@"ERROR: @%@", [error localizedDescription]);
    
    int statusCode = request.responseStatusCode;
    NSLog(@"Plant with Stock Response status code is: %d", statusCode);
    NSData *responseData = [request responseData];
    
    NSString *responseString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
    NSLog(@"Plant with Stock Getting error response string: %@", responseString);
    
    NSString *errorMessage = [NSString stringWithFormat:@"ERROR: %@. Response status code is: %d.",[request error], statusCode];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Request Failed!"
                                                    message:errorMessage
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
}


-(void)reqFin:(id<Requesting>)request {
    NSError *error;
    NSMutableArray *entryIdArray = [ request cacheEntryIdList];
    for (NSString *entryId in entryIdArray) {
        [self.cache clearLocalEntryForEntryId:entryId withError:&error];
        }

    NSLog(@"******************************************************************************\n");
    NSLog(@"REQUEST COMPLETED SUCCESSFULLY PWSDC \n");
    NSLog(@"******************************************************************************\n");

    int myTag = [request requestTag];
    
    if(myTag == 4) {
        
        NSLog(@"request is tag : %d",myTag);
        [[NSNotificationCenter defaultCenter] postNotificationName:@"createSalesOrderNotification" object:self userInfo:nil];
        [self updateCache];
    }
}




-(void)reqFail:(id<Requesting>)request {
    NSLog(@"%d\n,%@\n, %@\n %@\n",[request responseStatusCode],[request responseStatusMessage],[[request error] description],[request responseString]);
}

@end
