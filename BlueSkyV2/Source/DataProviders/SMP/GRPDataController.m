//
//  BSSMPMaterialGroupDataController.m
//  BlueSky
//
//  Created by Jones, Jeffry on 7/11/13.
//  Copyright (c) 2013 SAP MIC. All rights reserved.
//

#import "GRPDataController.h"
#import "BSMaterialGroup.h"
#import "Constants.h"

#import "RequestBuilder.h"
#import "Request.h"
#import "EncryptionKeyManager.h"

#import "ODataDataParser.h"
#import "ODataServiceDocumentParser.h"
#import "ODataMetaDocumentParser.h"
#import "ODataParser.h"
#import "ODataEntitySchema.h"
#import "BSAppDelegate.h"
#import "ODataEntry.h"


@implementation GRPDataController

@synthesize GRPList;
@synthesize serviceDocument;
@synthesize metaDataDoc;
@synthesize cache;
@synthesize applicationConnectionID;

- (id) init {
    if (self = [super init]) {
        NSLog(@"########## A01");
        
        
        //Endpoint credentials (Load them from storage if possible)
        NSError *error = nil;
        _credentials = [KeychainHelper loadCredentialsAndReturnError: &error];
        if (error) {
            _credentials = [[CredentialsData alloc] initWithUsername: @"MICDEMO" andPassword: @"welcome"];

        }

        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
         applicationConnectionID = [defaults stringForKey:kApplicationConnectionId];
        
        //OData Collection Name
        _odataCollectionName = kGRPCollection;

        //Build the Service Document URL ( http://<smp_server>:<smp_port>/<application_id>/ )
        _serviceDocumentURL = [[[ConnectivitySettings serviceURL] substringToIndex:[[ConnectivitySettings serviceURL] length]-1] stringByAppendingString:@"/"];
        
        //Build the Metadata Document URL ( http://<smp_server>:<smp_port>/<application_id>.grp/$metadata )
        _metadataDocumentURL = [NSString stringWithFormat:@"%@%@", _serviceDocumentURL, kMetadata];
        
        //call the super class setup method
        
        [RequestBuilder setDelegate:self];
        [RequestBuilder setDidFinishSelector:@selector(reqFin:)];
        [RequestBuilder setDidFailSelector:@selector(reqFail:)];
        
        [self setupCache];

        self.serviceDocument = [self.cache readDocumentForUrlKey:_odataCollectionName forDocType:0 withError:&error];
        
        self.metaDataDoc = [self.cache readDocumentForUrlKey:_odataCollectionName forDocType:1 withError:&error];

        [self setup];
        
        self.serverEntriesCopyList = [[NSArray alloc] init];
        self.locallyModifiedEntriesList = [[NSArray alloc] init];
        
        self.displayRowsArray = [[NSMutableArray alloc] init];
        
        self.serverEntriesCopyList = [self.cache readEntriesForUrlKey:_odataCollectionName withError:&error];
        self.locallyModifiedEntriesList = [self.cache readEntriesLocalForEntryId:nil forEntityType:_odataCollectionName withError:&error];
        [self.displayRowsArray setArray:self.serverEntriesCopyList];
        [self.GRPList setArray:self.serverEntriesCopyList];
        
        self.GRPCollection = [self.serviceDocument.schema getCollectionByName:_odataCollectionName];

    }
    return self;
}





