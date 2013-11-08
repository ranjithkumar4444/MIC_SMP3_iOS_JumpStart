//
//  BSDataController.m
///  OfflineSample
//
//  Copyright (c) 2013 SAP AG. All rights reserved.
//

#import "CategoryDataController.h"
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
#import "BSAppDelegate.h"
#import "SettingsUtilities.h"

//static CredentialsData *credentials;
static NSString *applicationConnectionID;

@interface CategoryDataController ()

@end

@implementation CategoryDataController

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

        _credentials = [KeychainHelper loadCredentialsAndReturnError: &error];
        
        if (error) {
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            NSString *username = [defaults stringForKey:@"username"];
            NSString *password = [defaults stringForKey:@"password"];
            _credentials = [[CredentialsData alloc] initWithUsername:username andPassword:password];
        }

        
        /* Initialize Cache */
        [self setupCache];

        /* Array for server copy from cache */
        self.serverEntriesCopyList = [[NSArray alloc] init];
        /* Array for local copy from cache.Will contain locally changed entries. */
        self.locallyModifiedEntriesList = [[NSArray alloc] init];
        /* Helper array for display */
        self.displayRowsArray = [[NSMutableArray alloc] init];
        self.serverEntriesCopyList = [self.cache readEntriesForUrlKey:kCategoryCollection withError:&error];
        self.locallyModifiedEntriesList = [self.cache readEntriesLocalForEntryId:nil forEntityType:kCategoryCollection withError:&error];
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
        
        /* Initialize categoryList and category */
        self.categoryList = [[NSMutableArray alloc] init];
        
        //The parser creates the schema of the input service document's collections and returns a collection by name
        self.categoryCollection = [self.serviceDocument.schema getCollectionByName:kCategoryCollection];

        [RequestBuilder setDelegate:self];
        [RequestBuilder setDidFinishSelector:@selector(reqFin:)];
        [RequestBuilder setDidFailSelector:@selector(reqFail:)];

        return self;
    }
    return nil;
}


- (void)setCategoryList:(NSMutableArray *)newList {
    if (_categoryList != newList) {
        _categoryList = [newList mutableCopy];
    }
}

#pragma mark - Singleton

+ (CategoryDataController *)uniqueInstance
{
    static CategoryDataController *instance;

    @synchronized(self) {
        if (!instance) {
            instance = [[CategoryDataController alloc] init];
        }
        return instance;
    }
}


