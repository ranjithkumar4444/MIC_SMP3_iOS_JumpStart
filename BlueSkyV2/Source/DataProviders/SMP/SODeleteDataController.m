//
//  BSSMPMaterialGroupDataController.m
//  BlueSky
//
//  Created by Jones, Jeffry on 7/11/13.
//  Copyright (c) 2013 SAP MIC. All rights reserved.
//

#import "SODeleteDataController.h"
#import "BSMaterialGroup.h"
#import "Constants.h"
#import "RequestBuilder.h"
#import "Request.h"
#import "EncryptionKeyManager.h"
#import "BSAppDelegate.h"


@implementation SODeleteDataController

- (id) init {
    if (self = [super init]) {

        NSError *error = nil;
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString *encryptionKey = [defaults stringForKey:kEncryptionKey ];
 
        
        if(!encryptionKey) {
            NSString *key = [EncryptionKeyManager getEncryptionKey:&error];
            [defaults setValue:key forKeyPath:kEncryptionKey];
        }
        else {
            [EncryptionKeyManager setEncryptionKey:encryptionKey withError:&error];
        }
        
        
        
        
        //Endpoint credentials (Load them from storage if possible)
        
        _credentials = [KeychainHelper loadCredentialsAndReturnError: &error];
        if (error) {
            _credentials = [[CredentialsData alloc] initWithUsername: @"MICDEMO" andPassword: @"welcome"];
        }

        //OData Collection Name
        _odataCollectionName = kSODelete;

        //Build the Service Document URL ( http://<smp_server>:<smp_port>/<application_id>.grp/ )
        _serviceDocumentURL = [[[ConnectivitySettings serviceURL] substringToIndex:[[ConnectivitySettings serviceURL] length]-1] stringByAppendingString:@"/"];
        
        //Build the Metadata Document URL ( http://<smp_server>:<smp_port>/<application_id>.grp/$metadata )
        _metadataDocumentURL = [NSString stringWithFormat:@"%@%@", _serviceDocumentURL, kMetadata];
        
        //call the super class setup method
        
        
        [RequestBuilder setDelegate:self];
        [RequestBuilder setDidFinishSelector:@selector(reqFin:)];
        [RequestBuilder setDidFailSelector:@selector(reqFail:)];

        
        
        
        [self setup];
        
        
        
        
        // OFFLINE STUFF
        [self setupCache];
        
        
        
        
        
        self.serverEntriesCopyList = [[NSArray alloc] init];
        self.locallyModifiedEntriesList = [[NSArray alloc] init];
        
        self.displayRowsArray = [[NSMutableArray alloc] init];
        
        self.serverEntriesCopyList = [self.cache readEntriesForUrlKey:_odataCollectionName withError:&error];
        self.locallyModifiedEntriesList = [self.cache readEntriesLocalForEntryId:nil forEntityType:_odataCollectionName withError:&error];
        [self.displayRowsArray setArray:self.serverEntriesCopyList];

        
        
        
    }
    return self;
}



- (void)requestFailed:(Request *)request {

    NSError* error = [request error];
    int statusCode = request.responseStatusCode;
    NSData *responseData = [request responseData];
    NSString *responseString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
    
    NSLog(@"error: %@ - responseString %@",error,responseString);
    
    NSString *errorMessage = [NSString stringWithFormat:@"ERROR: %@. Response status code is: %d.",[request error], statusCode];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Request Failed!"
                                                    message:errorMessage
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
}


-(void)reqFin:(id<Requesting>)request
{
    //NSError *error;
    
    
    NSMutableArray *entryIdArray = [ request cacheEntryIdList];
    for (NSString *entryId in entryIdArray)
    {
       // [self.cache clearLocalEntryForEntryId:entryId withError:&error];
    }
    
    NSLog(@"DELETE REQUEST COMPLETED SUCCESSFULLY*****************************************\n");
    
}




-(void)reqFail:(id<Requesting>)request
{
    NSLog(@"%d\n,%@\n, %@\n %@\n",[request responseStatusCode],[request responseStatusMessage],[[request error] description],[request responseString]);
}



