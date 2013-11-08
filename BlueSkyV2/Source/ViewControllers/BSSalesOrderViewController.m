//
//  BSMaterialGroupViewController.m
//  BlueSky
//
//  Created by Jones, Jeffry on 6/14/13.
//  Copyright (c) 2013 SAP MIC. All rights reserved.
//

#import "BSSalesOrderViewController.h"
#import "BSSalesOrderAdapter.h"
#import "BSSalesOrderCell.h"
#import "BSSOListViewController.h"
//#import "BSDummyDataProvider.h"
#import "BSSMPDataProvider.h"
#import "BSUtils.h"
#import "SMPHelper.h"
#import "ConnectivitySettings.h"
#import "CredentialsData.h"
#import "KeychainHelper.h"
#import "SettingsUtilities.h"
#import "Reachability.h"
#import "BSSMPDataProvider.h"
#import "BSAppDelegate.h"

@implementation BSSalesOrderViewController
{
    id<BSDataProvider>       dataProvider;
    BSSalesOrderAdapter  *soAdapter;
    CALayer                 *bgTintLayer;
}


@synthesize statusIcon;

- (id) initWithNibName: (NSString *) nibNameOrNil
                bundle: (NSBundle *) nibBundleOrNil {
    self = [super initWithNibName: nibNameOrNil
                           bundle: nibBundleOrNil];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateNetStatusLabel:) name:@"testA" object:nil];
    
    
    

    
    
    if (self) {
        //To test application without backend you can use the dummy provider
        //dataProvider = [BSDummyDataProvider new];
        dataProvider = [BSSMPDataProvider new];
    }
    return self;
}

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




-(void) reload{
    [self.loadingView setHidden:NO];
    [dataProvider requestSalesOrders:@"0000006677"
                        onCompletion:^(NSMutableArray *soRecords) {
                            self.titleLabel.text = [NSString stringWithFormat:@"%d Sales Orders", [soRecords count]];
                            
                            if (!soAdapter) {
                                soAdapter = [BSSalesOrderAdapter new];
                            }
                            
                            soAdapter.salesOrders = soRecords;
                            self.gridView.dataSource = soAdapter;
                            [self.gridView reloadData];
                            [self.loadingView setHidden:YES];
                            NSLog(@"Sales Order List Response: %@", [soRecords[0] description]);
                            
                        }
                             onError:^(NSString *errMsg) {
                                 NSLog(@"Received error from data provider while getting the Sales Order List: %@", errMsg);
                                 UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error!"
                                                                                 message:errMsg
                                                                                delegate:self
                                                                       cancelButtonTitle:@"OK"
                                                                       otherButtonTitles:nil];
                                 [alert show];
                             }
     ];

}

- (void) viewDidLoad {
    [super viewDidLoad];
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
    
    
    
    
    
    [self reload];
}

- (void)  collectionView: (UICollectionView *) collectionView
didSelectItemAtIndexPath: (NSIndexPath *) indexPath {
    
    BSSOListViewController *soVC = [[BSSOListViewController alloc] initWithNibName: nil
                                                                                 bundle: nil];
    
    soVC.salesOrder = [soAdapter.salesOrders objectAtIndex:indexPath.row];
    soVC.realParent = self;
    
    [self.navigationController pushViewController: soVC
                                         animated: YES];
}

- (CGSize) collectionView: (UICollectionView *) collectionView
                   layout: (UICollectionViewLayout *) collectionViewLayout
   sizeForItemAtIndexPath: (NSIndexPath *) indexPath {
    return CGSizeMake(280.0f, 80.0f);
}

- (void) viewWillAppear: (BOOL) animated {
    NSLog(@"BSSalesOrderViewController");
    UIImage *connected = [UIImage imageNamed:@"wifi_connected.png"];
    UIImage *notConnected = [UIImage imageNamed:@"wifi_not_connected.png"];
    UIImage *cellConnected = [UIImage imageNamed:@"3g_connected.png"];
    
    BSAppDelegate *appDelegate = (BSAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    Reachability *reach = [appDelegate reach];
    
    NetworkStatus remoteHostStatus = [reach currentReachabilityStatus];
    if(remoteHostStatus == NotReachable) {statusIcon.image = notConnected;}
    else if (remoteHostStatus == ReachableViaWiFi) {statusIcon.image = connected; }
    else if (remoteHostStatus == ReachableViaWWAN) {statusIcon.image = cellConnected; }
    
    
    
    
    [super viewWillAppear: animated];
}

- (void) didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
