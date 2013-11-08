//
//  BSSalesOrderListVC.m
//  BlueSky
//
//  Created by Ivan Reyes on 10/3/13.
//  Copyright (c) 2013 SAP MIC. All rights reserved.
//

#import "BSSalesOrderListVC.h"
#import "BSSalesOrderCell.h"
//#import "BSSalesOrderDetailVC.h"
#import "BSSalesOrderDetailVC.h"
#import "BSSalesOrderItem.h"
#import "BSUtils.h"
#import "SMPHelper.h"
#import "ConnectivitySettings.h"
#import "CredentialsData.h"
#import "KeychainHelper.h"
#import "SettingsUtilities.h"
#import "Reachability.h"
#import "BSAppDelegate.h"
#import "ODataPropertyValues.h"
#import "SalesOrderDataController.h"

#import "NSDateFormatter+Additions.h"

@implementation BSSalesOrderListVC {
    //id<BSDataProvider>  dataProvider;
    CALayer             *bgTintLayer;
}

@synthesize statusIcon;
@synthesize statusText;
@synthesize loadingView;


#pragma mark - Initialize



+ (NSString *)dateStringFromString:(NSString *)sourceString
                      sourceFormat:(NSString *)sourceFormat
                 destinationFormat:(NSString *)destinationFormat
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setFormatterBehavior:NSDateFormatterBehavior10_4];
    [dateFormatter setDateFormat:sourceFormat];
    NSDate *date = [dateFormatter dateFromString:sourceString];
    [dateFormatter setDateFormat:destinationFormat];
    return [dateFormatter stringFromDate:date];
}




- (id) initWithNibName: (NSString *) nibNameOrNil
                bundle: (NSBundle *) nibBundleOrNil {
    self = [super initWithNibName: nibNameOrNil
                           bundle: nibBundleOrNil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateNetStatusLabel:) name:@"testA" object:nil];

    return self;
}

-(void)setSalesOrderList:(NSMutableArray *)newList {
    if(_salesOrderList != newList) {
        _salesOrderList = [newList mutableCopy];
    }
}

-(void)reloadSO:(id)sender {
    [self.salesOrderDataController clearTheCache];
    
}


- (void)handleSalesOrderCollectionLoad
{
    if (!loadCompletedObserver) {
        [self.loadingView setHidden:NO];
        loadCompletedObserver = [[NSNotificationCenter defaultCenter] addObserverForName:kLoadSalesOrderCompletedNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *notification) {
            NSLog(@"loadCompletedObserver Sales Order : %@",self.salesOrderList);
            
            //ODataEntry *testEntry = (id)[self.salesOrderList objectAtIndex:0];

            
            

            [self.loadingView setHidden:YES];
            if ([self.salesOrderDataController.serverEntriesCopyList count] > 0)
                self.salesOrderList = self.salesOrderDataController.displayRowsArray;
            else
                self.salesOrderList = self.salesOrderDataController.salesOrderList;
            
            
            [self.gridView reloadData];
            
            NSLog(@"a: %@", self.salesOrderDataController.displayRowsArray );
            NSLog(@"a count: %d", [self.salesOrderDataController.displayRowsArray count] );
            
            int numForLabel = [self.salesOrderList count];
            
            self.titleLabel.text = [[NSString alloc] initWithFormat:@"# of Sales Orders: %d", numForLabel ];
            
            
            
            
        }];
        
    }
}



#pragma mark - View lifecycle

- (void) viewDidLoad {
    [super viewDidLoad];
    
    self.salesOrderDataController = [SalesOrderDataController uniqueInstance];
    
    /* Set the username and password here In the next version we will use a login screen for this */
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *Ausername = [defaults stringForKey:@"username"];
    NSString *Apassword = [defaults stringForKey:@"password"];
    
    self.username = Ausername;
    self.password = Apassword;
    
    self.gridView.delegate = self;
    self.gridView.dataSource = self;
    
    
    
    /* register nib file */
    [self.gridView registerNib: [BSSalesOrderCell nibFile] forCellWithReuseIdentifier: BS_SALES_ORDER_CELL_ID];
    

    
    CGFloat red = 1.0f, blue = 1.0f, green = 1.0f, alpha = 1.0f;
    [self.bgColor getRed: &red
                   green: &green
                    blue: &blue
                   alpha: &alpha];
    bgTintLayer.backgroundColor = [[UIColor colorWithRed: red
                                                   green: green
                                                    blue: blue
                                                   alpha: 0.7f] CGColor];

    

    
    
    //    if ([self.salesOrderList count] > 0)  {
    //        NSLog(@"from cache");
    //        [self.salesOrderDataController loadSalesOrderCollectionWithDidFinishSelector:@selector(loadSalesOrderCollectionCompleted:) forUrl:customerURL];
    //        [self.gridView reloadData];
    //    } else {
    //        NSLog(@"no from cache");
    //        [self.salesOrderDataController loadSalesOrderCollectionWithDidFinishSelector:@selector(loadSalesOrderCollectionCompleted:) forUrl:customerURL];
    //    }
    
    
    
    
}


