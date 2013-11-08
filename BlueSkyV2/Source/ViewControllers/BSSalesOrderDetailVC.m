//
//  BSSalesOrderDetailVC.m
//  BlueSky
//
//  Created by Ivan Reyes on 10/3/13.
//  Copyright (c) 2013 SAP MIC. All rights reserved.
//

#import "BSSalesOrderDetailVC.h"
#import "BSSOCreateViewController.h"
//#import "BSDummyDataProvider.h"
//#import "BSDataController.h"
#import "SalesOrderDataController.h"
#import "Constants.h"
#import "BSSalesOrder.h"
#import "BSSalesOrderItem.h"
#import "BSSOCell.h"
#import "BSUtils.h"
#import "BSSalesOrderListVC.h"
#import "Reachability.h"
#import "BSAppDelegate.h"
#import "ODataPropertyValues.h"

@interface BSSalesOrderDetailVC ()

@end

@implementation BSSalesOrderDetailVC {
   // id<BSDataProvider>       dataProvider;
    CALayer *bgTintLayer;
}

@synthesize statusIcon;
@synthesize salesOrderItemEntry;
@synthesize salesOrderItem;

#pragma mark - Initialization

- (id) initWithNibName: (NSString *) nibNameOrNil
                bundle:( NSBundle *) nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
 
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateNetStatusLabel:) name:@"testA" object:nil];
        
         [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didFinishDeleteSalesOrder:) name:@"deleteSalesOrderNotification" object:nil];
        
        //deleteSalesOrderNotification
        
    }
    return self;
}

#pragma mark - View lifecycle
- (void) viewDidLoad {
    [super viewDidLoad];
    
    self.salesOrderDataController = [SalesOrderDataController uniqueInstance];
    
    
    [self.gridView registerNib: [BSSOCell nibFile] forCellWithReuseIdentifier: BS_SO_CELL_ID];

    //NSLog(@"self.salesOrderItemEntry.fields: %@", self.salesOrderItemEntry );
    //NSLog(@"field for salesOrderItemEntry: %@",self.salesOrderItemEntry.fields);

    NSString *SOIe_Currency = [[self.salesOrderItemEntry getPropertyValueByPath:@"Currency"] getValue];
    NSString *SOIe_Description = [[self.salesOrderItemEntry getPropertyValueByPath:@"Description"] getValue];
    NSString *SOIe_Item = [[self.salesOrderItemEntry getPropertyValueByPath:@"Item"] getValue];
    NSString *SOIe_ItemDlvyStaTx = [[self.salesOrderItemEntry getPropertyValueByPath:@"ItemDlvyStaTx"] getValue];
    NSString *SOIe_ItemDlvyStatus = [[self.salesOrderItemEntry getPropertyValueByPath:@"ItemDlvyStatus"] getValue];
    NSString *SOIe_Material = [[self.salesOrderItemEntry getPropertyValueByPath:@"Material"] getValue];
    NSString *SOIe_OrderId = [[self.salesOrderItemEntry getPropertyValueByPath:@"OrderId"] getValue];
    NSString *SOIe_Plant = [[self.salesOrderItemEntry getPropertyValueByPath:@"Plant"] getValue];
    NSString *SOIe_Quantity = [[self.salesOrderItemEntry getPropertyValueByPath:@"Quantity"] getValue];
    NSString *SOIe_UoM = [[self.salesOrderItemEntry getPropertyValueByPath:@"UoM"] getValue];
    NSString *SOIe_Value = [[self.salesOrderItemEntry getPropertyValueByPath:@"Value"] getValue];

//    NSLog(@"SOI Currency %@ ",SOIe_Currency);
//    NSLog(@"SOI Description %@ ",SOIe_Description);
//    NSLog(@"SOI Item %@ ",SOIe_Item);
//    NSLog(@"SOI ItemDlvyStaTx %@ ",SOIe_ItemDlvyStaTx);
//    NSLog(@"SOI ItemDlvyStatus %@ ",SOIe_ItemDlvyStatus);
//    NSLog(@"SOI Material %@ ",SOIe_Material);
//    NSLog(@"SOI OrderId %@ ",SOIe_OrderId);
//    NSLog(@"SOI Plant %@ ",SOIe_Plant);
//    NSLog(@"SOI Quantity %@ ",SOIe_Quantity);
//    NSLog(@"SOI UoM %@ ",SOIe_UoM);
//    NSLog(@"SOI Value %@ ",SOIe_Value);
 
    BSSalesOrderItem *soitmp = [BSSalesOrderItem new];
    
    soitmp.description = SOIe_Description;
    soitmp.item = SOIe_Item;
    soitmp.itemDlvyStaTx = SOIe_ItemDlvyStaTx;
    soitmp.itemDlvyStatus = SOIe_ItemDlvyStatus;
    soitmp.material = SOIe_Material;
    soitmp.orderId = SOIe_OrderId;
    soitmp.plant = SOIe_Plant;
    soitmp.quantity = SOIe_Quantity;
    soitmp.uoM = SOIe_UoM;
    soitmp.value = SOIe_Value;
    
    NSLog(@"soitmp: %@",soitmp);
    
    self.salesOrderItem = soitmp;
    

    
    self.productDescription.text = SOIe_Description;
    //self.productImg.image = [BSUtils imageForMaterial: self.salesOrderItem.material];

    self.productImg.image = [BSUtils imageForMaterial: self.salesOrderItem.material];
    //self.productDescription.text = self.salesOrderItem.description;
    
    self.gridView.dataSource = self;
    [self.loadingView setHidden:YES];
}


