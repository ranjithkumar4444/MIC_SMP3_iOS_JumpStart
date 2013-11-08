//
//  ODataDataController.m
//  Flights
//
//  Created by Damien Murphy
//  Copyright (c) 2013 MIC. All rights reserved.
//

#import "ODataController.h"
#import "ODataFeed.h"

@implementation ODataController


-(NSArray *)createBusinessObjects:(NSArray *)oDataEntries
{
    NSLog(@"ODataController: createBusinessObjects");
    NSLog(@"ODataController: Error -  This function '-(NSArray *)createBusinessObjects:(NSArray *)oDataEntries' must be overidden by subclass");

    return nil;
}

- (void)getOData:(NSDictionary *)params onCompletion: (BSDataResponseBlock) responseBlock onError: (BSErrorResponseBlock) errorBlock
{
    NSLog(@"ODataController: getOdata called");
    //NSLog(@"ODataDataController: Error -  This function '- (void)getOData:(NSMutableDictionary *)params andDidFinishSelector:(SEL)aFinishSelector' must be overidden by subclass");
    //Set the Request type to HTTP
    [RequestBuilder setRequestType: HTTPRequestType];
    
    //Enable the Gateway header for OData
    [RequestBuilder enableXCSRF: YES];
    
    //Create the request using the request builder
    id<Requesting> request = [RequestBuilder requestWithURL: [NSURL URLWithString: _requestURL]];
    
    //Set the mthod type to get
    [request setRequestMethod: @"GET"];
    
    //Use JSON if set
    if ([ConnectivitySettings useJSON]) {
        [request addRequestHeader: @"Accept" value: kApplicationJSON];
    }
    
    //Set the application connection ID we got when we registered
    [request addRequestHeader:kX_SMP_APPCID value:self.applicationConnectionID];
    
    //No need to set these here if the Whitelist connection is made Anonymous
    [request setUsername: _credentials.username];
    [request setPassword: _credentials.password];
    
    //Set this class as the request delegate
    [request setDelegate: self];
    
    //Set the response and error callbacks
    _odataResponseBlock = responseBlock;
    _odataErrorBlock = errorBlock;

    
    
    
    
    
    //Set finish selector for request to that of the super class
    request.didFinishSelector = @selector(getODataCompleted:);
    
    NSLog(@"ODataController: getOData : Starting initial asynchronous GET request for GRP");
    [request startAsynchronous];
}

/*
 This is our OData response handler
 */
- (void) getODataCompleted: (id <Requesting>) request{
    NSLog(@"+++++++++++++ Y20");
    NSLog(@"ODataController Request succeeded!");
    
    //FOR DEBUG
    NSData *responseData = [request responseData];
    NSString *responseString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
    NSLog(@"ODataController Response string: %@", responseString);
    
    //_odataParser.entries = [[NSMutableArray alloc] init];
    _odataParser = nil;
    _odataParser = [[ODataDataParser alloc] initWithEntitySchema:self.odataCollection.entitySchema andServiceDocument:self.serviceDocument];
    
    if(responseString && ![responseString isEqualToString:@""]){
        //Parses a feed or an entry xml or json.
        [_odataParser parse:[request responseData]];
        
        NSLog(@"ODATA FEED update string=%@", [_odataParser.feed updated]);
        
        self.feed = _odataParser.feed;
        
        NSLog(@"feed: %@",self.feed);
        
        
        _odataResponseBlock([self createBusinessObjects:_odataParser.entries]);
        

        
    }else{
        _odataResponseBlock([self createBusinessObjects:nil]);
    }
}



#pragma mark - RequestDelegate

//Default requestFailed method can be overridden in subclasses
- (void)requestFailed:(Request *)request {
    NSLog(@"Y21");
    NSLog(@"ODataDataController: Request failed!");
    NSError* error = [request error];
    NSLog(@"ERROR: @%@", [error localizedDescription]);
    
    int statusCode = request.responseStatusCode;
    NSLog(@"ODataDataController: Response status code is: %d", statusCode);
    NSData *responseData = [request responseData];
    
    NSString *responseString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
    NSLog(@"ODataDataController: Getting error response string: %@", responseString);
    
    NSString *errorMessage = [NSString stringWithFormat:@"ERROR: %@",[request error]];
    
    
    if(_odataErrorBlock){
        _odataErrorBlock(errorMessage);
    }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Request Failed!"
                                                        message:errorMessage
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
    
}

#pragma mark - standard init method
- (void)setup {
    NSLog(@"ODataController: setup called");
    if(!_credentials){
        NSLog(@"ODataDataController: Error -  _credentials must be overidden by subclass");
    }
    
    //Get the Application Connection Id from the users stored settings
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *appConnectionId = [defaults stringForKey:kApplicationConnectionId];
    
    //Check that we have a valid Application donnection ID
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
        return;
    }
    
    //Load the service document and metadata document
    BOOL result = [self loadServiceDocumentAndMetaData];
    
    //If the loading of the service or metadocument failed show an alert
    if (!result) {
        NSLog(@"Error loading service document and/or metadata.");
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Service/Metadata Document Error!"
                                                        message:@"Error loading service and/or metadata document."
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    //The parser creates the schema of the input service document's collections and returns a collection by name
    self.odataCollection = [self.serviceDocument.schema getCollectionByName:self.odataCollectionName];
    
    //Instantiate parser for ATP entity
    _odataParser = [[ODataDataParser alloc] initWithEntitySchema:self.odataCollection.entitySchema andServiceDocument:self.serviceDocument];

[self setupCache];
    
    
}



