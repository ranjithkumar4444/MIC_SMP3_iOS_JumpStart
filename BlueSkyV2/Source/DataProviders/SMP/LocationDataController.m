//
//  BSSMPMaterialGroupDataController.m
//  BlueSky
//
//  Created by Jones, Jeffry on 7/11/13.
//  Copyright (c) 2013 SAP MIC. All rights reserved.
//

#import "LocationDataController.h"
#import "BSLocation.h"

@interface LocationDataController ()
{
    NSMutableArray * coords;
    int count;
}
@end

@implementation LocationDataController

- (id) init {
    if (self = [super init]) {

        //Endpoint credentials (Load them from storage if possible)
        NSError *error = nil;
        _credentials = [KeychainHelper loadCredentialsAndReturnError: &error];
        if (error) {
            _credentials = [[CredentialsData alloc] initWithUsername: @"MICDEMO"
                                                             andPassword: @"welcome"];
        }

        //OData Collection Name
        _odataCollectionName = kLocationInfoCollection;

        //Build the Service Document URL ( http://<smp_server>:<smp_port>/<application_id>/ )
        _serviceDocumentURL = [[[ConnectivitySettings serviceURL] substringToIndex:[[ConnectivitySettings serviceURL] length]-1] stringByAppendingString:@"/"];

        //Build the Metadata Document URL ( http://<smp_server>:<smp_port>/<application_id>.plant/$metadata )
        _metadataDocumentURL = [NSString stringWithFormat:@"%@%@", _serviceDocumentURL, kMetadata];
        
        //call the super class setup method
        [self setup];
        
        CLLocation * loc1 = [[CLLocation alloc] initWithLatitude:40.67 longitude:-73.94];
        CLLocation * loc2 = [[CLLocation alloc] initWithLatitude:40.695 longitude:-73.814];
        CLLocation * loc3 = [[CLLocation alloc] initWithLatitude:40.73 longitude:-73.874];
        
        coords = [[NSMutableArray alloc] initWithObjects: loc1, loc2, loc3, nil];
    }
    return self;
}

/*
 This is our request builder and request sender
 */
- (void)getOData:(NSDictionary *)params onCompletion: (BSDataResponseBlock) responseBlock
         onError: (BSErrorResponseBlock) errorBlock {
    
    NSLog(@"LocationInfo Reuqest Called");
    
    //Parse the params from the dictionary
    BSLocation * location = [params objectForKey:@"location"];
    
    //Create the request url to call the OData REST service
    _requestURL = [NSString stringWithFormat: @"%@%@?$filter=Material+eq+'MIC-001'+and+UnitOfMeasure+eq+'EA'", _serviceDocumentURL, _odataCollectionName, location.locationID];
    NSLog(@"LocationInfo Request URL=%@", _requestURL);

    //Call the super classes getOData method
    [super getOData:params onCompletion:responseBlock onError:errorBlock];
    
}

//Here we convert the ODataEntry Array into our business objects
//This method gets called internally from the super classes 'getODataCompleted:' method which parses the raw data into an ODataEntry Array
-(NSArray *)createBusinessObjects:(NSArray *)oDataEntries
{
    NSMutableArray *businessObjects = [NSMutableArray new];
    
    
    NSLog(@"LocationDataController: oDataEntries: %@",oDataEntries);
    
    // Create business objects to be consumed by the response block
    // Update the view.
    if (oDataEntries && [oDataEntries count] > 0) {
        int counter = 0;
        BSLocation *loc;
        ODataEntry * entry = [oDataEntries objectAtIndex:[oDataEntries count]-1];
        //for(ODataEntry * entry in oDataEntries){
            NSString * ID = [[entry getPropertyValueByPath:kLocationInfoID] getValue];
            NSString * name = [[entry getPropertyValueByPath:kLocationInfoName] getValue];
            NSString * street = [[entry getPropertyValueByPath:kLocationInfoStreet] getValue];
            NSString * city = [[entry getPropertyValueByPath:kLocationInfoCity] getValue];
            NSString * state = [[entry getPropertyValueByPath:kLocationInfoState] getValue];
            NSString * postalCode = [[entry getPropertyValueByPath:kLocationInfoPostalCode] getValue];
            NSString * country = [[entry getPropertyValueByPath:kLocationInfoCountry] getValue];
            
            loc = [BSLocation new];
            loc.locationID = ID;
            loc.name = name;
            loc.address = street;
            loc.city = city;
            loc.state = state;
            loc.postalcode = postalCode;
            loc.country = country;
            
            loc.latlon = [coords[count++] coordinate];
            
            if(count > 2){
                count = 0;
            }
            
            [businessObjects addObject: loc];
            
            NSLog(@"LocationInfo[%d] ID=%@, Name=%@, street=%@, city=%@, state=%@, postalCode=%@, country=%@", counter++, ID, name, street, city, state, postalCode, country);
        }
    //}

    return businessObjects;
}
@end
