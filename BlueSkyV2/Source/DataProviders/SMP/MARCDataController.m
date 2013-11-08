//
//  BSSMPMaterialGroupDataController.m
//  BlueSky
//
//  Created by Jones, Jeffry on 7/11/13.
//  Copyright (c) 2013 SAP MIC. All rights reserved.
//

#import "MARCDataController.h"
#import "BSLocation.h"

@implementation MARCDataController

- (id) init {
    if (self = [super init]) {
        NSLog(@"########## A03");
        //Endpoint credentials (Load them from storage if possible)
        NSError *error = nil;
        _credentials = [KeychainHelper loadCredentialsAndReturnError: &error];
        if (error) {
            _credentials = [[CredentialsData alloc] initWithUsername: @"MICDEMO"
                                                             andPassword: @"welcome"];
        }

        //OData Collection Name
        _odataCollectionName = kMARCCollection;

        //Build the Service Document URL ( http://<smp_server>:<smp_port>/<application_id>/ )
        _serviceDocumentURL = [[[ConnectivitySettings serviceURL] substringToIndex:[[ConnectivitySettings serviceURL] length]-1] stringByAppendingString:@"/"];
        
        //Build the Metadata Document URL ( http://<smp_server>:<smp_port>/<application_id>/$metadata )
        _metadataDocumentURL = [NSString stringWithFormat:@"%@%@", _serviceDocumentURL, kMetadata];
        
        //call the super class setup method
        [self setup];
    }
    return self;
}

/*
 This is our request builder and request sender
 */
- (void)getOData:(NSDictionary *)params onCompletion: (BSDataResponseBlock) responseBlock onError: (BSErrorResponseBlock) errorBlock;
{
    
    NSLog(@"MARC Reuqest Called");

    //Parse the params from the dictionary
    NSString * material = [params objectForKey:@"material"];
    
    //Create the request url to call the OData REST service
    _requestURL = [NSString stringWithFormat: @"%@%@?$filter=Material+eq+'%@'+and+UnitOfMeasure+eq+'EA'", _serviceDocumentURL, _odataCollectionName, material];
    
    NSLog(@"MARC Request URL=%@", _requestURL);
    
    //Call the super classes getOData method
    [super getOData:params onCompletion:responseBlock onError:errorBlock];
}


//Here we convert the ODataEntry Array into our business objects
//This method gets called internally from the super classes 'getODataCompleted:' method which parses the raw data into an ODataEntry Array
-(NSArray *)createBusinessObjects:(NSArray *)oDataEntries
{
    NSMutableArray *businessObjects = [NSMutableArray new];
    // Update the view.
    NSLog(@"createBusinessObjects from oDataEntries: %@",oDataEntries);
    
    if (oDataEntries && [oDataEntries count] > 0) {
        int count = 0;
        
        BSLocation *loc;
        NSString * locationID = @"";
        for(ODataEntry * entry in oDataEntries){
            
            locationID = [[entry getPropertyValueByPath:kMARClocationID] getValue];
            NSLog(@"sdfdsfdsf: %@",locationID);
            loc = [BSLocation new];
            loc.locationID = locationID;
            
            [businessObjects addObject:loc];
            
            NSLog(@"MARC[%d] ID=%@", count++, locationID);
        }
    }
    
    NSLog(@"MARC Business Objects!! %@",businessObjects);
    
    
    return businessObjects;
}
@end