- (void) viewWillAppear: (BOOL) animated {
    NSLog(@"********** BSSalesOrderListVC : %@",self.salesOrderList);
    [self.loadingView setHidden:YES];
    UIImage *connected = [UIImage imageNamed:@"wifi_connected.png"];
    UIImage *notConnected = [UIImage imageNamed:@"wifi_not_connected.png"];
    UIImage *cellConnected = [UIImage imageNamed:@"3g_connected.png"];
    BSAppDelegate *appDelegate = (BSAppDelegate *)[[UIApplication sharedApplication] delegate];
    Reachability *reach = [appDelegate reach];
    NetworkStatus remoteHostStatus = [reach currentReachabilityStatus];
        NSString *customerURL = @"http://micrelay.sap.com/micsmp3prod/BlueSky.svc/SalesOrders?$filter=CustomerId+eq+'BLUESKY1'&$expand=SalesOrderItems";
    
    
    if ([self.salesOrderDataController.serverEntriesCopyList count] > 0)
        self.salesOrderList = self.salesOrderDataController.displayRowsArray;
    else
        self.salesOrderList = self.salesOrderDataController.salesOrderList;
    
    
    
    if(remoteHostStatus == NotReachable) {
        statusIcon.image = notConnected;
    
    }
    else if (remoteHostStatus == ReachableViaWiFi) {
        


        statusIcon.image = connected;
        [self handleSalesOrderCollectionLoad];
        
        [self.salesOrderDataController loadSalesOrderCollectionWithDidFinishSelector:@selector(loadSalesOrderCollectionCompleted:) forUrl:customerURL];
        
        
    }
    else if (remoteHostStatus == ReachableViaWWAN) {
        statusIcon.image = cellConnected;
        [self handleSalesOrderCollectionLoad];
        
        [self.salesOrderDataController loadSalesOrderCollectionWithDidFinishSelector:@selector(loadSalesOrderCollectionCompleted:) forUrl:customerURL];
        
    }
    [super viewWillAppear: animated];
    
    
    
    
    int numForLabel = [self.salesOrderList count];
    
    self.titleLabel.text = [[NSString alloc] initWithFormat:@"# of Sales Orders: %d", numForLabel ];
}

#pragma mark - connectivity Notification

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




#pragma mark - Application Connection

-(void) registerConnection
{
    //Register using credentials
    BOOL registered = [self createAppConnection];
    // [self.loadingView setHidden:NO];
    
    //Check if registration was successful and show an error if it failed
    if(!registered){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error connecting to server!"
                                                        message:@"Please make sure you are connected to the SAP Corporate Network"
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        
        
        //We are registered so lets send of the first request to populate the main menu
        //        [dataProvider requestCategoriesWithCompletion: ^(NSArray* catGroups) {
        //            NSLog(@"matGroup Return: %@",catGroups);
        //
        //
        //            self.titleLabel.text = [NSString stringWithFormat:@"%d Product Categories", [catGroups count]];
        //
        //
        //            self.materialGroups = catGroups;
        //
        //            //self.gridView.dataSource = mgAdapter;
        //
        //            [self.gridView reloadData];
        //            [self.loadingView setHidden:YES];
        //        }
        //                                                  onError: ^(NSString *errMsg) {
        //                                                      NSLog(@"BSCategoryVC: A Received error from data provider while requesting material groups: %@", errMsg);
        //                                                      self.loadingLabel.text = @"D Unable to connect to SMP Server...";
        //                                                      [self.retryBtn setHidden:NO];
        //                                                  }
        //         ];
        
    }else{
        NSLog(@"asdf");
        /* We are registered so lets send of the first request to populate the main menu */
        //        [dataProvider requestCategoriesWithCompletion: ^(NSArray* catGroups) {
        //            self.titleLabel.text = [NSString stringWithFormat:@"%d Product Categories", [catGroups count]];
        //
        //
        //            self.materialGroups = catGroups;
        //
        //            //self.gridView.dataSource = mgAdapter;
        //
        //            [self.gridView reloadData];
        //            [self.loadingView setHidden:YES];
        //        }
        //                                                  onError: ^(NSString *errMsg) {
        //                                                      NSLog(@"BSCategoryVC: B Received error from data provider while requesting material groups: %@", errMsg);
        //
        //                                                      self.loadingLabel.text = @"E Unable to connect to SMP Server...";
        //                                                      [self.retryBtn setHidden:NO];
        //                                                  }
        //         ];
    }
}

