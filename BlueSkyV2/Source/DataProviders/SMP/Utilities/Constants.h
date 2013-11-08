//
//  Constants.h
//  FlightsS9
//
//  Created by Shin, Jin on 6/25/13.
//  Copyright (c) 2013 RIG. All rights reserved.
//

extern NSString * const kApplicationJSON;
extern NSString * const kApplicationAtom;
extern NSString * const kCharSetUTF8;
extern NSString * const kFormatJSON;
extern NSString * const kApplicationConnectionId;
extern NSString * const kErrorDomain;
extern NSString * const kBatch;
extern NSString * const kx_cookie;
extern NSString * const kx_csrf_token;
extern NSString * const kAuthenticationNeeded;
extern NSString * const kMetadata;

#pragma mark - Location Info Backend
extern NSString * const kLocationInfoCollection;
extern NSString * const kLocationInfoID;
extern NSString * const kLocationInfoName;
extern NSString * const kLocationInfoStreet;
extern NSString * const kLocationInfoCity;
extern NSString * const kLocationInfoState;
extern NSString * const kLocationInfoPostalCode;
extern NSString * const kLocationInfoCountry;
extern NSString * const kLoadLocationInfoCompletedNotification;

#pragma mark - Category
extern NSString * const kCategoryCollection;
extern NSString * const kGRPID;
extern NSString * const kGRPname;
extern NSString * const kLoadCategoryCollectionCompletedNotification;

#pragma mark - Product
extern NSString * const kProductCollection;
extern NSString * const kMARAID;
extern NSString * const kMARAname;
extern NSString * const kMARAgroupID;
extern NSString * const kLoadProductCompletedNotification;

#pragma mark - MARC Backend
extern NSString * const kMARCCollection;
extern NSString * const kMARClocationID;
extern NSString * const kMARCmaterialID;
extern NSString * const kLoadMARCCompletedNotification;

#pragma mark - ATP Backend
extern NSString * const kPlantWithStockCollection;
extern NSString * const kATPlocationID;
extern NSString * const kATPmaterialID;
extern NSString * const kATPunits;
extern NSString * const kATPPlant;
extern NSString * const kATPquantity;
extern NSString * const kLoadPlantWithStockCompletedNotification;

#pragma mark - Sales Order Items Backend
extern NSString * const kSOItemCollection;
extern NSString * const kItem;
extern NSString * const kUpdated;
extern NSString * const kMaterial;
extern NSString * const kDescription;
extern NSString * const kPlant;
extern NSString * const kQuantity;
extern NSString * const kUoM;
extern NSString * const kValue;
extern NSString * const kItemDlvyStaTx;
extern NSString * const kItemDlvyStatus;

#pragma mark - Sales Order
extern NSString * const kSalesOrderCollection;
extern NSString * const kLoadSalesOrderCompletedNotification;
extern NSString * const kDeleteSalesOrderCoompletedNotification;

#pragma mark - Sales Order Create Backend
extern NSString * const kSOHeadersCollection;
extern NSString * const kLoadSOCompletedNotification;
extern NSString * const kCreateSOCompletedNotification;
extern NSString * const kSalesOrderTitle;
extern NSString * const kSalesOrderId;
extern NSString * const kDocumentType;
extern NSString * const kDocumentDate;
extern NSString * const kCustomerId;
extern NSString * const kSalesOrg;
extern NSString * const kDistChannel;
extern NSString * const kDivision;
extern NSString * const kOrderValue;
extern NSString * const kCurrency;

extern NSString * const kSODelete;

#pragma mark - Drop 9
extern NSString * const kX_SMP_APPCID;

#pragma mark - Drop 10
//extern NSString * const kX_SMP_APPCID;

static NSString * const kEncryptionKey = @"EncryptionKey";


static NSString * const kLoadSOItemCollectionCompletedNotification = @"LoadSOItemCollectionCompletedNotification";

