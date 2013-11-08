//
//  BSSMPMaterialGroupDataController.m
//  BlueSky
//
//  Created by Jones, Jeffry on 7/11/13.
//  Copyright (c) 2013 SAP MIC. All rights reserved.
//

#import "MARADataController.h"
#import "BSMaterial.h"
#import "Constants.h"

#import "RequestBuilder.h"
#import "EncryptionKeyManager.h"
#import "Request.h"

#import "ODataDataParser.h"
#import "ODataServiceDocumentParser.h"
#import "ODataMetaDocumentParser.h"
#import "ODataParser.h"
#import "ODataEntitySchema.h"
#import "BSAppDelegate.h"
#import "ODataEntry.h"


@implementation MARADataController

@synthesize ProductsList;
@synthesize ProductCollection;
@synthesize serviceDocument;
@synthesize metaDataDoc;
@synthesize cache;
@synthesize applicationConnectionID;


- (id) init {
    if (self = [super init]) {
        NSLog(@"########## A02");
        //Endpoint credentials (Load them from storage if possible)
        NSError *error = nil;
        _credentials = [KeychainHelper loadCredentialsAndReturnError: &error];
        if (error) {
            _credentials = [[CredentialsData alloc] initWithUsername: @"MICDEMO"
                                                             andPassword: @"welcome"];
        }
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        applicationConnectionID = [defaults stringForKey:kApplicationConnectionId];
        
        //OData Collection Name
        _odataCollectionName = kMARACollection;
        
        

        //Build the Service Document URL ( http://<smp_server>:<smp_port>/<application_id>/ )
        _serviceDocumentURL = [[[ConnectivitySettings serviceURL] substringToIndex:[[ConnectivitySettings serviceURL] length]-1] stringByAppendingString:@"/"];

        //Build the Metadata Document URL ( http://<smp_server>:<smp_port>/<application_id>/$metadata )
        _metadataDocumentURL = [NSString stringWithFormat:@"%@%@", _serviceDocumentURL, kMetadata];
        
        
        
        //call the super class setup method
        
        [RequestBuilder setDelegate:self];
        [RequestBuilder setDidFinishSelector:@selector(reqFin:)];
        [RequestBuilder setDidFailSelector:@selector(reqFail:)];
        
        [self setupCache];
        

        
        
// ?
        
        self.serviceDocument = [self.cache readDocumentForUrlKey:_odataCollectionName forDocType:0 withError:&error];
        
        //NSLog(@"MARADataController: init self.serviceDocumentURL: %@ error: %@",self.serviceDocumentURL,error);
        //NSLog(@"MARADataController: init  _serviceDocumentURL: %@ error: %@",_serviceDocumentURL,error);
        
        self.metaDataDoc = [self.cache readDocumentForUrlKey:_odataCollectionName forDocType:1 withError:&error];
        
       // NSLog(@"MARADataController: init  self.metaDataDoc: %@ error: %@",self.metaDataDoc,error);
       // NSLog(@"MARADataController: init  _metaDataDoc: %@ error: %@",_metadataDocumentURL,error);
        
        
        //NSLog(@"MARADataController: init  A self.cache: %@ error: %@",self.cache,error);
        
        [self setup];
        
       // NSLog(@"MARADataController: init  B self.cache: %@ error: %@",self.cache,error);
        
        self.serverEntriesCopyList = [[NSArray alloc] init];
        self.locallyModifiedEntriesList = [[NSArray alloc] init];
        
        self.displayRowsArray = [[NSMutableArray alloc] init];
        
        self.serverEntriesCopyList = [self.cache readEntriesForUrlKey:_odataCollectionName withError:&error];
        self.locallyModifiedEntriesList = [self.cache readEntriesLocalForEntryId:nil forEntityType:_odataCollectionName withError:&error];
        [self.displayRowsArray setArray:self.serverEntriesCopyList];
        [ProductsList setArray:self.serverEntriesCopyList];
        
        self.ProductCollection = [self.serviceDocument.schema getCollectionByName:_odataCollectionName];
        
       /// NSLog(@"MARADataController: init ProductCollection: %@",self.ProductCollection);
        
        
        
        
        
        
        
        
       // NSLog(@"MARADataController: init ProductCollection: %@", self.ProductCollection.links);
        
       // NSLog(@"MARADataController: init what's in self.serverEntriesCopyList?: %@",self.serverEntriesCopyList);
       // NSLog(@"MARADataController: init what's in self.locallyModifiedEntriesList?: %@",self.locallyModifiedEntriesList);
        
       // NSLog(@"MARADataController: init what's in displayRowsArray?: %@",self.displayRowsArray);
        
       // NSLog(@"MARADataController: init what's in displayRowsArray?: %@",self.ProductsList);
        
        
        
        
        
        
        
        
        //call the super class setup method
       // [self setup];
    }
    return self;
}

/*
 This is our request builder and request sender
 */
- (void)getOData:(NSDictionary *)params onCompletion: (BSDataResponseBlock) responseBlock onError: (BSErrorResponseBlock) errorBlock
{
    NSLog(@"MARA Reuqest Called");

    //Parse the params from the dictionary
    NSString * group = [params objectForKey:@"group"];
    
    //Create the request url to call the OData REST service
    _requestURL = [NSString stringWithFormat: @"%@%@?$filter=Category+eq+'%@'", _serviceDocumentURL, _odataCollectionName, group];
    
    NSLog(@"MARA Request URL=%@", _requestURL);
    
    //Call the super classes getOData method
    [super getOData:params onCompletion:responseBlock onError:errorBlock];
}

//Here we convert the ODataEntry Array into our business objects
//This method gets called internally from the super classes 'getODataCompleted:' method which parses the raw data into an ODataEntry Array
-(NSArray *)createBusinessObjects:(NSArray *)oDataEntries
{
    NSMutableArray *businessObjects = [NSMutableArray new];
    // Update the view.
    if (oDataEntries && [oDataEntries count] > 0) {
        int count = 0;
        
        BSMaterial *mat;
        
        for(ODataEntry * entry in oDataEntries){
            NSString * ID = [[entry getPropertyValueByPath:kMARAID] getValue];
            NSString * name = [[entry getPropertyValueByPath:kMARAname] getValue];
            NSString * groupID = [[entry getPropertyValueByPath:kMARAgroupID] getValue];
            
            mat = [BSMaterial new];
            mat.groupID = groupID;
            mat.materialID = ID;
            mat.name = name;
            [businessObjects addObject: mat];
            
            NSLog(@"MARA[%d] ID=%@ Name=%@, groupID=%@", count++, ID, name, groupID);
        }
        [self updateCache];
    }
    return businessObjects;
}




-(void)reqFin:(id<Requesting>)request
{
    NSLog(@"MARADataController - Z33");
    //NSError *error;
    
    
    NSMutableArray *entryIdArray = [ request cacheEntryIdList];
    for (NSString *entryId in entryIdArray)
    {
        // [self.cache clearLocalEntryForEntryId:entryId withError:&error];
    }
    
    NSLog(@"MARADataController -            ***********************************************\n");
    NSLog(@" ****** COMPLETED SUCCESSFULLY\n");
    NSLog(@"******************************************************************************\n");
    
}


-(void)updateCache {
    NSLog(@"MARADataController: updateCache called");

}


-(void)setupCache
{
    id<Caching> cacheLocal = [[Cache alloc] init];
    NSError* error = nil;
    if (![cacheLocal initializeCacheWithError:&error])
    {
        return;
    }

    self.cache = cacheLocal;

    
}



@end
