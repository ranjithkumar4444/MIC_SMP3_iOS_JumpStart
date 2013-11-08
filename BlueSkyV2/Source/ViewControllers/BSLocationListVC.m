//
//  BSLocationListVC.m
//  BlueSky
//
//  Created by Ivan Reyes on 10/3/13.
//  Copyright (c) 2013 SAP MIC. All rights reserved.
//

#import "BSLocationListVC.h"
#import "BSLocationListCell.h"
#import "BSSalesOrderDetailVC.h"
#import "BSUtils.h"
#import "SMPHelper.h"
#import "ConnectivitySettings.h"
#import "CredentialsData.h"
#import "KeychainHelper.h"
#import "SettingsUtilities.h"
#import "BSProduct.h"
#import "BSPlantWithStock.h"
#import "BSSalesOrder.h"
#import "BSMapVC.h"
#import "BSSalesOrderItemVC.h"
#import "ODataPropertyValues.h"
#import "ODataEntry.h"
#import "ODataEntitySchema.h"



@implementation BSLocationListVC
{
    //id<BSDataProvider>       dataProvider;
    CALayer                 *bgTintLayer;
    NSMutableArray * locationsArray;
    NSMutableArray * countsArray;
    BSMapVC *mapVC;
    BSSalesOrderItemVC *oiVC;
}

@synthesize pwsRecordsArray;
@synthesize selectedProductID;
@synthesize productEntry;


#pragma mark Initialization
- (id) initWithNibName: (NSString *) nibNameOrNil
                bundle: (NSBundle *) nibBundleOrNil {
    self = [super initWithNibName: nibNameOrNil
                           bundle: nibBundleOrNil];
    if (self) {
        //To test application without backend you can use the dummy provider
        //dataProvider = [BSDummyDataProvider new];
        //dataProvider = [BSDataProvider new];
        
        
        
        
    }
    return self;
}





#pragma mark View

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
}


- (void) viewWillAppear: (BOOL) animated {
    
    [super viewWillAppear: animated];

    self.plantWithStockDataController = [PlantWithStockDataController uniqueInstance];
    
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *Ausername = [defaults stringForKey:@"username"];
    NSString *Apassword = [defaults stringForKey:@"password"];
    self.username = Ausername;
    self.password = Apassword;


    self.selectedProductID = [[self.productEntry getPropertyValueByPath:@"Material"] getValue];
    NSLog(@"selectedProductID: %@",self.selectedProductID);

    [self handlePlantWithStockCollectionLoad];
    [self.plantWithStockDataController clearTheCache];
    [self.plantWithStockDataController loadPlantWithStockWithProductID:self.selectedProductID andDidFinishSelector:@selector(loadPlantWithStockCollectionCompleted:) ];
 
}



#pragma mark Data Providers

- (void)populatePlantWithStockAndAddToMap {

    NSLog(@"populatePlantWithStockAndAddToMap!");
    NSLog(@"fields of productEntry: %@",self.productEntry.fields);
    //NSString *matGroupID = [[self.productEntry getPropertyValueByPath:@"Material"] getValue];
    NSLog(@"selectedProductID : %@",self.selectedProductID);
    [self.plantWithStockDataController loadPlantWithStockWithProductID:self.selectedProductID andDidFinishSelector:@selector(testSelector:) ];
    
}

- (void)handlePlantWithStockCollectionLoad
{
    if (!loadCompletedObserver) {
        [self.loadingView setHidden:NO];
        loadCompletedObserver = [[NSNotificationCenter defaultCenter] addObserverForName:kLoadPlantWithStockCompletedNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *notification) {
            NSLog(@"++++++++++++++++++  loadCompletedObserver Plant With Stock in List");
            
            NSLog (@"plantWithStockList: %@",self.plantWithStockList);
            
            [self.loadingView setHidden:YES];
            if ([self.plantWithStockDataController.serverEntriesCopyList count] > 0)
                self.plantWithStockList = self.plantWithStockDataController.displayRowsArray;
            else
                self.plantWithStockList = self.plantWithStockDataController.plantWithStockList;
            
            
            [self.gridView reloadData];
            
        }];
        
    }
}


#pragma mark CollectionView

- (void)  collectionView: (UICollectionView *) collectionView didSelectItemAtIndexPath: (NSIndexPath *) indexPath {
    
    if(!oiVC){
        oiVC = [[BSSalesOrderItemVC alloc] initWithNibName: nil bundle: nil];
    }

    oiVC.product = self.product;
    
    BSLocationListCell *cell = (id)[collectionView cellForItemAtIndexPath:indexPath];
    
    oiVC.nameLabel.text = cell.nameLabel.text;
    oiVC.skuLabel.text = cell.skuLabel.text;
    oiVC.quantityLabel.text = cell.quantityLabel.text;
    oiVC.addressLabel.text = cell.addressLabel.text;

    oiVC.productEntry = [self.pwsRecordsArray objectAtIndex:indexPath.row];
    
    NSLog(@"oiVC.product %@",self.product);
    NSLog(@"oiVC.productEntry %@",self.productEntry);

    oiVC.productEntry = self.productEntry;

    //oiVC.nameLabel.text =

    oiVC.atpRecord = countsArray[indexPath.row];
    
    oiVC.view.frame = [self getScreenFrameForCurrentOrientation];
    //[self.navigationController presentModalViewController:oiVC animated:YES];

    oiVC.realParent = self;
    [self.view addSubview: oiVC.view];
}

