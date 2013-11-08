//
//  BSDataProvider.m
//  BlueSky
//
//  Created by Jones, Jeffry on 7/2/13.
//  Copyright (c) 2013 SAP MIC. All rights reserved.
//

#import "BSDummyDataProvider.h"
#import "BSMaterialGroup.h"
#import "BSMaterial.h"
#import "BSLocation.h"
#import "BSATPRecord.h"
#import "BSSalesOrder.h"

@implementation BSDummyDataProvider

- (void) requestMaterialGroupsWithCompletion: (BSDataResponseBlock) responseBlock
                                     onError: (BSErrorResponseBlock) errorBlock {
    responseBlock([self createGroups]);
    
}

- (void) requestMaterialsForGroup: (NSString *) groupID
                     onCompletion: (BSDataResponseBlock) responseBlock
                          onError: (BSErrorResponseBlock) errorBlock {
    responseBlock([self createMaterials]);
}

- (void) requestATPForMaterial: (NSString *) materialID
                    atLocation: (NSString *) locationID
                  onCompletion: (BSDataResponseBlock) responseBlock
                       onError: (BSErrorResponseBlock) errorBlock {
    responseBlock([self createATPRecords]);
}

- (void) requestLocationInfoForLocationIDs: (NSArray *) locationIDs
                             onCompletion: (BSDataResponseBlock) responseBlock
                                  onError: (BSErrorResponseBlock) errorBlock
{
    responseBlock([self createLocations]);
}

- (void) requestLocationIDForMaterial: (NSString *) materialID
                         onCompletion: (BSDataResponseBlock) responseBlock
                              onError: (BSErrorResponseBlock) errorBlock
{
    responseBlock([self createLocationIds]);
}

- (void) requestSalesOrders: (NSString *) customerID
               onCompletion: (BSDataResponseBlock) responseBlock
                    onError: (BSErrorResponseBlock) errorBlock {
    responseBlock([self createSOList]);
}

- (void) createSalesOrder: (BSSalesOrderCreate *) order
             onCompletion: (BSDataResponseBlock) responseBlock
                  onError: (BSErrorResponseBlock) errorBlock {
    responseBlock([self createSOList]);
}

- (NSArray *) createLocationIds {
    BSLocation *loc;
    NSMutableArray *locations = [NSMutableArray new];
    
    loc = [BSLocation new];
    loc.locationID = @"3000";
    
    [locations addObject:loc];
    
    return [NSArray arrayWithArray: locations];
}

- (NSArray *) createGroups {
    BSMaterialGroup *grp;
    NSMutableArray *groups = [NSMutableArray new];
     
    grp = [BSMaterialGroup new];
    grp.name = @"Pliers";
    grp.groupID = @"MIC001";

    grp = [BSMaterialGroup new];
    grp.name = @"Wrenches";
    grp.groupID = @"MIC002";
    [groups addObject: grp];

    grp = [BSMaterialGroup new];
    grp.name = @"Drills";
    grp.groupID = @"MIC003";
    [groups addObject: grp];

    grp = [BSMaterialGroup new];
    grp.name = @"Sanders";
    grp.groupID = @"MIC004";
    [groups addObject: grp];

    grp = [BSMaterialGroup new];
    grp.name = @"Washing Machines";
    grp.groupID = @"MIC005";
    [groups addObject: grp];

    grp = [BSMaterialGroup new];
    grp.name = @"Ratchet Sets";
    grp.groupID = @"MIC006";
    [groups addObject: grp];

    grp = [BSMaterialGroup new];
    grp.name = @"Screw Drivers";
    grp.groupID = @"MIC007";
    [groups addObject: grp];

    grp = [BSMaterialGroup new];
    grp.name = @"Cutting Tools";
    grp.groupID = @"MIC008";
    [groups addObject: grp];

    grp = [BSMaterialGroup new];
    grp.name = @"Hammers";
    grp.groupID = @"MIC009";
    [groups addObject: grp];

    grp = [BSMaterialGroup new];
    grp.name = @"Vacuum Cleaners";
    grp.groupID = @"MIC010";
    [groups addObject: grp];

    return [NSArray arrayWithArray: groups];
}

