//
//  BSSMPDataProvider.m
//  BlueSky
//
//  Created by Jones, Jeffry on 7/15/13.
//  Copyright (c) 2013 SAP MIC. All rights reserved.
//

#import "BSSMPDataProvider.h"
#import "GRPDataController.h"
#import "MARADataController.h"
#import "MARCDataController.h"
#import "PWSDataController.h"
#import "LocationDataController.h"
#import "SOListDataController.h"
#import "SOCreateDataController.h"
#import "BSSalesOrderCreate.h"
#import "SODeleteDataController.h"
#import "BSLocation.h"

@implementation BSSMPDataProvider {
    GRPDataController *grpDC;
    MARADataController *maraDC;
    MARCDataController *marcDC;
    PWSDataController *atpDC;
    LocationDataController *locationInfoDC;
    SOListDataController *soListDC;
    SOCreateDataController *soCreateDC;
    SODeleteDataController *soDeleteDC;
}

#pragma mark - GRP Backend [Category]

- (void) requestMaterialGroupsWithCompletion: (BSDataResponseBlock) responseBlock
                                     onError: (BSErrorResponseBlock) errorBlock {
    if (!grpDC) {
        grpDC = [GRPDataController new];
    }

    //Send the request to the GRP data controller
    NSLog(@"send the request to the GRP data controller - [Categories]");
    [grpDC getOData:nil onCompletion:responseBlock onError:errorBlock];
}

#pragma mark - MARA Backend [Products]

- (void) requestMaterialsForGroup: (NSString *) groupID
                     onCompletion: (BSDataResponseBlock) responseBlock
                          onError: (BSErrorResponseBlock) errorBlock {
    if (!maraDC) {
        maraDC = [MARADataController new];
    }
    
    //Send the request to the MARA data controller
    
    NSLog(@"send the request to the MARA data controller - [Products]");
    
    [maraDC getOData:@{@"group":groupID} onCompletion:responseBlock onError:errorBlock];
}

//#pragma mark - MARC Backend
//
//- (void) requestLocationInfoForLocationIDs: (BSLocation *) location
//                        onCompletion: (BSDataResponseBlock) responseBlock
//                             onError: (BSErrorResponseBlock) errorBlock {
//
//    if (!locationInfoDC) {
//         locationInfoDC = [LocationDataController new];
//    }
//    
//    //Send the request to the LocationInfo data controller
//    NSLog(@"send the request to the LocationInfo data controller [LocationIDs]");
//   // [locationInfoDC getOData:@{@"location":location} onCompletion:responseBlock onError:errorBlock];
//     [locationInfoDC getOData:nil onCompletion:responseBlock onError:errorBlock];
//}




#pragma mark - PlantWithStock Backend

- (void) requestPlantWithStock: (NSString *) materialID
                  onCompletion: (BSDataResponseBlock) responseBlock
                       onError: (BSErrorResponseBlock) errorBlock {
    if (!atpDC) {
        atpDC = [PWSDataController new];
    }
    
    //Send the request to the ATP data controller
    NSLog(@"send the request to the ATP data controller");
    [atpDC getOData:@{@"material":materialID, @"unit":@"EA"} onCompletion:responseBlock onError:errorBlock];
}





#pragma mark - ATP Backend

- (void) requestATPForMaterial: (NSString *) materialID
                    atLocation: (NSString *) locationID
                  onCompletion: (BSDataResponseBlock) responseBlock
                       onError: (BSErrorResponseBlock) errorBlock {
    if (!atpDC) {
        atpDC = [PWSDataController new];
    }

    //Send the request to the ATP data controller
    NSLog(@"send the request to the ATP data controller");
    [atpDC getOData:@{@"material":materialID, @"plant":locationID, @"unit":@"EA"} onCompletion:responseBlock onError:errorBlock];
}

#pragma mark - PLANT Backend

- (void) requestLocationIDForMaterial: (NSString *) materialID
                  onCompletion: (BSDataResponseBlock) responseBlock
                       onError: (BSErrorResponseBlock) errorBlock {
    if (!marcDC) {
        marcDC = [MARCDataController new];
    }
    
    //Send the request to the MARC data controller
    NSLog(@"send the request to the MARC data controller");
    [marcDC getOData:@{@"material":materialID} onCompletion:responseBlock onError:errorBlock];
}

#pragma mark - PLANT Backend

- (void) requestSalesOrders: (NSString *) customerID
               onCompletion: (BSDataResponseBlock) responseBlock
                    onError: (BSErrorResponseBlock) errorBlock {
    if (!soListDC) {
        soListDC = [SOListDataController new];
    }
    
    //Send the request to the SOList data controller
    NSLog(@"send the request to the SOList data controller");
    [soListDC getOData:@{@"customerID":customerID} onCompletion:responseBlock onError:errorBlock];
}

#pragma mark - PLANT Backend

- (void) createSalesOrder: (BSSalesOrderCreate *) order
             onCompletion: (BSDataResponseBlock) responseBlock
                  onError: (BSErrorResponseBlock) errorBlock {
    if (!soCreateDC) {
        soCreateDC = [SOCreateDataController new];
    }
    
    //Send the request to the SOCreate data controller
    NSLog(@"send the request to the SalesOrder data controller");
    [soCreateDC getOData:@{@"salesOrder":order} onCompletion:responseBlock onError:errorBlock];
}

- (void) deleteSalesOrder: (NSString *) salesOrderID
             onCompletion: (BSDataResponseBlock) responseBlock
                  onError: (BSErrorResponseBlock) errorBlock {
    if (!soDeleteDC) {
        soDeleteDC = [SODeleteDataController new];
    }
    
    //Send the request to the SOCreate data controller
    NSLog(@"send the request to the SalesOrder create data controller");
    [soDeleteDC getOData:@{@"salesOrderID":salesOrderID} onCompletion:responseBlock onError:errorBlock];
}

@end