- (CGSize) collectionView: (UICollectionView *) collectionView layout: (UICollectionViewLayout *) collectionViewLayout sizeForItemAtIndexPath: (NSIndexPath *) indexPath {
    return CGSizeMake(280.0f, 100.0f);
}



- (NSInteger) collectionView: (UICollectionView *) collectionView numberOfItemsInSection: (NSInteger) section {
    return [self.plantWithStockList count];
}

- (UICollectionViewCell *) collectionView: (UICollectionView *) collectionView cellForItemAtIndexPath: (NSIndexPath *) indexPath {
    
    BSLocationListCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier: BS_LOCATION_LIST_CELL_ID
                                                                         forIndexPath: indexPath];
    if (indexPath.row < [self.plantWithStockList count]) {

        BSPlantWithStock *pws = [BSPlantWithStock new];
        
        NSLog(@"allKeys: %@",[self.plantWithStockEntry.fields allKeys]);
        NSLog(@"[self.pwsRecordsArray objectAtIndex:indexPath.row]: %@",[self.plantWithStockList objectAtIndex:indexPath.row]);
        
        pws.UnitOfMeasure = [[[self.plantWithStockList objectAtIndex:indexPath.row] getPropertyValueByPath:@"UnitOfMeasure"] getValue];
        pws.MaterialID = [[[self.plantWithStockList objectAtIndex:indexPath.row] getPropertyValueByPath:@"Material"] getValue];
        pws.Location = [[[self.plantWithStockList objectAtIndex:indexPath.row] getPropertyValueByPath:@"Location"] getValue];
        pws.Name = [[[self.plantWithStockList objectAtIndex:indexPath.row] getPropertyValueByPath:@"Name"] getValue];
        pws.Street = [[[self.plantWithStockList objectAtIndex:indexPath.row] getPropertyValueByPath:@"Street"] getValue];
        pws.PostalCode = [[[self.plantWithStockList objectAtIndex:indexPath.row] getPropertyValueByPath:@"PostalCode"] getValue];
        pws.City = [[[self.plantWithStockList objectAtIndex:indexPath.row] getPropertyValueByPath:@"City"] getValue];
        pws.CountryKey = [[[self.plantWithStockList objectAtIndex:indexPath.row] getPropertyValueByPath:@"CountryKey"] getValue];
        pws.State = [[[self.plantWithStockList objectAtIndex:indexPath.row] getPropertyValueByPath:@"State"] getValue];

        CGFloat zLatFloat = (CGFloat)[[[[self.plantWithStockList objectAtIndex:indexPath.row] getPropertyValueByPath:@"ZLat"] getValue] floatValue];
        CGFloat zLngFloat = (CGFloat)[[[[self.plantWithStockList objectAtIndex:indexPath.row] getPropertyValueByPath:@"ZLng"] getValue] floatValue];

        pws.zLat = zLatFloat;
        pws.zLng = zLngFloat;
        CLLocationCoordinate2D loca;

        loca.latitude = zLatFloat;
        loca.longitude = zLngFloat;
        pws.latlon = loca;

        NSString *test = [[[self.plantWithStockList objectAtIndex:indexPath.row] getPropertyValueByPath:@"Quantity"] getValue];

        NSNumberFormatter * f = [[NSNumberFormatter alloc] init];
        [f setNumberStyle:NSNumberFormatterDecimalStyle];
        NSNumber * myNumber = [f numberFromString:test];
        
        
        // pws.Quantity =  [NSNumber numberWithInteger:stringToInt(test)];

        pws.Quantity =  myNumber;

        //BSPlantWithStock *pws = [self.pwsRecordsArray objectAtIndex:indexPath.row];
        
        cell.skuLabel.text = pws.MaterialID;
        cell.nameLabel.text = [[self.productEntry getPropertyValueByPath:@"MaterialDescription"] getValue];
        cell.addressLabel.text = pws.Street;
        cell.quantityLabel.text = [pws.Quantity stringValue];
        cell.tag = indexPath.row;
        
        [BSUtils addCellShadow:cell];
        
        [cell.orderBtn addTarget:self action:@selector(orderClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        cell.backgroundColor = [BSUtils colorForIndex: 1];
    }
    
    return cell;
}

#pragma mark Memory

- (void) didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark Actions

-(void)mapViewClicked:(id)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"toggleMap" object:nil];
}


-(void)reload {
    NSLog(@"reload");
}

@end
