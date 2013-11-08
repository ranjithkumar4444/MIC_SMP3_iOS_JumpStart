//
//  BSMaterialGroupViewController.m
//  BlueSky
//
//  Created by Jones, Jeffry on 6/14/13.
//  Copyright (c) 2013 SAP MIC. All rights reserved.
//

#import "BSLocationListViewController.h"
#import "BSLocationListCell.h"
#import "BSSOListViewController.h"
//#import "BSDummyDataProvider.h"
#import "BSSMPDataProvider.h"
#import "BSUtils.h"
#import "SMPHelper.h"
#import "ConnectivitySettings.h"
#import "CredentialsData.h"
#import "KeychainHelper.h"
#import "SettingsUtilities.h"
#import "BSMaterial.h"
#import "BSLocation.h"
#import "BSATPRecord.h"
//#import "BSDummyDataProvider.h"
#import "BSSMPDataProvider.h"
#import "BSSalesOrder.h"
#import "BSSMPDataProvider.h"
#import "BSMapViewController.h"
#import "BSOrderItemViewController.h"

@implementation BSLocationListViewController
{
    id<BSDataProvider>       dataProvider;
    CALayer                 *bgTintLayer;
    NSMutableArray * locationsArray;
    NSMutableArray * countsArray;
    BSMapViewController *mapVC;
    BSOrderItemViewController *oiVC;
}

- (id) initWithNibName: (NSString *) nibNameOrNil
                bundle: (NSBundle *) nibBundleOrNil {
    self = [super initWithNibName: nibNameOrNil
                           bundle: nibBundleOrNil];
    if (self) {
        //To test application without backend you can use the dummy provider
        //dataProvider = [BSDummyDataProvider new];
        dataProvider = [BSSMPDataProvider new];
        
    }
    return self;
}

- (void)populateATPForLocation:(BSLocation *)item
{
    [dataProvider requestATPForMaterial: self.material.materialID
                             atLocation: item.locationID
                           onCompletion: ^(NSArray *atpRecords) {
                               
                               NSLog(@"atpRecords: %@",atpRecords);
                               
                               [countsArray addObject: atpRecords[[atpRecords count]-1]];
                               if([countsArray count] == 3){
                                   for(int i=[countsArray count]-3; i<[countsArray count]; i++){
                                       ((BSLocation *)locationsArray[i]).quantity = (int)((BSATPRecord *)countsArray[i]).quantity;
                                   }
                                   self.titleLabel.text = [NSString stringWithFormat:@"%d Stores Found", [locationsArray count]];
                                   
                                   self.locationArray = locationsArray;
                                   self.gridView.dataSource = self;
                                   [self.gridView reloadData];
                                   [self.loadingView setHidden:YES];
                               }
                           }
                                onError: ^(NSString *errMsg) {
                                    NSLog(@"Received error from data provider while requesting ATP record: %@", errMsg);
                                }];
}

- (void)getLocationInfoForID:(BSLocation *)loc
{
//    [dataProvider requestLocationInfoForLocationIDs: loc
//                                       onCompletion: ^(NSArray * locations) {
//                                           
//                                           NSLog(@"locations: %@",locations);
//                                           
//                                           ((BSLocation *)locations[0]).material = self.material;
//                                           [locationsArray addObject:locations[0]];
//                                           
//                                           if([locationsArray count] == 3){
//                                               for(BSLocation * item in locationsArray){
//                                                  // [self populateATPForLocation:item];
//                                                   NSLog(@"was going to call ATPForLocation: %@",item);
//                                               }
//                                               //self.titleLabel.text = [NSString stringWithFormat:@"%d Stores Found", [locationsArray count]];
//                                           }
//                                       }
//                                            onError: ^(NSString *errMsg) {
//                                                NSLog(@"Received error from data provider while requesting locations: %@", errMsg);
//                                            }
//     ];
}