- (BOOL) createAppConnection {
    NSLog(@"createAppConnection");
    if (![SMPHelper isSMPUserRegistered]) {
        NSLog(@"createAppConnection: %@: %@", self.username, self.password);
        /* Check that username and password are not empty */
        if ([self.username length] == 0 || [self.password length] == 0) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Required Fields Missing"
                                                            message:@"Enter username and password."
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
            return NO;
        }
        
        NSError *error = nil;
        
        CredentialsData *credentials = [[CredentialsData alloc] initWithUsername:self.username andPassword:self.password];
        
        [SMPHelper setSMPConnectionProfileWithHost:[ConnectivitySettings SMPHost] andSMPPort:[ConnectivitySettings SMPPort] andDomain:[ConnectivitySettings SMPDomain] andAppId:[ConnectivitySettings SMPAppID] andSecurityConfigName:[ConnectivitySettings SMPSecurityConfiguration]];
        [SMPHelper registerSMPUserWithCredentials:credentials error:&error];
        
        if (!error){
            NSLog(@"Registration Succeeded.");
            /* Registration succeeded: */
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            NSString *appConnectionId = [defaults stringForKey:kApplicationConnectionId];
            if ([appConnectionId length] > 0) {
                NSLog(@"BSCategoryVC: Current App Connection ID: %@", appConnectionId);
                NSString *appCIDMessage = [NSString stringWithFormat:@"Application Connection ID: %@", appConnectionId];
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Registration Succeeded"
                                                                message:appCIDMessage
                                                               delegate:nil
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil];
                [alert show];
            }
            
            NSError *getEndPointError = nil;
            
            /* Set Service URL for ConnectivitySettings */
            NSString *endPoint = [SMPHelper getSMPApplicationEndPointWithCredentials:credentials error:&getEndPointError];
            
            if (!getEndPointError) {
                NSLog(@"Endpoint!");
                endPoint = [NSString stringWithFormat:@"%@/",endPoint];
                [ConnectivitySettings setServiceURL:endPoint];
            } else {
                NSLog(@"BSCategoryVC: ERROR: Failed to get application endpoint/service URL. Error message: %@", [error localizedDescription]);
                return NO;
            }
            
            /* Save credentials in keychain */
            NSError *saveCredentialsError = nil;
            [KeychainHelper saveCredentials:credentials error:&saveCredentialsError];
            if (saveCredentialsError) {
                NSLog(@"BSCategoryVC: ERROR: Credentials could not be saved in keychain. %@", saveCredentialsError);
            }
        } else {
            NSLog(@"BSCategoryVC: Registration failed with error code %d", [error code]);
            return NO;
        }
    } else {
        /* Check for different user */
        if ([KeychainHelper isCredentialsSaved]) {
            CredentialsData *credentials = [[CredentialsData alloc] init];
            NSError *error = nil;
            credentials = [KeychainHelper loadCredentialsAndReturnError:&error];
            
            if (![credentials.username isEqualToString:self.username]) {
                /* Alert user that unregistration of existing user must take place first */
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Different user entered"
                                                                message:@"Unregister existing user first."
                                                               delegate:nil
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil];
                [alert show];
            }
        } else {
            NSLog(@"BSCategoryVC: Device already registered proceeding with login.");
        }
    }
    return YES;
}





#pragma mark - Data Handler

