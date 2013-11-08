//
//  BSMapVC.m
//  BlueSky
//
//  Created by Ivan Reyes on 10/3/13.
//  Copyright (c) 2013 SAP MIC. All rights reserved.
//

#import "BSMapVC.h"
#import "BSProduct.h"
#import "PlantWithStockDataController.h"
#import "BSMapAnnotation.h"
#import "BSMapAnnotationView.h"
#import "BSMapCalloutView.h"
#import "BSSalesOrder.h"
#import "BSSalesOrderItem.h"
#import "BSPlantWithStock.h"
#import "BSSalesOrderDetailVC.h"
#import "BSLocationListVC.h"
#import "ODataEntry.h"
#import "Constants.h"
#import "ODataPropertyValues.h"
#import "ODataServiceDocumentParser.h"
#import "BSAppDelegate.h"
#import "ODataDataParser.h"
#import "SalesOrderDataController.h"

static MKCoordinateRegion CONTIGUOUS_US_REGION;
static NSString * const PIN_REUSE_IDENTIFIER = @"BSMapAnnotationPin";
static NSString *BSStringFromMkCoordRegion(MKCoordinateRegion r) {
    return [NSString stringWithFormat: @"{{%f°, %f°}, {%f°, %f°}}",
            r.center.latitude, r.center.longitude, r.span.latitudeDelta, r.span.longitudeDelta];
}

@interface BSMapVC ()

@end

@implementation BSMapVC {
    MKCoordinateRegion       annotationsRegion;
    NSMutableArray * locationsArray;
    NSMutableArray * countsArray;
    BSLocationListVC *gridVC;
}


@synthesize pwsRecordsArray;
@synthesize selectedProductID;


+ (void) initialize {
    CONTIGUOUS_US_REGION = MKCoordinateRegionMake(
        CLLocationCoordinate2DMake(37.0f, -95.85f),
        MKCoordinateSpanMake(25.0f, 58.3f)
    );
}


#pragma mark - Initialize

- (id) initWithNibName: (NSString *) nibNameOrNil
                bundle:( NSBundle *) nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        annotationsRegion = CONTIGUOUS_US_REGION;
        
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didFinishCreateSalesOrder:) name:@"createSalesOrderNotification" object:nil];
        
        
    }
    return self;
}

-(void)didFinishCreateSalesOrder:(id)sender {
    NSLog(@"didFinishCreateSalesOrder");
    [self.loadingView setHidden:YES];
    
    NSArray *selectedAnnotations = self.mapView.selectedAnnotations;
    for(id bsma in selectedAnnotations) {
        [self.mapView deselectAnnotation:bsma animated:YES];
        
        
    }
    
    
    
    
}

-(void)setPlantWithStockList:(NSMutableArray *)newList {
    if(_plantWithStockList != newList) {
        _plantWithStockList = [newList mutableCopy];
    }
}

- (void)handlePlantWithStockCollectionLoad
{
    if (!loadCompletedObserver) {
        [self.loadingView setHidden:NO];
        loadCompletedObserver = [[NSNotificationCenter defaultCenter]
                                 addObserverForName:kLoadPlantWithStockCompletedNotification
                                 object:nil
                                 queue:[NSOperationQueue mainQueue]
                                 usingBlock:^(NSNotification *notification) {
            NSLog(@"++++++++++++++++++  loadCompletedObserver Plant With Stock ");
            [self.loadingView setHidden:YES];
            if ([self.plantWithStockDataController.serverEntriesCopyList count] > 0)
                self.plantWithStockList = self.plantWithStockDataController.displayRowsArray;
            else
                self.plantWithStockList = self.plantWithStockDataController.plantWithStockList;
             [self reload];

        }];
        
    }
}


#pragma mark - View


- (void) viewDidLoad {
    [super viewDidLoad];
}