-(void)viewWillAppear:(BOOL)animated
{
    NSLog(@"BSSalesOrderDetailVC");

    //NSLog(@"self.salesOrderItemEntry.fields: %@", self.salesOrderItemEntry.fields );

    [self handleDataLoad];
    
    
    bgTintLayer = [CALayer new];
    bgTintLayer.frame = [self getScreenFrameForCurrentOrientation];
    
    self.bgView.frame = bgTintLayer.frame;
    [self.bgView.layer addSublayer: bgTintLayer];
    
    CGFloat red = 0.0f, blue = 0.75f, green = 0.0f, alpha = 1.0f;
    [self.bgColor getRed: &red
                   green: &green
                    blue: &blue
                   alpha: &alpha];
    /*bgTintLayer.backgroundColor = [[UIColor colorWithRed: red
     green: green
     blue: blue
     alpha: 0.7f] CGColor];
     */
    
    UIImage *connected = [UIImage imageNamed:@"wifi_connected.png"];
    UIImage *notConnected = [UIImage imageNamed:@"wifi_not_connected.png"];
    UIImage *cellConnected = [UIImage imageNamed:@"3g_connected.png"];
    
    BSAppDelegate *appDelegate = (BSAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    Reachability *reach = [appDelegate reach];
    
    NetworkStatus remoteHostStatus = [reach currentReachabilityStatus];
    if(remoteHostStatus == NotReachable) {statusIcon.image = notConnected;}
    else if (remoteHostStatus == ReachableViaWiFi) {statusIcon.image = connected; }
    else if (remoteHostStatus == ReachableViaWWAN) {statusIcon.image = cellConnected; }
    
 
    
    
}

-(void)viewWillLayoutSubviews
{
    if(self.gridView.collectionViewLayout.collectionViewContentSize.height == 60.0){
        self.uiView.frame = CGRectMake(self.uiView.frame.origin.x, self.uiView.frame.origin.y, self.uiView.frame.size.width, 102.0);
        self.uiViewShadow.frame = CGRectMake(self.uiViewShadow.frame.origin.x, self.uiViewShadow.frame.origin.y, self.uiViewShadow.frame.size.width, 102.0);
    }else if(self.gridView.collectionViewLayout.collectionViewContentSize.height == 120.0){
        self.uiView.frame = CGRectMake(self.uiView.frame.origin.x, self.uiView.frame.origin.y, self.uiView.frame.size.width, 162.0);
        self.uiViewShadow.frame = CGRectMake(self.uiViewShadow.frame.origin.x, self.uiViewShadow.frame.origin.y, self.uiViewShadow.frame.size.width, 162.0);
    }
    
    bgTintLayer.frame = [self getScreenFrameForCurrentOrientation];
    
    self.bgView.frame = bgTintLayer.frame;
}

#pragma mark - Data handler
- (void)handleDataLoad
{
    if (!loadCompletedObserver) {
        loadCompletedObserver = [[NSNotificationCenter defaultCenter] addObserverForName:kLoadSOItemCollectionCompletedNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *notification) {
            
//            if ([self.dataProvider.serverEntriesCopyList count] > 0)
//                self.travelAgencyList = self.travelAgencyDataController.displayRowsArray;
//            else
//                self.travelAgencyList = self.travelAgencyDataController.travelAgencyList;
//            [[self tableView] reloadData];
            
            
            
//            if ([self.travelAgencyDataController.serverEntriesCopyList count] > 0)
//                self.travelAgencyList = self.travelAgencyDataController.displayRowsArray;
//            else
//                self.travelAgencyList = self.travelAgencyDataController.travelAgencyList;
//            [[self tableView] reloadData];
            
        }];
    }
}



-(void)didFinishDeleteSalesOrder:(id)sender {
    
    NSLog(@"didFinishDeleteSalesOrder");
    
    [self.loadingView setHidden:YES];
    
    
    [self backButtonClicked:(id)sender];
    
    
}



#pragma mark - Network Status Label
-(void)updateNetStatusLabel:(NSNotification *) notification {
    
    UIImage *connected = [UIImage imageNamed:@"wifi_connected.png"];
    UIImage *notConnected = [UIImage imageNamed:@"wifi_not_connected.png"];
    UIImage *cellConnected = [UIImage imageNamed:@"3g_connected.png"];
    
    
    NSString *netStatusText = [notification object];
    
    
    if([netStatusText isEqualToString:@"Not Reachable"]) {
        statusIcon.image = notConnected;
        
    }
    else if([netStatusText isEqualToString:@"Reachable View Wi-Fi"]) {
        statusIcon.image = connected;
    }
    else if([netStatusText isEqualToString:@"Reachable View WWAN"]) {
        statusIcon.image = cellConnected;
    }
    
    else {
        statusIcon.image = connected;
    }
    
    
}