#pragma mark - Load Service and MetaData Docs
- (BOOL)loadServiceDocumentAndMetaData {
    BOOL result = YES;
    NSError *error;
    /* Check if serviceDocument and Metadocument are available from cache */
    self.serviceDocument = [self.cache readDocumentForUrlKey:kCategoryCollection forDocType:0 withError:&error];
    self.metaDataDoc = [self.cache readDocumentForUrlKey:kCategoryCollection forDocType:1 withError:&error];

    if (!self.serviceDocument || !self.metaDataDoc)
    {
        /* Get Service Document */
        NSLog(@"Service URL is: %@", [ConnectivitySettings serviceURL]);
        [RequestBuilder setRequestType:HTTPRequestType];
        [RequestBuilder enableXCSRF:YES];
        id<Requesting> svcDocRequest = [RequestBuilder requestWithURL:[[NSURL alloc] initWithString:[ConnectivitySettings serviceURL]]];

        [svcDocRequest setRequestMethod:@"GET"];
        [svcDocRequest addRequestHeader:kX_SMP_APPCID value:self.applicationConnectionID];
        [svcDocRequest setUsername:_credentials.username];
        [svcDocRequest setPassword:_credentials.password];

        /* Starting initial synchronous GET request for service document */
        [svcDocRequest startSynchronous];
        
        int svcDocRequestStatusCode = [svcDocRequest responseStatusCode];
        NSData *svcDoc = [svcDocRequest responseData];
        //NSString* newStrA = [NSString stringWithUTF8String:[svcDoc bytes]];
        //NSLog(@"svcDoc response string: %@",newStrA);
        
        /* Get Metadata */
        NSString *metaDataURL = [NSString stringWithFormat:@"%@%@",[ConnectivitySettings serviceURL], kMetadata];
        [RequestBuilder setRequestType:HTTPRequestType];
        [RequestBuilder enableXCSRF:YES];
        id<Requesting> metaDocRequest = [RequestBuilder requestWithURL:[[NSURL alloc] initWithString:metaDataURL]];
        [metaDocRequest setRequestMethod:@"GET"];
        [metaDocRequest addRequestHeader:kX_SMP_APPCID value:self.applicationConnectionID];
        [metaDocRequest setUsername:_credentials.username];
        [metaDocRequest setPassword:_credentials.password];
        
        /* Starting initial synchronous GET request for metadata document */
        [metaDocRequest startSynchronous];
        
        int metaDocRequestStatusCode = [metaDocRequest responseStatusCode];
        NSData *metaDoc = [metaDocRequest responseData];
        //NSString* newStr = [NSString stringWithUTF8String:[metaDoc bytes]];
        //NSLog(@"metaDoc response string: %@",newStr);

        if (svcDocRequestStatusCode == 200 && metaDocRequestStatusCode == 200) {
            @try {
                /* Parse service Doc */
                self.serviceDocument = parseODataServiceDocumentXML(svcDoc);
                
                /* Parse MetaDataDoc */
                self.metaDataDoc = parseODataSchemaXML(metaDoc,self.serviceDocument);
                
                /* Store both in cache. The service doc msut be stored only after the metadatadoc is parsed.( as in the line above) */
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
            
            /* Delete bad credentials from keychain if 401 unauthorized //TODO - do we still need this if we are using MAF? */
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





- (void)loadCategoryCollectionWithDidFinishSelector:(SEL)aFinishSelector forUrl:(NSString *)url{
    NSLog(@"loadCategoryCollectionWithDidFinishSelector");

    if (!url)
        url = [NSString stringWithFormat:@"%@%@",[ConnectivitySettings serviceURL], kCategoryCollection];
    
    /* NSLog(@"%@\n",url); */
    
    [RequestBuilder setRequestType:HTTPRequestType];
    [RequestBuilder enableXCSRF:YES];
    id<Requesting> request = [RequestBuilder requestWithURL:[[NSURL alloc] initWithString:url]];
    [request setRequestMethod:@"GET"];

    /* Use JSON if set */
    if ([ConnectivitySettings useJSON]) {
        [request addRequestHeader:@"Accept" value:kApplicationJSON];
    }

    [request addRequestHeader:kX_SMP_APPCID value:applicationConnectionID];
    [request setUsername:_credentials.username];
    [request setPassword:_credentials.password];

    if (aFinishSelector != nil) {
        [request setDelegate:self];
        
        /* Set finish selector for request */
        if (aFinishSelector) {
            request.didFinishSelector = aFinishSelector;
            }

        /* Starting initial asynchronous GET request for Travel Agency Collection */
        [request startAsynchronous];
        
        }
    else { // All requests for GET after CUD operation (other than the first GET)

        [request startSynchronous];
        NSLog(@"%d\n,%@\n, %@\n %@\n",[request responseStatusCode],[request responseStatusMessage],[[request error] description],[request responseString]);
        ODataDataParser *dataParser=[[ODataDataParser alloc] initWithEntitySchema:self.categoryCollection.entitySchema andServiceDocument:self.serviceDocument];
        [dataParser parse:[request responseData]];
        self.categoryList = dataParser.entries;
        self.feed = dataParser.feed;
        
        NSLog(@"loaded %d entries", [self.feed entries].count);
    }
}


- (void)loadCategoryWithID:(NSString *)agencyID andDidFinishSelector:(SEL)aFinishSelector {
    NSLog(@"loadCategoryWithID %@",agencyID);
    
    NSString *categoryURL = [NSString stringWithFormat:@"%@%@('%@')",[ConnectivitySettings serviceURL], kCategoryCollection, agencyID];
    [RequestBuilder setRequestType:HTTPRequestType];
    [RequestBuilder enableXCSRF:YES];
    id<Requesting> request = [RequestBuilder requestWithURL:[[NSURL alloc] initWithString:categoryURL]];
    [request setRequestMethod:@"GET"];
    
    [request addRequestHeader:kX_SMP_APPCID value:applicationConnectionID];
    
    /* Use JSON if set */
    if ([ConnectivitySettings useJSON]) {
        [request addRequestHeader:@"Accept" value:kApplicationJSON];
    }
    
    [request setDelegate:self];
    
    /* Set finish selector for request */
    if (aFinishSelector) {
        request.didFinishSelector = aFinishSelector;
    }
    
    NSLog(@"Starting initial asynchronous GET request for Category");
    [request startAsynchronous];
}

/* This method is called the very first time the agencies are retrieved with a GET. */
- (void)loadCategoryCollectionCompleted:(id <Requesting>)request {
    
    /* Instantiate parser for OData entities */
    ODataDataParser *dataParser=[[ODataDataParser alloc] initWithEntitySchema:self.categoryCollection.entitySchema andServiceDocument:self.serviceDocument];
    
    /*Parses a feed or an entry or json */
    [dataParser parse:[request responseData]];
    
    /* The array of parsed entry/entries can be accessed via the "entries" property
     of the parser after parsing.
     Array of OData Entries can be iterated
     and diplay the requisite data in CollectionView */
    self.categoryList = dataParser.entries;
    self.feed = dataParser.feed;
    
    //NSLog(@"loaded %d entries", [self.feed entries].count);
    
    [self updateCache];
}

- (void)loadCategoryCompleted:(id <Requesting>)request {

    NSLog(@"Request for OData Entries succeeded!");
    
    /* Instantiate parser for OData Entries */
    ODataDataParser *dataParser=[[ODataDataParser alloc] initWithEntitySchema:self.categoryCollection.entitySchema andServiceDocument:self.serviceDocument];
    
    /* FOR DEBUG */
    //NSData *responseData = [request responseData];
    //NSString *responseString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
    //NSLog(@"Getting Response string: %@", responseString);
    
    //Parses a feed or an entry xml or json.
    [dataParser parse:[request responseData]];
    self.categoryList = dataParser.entries;
    self.feed = dataParser.feed;
    
    //The array of parsed entry/entries can be accessed via the "entries" property of the parser after parsing.
    //Array of OData Entries can be iterated and diplay the requisite data in tableview
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kLoadCategoryCollectionCompletedNotification object:self userInfo:nil];
}

#pragma mark - Cache

-(void)setupCache {
    id<Caching> cacheLocal = [[Cache alloc] init];
    NSError* error = nil;
    if (![cacheLocal initializeCacheWithError:&error]) {
        NSLog(@"Initialize Error : %@@", error);
        return;
        }
    self.cache = cacheLocal;
}

-(void)updateCache
{
    /* After the initial load of entries, populate the server cache for the first time. */
    NSError* error;

    [self.cache mergeEntriesFromFeed:self.feed forUrlKey:kCategoryCollection withError:&error withCompletionBlock:^(NSNotification *notif) {
        NSError* error;
        self.serverEntriesCopyList = [self.cache readEntriesForUrlKey:kCategoryCollection withError:&error];
        self.locallyModifiedEntriesList = [self.cache readEntriesLocalForEntryId:nil  forEntityType:kCategoryCollection withError:&error];
        [self.displayRowsArray setArray:self.serverEntriesCopyList];
        [[NSNotificationCenter defaultCenter] postNotificationName:kLoadCategoryCollectionCompletedNotification object:self userInfo:nil];
        
    }];
}

-(void)onMergeComplete:(NSNotification *)notification {
    
    NSLog(@"In listener\n");
    NSError* error;
    self.serverEntriesCopyList = [self.cache readEntriesForUrlKey:kCategoryCollection withError:&error];
    self.locallyModifiedEntriesList = [self.cache readEntriesLocalForEntryId:nil  forEntityType:kCategoryCollection withError:&error];
    [self.displayRowsArray setArray:self.serverEntriesCopyList];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kLoadCategoryCollectionCompletedNotification object:self userInfo:nil];
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


-(void)reqFin:(id<Requesting>)request {
    NSError *error;
    NSMutableArray *entryIdArray = [ request cacheEntryIdList];
    for (NSString *entryId in entryIdArray)
    {
        [self.cache clearLocalEntryForEntryId:entryId withError:&error];
    }
    NSLog(@"******************************************************************************\n");
    NSLog(@"REQUEST COMPLETED SUCCESSFULLY CDC \n");
    NSLog(@"******************************************************************************\n");
}




-(void)reqFail:(id<Requesting>)request {
    NSLog(@"%d\n,%@\n, %@\n %@\n",[request responseStatusCode],[request responseStatusMessage],[[request error] description],[request responseString]);
}

@end
