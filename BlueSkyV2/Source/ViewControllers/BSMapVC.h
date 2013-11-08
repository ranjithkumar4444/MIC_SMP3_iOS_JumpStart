//
//  BSMapVC.h
//  BlueSky
//
//  Created by Ivan Reyes on 10/3/13.
//  Copyright (c) 2013 SAP MIC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "BSBaseVC.h"
#import "ODataEntry.h"
#import "PlantWithStockDataController.h"
#import "SalesOrderDataController.h"


@class BSProduct, BSATPRecord,BSPlantWithStock, BSMapCalloutView;

@interface BSMapVC : BSBaseVC <MKMapViewDelegate>
{
    BSMapCalloutView * calloutView;
    int available;
    id loadCompletedObserver;
}
@property (nonatomic,strong)    PlantWithStockDataController *plantWithStockDataController;
@property (nonatomic,strong)    NSMutableArray *plantWithStockList;
@property (nonatomic,retain)    NSString *username;
@property (nonatomic,retain)    NSString *password;
@property (nonatomic,retain)    NSString *selectedProductID;

@property (nonatomic,strong)    BSProduct *product;
@property (nonatomic,strong)    BSATPRecord *atpRecord;
@property (nonatomic,strong)    BSPlantWithStock *pwsRecord;

@property (nonatomic,strong)    ODataEntry *productEntry;
@property (nonatomic,strong)    ODataEntry *BSPlantWithStockEntry;


@property (nonatomic,strong) SalesOrderDataController *salesOrderDataController;

@property (nonatomic,strong)    NSMutableArray *salesOrderArray;

@property (nonatomic,strong)    NSArray *pwsRecordsArray;
@property (nonatomic,weak)      IBOutlet UILabel          *subtitleLabel;
@property (nonatomic,weak)      IBOutlet MKMapView *mapView;
@property (nonatomic,strong)    IBOutlet UIView          *loadingView;
-(IBAction)orderClicked:(id)sender;

-(void)didFinishCreateSalesOrder:(id)sender;



-(IBAction)gridViewClicked:(id)sender;
- (void)populatePlantWithStockAndAddToMap;


- (void)setStringValueForEntry:(ODataEntry *)aSDMEntry withValue:(NSString *)aValue forSDMPropertyWithName:(NSString *)aName;

-(void)testSelector;
-(void)reload;

@end