#pragma mark - Memory

- (void) didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - CollectionView

- (void)  collectionView: (UICollectionView *) collectionView didSelectItemAtIndexPath: (NSIndexPath *) indexPath {
    NSLog(@"Selected cell");
}


- (NSInteger) collectionView: (UICollectionView *) collectionView
      numberOfItemsInSection: (NSInteger) section {
    return 6;
}

- (UICollectionViewCell *) collectionView: (UICollectionView *) collectionView
                   cellForItemAtIndexPath: (NSIndexPath *) indexPath {
    
    BSSOCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier: BS_SO_CELL_ID
                                                               forIndexPath: indexPath];
    
    //NSLog(@"+++++++++++++ self.salesOrderitem: %@",self.salesOrderItem);
    
    
    if (self.salesOrderItem) {
        if(indexPath.row == 0){
            cell.label.text = @"Requested Date";
            if(self.isEditing){
                [cell.value setHidden:YES];
                [cell.txtValue setHidden:NO];
                cell.txtValue.text = self.salesOrderItem.updated;
            }else{
                [cell.value setHidden:NO];
                [cell.txtValue setHidden:YES];
                cell.value.text = self.salesOrderItem.updated;
            }
            
        }else if(indexPath.row == 1){
            cell.label.text = @"Material";
            if(self.isEditing){
                [cell.value setHidden:YES];
                [cell.txtValue setHidden:NO];
                cell.txtValue.text = self.salesOrderItem.material;
            }else{
                [cell.value setHidden:NO];
                [cell.txtValue setHidden:YES];
                cell.value.text = self.salesOrderItem.material;
            }
        }else if(indexPath.row == 2){
            cell.label.text = @"Quantity";
            if(self.isEditing){
                [cell.value setHidden:YES];
                [cell.txtValue setHidden:NO];
                cell.txtValue.text = self.salesOrderItem.quantity;
            }else{
                [cell.value setHidden:NO];
                [cell.txtValue setHidden:YES];
                cell.value.text = self.salesOrderItem.quantity;
            }
        }else if(indexPath.row == 3){
            [cell.value setHidden:NO];
            [cell.txtValue setHidden:YES];
            cell.label.text = @"Price/Unit";
            float tmp = [self.salesOrderItem.value floatValue]/[self.salesOrderItem.quantity floatValue];
            cell.value.text = [NSString stringWithFormat:@"$%.2f",tmp];
        }else if(indexPath.row == 4){
            [cell.value setHidden:NO];
            [cell.txtValue setHidden:YES];
            cell.label.text = @"Total Value";
            cell.value.text = [NSString stringWithFormat:@"$%.2f",[self.salesOrderItem.value floatValue]];
        }else if(indexPath.row == 5){
            [cell.value setHidden:NO];
            [cell.txtValue setHidden:YES];
            cell.label.text = @"Status";
            cell.value.text = self.salesOrderItem.itemDlvyStaTx;
        }
    }
    
    return cell;
}


- (CGSize) collectionView: (UICollectionView *) collectionView
                   layout: (UICollectionViewLayout *) collectionViewLayout
   sizeForItemAtIndexPath: (NSIndexPath *) indexPath {
    return CGSizeMake(130.0f, 60.0f);
}


#pragma mark - Button Handlers
-(IBAction)btnEditClicked:(id)sender {
    NSLog(@"btnCreateClicked");
    
    if(!self.isEditing){
        self.isEditing = YES;

        [self.gridView reloadData];
        
        [self.btnEdit setTitle:@"Save" forState:UIControlStateNormal];
        [self.btnDelete setTitle:@"Cancel" forState:UIControlStateNormal];
    }else{
        //soAdapter.isEditing = NO;
        
        //[self.btnEdit setTitle:@"Edit" forState:UIControlStateNormal];
        //[self.btnDelete setTitle:@"Delete" forState:UIControlStateNormal];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Not Supported!"
                                                        message:@"Update is not currently supported..."
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
}


-(IBAction)btnDeleteClicked:(id)sender
{
    NSLog(@"btnDeleteClicked");
    if(self.isEditing){
        self.isEditing = NO;
        for(int i=0; i< 3; i++){
            UICollectionViewCell *cell = [self.gridView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:i inSection:0]];
            [((BSSOCell *)cell).txtValue setHidden:YES];
        }
        [self.gridView reloadData];

        [self.btnEdit setTitle:@"Edit" forState:UIControlStateNormal];
        [self.btnDelete setTitle:@"Delete" forState:UIControlStateNormal];

    }else{
        [self.loadingView setHidden:NO];
        
    NSString *soI = [[self.salesOrderItemEntry getPropertyValueByPath:@"OrderId"] getValue];
        
    NSLog(@"*********** GOING TO DELETE: %@",soI);
        [self.salesOrderDataController clearTheCache];
    
    [self.salesOrderDataController deleteSalesOrderWithOrder:self.salesOrderEntry WithSelector:@selector(finishedDelete:) ];

    }
}

@end