- (void) viewDidLoad {
    [super viewDidLoad];
    NSLog(@"########## 006");
    
    [self.gridView registerNib: [BSLocationListCell nibFile] forCellWithReuseIdentifier: BS_LOCATION_LIST_CELL_ID];
    
    CGFloat red = 1.0f, blue = 1.0f, green = 1.0f, alpha = 1.0f;
    [self.bgColor getRed: &red
                   green: &green
                    blue: &blue
                   alpha: &alpha];
    bgTintLayer.backgroundColor = [[UIColor colorWithRed: red
                                                   green: green
                                                    blue: blue
                                                   alpha: 0.7f] CGColor];
    [self reload];
}

-(void) reload{
    [self.loadingView setHidden:NO];
    
    locationsArray = [[NSMutableArray alloc] init];
    countsArray = [[NSMutableArray alloc] init];
    
    //Get the Location ID for the material
    [dataProvider requestLocationIDForMaterial:self.material.materialID
                                  onCompletion:^(NSArray * locationIDs) {
                                      //Now use the returned ID to get the Location Info
                                      for(int i = 0; i<3;i++){
                                          [self getLocationInfoForID:locationIDs[i]];
                                      }
                                      
                                  }
                                       onError:^(NSString *errMsg) {
                                           NSLog(@"Received error from data provider while requesting locationID: %@", errMsg);
                                       }];

}

- (void)  collectionView: (UICollectionView *) collectionView
didSelectItemAtIndexPath: (NSIndexPath *) indexPath {
    
    if(!oiVC){
        oiVC = [[BSOrderItemViewController alloc] initWithNibName: nil bundle: nil];
    }

    oiVC.material = self.material;
    oiVC.atpRecord = countsArray[indexPath.row];
    
    oiVC.view.frame = [self getScreenFrameForCurrentOrientation];
    //[self.navigationController presentModalViewController:oiVC animated:YES];
    oiVC.realParent = self;
    [self.view addSubview: oiVC.view];
}

- (CGSize) collectionView: (UICollectionView *) collectionView
                   layout: (UICollectionViewLayout *) collectionViewLayout
   sizeForItemAtIndexPath: (NSIndexPath *) indexPath {
    return CGSizeMake(280.0f, 100.0f);
}

- (void) viewWillAppear: (BOOL) animated {

    [super viewWillAppear: animated];
}

- (void) didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



-(void)mapViewClicked:(id)sender
{
   [[NSNotificationCenter defaultCenter] postNotificationName:@"toggleMap" object:nil];
}

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
                            //[self.mapView deselectAnnotation:self.mapView.selectedAnnotations[0] animated:NO];
                        }
                             onError:^(NSString *errMsg) {
                                 NSLog(@"Received error from data provider while getting the Sales Order List: %@", errMsg);
                             }
     ];
}

- (NSInteger) collectionView: (UICollectionView *) collectionView
      numberOfItemsInSection: (NSInteger) section {
    return [self.locationArray count];
}

- (UICollectionViewCell *) collectionView: (UICollectionView *) collectionView
                   cellForItemAtIndexPath: (NSIndexPath *) indexPath {
    
    BSLocationListCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier: BS_LOCATION_LIST_CELL_ID
                                                                         forIndexPath: indexPath];
    if (indexPath.row < [self.locationArray count]) {
        BSLocation *loc = [self.locationArray objectAtIndex: indexPath.row];
        
        cell.skuLabel.text = [NSString stringWithFormat: @"SKU %@", loc.material.materialID];
        cell.nameLabel.text = loc.material.name;
        cell.addressLabel.text = loc.address;
        cell.quantityLabel.text = [NSString stringWithFormat: @"%d", loc.quantity];
        cell.tag = indexPath.row;
        
        [BSUtils addCellShadow:cell];
        
        [cell.orderBtn addTarget:self action:@selector(orderClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        cell.backgroundColor = [BSUtils colorForIndex: 1];
    }
    
    return cell;
}
@end
