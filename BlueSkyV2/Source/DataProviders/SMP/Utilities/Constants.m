//
//  Constants.m
//  BlueSky
//
//  Created by Ivan Reyes on 10/3/13.
//  Copyright (c) 2013 SAP MIC. All rights reserved.
//

#import "Constants.h"

#pragma mark - Header values
NSString * const kApplicationJSON = @"application/json";
NSString * const kApplicationAtom = @"application/atom+xml"; //application/atom+xml;type=entry
NSString * const kCharSetUTF8 = @"charset=utf-8";
NSString * const kFormatJSON = @"$format=json";
NSString * const kApplicationConnectionId = @"ApplicationConnectionId";
NSString * const kErrorDomain = @"SAP Mobile Platform Service Proxy";
NSString * const kBatch = @"$batch";
NSString * const kx_csrf_token = @"x-csrf-token";
NSString * const kx_cookie = @"Cookie";
NSString * const kAuthenticationNeeded = @"AuthenticationNeeded";
NSString * const kMetadata = @"$metadata";
NSString * const kX_SMP_APPCID = @"X-SMP-APPCID";

#pragma mark - ATP Backend
NSString * const kATPCollection = @"PlantWithStockCollection";
NSString * const kATPlocationID = @"plant";
NSString * const kATPmaterialID = @"material";
NSString * const kATPunits = @"unit";
NSString * const kATPPlant = @"plant";
NSString * const kATPquantity = @"av_qty_plt";
NSString * const kLoadATPCompletedNotification = @"LoadATPCompletedNotification";

#pragma mark - Category Collection
NSString * const kCategoryCollection = @"CategoryCollection";
NSString * const kGRPID = @"Category"; //matkl
NSString * const kGRPname = @"CategoryDescription";//wgbez
NSString * const kLoadCategoryCollectionCompletedNotification = @"LoadCategoryCompletedNotification";

#pragma mark - Product Collection
NSString * const kProductCollection = @"ProductCollection"; //z_mic_maraCollection
NSString * const kMARAID = @"Material"; //matnr
NSString * const kMARAname = @"MaterialDescription"; //maktx
NSString * const kMARAgroupID = @"Category";//matkl
NSString * const kLoadProductCompletedNotification = @"LoadProductCompletedNotification";

#pragma mark - MARC Backend
NSString * const kMARCCollection = @"PlantWithStockCollection";//z_marcCollection
NSString * const kMARClocationID = @"Location";//werks
NSString * const kMARCmaterialID = @"Material";//matnr
NSString * const kLoadMARCCompletedNotification = @"LoadMARCCompletedNotification";

#pragma mark - PlantWithStock Backend
NSString * const kPlantWithStockCollection = @"PlantWithStockCollection";//iwerksCollection
NSString * const kLocationInfoID = @"Location"; //werks
NSString * const kLocationInfoName = @"Name"; //name1
NSString * const kLocationInfoStreet = @"Street"; //stras
NSString * const kLocationInfoCity = @"City"; //ort01
NSString * const kLocationInfoState = @"State"; //regio
NSString * const kLocationInfoPostalCode = @"PostalCode"; //pstlz
NSString * const kLocationInfoCountry = @"CountryKey"; //land1
NSString * const kLoadPlantWithStockCompletedNotification = @"LoadPlantWithStockCompletedNotification";

#pragma mark - Sales Order Items Backend
NSString * const kSOItemCollection = @"SalesOrderItems";
NSString * const kItem = @"Item";
NSString * const kUpdated = @"updated";
NSString * const kMaterial = @"Material";
NSString * const kDescription = @"Description";
NSString * const kPlant = @"Plant";
NSString * const kQuantity = @"Quantity";
NSString * const kUoM = @"UoM";
NSString * const kValue = @"Value";
NSString * const kItemDlvyStaTx = @"ItemDlvyStaTx";
NSString * const kItemDlvyStatus = @"ItemDlvyStatus";

#pragma mark - Sales Order
NSString * const kSalesOrderCollection = @"SalesOrders";
NSString * const kLoadSalesOrderCompletedNotification = @"LoadSalesOrderCompletedNotification";
NSString * const kDeleteSalesOrderCoompletedNotification = @"DeleteSalesOrderCompletedNotification";
//
//#pragma mark - Sales Order Item
//NSString * const kSalesOrderItemsCollection = @"SalesOrderItems";
//NSString * const kLoadSalesOrderItemsCompletedNotification = @"LoadSalesOrderItemsCompletedNotification";


#pragma mark - Sales Order Create Backend
NSString * const kSOHeadersCollection = @"SalesOrders";
NSString * const kLoadSOCompletedNotification = @"LoadSOCompletedNotification";
NSString * const kCreateSOCompletedNotification = @"CreateSOCompletedNotification";
NSString * const kSalesOrderTitle = @"title";
NSString * const kSalesOrderId = @"OrderId";
NSString * const kDocumentType = @"DocumentType";
NSString * const kDocumentDate = @"DocumentDate";
NSString * const kCustomerId = @"CustomerId";
NSString * const kSalesOrg = @"SalesOrg";
NSString * const kDistChannel = @"DistChannel";
NSString * const kDivision = @"Division";
NSString * const kOrderValue = @"OrderValue";
NSString * const kCurrency = @"Currency";

NSString * const kSODelete = @"SalesOrders";