- (void) viewWillAppear: (BOOL) animated {
    [super viewWillAppear: animated];
    self.plantWithStockDataController = [PlantWithStockDataController uniqueInstance];

    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *Ausername = [defaults stringForKey:@"username"];
    NSString *Apassword = [defaults stringForKey:@"password"];
    self.username = Ausername;
    self.password = Apassword;
    self.salesOrderDataController = [SalesOrderDataController uniqueInstance];

    //    if([statusText isEqualToString:@"nointernetz"]) {
    //        NSLog(@"no Iternetsz");
    //
    //
    //    }
    //    else {
    //        NSLog(@"gonna register Connection");
    //        [self performSelector:@selector(registerConnection) withObject:self afterDelay:0.1 ];
    //    }
    
    self.selectedProductID = [[self.productEntry getPropertyValueByPath:@"Material"] getValue];
    NSLog(@"selectedProductID: %@",self.selectedProductID);

    
//    if ([self.plantWithStockDataController.serverEntriesCopyList count] > 0)
//        self.plantWithStockList = self.plantWithStockDataController.displayRowsArray;
//    else
//        self.plantWithStockList = self.plantWithStockDataController.plantWithStockList;
//    
//    
//    if ([self.plantWithStockList count] > 0)  {
//        NSLog(@"from cache");
//        [self reload];
//    } else {
//        NSLog(@"no from cache");
//        
//        
//        [self.plantWithStockDataController loadPlantWithStockWithProductID:self.selectedProductID andDidFinishSelector:@selector(loadPlantWithStockCollectionCompleted:) ];
//        
//        
//        // [self.plantWithStockDataController loadPlantWithStockCollectionWithDidFinishSelector:@selector(loadPlantWithStockCollectionCompleted:) forUrl:nil];
//    }
    
    
    [self handlePlantWithStockCollectionLoad];
    [self.plantWithStockDataController clearTheCache];
    [self.plantWithStockDataController loadPlantWithStockWithProductID:self.selectedProductID andDidFinishSelector:@selector(loadPlantWithStockCollectionCompleted:) ];
    
    
    //[self getSalesOrderAndShowDetails];
    // [self populatePlantWithStockAndAddToMap];
    self.mapView.delegate = self;
    //[self reload];

}

-(void)viewWillDisappear:(BOOL)animated {
  //  [self.plantWithStockDataController clearTheCache];
    
}

-(void)testSelector{
    NSLog(@"testSelector");
    
}

#pragma mark - dataProviders

- (void)populatePlantWithStockAndAddToMap {
    
    
    NSLog(@"populatePlantWithStockAndAddToMap!");
    NSLog(@"fields of productEntry: %@",self.productEntry.fields);
    //NSString *matGroupID = [[self.productEntry getPropertyValueByPath:@"Material"] getValue];
    NSLog(@"selectedProductID : %@",self.selectedProductID);
    
    [self.plantWithStockDataController loadPlantWithStockWithProductID:self.selectedProductID andDidFinishSelector:@selector(testSelector:) ];

}


//- (void)getSalesOrder {
//    
//
//    
//    NSString *matGroupID = [[self.productEntry getPropertyValueByPath:@"Material"] getValue];
//    
//    NSLog(@"matGroupID: %@",matGroupID);
//    
//    
//    [dataProvider requestSalesOrders:@"0000300"  //self.product.materialID
//                           onCompletion:^(NSArray *pwsRecords) {
//                               
//                               NSLog(@"pwsRecords: %@",pwsRecords);
//                               NSLog(@"pwsRecordsArray: %@",pwsRecordsArray);
//                               
//                               self.pwsRecordsArray = pwsRecords;
//                               [self addLocations: pwsRecords];
//                               [self.loadingView setHidden:YES];
//                           }
//                                onError: ^(NSString *errMsg) {
//                                    NSLog(@"Received error from data provider while requesting ATP record: %@", errMsg);
//                                }];
//}


//}





-(void) reload {
    
    self.mapView.region = annotationsRegion;

    NSString *prodName = [[self.productEntry getPropertyValueByPath:@"Material"] getValue];

    self.subtitleLabel.text = prodName; //self.product.name
    
    //[self.loadingView setHidden:YES];
    self.pwsRecordsArray = self.plantWithStockList;
    
    [self addLocations: self.pwsRecordsArray];
    
    //NSString *matGroupID = [[self.productEntry getPropertyValueByPath:@"Material"] getValue];
    
    
//    [dataProvider requestPlantWithStock:matGroupID //self.product.materialID
//                           onCompletion:^(NSArray *pwsRecords) {
//                               self.pwsRecordsArray = pwsRecords;
//                               [self addLocations: pwsRecords];
//                               [self.loadingView setHidden:YES];
//                           }
//                                onError: ^(NSString *errMsg) {
//                                    NSLog(@"Received error from data provider while requesting ATP record: %@", errMsg);
//                                }];
    
}

