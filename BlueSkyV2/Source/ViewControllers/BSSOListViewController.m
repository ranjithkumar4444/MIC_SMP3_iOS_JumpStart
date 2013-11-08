//
//  BSMapViewController.m
//  BlueSky
//
//  Created by Jones, Jeffry on 7/10/13.
//  Copyright (c) 2013 SAP MIC. All rights reserved.
//

#import "BSSOListViewController.h"
#import "BSSOCreateViewController.h"
//#import "BSDummyDataProvider.h"
#import "BSSMPDataProvider.h"
#import "Constants.h"
#import "BSSalesOrder.h"
#import "BSSOAdapter.h"
#import "BSSOCell.h"
#import "BSUtils.h"
#import "BSSalesOrderViewController.h"
#import "Reachability.h"
#import "BSAppDelegate.h"


@interface BSSOListViewController ()

@end

@implementation BSSOListViewController {
    id<BSDataProvider>       dataProvider;
    BSSOAdapter  *soAdapter;
    CALayer                 *bgTintLayer;
}

@synthesize statusIcon;

- (id) initWithNibName: (NSString *) nibNameOrNil
                bundle:( NSBundle *) nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        //dataProvider = [BSDummyDataProvider new];
        dataProvider = [BSSMPDataProvider new];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateNetStatusLabel:) name:@"testA" object:nil];
    }
    return self;
}




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

- (void) viewDidLoad {
    [super viewDidLoad];
    
    [self.gridView registerNib: [BSSOCell nibFile] forCellWithReuseIdentifier: BS_SO_CELL_ID];
    
    if (!soAdapter) {
        soAdapter = [BSSOAdapter new];
    }
    
    soAdapter.salesOrder = self.salesOrder;
    
    self.productImg.image = [BSUtils imageForMaterial: self.salesOrder.material];
    self.productDescription.text = self.salesOrder.description;

    self.gridView.dataSource = soAdapter;
    [self.loadingView setHidden:YES];
}

-(void)viewWillAppear:(BOOL)animated
{
    NSLog(@"BSSOListViewController");
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

- (void) didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)  collectionView: (UICollectionView *) collectionView didSelectItemAtIndexPath: (NSIndexPath *) indexPath {
    NSLog(@"Selected cell");
}

- (CGSize) collectionView: (UICollectionView *) collectionView
                   layout: (UICollectionViewLayout *) collectionViewLayout
   sizeForItemAtIndexPath: (NSIndexPath *) indexPath {
    return CGSizeMake(130.0f, 60.0f);
}

-(IBAction)btnEditClicked:(id)sender
{
    NSLog(@"btnCreateClicked");
    
    if(!soAdapter.isEditing){
        soAdapter.isEditing = YES;

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
    if(soAdapter.isEditing){
        soAdapter.isEditing = NO;
        for(int i=0; i< 3; i++){
            UICollectionViewCell *cell = [self.gridView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:i inSection:0]];
            [((BSSOCell *)cell).txtValue setHidden:YES];
        }
        [self.gridView reloadData];

        [self.btnEdit setTitle:@"Edit" forState:UIControlStateNormal];
        [self.btnDelete setTitle:@"Delete" forState:UIControlStateNormal];

    }else{
        [dataProvider deleteSalesOrder:self.salesOrder.orderId
                          onCompletion:^(NSMutableArray *soRecords) {

                              NSLog(@"Delete Sales Order List Response: ");
                              
                              [self.realParent reload];
                              
                              [self.navigationController popViewControllerAnimated:YES];
                              
                              
                              
                              UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Success!"
                                                                              message:[NSString stringWithFormat:@"Sales Order [%@] Deleted!", self.salesOrder.orderId]
                                                                             delegate:self
                                                                    cancelButtonTitle:@"OK"
                                                                    otherButtonTitles:nil];
                              [alert show];
                              
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
        
        /*
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Not Supported!"
                                                        message:@"Delete is not currently supported..."
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
         */
    }
}

@end
