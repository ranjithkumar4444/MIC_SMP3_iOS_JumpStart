//
//  PWSDataController.m
//  Flights
//
//  Created by Damien Murphy
//  Copyright (c) 2013 MIC. All rights reserved.
//

#import "PWSDataController.h"
#import "BSATPRecord.h"

@implementation PWSDataController

- (id)init {
    if (self = [super init]) {
        NSLog(@"########## A04");
        //Endpoint credentials (Load them from storage if possible)
        NSError *error = nil;
        _credentials = [KeychainHelper loadCredentialsAndReturnError: &error];
        if (error) {
            _credentials = [[CredentialsData alloc] initWithUsername: @"MICDEMO"
                                                         andPassword: @"welcome"];
        }
        
        //OData Collection Name
        _odataCollectionName = kATPCollection;
        
        //Build the Service Document URL ( http://<smp_server>:<smp_port>/<application_id>.atp/ )
        _serviceDocumentURL = [[[ConnectivitySettings serviceURL] substringToIndex:[[ConnectivitySettings serviceURL] length]-1] stringByAppendingString:@"/"];
        
        //Build the Metadata Document URL ( http://<smp_server>:<smp_port>/<application_id>/$metadata )
        _metadataDocumentURL = [NSString stringWithFormat:@"%@%@", _serviceDocumentURL, kMetadata];
        
        //call the super class setup method
        [self setup];
    }
    return self;
}

- (void)getOData:(NSDictionary *)params onCompletion: (BSDataResponseBlock) responseBlock onError: (BSErrorResponseBlock) errorBlock
{
    
    //Parse the params from the dictionary
    NSString * material = [params objectForKey:@"material"];
    NSString * plant = [params objectForKey:@"plant"];
    NSString * unit = [params objectForKey:@"unit"];
    
    //Create the request url to call the OData REST service
    _requestURL = [NSString stringWithFormat:@"%@%@(material='%@',plant='%@',unit='%@')",_serviceDocumentURL, _odataCollectionName, material, plant, unit];

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

        BSATPRecord *atp = [BSATPRecord new];
        
        for(ODataEntry * entry in oDataEntries){
            NSString * locationID = [[entry getPropertyValueByPath:kATPlocationID] getValue];
            NSString * materialID = [[entry getPropertyValueByPath:kATPmaterialID] getValue];
            NSString * unit = [[entry getPropertyValueByPath:kATPunits] getValue];
            NSString * plant = [[entry getPropertyValueByPath:kATPPlant] getValue];
            NSString * quantity = [[entry getPropertyValueByPath:kATPquantity] getValue];
            
            atp = [BSATPRecord new];
            atp.materialID = materialID;
            atp.locationID = locationID;
            atp.units = unit;
            atp.plant = plant;
            atp.quantity = [quantity floatValue];
            [businessObjects addObject: atp];
        }
    }
    return businessObjects;
    
}
@end
