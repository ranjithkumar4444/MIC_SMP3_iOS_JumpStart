//
//  BSMapViewController.m
//  BlueSky
//
//  Created by Jones, Jeffry on 7/10/13.
//  Copyright (c) 2013 SAP MIC. All rights reserved.
//

#import "BSMapViewController.h"
#import "BSMaterial.h"
#import "BSLocation.h"
#import "BSATPRecord.h"
//#import "BSDummyDataProvider.h"
#import "BSSMPDataProvider.h"
#import "BSMapAnnotation.h"
#import "BSMapAnnotationView.h"
#import "BSMapCalloutView.h"
#import "BSSalesOrder.h"
#import "BSATPRecord.h"
#import "BSSOListViewController.h"
#import "BSLocationListViewController.h"

static MKCoordinateRegion CONTIGUOUS_US_REGION;

static NSString * const PIN_REUSE_IDENTIFIER = @"BSMapAnnotationPin";

static NSString *BSStringFromMkCoordRegion(MKCoordinateRegion r) {
    return [NSString stringWithFormat: @"{{%f°, %f°}, {%f°, %f°}}",
            r.center.latitude, r.center.longitude, r.span.latitudeDelta, r.span.longitudeDelta];
}

@interface BSMapViewController ()

@end

@implementation BSMapViewController {
    id<BSDataProvider>       dataProvider;
    MKCoordinateRegion       annotationsRegion;
    NSMutableArray * locationsArray;
    NSMutableArray * countsArray;
    BSLocationListViewController *gridVC;
}

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
        //dataProvider = [BSDummyDataProvider new];
        dataProvider = [BSSMPDataProvider new];
        annotationsRegion = CONTIGUOUS_US_REGION;
    }
    return self;
}

#pragma mark - View

- (void) viewWillAppear: (BOOL) animated {
    NSLog(@"########## 003");
    [super viewWillAppear: animated];
}

- (void) viewDidLoad {
    [super viewDidLoad];
    self.mapView.delegate = self;
    [self reload];
}


#pragma mark - dataProviders

- (void)populateATPForLocationAndAddToMap:(BSLocation *)item
{
    NSLog(@"populateATPForLocationAndAddToMap called");
    [dataProvider requestATPForMaterial: self.material.materialID
                             atLocation: item.locationID
                           onCompletion: ^(NSArray *atpRecords) {
                               NSLog(@"atpRecordsReturned : %@",atpRecords);
                               [countsArray addObject: atpRecords[[atpRecords count]-1]];
                               if([countsArray count] == 3){
                                   [self addLocations: locationsArray];
                                   [self.loadingView setHidden:YES];
                               }
                           }
                                onError: ^(NSString *errMsg) {
                                    NSLog(@"Received error from data provider while requesting ATP record: %@", errMsg);
                                }];
}


- (void)getLocationInfoForID:(BSLocation *)loc
{
    NSLog(@"getLocationInfoForID called");
//    [dataProvider requestLocationInfoForLocationIDs: loc
//                                       onCompletion: ^(NSArray * locations) {
//                                           NSLog(@"requestLocationInfoForLocationIDs returned : %@",locations);
//                                           [locationsArray addObject:locations[0]];
//                                           
//                                           if([locationsArray count] == 3){
//                                                NSLog(@"requestLocationInfoForLocationIDs returned B : %@",locationsArray);
//                                               for(BSLocation * item in locationsArray){
//                                                   [self populateATPForLocationAndAddToMap:item];
//                                               }
//                                               self.titleLabel.text = [NSString stringWithFormat:@"%d Stores Found", [locationsArray count]];
//                                           }
//                                       }
//                                            onError: ^(NSString *errMsg) {
//                                                NSLog(@"Received error from data provider while requesting locations: %@", errMsg);
//                                            }
//     ];
}