-(void) reload{
    [self.loadingView setHidden:NO];
    
    
    NSString *customerURL = @"http://micrelay.sap.com/micsmp3prod/BlueSky.svc/SalesOrders?$filter=CustomerId+eq+'BLUESKY1'&$expand=SalesOrderItems";
    
    
    [self.salesOrderDataController loadSalesOrderCollectionWithDidFinishSelector:@selector(loadSalesOrderCollectionCompleted:) forUrl:customerURL];
    
    
//    [dataProvider   requestSalesOrders:@"0000003000"
//                    onCompletion:^(NSMutableArray *soRecords) {
//                        NSLog(@"********** BSSalesOrderListVC [reload] soRecords: %@",soRecords);
//                        self.titleLabel.text = [NSString stringWithFormat:@"%d Sales Orders", [soRecords count]];
//
//                            
//                            self.salesOrders = soRecords;
//                            //self.gridView.dataSource = soAdapter;
//                            [self.gridView reloadData];
//                            [self.loadingView setHidden:YES];
//                            NSLog(@"********** BSSalesOrderListVC [soRecords[0] description]: %@", [soRecords[0] description]);
//                        }
//                    onError:^(NSString *errMsg) {
//                        NSLog(@"Received error from data provider while getting the Sales Order List: %@", errMsg);
//                        UIAlertView *alert = [[UIAlertView alloc]   initWithTitle:@"Error!"
//                                                                    message:errMsg
//                                                                    delegate:self
//                                                                    cancelButtonTitle:@"OK"
//                                                                    otherButtonTitles:nil];
//                        [alert show];
//                        }
//        ];

}




#pragma mark - collectionView

- (void)  collectionView: (UICollectionView *) collectionView didSelectItemAtIndexPath: (NSIndexPath *) indexPath {
    //NSLog(@"********** BSSalesOrderListVC didSelectItemAtIndexPath: %@",indexPath);
    
    BSSalesOrderDetailVC *soVC = [[BSSalesOrderDetailVC alloc] initWithNibName: nil bundle: nil];
    
    //NSLog(@"********** BSSalesOrderListVC self.salesOrders: %@",self.salesOrderList);
    
    
    //NSLog(@"********** BSSalesOrderListVC [[soAdapter.salesOrders objectAtIndex:indexPath.row] class] : %@",[[self.salesOrderList objectAtIndex:indexPath.row] class]);
    
    
    ODataEntry *salesOrderEntry = [self.salesOrderList objectAtIndex:indexPath.row];
    
    //NSLog(@"salesOrderEntry: %@",salesOrderEntry);

    NSMutableDictionary *salesOrderEntryDict = [salesOrderEntry getInlinedRelatedEntries];
    
    NSArray *tempArray = [salesOrderEntryDict allValues];
    
    //NSLog(@"tempArray: %@",[tempArray[0] objectAtIndex:0]);
    
    soVC.salesOrderItemEntry = [tempArray[0] objectAtIndex:0];
    
    soVC.salesOrderEntry = salesOrderEntry;
    
    //soVC.salesOrderItem = [tempArray[0] objectAtIndex:0];
    //NSLog(@"myNewODEntry: %@",myNewODEntry);
    //soVC.salesOrderItemEntry = myNewODEntry;
    //soVC.salesOrderItemEntry = [soAdapter.salesOrders objectAtIndex:indexPath.row];
    //soVC.salesOrderItem = [soAdapter.salesOrders objectAtIndex:indexPath.row];

    soVC.realParent = self;
    
    [self.navigationController pushViewController: soVC animated: YES];
}

- (CGSize) collectionView: (UICollectionView *) collectionView layout: (UICollectionViewLayout *) collectionViewLayout sizeForItemAtIndexPath: (NSIndexPath *) indexPath {
    return CGSizeMake(280.0f, 80.0f);
}



- (NSInteger) collectionView: (UICollectionView *) collectionView
      numberOfItemsInSection: (NSInteger) section {
    return [self.salesOrderList count];
}

