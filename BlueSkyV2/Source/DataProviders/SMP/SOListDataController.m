//
//  BSSMPMaterialGroupDataController.m
//  BlueSky
//
//  Created by Jones, Jeffry on 7/11/13.
//  Copyright (c) 2013 SAP MIC. All rights reserved.
//

//TEST
#import "BSAppDelegate.h"
#import "ODataParser.h"
#import "KeychainHelper.h"
#import "ConnectionSettings.h"
#import "Constants.h"
#import "ODataServiceDocument.h"
#import "ODataMetaDocumentParser.h"


#import "SOListDataController.h"
#import "BSSalesOrder.h"
#import "Constants.h"
#import "ODataFeed.h"
#import "Cache.h"




@implementation SOListDataController

- (id) init {
    if (self = [super init]) {
        NSLog(@"Y01");
        //Endpoint credentials (Load them from storage if possible)
        NSError *error = nil;
        _credentials = [KeychainHelper loadCredentialsAndReturnError: &error];
        if (error) {
            _credentials = [[CredentialsData alloc] initWithUsername: @"MICDEMO" andPassword: @"welcome"];
        }

        //OData Collection Name
        _odataCollectionName = kSOItemCollection;

        //Build the Service Document URL ( http://<smp_server>:<smp_port>/<application_id>/ )
        _serviceDocumentURL = [[[ConnectivitySettings serviceURL] substringToIndex:[[ConnectivitySettings serviceURL] length]-1] stringByAppendingString:@"/"];
        
        //Build the Metadata Document URL ( http://<smp_server>:<smp_port>/<application_id>.so/$metadata )
        _metadataDocumentURL = [NSString stringWithFormat:@"%@%@", _serviceDocumentURL, kMetadata];
        

        
        
        
        
        self.serverEntriesCopyList = [[NSArray alloc] init];
        self.locallyModifiedEntriesList = [[NSArray alloc] init];
        
        self.displayRowsArray = [[NSMutableArray alloc] init];
        
        self.serverEntriesCopyList = [self.cache readEntriesForUrlKey:@"SalesOrderItems" withError:&error];
        self.locallyModifiedEntriesList = [self.cache readEntriesLocalForEntryId:nil forEntityType:@"SalesOrderItems" withError:&error];
        [self.displayRowsArray setArray:self.serverEntriesCopyList];
        
        
        
        NSLog(@"what's in self.serverEntriesCopyList?: %@",self.serverEntriesCopyList);
        NSLog(@"what's in self.locallyModifiedEntriesList?: %@",self.locallyModifiedEntriesList);
        
        NSLog(@"what's in displayRowsArray?: %@",self.displayRowsArray);
        
        
        
        
        
        
        
        
        //call the super class setup method
        [self setup];
    }
    return self;
}
 


/*
 This is our request builder and request sender
 */
- (void)getOData:(NSDictionary *)params onCompletion: (BSDataResponseBlock) responseBlock
         onError: (BSErrorResponseBlock) errorBlock {
    NSLog(@"Y02");
    NSLog(@"GRP Reuqest Called");
    
    //Build the request url to call the OData REST service
   // _requestURL = [NSString stringWithFormat:@"%@%@(OrderId='',CustomerId='0000006677',SalesOrg='3000')/%@",_serviceDocumentURL , kSOHeadersCollection, kSOItemCollection];
    
    // _requestURL = [NSString stringWithFormat:@"%@%@('0000006677')/SalesOrderItems",_serviceDocumentURL , kSOHeadersCollection];//, kSOItemCollection
    
    
     _requestURL = [NSString stringWithFormat:@"%@%@?$filter=CustomerId+eq+'0000003000'",_serviceDocumentURL , kSOHeadersCollection];//, kSOItemCollection
    
    NSLog(@"GRP Request URL=%@", _requestURL);
    
    //Call the super classes getOData method
    [super getOData:params onCompletion:responseBlock onError:errorBlock];
}

//Here we convert the ODataEntry Array into our business objects 
//This method gets called internally from the super classes 'getODataCompleted:' method which parses the raw data into an ODataEntry Array
-(NSArray *)createBusinessObjects:(NSArray *)oDataEntries
{
    NSLog(@"Y03");
    NSLog(@"updated SOListDataController feed?: %@",self.feed);
    NSLog(@"with %d entries", [self.feed entries].count);
    
    
    
    
    
    NSMutableArray *businessObjects = [NSMutableArray new];
    // Create business objects to be consumed by the response block
    if (oDataEntries && [oDataEntries count] > 0) {
        NSLog(@"  Y03a");
        int count = 0;
        
        //MaterialGroup Business Object
        BSSalesOrder *so;
        // TEMP replace oDataEntries with [self.feed entries]
        for(ODataEntry * entry in [self.feed entries]){
            NSLog(@"  Y03b");
            NSString * title = [[entry getPropertyValueByPath:kSalesOrderTitle] getValue];
            NSString * orderId = [[entry getPropertyValueByPath:kSalesOrderId] getValue];
            NSString * item = [[entry getPropertyValueByPath:kItem] getValue];
            NSString * material = [[entry getPropertyValueByPath:kMaterial] getValue];
            NSString * description = [[entry getPropertyValueByPath:kDescription] getValue];
            NSString * plant = [[entry getPropertyValueByPath:kPlant] getValue];
            NSString * quantity = [[entry getPropertyValueByPath:kQuantity] getValue];
            NSString * uoM = [[entry getPropertyValueByPath:kUoM] getValue];
            NSString * value = [[entry getPropertyValueByPath:kValue] getValue];
            NSString * itemDlvyStaTx = [[entry getPropertyValueByPath:kItemDlvyStaTx] getValue];
            NSString * itemDlvyStatus = [[entry getPropertyValueByPath:kItemDlvyStatus] getValue];
            
            NSString * updated = [entry getUpdatedString];
            
            
            so = [BSSalesOrder new];
            
            so.title = title;
            so.updated = [updated substringToIndex:10];
            so.orderId = orderId;
            so.item = item;
            so.material = material;
            so.description = description;
            so.plant = plant;
            so.quantity = [NSString stringWithFormat:@"%d",[quantity intValue]];
            so.uoM = uoM;
            so.value = [NSString stringWithFormat:@"%d",[value intValue]];
            so.itemDlvyStaTx = itemDlvyStaTx;
            so.itemDlvyStatus = itemDlvyStatus;
            NSLog(@"  Y03c");
            [businessObjects addObject: so];
            NSLog(@"  Y03d");
            
            NSLog(@"SO[%d] Item=%@ Quantity=%@", count++, item, quantity);
        }
    }
    return businessObjects;
}

-(void)testFunctionCall:(NSString *)someString {
    NSLog(@"testFunctionCalled!!!");
    
}


@end