#pragma mark - Memory Warning

- (void) didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) dealloc {
    self.mapView.delegate = nil;
}


#pragma mark - mapView


- (MKAnnotationView *) mapView: (MKMapView *) mapView viewForAnnotation: (id <MKAnnotation>) annotation {

    // Handle any BSMapAnnotations, and return nil for all other annotation types,
    // which will allow the default view to be used for those types.
    if (![annotation isKindOfClass: [BSMapAnnotation class]])
        return nil;

    // Try to dequeue an existing pin view first.
    BSMapAnnotationView *pinView =
        (BSMapAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier: PIN_REUSE_IDENTIFIER];

    // If an existing pin view was not available, create one.
    if (!pinView) {
        pinView = [[BSMapAnnotationView alloc] initWithAnnotation: annotation
                                                  reuseIdentifier: PIN_REUSE_IDENTIFIER];
    } else {
        pinView.annotation = annotation;
    }
    
    return pinView;
}

- (void) mapView: (MKMapView *) mapView didSelectAnnotationView: (MKAnnotationView *) annView {

    // If it's not one of our custom annotations, do nothing
    if (![annView isKindOfClass: [BSMapAnnotationView class]])
        return;

    // Switch the annotation view to its selected state (changes pin image)
    [(BSMapAnnotationView *)annView showSelectedState: YES];

    calloutView = nil;
    // Create the callout view
    calloutView = [BSMapCalloutView calloutView];

    BSMapAnnotation *ann = (BSMapAnnotation *) annView.annotation;
    //self.atpRecord = ann.atpRecord;
    
    available =  (int)ann.location.Quantity;
    
    //NSLog(@"self.productEntry fields: %@", self.productEntry.fields );
           
    //NSLog(@"self.ann.BSPlant %@",ann.BSPlantWithStockEntry.fields);
    
    
    NSString *sku = [[ann.BSPlantWithStockEntry getPropertyValueByPath:@"Material"] getValue];
    NSString *productName = [[ann.BSPlantWithStockEntry getPropertyValueByPath:@"Name"] getValue];
    NSString *Street = [[ann.BSPlantWithStockEntry getPropertyValueByPath:@"Street"] getValue];
    //NSString *Quantity = [[ann.BSPlantWithStockEntry getPropertyValueByPath:@"Quantity"] getValue];
    
    //NSLog(@"sku: %@",sku);
    
    calloutView.skuLabel.text = sku;
    
    //calloutView.skuLabel.text = [NSString stringWithFormat: @"SKU %@", self.product.materialID];
    
    //calloutView.nameLabel.text = self.product.name;
    calloutView.nameLabel.text = productName;
    
    //calloutView.addressLabel.text = ann.location.Street;
    calloutView.addressLabel.text = Street;
    
    
    
    //NSLog(@"test:Quantity: %@", ann.location.Quantity);
    
    
    //calloutView.quantityLabel.text = [NSString stringWithFormat: @"%@ available", ann.location.Quantity];
    
    NSInteger productQuantity = [[[ann.BSPlantWithStockEntry getPropertyValueByPath:@"Quantity"] getValue]integerValue];
    NSLog(@"productQuantity: %d", productQuantity);
    
    
    
    calloutView.quantityLabel.text = [NSString stringWithFormat: @"%d available", productQuantity];
    
    
    [calloutView.orderBtn addTarget:self action:@selector(orderClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    [calloutView setTextFieldDelegate];
    annView.backgroundColor = [UIColor clearColor];

    annView.bounds = calloutView.frame;
    
    [annView addSubview: calloutView];

    MKCoordinateRegion coordRect = [self.mapView convertRect: calloutView.frame
                                            toRegionFromView: annView];
    [self.mapView setRegion: coordRect
                   animated: YES];

}

- (void) mapView: (MKMapView *) mapView didDeselectAnnotationView: (MKAnnotationView *) annView {

    if (![annView isKindOfClass: [BSMapAnnotationView class]])
        return;

    [(BSMapAnnotationView *)annView showSelectedState: NO];

    for (UIView *subview in annView.subviews) {
        [subview removeFromSuperview];
    }

    [self.mapView setRegion: annotationsRegion
                   animated: YES];
}


- (void) addLocations: (NSArray*) locs {
    float min_lat = HUGE_VALF;
    float max_lat = -HUGE_VALF;
    float min_lon = HUGE_VALF;
    float max_lon = -HUGE_VALF;
    
    //int count = 0;

 for (ODataEntry *loc = (id)loc in locs) {  // for (BSPlantWithStock *loc = (id)loc in locs) {

    BSPlantWithStock *pws = [BSPlantWithStock new];
    NSLog(@"Entry - loc: %@",loc);
 
    pws.UnitOfMeasure = [[loc getPropertyValueByPath:@"UnitOfMeasure"] getValue];
    pws.MaterialID = [[loc getPropertyValueByPath:@"Material"] getValue];
    pws.Location = [[loc getPropertyValueByPath:@"Location"] getValue];
    pws.Name = [[loc getPropertyValueByPath:@"Name"] getValue];
    pws.Street = [[loc getPropertyValueByPath:@"Street"] getValue];
    pws.PostalCode = [[loc getPropertyValueByPath:@"PostalCode"] getValue];
    pws.City = [[loc getPropertyValueByPath:@"City"] getValue];
    pws.CountryKey = [[loc getPropertyValueByPath:@"CountryKey"] getValue];
    pws.State = [[loc getPropertyValueByPath:@"State"] getValue];
  
    CGFloat zLatFloat = (CGFloat)[[[loc getPropertyValueByPath:@"ZLat"] getValue] floatValue];
    CGFloat zLngFloat = (CGFloat)[[[loc getPropertyValueByPath:@"ZLng"] getValue] floatValue];

    pws.zLat = zLatFloat;
    pws.zLng = zLngFloat;
    CLLocationCoordinate2D loca;

    loca.latitude = zLatFloat;
    loca.longitude = zLngFloat;
    pws.latlon = loca;

    NSString *test = [[loc getPropertyValueByPath:@"Quantity"] getValue];

     
     NSNumberFormatter * f = [[NSNumberFormatter alloc] init];
     [f setNumberStyle:NSNumberFormatterDecimalStyle];
     NSNumber * myNumber = [f numberFromString:test];
     
     
    pws.Quantity =  myNumber;

         //BSPlantWithStock *loc = (id)loc;
        BSMapAnnotation *ann = [[BSMapAnnotation alloc] initWithLocation: pws];
     
     ann.BSPlantWithStockEntry = loc;
     
     
     
     
     
       // ann.atpRecord = countsArray[count++];
     
     
     
    [self.mapView addAnnotation: ann];

        min_lat = MIN(min_lat, pws.zLat);
        max_lat = MAX(max_lat, pws.zLat);
        min_lon = MIN(min_lon, pws.zLng);
        max_lon = MAX(max_lon, pws.zLng);
 }
    
    annotationsRegion = MKCoordinateRegionMake(
                                               CLLocationCoordinate2DMake((max_lat + min_lat) / 2.0f, (max_lon + min_lon) / 2.0f),
                                               MKCoordinateSpanMake((max_lat - min_lat) * 1.4f, (max_lon - min_lon) * 1.4f)
                                               );
    
    self.mapView.region = annotationsRegion;
}

#pragma mark - SalesOrder

- (void)getSalesOrderAndShowDetails
{
    NSLog(@"getSalesOrderAndShowDetails!!");

}

#pragma mark - OrderButton

-(void)orderClicked:(id)sender {
    NSLog(@"OrderClicked");
    
    UIButton *clickedButton = (id)sender;
    BSMapCalloutView *bsmcov = (id)clickedButton.superview;

    int quantity = [bsmcov.txtQuantity.text intValue];
    if(!quantity){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Invalid quantity entered!"
                                                        message:[NSString stringWithFormat:@"Please enter a value from 1 & %@", bsmcov.quantityLabel.text]
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }else if(quantity > 0 && quantity <= [bsmcov.quantityLabel.text intValue]){

    NSLog(@"txt Quantity %@", bsmcov.txtQuantity.text);

    NSLog(@"sender superview product: %@",clickedButton.superview.description);
    
    NSLog(@"AA:%@",nil);

    ODataEntry *newOrder = [[ODataEntry alloc] initWithEntitySchema:self.salesOrderDataController.salesOrderCollection.entitySchema];
    
    ODataEntry *newOrderItem = [[ODataEntry alloc] initWithEntitySchema:self.salesOrderDataController.salesOrderItemCollection.entitySchema];
    
    
    [self.salesOrderDataController setStringValueForEntry:newOrder withValue:@"USD" forSDMPropertyWithName:@"Currency"];
    [self.salesOrderDataController setStringValueForEntry:newOrder withValue:@"BLUESKY1" forSDMPropertyWithName:@"CustomerId"];
    [self.salesOrderDataController setStringValueForEntry:newOrder withValue:@"10" forSDMPropertyWithName:@"DistChannel"];
    [self.salesOrderDataController setStringValueForEntry:newOrder withValue:@"00" forSDMPropertyWithName:@"Division"];
    [self.salesOrderDataController setStringValueForEntry:newOrder withValue:@"2013-07-10T00:00:00" forSDMPropertyWithName:@"DocumentDate"];
    [self.salesOrderDataController setStringValueForEntry:newOrder withValue:@"TA" forSDMPropertyWithName:@"DocumentType"];
    [self.salesOrderDataController setStringValueForEntry:newOrder withValue:@"0000007995" forSDMPropertyWithName:@"OrderId"];
        
    
        
    [self.salesOrderDataController setStringValueForEntry:newOrder withValue:@"23.00" forSDMPropertyWithName:@"OrderValue"];
    [self.salesOrderDataController setStringValueForEntry:newOrder withValue:@"3000" forSDMPropertyWithName:@"SalesOrg"];
    
    
    [self.salesOrderDataController setStringValueForEntry:newOrderItem withValue:@"0000007995" forSDMPropertyWithName:@"OrderId"];
    [self.salesOrderDataController setStringValueForEntry:newOrderItem withValue:@"000010" forSDMPropertyWithName:@"Item"];
    [self.salesOrderDataController setStringValueForEntry:newOrderItem withValue:[[self.productEntry getPropertyValueByPath:@"Material"] getValue] forSDMPropertyWithName:@"Material"];
    [self.salesOrderDataController setStringValueForEntry:newOrderItem withValue:[[self.productEntry getPropertyValueByPath:@"MaterialDescription"] getValue] forSDMPropertyWithName:@"Description"];
    [self.salesOrderDataController setStringValueForEntry:newOrderItem withValue:bsmcov.txtQuantity.text forSDMPropertyWithName:@"Quantity"];
    [self.salesOrderDataController setStringValueForEntry:newOrderItem withValue:@"FT3" forSDMPropertyWithName:@"UoM"];
    [self.salesOrderDataController setStringValueForEntry:newOrderItem withValue:@"3000" forSDMPropertyWithName:@"Plant"];
    [self.salesOrderDataController setStringValueForEntry:newOrderItem withValue:@"3.50" forSDMPropertyWithName:@"Value"];
    [self.salesOrderDataController setStringValueForEntry:newOrderItem withValue:@"USD" forSDMPropertyWithName:@"Currency"];
    [self.salesOrderDataController setStringValueForEntry:newOrderItem withValue:@"C" forSDMPropertyWithName:@"ItemDlvyStatus"];
    [self.salesOrderDataController setStringValueForEntry:newOrderItem withValue:@"Completely processed" forSDMPropertyWithName:@"ItemDlvyStaTx"];
    
 
    NSMutableDictionary *inlineDict = [[NSMutableDictionary alloc] initWithObjectsAndKeys:newOrderItem,@"SalesOrderItems", nil];
 
    [newOrder setInlinedRelatedEntries:inlineDict];
    
    NSLog(@"salesOrderItem: %@",newOrderItem);
    
    NSLog(@"test");
    
    
    

    [self.salesOrderDataController createSalesOrderWithOrder:newOrder withTempEntryId:@"SalesOrders('0000007995')"];
        
        [bsmcov.txtQuantity resignFirstResponder];
        
    [self.loadingView setHidden:NO];
    
    }

    
}


#pragma mark - toggleMapDelegate

-(void)gridViewClicked:(id)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"toggleMap" object:nil];
}

#pragma mark - Data Parse Utilities

- (void)setStringValueForEntry:(ODataEntry *)aSDMEntry withValue:(NSString *)aValue forSDMPropertyWithName:(NSString *)aName {
    ODataPropertyValueString *property = (ODataPropertyValueString *)[aSDMEntry getPropertyValueByPath:aName];
    [property setValue:aValue];
}


@end