#pragma mark - Data service calls
- (BOOL)loadServiceDocumentAndMetaData {
    
    NSLog(@"ODataController - loadServiceDocumentAndMetaData called");
    if(!self.serviceDocumentURL || !self.metadataDocumentURL){
        NSLog(@"ODataDataController: Error - You must set serviceDocumentURL & metadataDocumentURL in your subclass!");
    }
    BOOL result = YES;
    
    NSLog(@"ODataDataController: Application Conn ID: %@", self.applicationConnectionID);
    
    /* =====================
     Get The OData Service Document
     ===================== */
    NSLog(@"ODataDataController: Service URL is: %@", self.serviceDocumentURL);
    
    //Set the Request type to HTTP
    [RequestBuilder setRequestType:HTTPRequestType];
    
    //Set the gateway header
    [RequestBuilder enableXCSRF:YES];
    
    id<Requesting> svcDocRequest = [RequestBuilder requestWithURL:[[NSURL alloc] initWithString:_serviceDocumentURL]];
    
    
    [svcDocRequest setRequestMethod:@"GET"];
    
    //Set the Application Connection ID we got when we registered
    [svcDocRequest addRequestHeader:kX_SMP_APPCID value:self.applicationConnectionID];
    
    [svcDocRequest setTimeOutSeconds:30];
    
    //Set the credentials
    [svcDocRequest setUsername:_credentials.username];
    [svcDocRequest setPassword:_credentials.password];
    
    NSLog(@"ODataDataController: Starting initial synchronous GET request for service document");
    
    //Send a syncronous request fro the metadata document
    [svcDocRequest startSynchronous];
    int svcDocRequestStatusCode = [svcDocRequest responseStatusCode];
    NSData *svcDoc = [svcDocRequest responseData];
    
    //Debug the response
    NSString *jsonStr = [[NSString alloc] initWithData:svcDoc encoding:NSASCIIStringEncoding];
    NSLog(@"==== service doc=%@", jsonStr);
    
    
    
    /* =====================
     Get The OData Metadata Document
     ===================== */
    NSLog(@"ODataDataController: Metadata URL is: %@", _metadataDocumentURL);
    
    //Set the Request type to HTTP
    [RequestBuilder setRequestType:HTTPRequestType];
    
    //Set the gateway header
    [RequestBuilder enableXCSRF:YES];
    
    id<Requesting> metaDocRequest = [RequestBuilder requestWithURL:[[NSURL alloc] initWithString:_metadataDocumentURL]];
    
    [metaDocRequest setRequestMethod:@"GET"];
    
    //Set the Application Connection ID we got when we registered
    [metaDocRequest addRequestHeader:kX_SMP_APPCID value:self.applicationConnectionID];
    
    [metaDocRequest setTimeOutSeconds:30];
    //Set the credentials
    [metaDocRequest setUsername:_credentials.username];
    [metaDocRequest setPassword:_credentials.password];
    
    NSLog(@"ODataDataController: Starting initial synchronous GET request for metadata document");
    
    //Send a syncronous request fro the metadata document
    [metaDocRequest startSynchronous];
    
    int metaDocRequestStatusCode = [metaDocRequest responseStatusCode];
    NSData *metaDoc = [metaDocRequest responseData];
    
    //Debug the response
    NSString *jsonStr2 = [[NSString alloc] initWithData:metaDoc encoding:NSASCIIStringEncoding];
    NSLog(@"==== meta doc=%@", jsonStr2);
    
    
    //check that both return successfully with a 200 response code
    if (svcDocRequestStatusCode == 200 && metaDocRequestStatusCode == 200) {
        @try {
            ODataServiceDocumentParser *serviceDocumentParser = [[ODataServiceDocumentParser alloc] init];
            [serviceDocumentParser parse:svcDoc];
            self.serviceDocument = serviceDocumentParser.serviceDocument;
            
            //Load the object with metadata xml:
            ODataMetaDocumentParser *metaDataParser = [[ODataMetaDocumentParser alloc] initWithServiceDocument:self.serviceDocument];
            [metaDataParser parse:metaDoc];
            
            
            NSString *message = nil;
            NSString *token = [svcDocRequest responseHeaders][kx_csrf_token];
            if ([token length] > 0) {
                message = [NSString stringWithFormat:@"ODataDataController: Service document and metadata loaded.\nX-CSRF token fetched: %@", token];
            } else {
                message = @"ODataDataController: Service document and metadata loaded.\nHowever, X-CSRF token not found!";
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
        NSLog(@"ODataDataController: Request for service document and/or metadata failed. Service document response code is: %d.  Metadata response status code is: %d", svcDocRequestStatusCode, metaDocRequestStatusCode);
        
        //Delete bad credentials from keychain if 401 unauthorized
        if (svcDocRequestStatusCode == 401 || metaDocRequestStatusCode == 401) {
            NSError *error = nil;
            [KeychainHelper deleteCredentialsAndReturnError:&error];
            if (error) {
                NSLog(@"ODataDataController: ERROR: Credentials could not be deleted from keychain - %@", [error localizedDescription]);
            }
        }
        result = NO;
    }
    return result;
}

///////////////////




-(void)setupCache
{

    
    
    
    NSLog(@"ODataController: setupCache ");
    id<Caching> cacheLocal = [[Cache alloc] init];
    NSError* error = nil;
    if (![cacheLocal initializeCacheWithError:&error])
    {
        NSLog(@"Initialize Error : %@@", error);
        return;
    }
    NSLog(@"cache: %@",cacheLocal);
    
    
    
    self.cache = cacheLocal;
}


@end