- (NSArray *) createMaterials {
    NSMutableArray *materials = [NSMutableArray new];
    BSMaterial *mat;

    mat = [BSMaterial new];
    mat.groupID = @"MIC002";
    mat.materialID = @"MIC-005";
    mat.name = @"Adjustable Wrench";
    [materials addObject: mat];

    mat = [BSMaterial new];
    mat.groupID = @"MIC002";
    mat.materialID = @"MIC-006";
    mat.name = @"Box End Wrench Set";
    [materials addObject: mat];

    mat = [BSMaterial new];
    mat.groupID = @"MIC002";
    mat.materialID = @"MIC-007";
    mat.name = @"Hex Wrench";
    [materials addObject: mat];

    mat = [BSMaterial new];
    mat.groupID = @"MIC002";
    mat.materialID = @"MIC-008";
    mat.name = @"Torque Wrench";
    [materials addObject: mat];

    mat = [BSMaterial new];
    mat.groupID = @"MIC002";
    mat.materialID = @"MIC-009";
    mat.name = @"Pipe Wrench";
    [materials addObject: mat];

    mat = [BSMaterial new];
    mat.groupID = @"MIC002";
    mat.materialID = @"ZZWRENCH01";
    mat.name = @"ZZ Test Wrench 1";
    [materials addObject: mat];

    mat = [BSMaterial new];
    mat.groupID = @"MIC002";
    mat.materialID = @"ZZWRENCH02";
    mat.name = @"ZZ Test Wrench 2";
    [materials addObject: mat];

    return [NSArray arrayWithArray: materials];
}

- (NSArray *) createLocations {
    NSMutableArray *locations = [NSMutableArray new];
    BSLocation *loc;

    loc = [BSLocation new];
    loc.locationID = @"3000";
    loc.name = @"Warehouse 1";
    loc.address = @"123 First St";
    loc.city = @"New York";
    loc.state = @"NY";
    loc.postalcode = @"10001";
    loc.country = @"US";
    loc.latlon = CLLocationCoordinate2DMake(40.67, -73.94);
    [locations addObject: loc];

    loc = [BSLocation new];
    loc.locationID = @"3100";
    loc.name = @"Warehouse 2";
    loc.address = @"456 First Ave";
    loc.city = @"Chicago";
    loc.state = @"IL";
    loc.postalcode = @"70001";
    loc.country = @"US";
    loc.latlon = CLLocationCoordinate2DMake(41.881944, -87.627778);
    [locations addObject: loc];

    loc = [BSLocation new];
    loc.locationID = @"3200";
    loc.name = @"Warehouse 3";
    loc.address = @"789 King St E";
    loc.city = @"Hamilton";
    loc.state = @"ON";
    loc.postalcode = @"L8N 1A1";
    loc.country = @"CA";
    loc.latlon = CLLocationCoordinate2DMake(43.25, -79.866667);
    [locations addObject: loc];

    return [NSArray arrayWithArray: locations];
}

- (NSArray *) createATPRecords {
    NSMutableArray *records = [NSMutableArray new];
    BSATPRecord *atp = [BSATPRecord new];
    
    atp = [BSATPRecord new];
    atp.materialID = @"MIC-009";
    atp.locationID = @"3100";
    atp.units = @"EA";
    atp.quantity = 24.0f;
    [records addObject: atp];
    
    atp = [BSATPRecord new];
    atp.materialID = @"MIC-009";
    atp.locationID = @"32100";
    atp.units = @"EA";
    atp.quantity = 51.0f;
    [records addObject: atp];
    
    return [NSArray arrayWithArray: records];
}


- (NSArray *) createSOList {
    NSMutableArray *records = [NSMutableArray new];
    BSSalesOrder *so = [BSSalesOrder new];
    
    so.item = @"item";
    so.material = @"material";
    so.description = @"description";
    so.plant = @"plant";
    so.quantity = @"quantity";
    so.uoM = @"uoM";
    so.value = @"123";
    so.itemDlvyStaTx = @"itemDlvyStaTx";
    so.itemDlvyStatus = @"itemDlvyStatus";

    
    [records addObject: so];
    
    so = [BSSalesOrder new];
    so.item = @"item";
    so.material = @"material";
    so.description = @"description";
    so.plant = @"plant";
    so.quantity = @"quantity";
    so.uoM = @"uoM";
    so.value = @"123";
    so.itemDlvyStaTx = @"itemDlvyStaTx";
    so.itemDlvyStatus = @"itemDlvyStatus";
    
    [records addObject: so];
    
    return [NSArray arrayWithArray: records];
}

@end


/*

 */