/*
 This is our request builder and request sender
 */
- (void)getOData:(NSDictionary *)params onCompletion: (BSDataResponseBlock) responseBlock
         onError: (BSErrorResponseBlock) errorBlock {
    
    NSString  * salesOrderID = [params objectForKey:@"salesOrderID"];
    
    //Build the request url to call the OData REST service
    _requestURL = [NSString stringWithFormat: @"%@%@('%@')", _serviceDocumentURL, _odataCollectionName, salesOrderID];

    //Call the super classes getOData method
    //[super getOData:params onCompletion:responseBlock onError:errorBlock];
    
    [RequestBuilder setRequestType: HTTPRequestType];
    
    //Enable the Gateway header for OData
    [RequestBuilder enableXCSRF: YES];
    
    //Create the request using the request builder
    id<Requesting> request = [RequestBuilder requestWithURL: [NSURL URLWithString: _requestURL]];
    
    //Set the mthod type to get
    [request setRequestMethod: @"DELETE"];
    
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

    
    // OFFLINE STUFF
    NSMutableArray *entryIdArray = [NSMutableArray array];
    //[entryIdArray addObject:[SOItem getEntryID]];
    [entryIdArray addObject:salesOrderID];

    [request setCacheEntryIdList:entryIdArray];
    
    //Set finish selector for request to that of the super class
    request.didFinishSelector = @selector(getODataCompleted:);
    [request startAsynchronous];
}



- (void)deleteSOItemWithSOItem:(ODataEntry *)SOItem {

    NSString *salesOrderID = [[SOItem getPropertyValueByPath:@"salesOrderID"] getValue];
    
    NSString *soURL = [NSString stringWithFormat:@"%@%@('%@')",_serviceDocumentURL, _odataCollectionName, salesOrderID];
    [RequestBuilder setRequestType:HTTPRequestType];
    [RequestBuilder enableXCSRF:YES];
    
    //NSError *error;
//    MAFLogonRegistrationData* registrationData = [self.onboardingHandler.logonManager registrationDataWithError:&error];
//    
    id<Requesting> request = [RequestBuilder requestWithURL:[[NSURL alloc] initWithString:soURL]];
    [request setRequestMethod:@"DELETE"];
//    
    [request setUsername: _credentials.username];
    [request setPassword: _credentials.password];
    [request addRequestHeader:kX_SMP_APPCID value:self.applicationConnectionID];
//    
//    if ([ConnectivitySettings useJSON]) {
//        [request addRequestHeader:@"Accept" value:kApplicationJSON];
//    }
//    
//

    NSMutableArray *entryIdArray = [NSMutableArray array];

    [entryIdArray addObject:[SOItem getEntryID]];
    [request setCacheEntryIdList:entryIdArray];

    [request startAsynchronous];
}









//Here we convert the ODataEntry Array into our business objects 
//This method gets called internally from the super classes 'getODataCompleted:' method which parses the raw data into an ODataEntry Array
-(NSArray *)createBusinessObjects:(NSArray *)oDataEntries{
    [self updateCache];
    return nil;
}




-(void)updateCache {
    NSError *error;
    
    //SOItems
    
    [self.cache mergeEntriesFromFeed:self.feed forUrlKey:_odataCollectionName withError:&error withCompletionBlock:^(NSNotification *notif) {
        NSError *error;
        self.serverEntriesCopyList = [self.cache readEntriesForUrlKey:_odataCollectionName withError:&error];
        self.locallyModifiedEntriesList = [self.cache readEntriesLocalForEntryId:nil forEntityType:_odataCollectionName withError:&error];
        [self.displayRowsArray setArray:self.serverEntriesCopyList];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"blah" object:self userInfo:nil];
    }];
    
}


-(void)setupCache
{
    
    
   // BSAppDelegate *appDelegate = (BSAppDelegate *)[[UIApplication sharedApplication] delegate];
   //
   //  self.cache = [appDelegate cache];

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