- (UICollectionViewCell *) collectionView: (UICollectionView *) collectionView cellForItemAtIndexPath: (NSIndexPath *) indexPath {
    
    BSSalesOrderCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier: BS_SALES_ORDER_CELL_ID
                                                                       forIndexPath: indexPath];
    
    ODataEntry *thisSalesOrder = (id)[self.salesOrderList objectAtIndex:indexPath.row];
    
 
    
    
    if( thisSalesOrder.isLocalEntry ) {
        NSLog(@"this is a local entry");
    }
    else {
        NSLog(@"this is not a local entry");
    }

    
    if( thisSalesOrder.isLocalEntryInCache ) {
        NSLog(@"this is a local entry in cache");
    }
    else {
        NSLog(@"this is not a local entry in cache");
    }
 
    
    
    BSSalesOrder *so = [BSSalesOrder new];
    
    NSString * currency = [[thisSalesOrder getPropertyValueByPath:kCurrency] getValue];
    NSString * customerID = [[thisSalesOrder getPropertyValueByPath:kCustomerId] getValue];
    NSString * distChannel = [[thisSalesOrder getPropertyValueByPath:kDistChannel] getValue];
    NSString * division = [[thisSalesOrder getPropertyValueByPath:kDivision] getValue];
    NSString * documentDate = [[thisSalesOrder getPropertyValueByPath:kDocumentDate] getValue];
    NSString * documentType = [[thisSalesOrder getPropertyValueByPath:kDocumentType] getValue];
    NSString * orderID = [[thisSalesOrder getPropertyValueByPath:kSalesOrderId] getValue];
    NSString * orderValue = [[thisSalesOrder getPropertyValueByPath:kOrderValue] getValue];
    NSString * salesOrg = [[thisSalesOrder getPropertyValueByPath:kSalesOrg] getValue];
    
    
    NSLog(@"documentDate : %@",documentDate );
    
    
    
    
    so.currency = currency;
    so.customerId = customerID;
    so.distChannel = distChannel;
    so.division = division;
    so.documentDate = documentDate;
    so.documentType = documentType;
    so.salesOrderId = orderID;
    so.orderValue = orderValue;
    so.salesOrg = salesOrg;

    
    //ODataEntry *test = [self.salesOrderList objectAtIndex:indexPath.row];
    cell.lblDate.text = so.division;
    cell.lblOrderID.text = so.customerId;
    cell.lblDate.text = so.documentDate;
    cell.lblDescription.text = so.salesOrg;

    [BSUtils addCellShadow:cell];
    cell.backgroundColor = [BSUtils colorForIndex: 1];

    
    NSDictionary *inLinedEntries = (id)[thisSalesOrder getInlinedRelatedEntries];
    //NSLog(@"inlinedEntries: %@",inLinedEntries);
    NSString *tempId = [[inLinedEntries allKeys] objectAtIndex:0];
    //NSLog(@"tempId: %@",tempId);
    NSArray *soiArray = (id)[inLinedEntries objectForKey:tempId];
    ODataEntry *soiI = (id)[soiArray objectAtIndex:0];
    //NSLog(@"soii: %@",soiI.fields);

    BSSalesOrderItem *soi = [BSSalesOrderItem new];
    NSString * SOIDescription = [[soiI getPropertyValueByPath:kDescription] getValue];
    NSString * SOIUpdated = [[soiI getPropertyValueByPath:kUpdated] getValue];
    NSString * SOIStatus = [[soiI getPropertyValueByPath:kItemDlvyStatus] getValue];
    NSString * SOIStaTx = [[soiI getPropertyValueByPath:kItemDlvyStaTx] getValue];
    NSString * SOIMaterial = [[soiI getPropertyValueByPath:kMaterial]getValue];
    NSString * SOIValue = [[soiI getPropertyValueByPath:kValue] getValue];
    NSString * SOItem = [[soiI getPropertyValueByPath:kItem]getValue];
    NSString * SOIQuantity = [[soiI getPropertyValueByPath:kQuantity]getValue];
    NSString * SOIOrderId = [[soiI getPropertyValueByPath:kSalesOrderId]getValue];
    
    
    soi.updated = SOIUpdated;
    soi.description = SOIDescription;
    soi.itemDlvyStatus = SOIStatus;
    soi.itemDlvyStaTx = SOIStaTx;
    soi.material = SOIMaterial;
    soi.value = SOIValue;
    soi.orderId = SOIOrderId;
    soi.quantity = SOIQuantity;
    
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setTimeZone:[NSTimeZone timeZoneWithName:@"UTD"]];
    [formatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
    NSDate *date = [formatter dateFromString:documentDate];

    
    NSString *twitterReadableString = [NSDateFormatter blueSkyStringFromDate:date]; //ex:'1s' '1m' '1h' '1d' 'Jan 22'
 
    NSLog(@"Date: %@",twitterReadableString);

    
 
    
    
    
    
    
    
    
    //cell.lblDate.text = soi.updated;
    //NSLog(@"DocumentDate: %@",documentDate);
    //NSLog(@"Updated: %@",SOIUpdated);
    cell.lblDate.text = twitterReadableString;
    
   
    cell.lblStatus.text = soi.itemDlvyStaTx;
    cell.lblDescription.text = soi.description;
    cell.lblOrderID.text = [NSString stringWithFormat:@"#%d", [soi.orderId intValue] ];
    cell.lblQuantity.text = [NSString stringWithFormat:@"%dX", [soi.quantity intValue] ];

    NSString *formattedOrderValue = [NSString stringWithFormat:@"%.2f", [soi.value doubleValue] ];

    //NSLog(@"formattedOrderValue: %@",formattedOrderValue);

    cell.lblOrderValue.text = [NSString stringWithFormat:@"$%@", formattedOrderValue ];

    return cell;
}

#pragma mark - Memory

- (void) didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
