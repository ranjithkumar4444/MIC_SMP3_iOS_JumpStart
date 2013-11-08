//
//  BSDataProvider.h
//  BlueSky
//
//  Created by Jones, Jeffry on 7/2/13.
//  Copyright (c) 2013 SAP MIC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BSSalesOrderCreate.h"
#import "BSLocation.h"

typedef void (^BSDataResponseBlock)(id);
typedef void (^BSErrorResponseBlock)(NSString *);

@protocol BSDataProvider <NSObject>

- (void) requestMaterialGroupsWithCompletion: (BSDataResponseBlock) responseBlock
                                     onError: (BSErrorResponseBlock) errorBlock;

- (void) requestMaterialsForGroup: (NSString *) groupID
                     onCompletion: (BSDataResponseBlock) responseBlock
                          onError: (BSErrorResponseBlock) errorBlock;

//- (void) requestLocationInfoForLocationIDs: (BSLocation *) location
//                        onCompletion: (BSDataResponseBlock) responseBlock
//                             onError: (BSErrorResponseBlock) errorBlock ;

- (void) requestATPForMaterial: (NSString *) materialID
                    atLocation: (NSString *) locationID
                  onCompletion: (BSDataResponseBlock) responseBlock
                       onError: (BSErrorResponseBlock) errorBlock;

- (void) requestLocationIDForMaterial: (NSString *) materialID
                         onCompletion: (BSDataResponseBlock) responseBlock
                              onError: (BSErrorResponseBlock) errorBlock;

- (void) requestSalesOrders: (NSString *) customerID
               onCompletion: (BSDataResponseBlock) responseBlock
                    onError: (BSErrorResponseBlock) errorBlock;

- (void) createSalesOrder: (BSSalesOrderCreate *) order
             onCompletion: (BSDataResponseBlock) responseBlock
                  onError: (BSErrorResponseBlock) errorBlock;

- (void) deleteSalesOrder: (NSString *) salesOrderID
             onCompletion: (BSDataResponseBlock) responseBlock
                  onError: (BSErrorResponseBlock) errorBlock;

//-(void) testFunctionCall: (NSString *) someString;

@end