#pragma mark - Data service calls
- (BOOL)loadServiceDocumentAndMetaData {

    BOOL result = YES;
    NSError *error;

    self.serviceDocument = [self.cache readDocumentForUrlKey:_odataCollectionName forDocType:0 withError:&error];
    self.metaDataDoc = [self.cache readDocumentForUrlKey:_odataCollectionName forDocType:1 withError:&error];

    if (!self.serviceDocument || !self.metaDataDoc)
    {
        //Get Service Document
        
        [RequestBuilder setRequestType:HTTPRequestType];
        [RequestBuilder enableXCSRF:YES];
        
        //id<Requesting> svcDocRequest = [RequestBuilder requestWithURL:[[NSURL alloc] initWithString:[ConnectivitySettings serviceURL]]];
        
        id<Requesting> svcDocRequest = [RequestBuilder requestWithURL:[[NSURL alloc] initWithString:_serviceDocumentURL]];
        
        
      //  MAFLogonRegistrationData* registrationData = [self.onboardingHandler.logonManager registrationDataWithError:&error];
        
        [svcDocRequest setRequestMethod:@"GET"];
        [svcDocRequest addRequestHeader:kX_SMP_APPCID value:self.applicationConnectionID];
        
        [svcDocRequest setUsername: _credentials.username];
        [svcDocRequest setPassword: _credentials.password];
        
        
//        [svcDocRequest setUsername:registrationData.backendUserName];
//        [svcDocRequest setPassword:registrationData.backendPassword];

        [svcDocRequest startSynchronous];
        int svcDocRequestStatusCode = [svcDocRequest responseStatusCode];
        NSData *svcDoc = [svcDocRequest responseData];
        
        //Get Metadata
        //NSString *metaDataURL = [NSString stringWithFormat:@"%@%@",[ConnectivitySettings serviceURL], kMetadata];
        NSString *metaDataURL = [NSString stringWithFormat:@"%@%@",_serviceDocumentURL, kMetadata];
        [RequestBuilder setRequestType:HTTPRequestType];
        [RequestBuilder enableXCSRF:YES];
        id<Requesting> metaDocRequest = [RequestBuilder requestWithURL:[[NSURL alloc] initWithString:metaDataURL]];
        

        
        
        [svcDocRequest setRequestMethod:@"GET"];
        [svcDocRequest addRequestHeader:kX_SMP_APPCID value:self.applicationConnectionID];
        [svcDocRequest setUsername: _credentials.username];
        [svcDocRequest setPassword: _credentials.password];
        
//        [svcDocRequest setUsername:registrationData.backendUserName];
//        [svcDocRequest setPassword:registrationData.backendPassword];
        
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
                [self.cache storeDocument:self.serviceDocument forDocType:0 forUrlKey:_odataCollectionName withError:&error];
                [self.cache storeDocument:self.metaDataDoc forDocType:1 forUrlKey:_odataCollectionName withError:&error];
                
                
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










/*
 This is our request builder and request sender
 */
- (void)getOData:(NSDictionary *)params onCompletion: (BSDataResponseBlock) responseBlock
         onError: (BSErrorResponseBlock) errorBlock {

    
    //Build the request url to call the OData REST service
    _requestURL = [NSString stringWithFormat: @"%@%@%@", _serviceDocumentURL, _odataCollectionName,@""];

    
    
    
    
    
//    // OFFLINE STUFF
//    NSMutableArray *entryIdArray = [NSMutableArray array];
//    //[entryIdArray addObject:[SOItem getEntryID]];
//    [entryIdArray addObject:salesOrderID];
//    
//    NSLog(@"entryIdArray:%@",entryIdArray);
//    
//    
//    
//    [request setCacheEntryIdList:entryIdArray];
    

    
    //FOR DEBUG
    
    [RequestBuilder setRequestType: HTTPRequestType];
    
    //Enable the Gateway header for OData
    [RequestBuilder enableXCSRF: YES];
    
    //Create the request using the request builder
    id<Requesting> request = [RequestBuilder requestWithURL: [NSURL URLWithString: _requestURL]];
    
    
    NSData *responseData = [request responseData];
    NSString *responseString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
    NSLog(@"GRP Response string: %@", responseString);
    
    //_odataParser.entries = [[NSMutableArray alloc] init];
    
    ODataDataParser *odataParser = [ODataDataParser alloc];
    
    
    odataParser = nil;
    odataParser = [[ODataDataParser alloc] initWithEntitySchema:self.odataCollection.entitySchema andServiceDocument:self.serviceDocument];
    
    if(responseString && ![responseString isEqualToString:@""]){
        //Parses a feed or an entry xml or json.
        [odataParser parse:[request responseData]];
        
        NSLog(@"ODATA FEED update string=%@", [odataParser.feed updated]);
        
        self.feed = odataParser.feed;
        
        NSLog(@"feed: %@",self.feed);
        
        
        _odataResponseBlock([self createBusinessObjects:odataParser.entries]);
        
        
        
    }else{
        //_odataResponseBlock([self createBusinessObjects:nil]);
        
        
        //_odataResponseBlock([self createBusinessObjects:self.displayRowsArray]);
        [self createBusinessObjects:self.displayRowsArray];
        
        
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"blahblah" object:self userInfo:nil];
        
    }
    


    //Call the super classes getOData method
    [super getOData:params onCompletion:responseBlock onError:errorBlock];
}

//Here we convert the ODataEntry Array into our business objects 
//This method gets called internally from the super classes 'getODataCompleted:' method which parses the raw data into an ODataEntry Array
-(NSArray *)createBusinessObjects:(NSArray *)oDataEntries
{

    
    NSMutableArray *businessObjects = [NSMutableArray new];
    //NSLog(@"entryIdArray: %@",entryIdArray);
    //self.feed = entryIdArray;

    // Create business objects to be consumed by the response block
    //oDataEntries to [self.feed];
    
    if(oDataEntries.count > 1) {

        
        if ( oDataEntries && oDataEntries.count  > 0) {
            
            int count = 0;
            //MaterialGroup Business Object
            BSMaterialGroup *grp;
            
            for(ODataEntry * entry in oDataEntries){
                NSString * ID = [[entry getPropertyValueByPath:kGRPID] getValue];
                NSString * name = [[entry getPropertyValueByPath:kGRPname] getValue];
                
                grp = [BSMaterialGroup new];
                grp.groupID = ID;
                grp.name = name;
                [businessObjects addObject: grp];

            }
        }
        
        [self updateCache];
        //return businessObjects;

        
        //return nil;
        
        
        
        
    }
    else {

        
        if ( self.feed && [self.feed entries ].count  > 0) {
            
            int count = 0;
            //MaterialGroup Business Object
            BSMaterialGroup *grp;
            
            for(ODataEntry * entry in [self.feed entries]){
                NSString * ID = [[entry getPropertyValueByPath:kGRPID] getValue];
                NSString * name = [[entry getPropertyValueByPath:kGRPname] getValue];
                
                grp = [BSMaterialGroup new];
                grp.groupID = ID;
                grp.name = name;
                [businessObjects addObject: grp];
                
                NSLog(@"GRP[%d] ID=%@ Name=%@", count++, ID, name);
            }
        }
        
        [self updateCache];
        //return businessObjects;
        
        //return nil;
        
        
        
    }
    
    self.GRPList = businessObjects;
    
    return businessObjects;

}






// Tsis method is called the very first time the agencies are retrieved with a GET.
- (void)loadTravelAgencyCollectionCompleted:(id <Requesting>)request {
    
    //Instantiate parser for Travel Agency entity
    ODataDataParser *dataParser=[[ODataDataParser alloc] initWithEntitySchema:self.GRPCollection.entitySchema andServiceDocument:self.serviceDocument];
    
    //Parses a feed or an entry or json
    [dataParser parse:[request responseData]];
    
    //The array of parsed entry/entries can be accessed via the "entries" property of the parser after parsing.
    //Array of OData Entries can be iterated and diplay the requisite data in tableview
    self.GRPList = dataParser.entries;
    self.feed = dataParser.feed;
    
    NSLog(@"%d", [self.feed entries].count);
    
    [self updateCache];
}







-(void)reqFin:(id<Requesting>)request
{
    //NSError *error;
    
    
    NSMutableArray *entryIdArray = [ request cacheEntryIdList];
    for (NSString *entryId in entryIdArray)
    {
        // [self.cache clearLocalEntryForEntryId:entryId withError:&error];
    }
    
    NSLog(@"GRPDataController -            ***********************************************\n");
    NSLog(@" ****** COMPLETED SUCCESSFULLY\n");
    NSLog(@"******************************************************************************\n");
    
}




-(void)reqFail:(id<Requesting>)request
{
    NSLog(@"%d\n,%@\n, %@\n %@\n",[request responseStatusCode],[request responseStatusMessage],[[request error] description],[request responseString]);
}



- (void)requestFailed:(Request *)request {

    
    NSDictionary *stuff = [[NSDictionary alloc] initWithObjectsAndKeys:self.GRPList ,@"displayrows", nil];
 
    

    
    
    
    
    
    
    NSLog(@"what's in self.feed: %@",self.feed);
    
    
    
    
     [[NSNotificationCenter defaultCenter] postNotificationName:@"blahblah" object:self userInfo:stuff];
    
    
    
}




-(void)updateCache {
    NSLog(@"GRPDataController: updateCache called");
}


-(void)setupCache
{
    id<Caching> cacheLocal = [[Cache alloc] init];
    NSError* error = nil;
    if (![cacheLocal initializeCacheWithError:&error])
    {
        NSLog(@"GRPDataController - Initialize Error : %@@", error);
        return;
    }
    
    
    
    self.cache = cacheLocal;
    if(!self.cache){

    }
    
}



@end