-(void)reload
{
    self.mapView.region = annotationsRegion;
    
    self.subtitleLabel.text = self.material.name;
    
    //Below we make 2 webservice calls which are nested as the first returns the LocationID which the second needs to get the LocationInfo
    
    locationsArray = [[NSMutableArray alloc] init];
    countsArray = [[NSMutableArray alloc] init];
    
    [self.loadingView setHidden:NO];
    
//    //Get the Location ID for the material
//    [dataProvider requestLocationIDForMaterial:self.material.materialID
//                                  onCompletion:^(NSArray * locationIDs) {
//                                      //Now use the returned ID to get the Location Info
//                                      for(int i = 0; i<3;i++){
//                                          [self getLocationInfoForID:locationIDs[i]];
//                                      }
//                                      
//                                  }
//                                       onError:^(NSString *errMsg) {
//                                           NSLog(@"Received error from data provider while requesting locationID: %@", errMsg);
//                                       }];
    
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


- (MKAnnotationView *) mapView: (MKMapView *) mapView
             viewForAnnotation: (id <MKAnnotation>) annotation {

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

- (void) mapView: (MKMapView *) mapView
didSelectAnnotationView: (MKAnnotationView *) annView {

    // If it's not one of our custom annotations, do nothing
    if (![annView isKindOfClass: [BSMapAnnotationView class]])
        return;

    // Switch the annotation view to its selected state (changes pin image)
    [(BSMapAnnotationView *)annView showSelectedState: YES];

    calloutView = nil;
    // Create the callout view
    calloutView = [BSMapCalloutView calloutView];

    BSMapAnnotation *ann = (BSMapAnnotation *) annView.annotation;
    self.atpRecord = ann.atpRecord;
    available =  (int)ann.atpRecord.quantity;
    calloutView.skuLabel.text = [NSString stringWithFormat: @"SKU %@", self.material.materialID];
    calloutView.nameLabel.text = self.material.name;
    calloutView.addressLabel.text = ann.location.address;
    calloutView.quantityLabel.text = [NSString stringWithFormat: @"%d available", (int)ann.atpRecord.quantity];
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

- (void)          mapView: (MKMapView *) mapView
didDeselectAnnotationView: (MKAnnotationView *) annView {

    if (![annView isKindOfClass: [BSMapAnnotationView class]])
        return;

    [(BSMapAnnotationView *)annView showSelectedState: NO];

    for (UIView *subview in annView.subviews) {
        [subview removeFromSuperview];
    }

    [self.mapView setRegion: annotationsRegion
                   animated: YES];
}


- (void) addLocations: (NSArray *) locs {
    float min_lat = HUGE_VALF;
    float max_lat = -HUGE_VALF;
    float min_lon = HUGE_VALF;
    float max_lon = -HUGE_VALF;
    
    int count = 0;
    
    for (BSLocation *loc in locs) {
        BSMapAnnotation *ann = [[BSMapAnnotation alloc] initWithLocation: loc];
        ann.atpRecord = countsArray[count++];
        [self.mapView addAnnotation: ann];
        
        min_lat = MIN(min_lat, loc.latlon.latitude);
        max_lat = MAX(max_lat, loc.latlon.latitude);
        min_lon = MIN(min_lon, loc.latlon.longitude);
        max_lon = MAX(max_lon, loc.latlon.longitude);
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
    [dataProvider requestSalesOrders:@"0000006677"
                        onCompletion:^(NSMutableArray *soRecords) {
                            BSSOListViewController *soVC = [[BSSOListViewController alloc] initWithNibName: nil
                                                                                                    bundle: nil];
                            
                            soVC.salesOrder = soRecords[0];
                            
                            [self.navigationController pushViewController: soVC
                                                                 animated: YES];
                            [self.loadingView setHidden:YES];
                            [self.mapView deselectAnnotation:self.mapView.selectedAnnotations[0] animated:NO];
                        }
                             onError:^(NSString *errMsg) {
                                 NSLog(@"Received error from data provider while getting the Sales Order List: %@", errMsg);
                             }
     ];
}

#pragma mark - OrderButton

-(void)orderClicked:(id)sender
{
    
    int quantity = [calloutView.txtQuantity.text intValue];
    if(!quantity){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Invalid quantity entered!"
                                                        message:[NSString stringWithFormat:@"Please enter a value from 1 & %d ", available]
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }else if(quantity > 0 && quantity <= available){
        
        [self.view endEditing:YES];
        [self.loadingView setHidden:NO];
        BSSalesOrderCreate * soCreate = [BSSalesOrderCreate new];
        
        BSSalesOrder * item = [[BSSalesOrder alloc] init];
        
        item.quantity = calloutView.txtQuantity.text;
        item.material = self.material.materialID;
        item.plant = self.atpRecord.plant;
        soCreate.soItems = [[NSArray alloc] initWithObjects:item, nil];
        
        [dataProvider createSalesOrder: soCreate
                          onCompletion: ^(NSArray *soRecords) {
                              
                              calloutView = nil;
                              
                              [self getSalesOrderAndShowDetails];
                          }
                               onError: ^(NSString *errMsg) {
                                   [self.loadingView setHidden:YES];
                                   NSLog(@"Received error from data provider while creating Sales Order record: %@", errMsg);
                                   UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error!"
                                                                                   message:errMsg
                                                                                  delegate:self
                                                                         cancelButtonTitle:@"OK"
                                                                         otherButtonTitles:nil];
                                   [alert show];
                               }];
        
    }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Quantity not available!"
                                                        message:[NSString stringWithFormat:@"Max available in stock is %d ", available]
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
    
}

#pragma mark - toggleMapDelegate

-(void)gridViewClicked:(id)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"toggleMap" object:nil];
}

@end
