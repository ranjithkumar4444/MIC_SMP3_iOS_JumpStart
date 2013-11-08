//
//  BSMaterialGroupViewController.m
//  BlueSky
//
//  Created by Jones, Jeffry on 6/14/13.
//  Copyright (c) 2013 SAP MIC. All rights reserved.
//

#import "BSMaterialGroupViewController.h"
#import "BSMaterialGroupAdapter.h"
#import "BSMaterialGroupCell.h"
#import "BSMaterialViewController.h"
#import "BSSalesOrderViewController.h"
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
#import "ODataEntry.h"
#import "Constants.h"

@implementation BSMaterialGroupViewController
{
    id<BSDataProvider>       dataProvider;
    BSMaterialGroupAdapter  *mgAdapter;
    BSSalesOrderViewController *gridVC;
}

@synthesize statusIcon;
@synthesize statusText;


#pragma mark - Initialization

- (id) initWithNibName: (NSString *) nibNameOrNil
                bundle: (NSBundle *) nibBundleOrNil {
    self = [super initWithNibName: nibNameOrNil
                           bundle: nibBundleOrNil];
    if (self) {
        //To test application without backend you can use the dummy provider
        //dataProvider = [BSDummyDataProvider new];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateNetStatusLabel:) name:@"testA" object:nil];    
        dataProvider = [BSSMPDataProvider new];
    }
    return self;
}


#pragma mark - View

- (void) viewDidLoad {
    [super viewDidLoad];
    [self.gridView registerNib: [BSMaterialGroupCell nibFile] forCellWithReuseIdentifier: BS_MATGROUP_CELL_ID];
    
    //Set the username and password here
    //In the next version we will use a login screen for this
    self.username = @"MICDEMO";
    self.password = @"welcome";
    [self handleGRPDataLoad];
    
    if([statusText isEqualToString:@"nointernetz"]) {

        //We are registered so lets send of the first request to populate the main menu
        [dataProvider requestMaterialGroupsWithCompletion: ^(NSArray* matGroups) {

            self.titleLabel.text = [NSString stringWithFormat:@"%d Product Categories", [matGroups count]];
            if (!mgAdapter) {
                mgAdapter = [BSMaterialGroupAdapter new];
            }
            
            mgAdapter.materialGroups = matGroups;
            self.gridView.dataSource = mgAdapter;
            [self.gridView reloadData];
            [self.loadingView setHidden:YES];
        }
            onError: ^(NSString *errMsg) {
            NSLog(@"BSMaterialGroupViewController:  A Received error from data provider while requesting material groups: %@", errMsg);
            self.loadingLabel.text = @"D Unable to connect to SMP Server...";
            [self.retryBtn setHidden:NO];
            }
         ];

    }
    else {
        [self performSelector:@selector(registerConnection) withObject:self afterDelay:0.1 ];
    }

}


- (void) viewWillAppear: (BOOL) animated {
    NSLog(@"BSMaterialGroupViewController");
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


#pragma mark - NetStatus Notification

-(void)updateNetStatusLabel:(NSNotification *) notification {
    
    UIImage *connected = [UIImage imageNamed:@"wifi_connected.png"];
    UIImage *notConnected = [UIImage imageNamed:@"wifi_not_connected.png"];
    UIImage *cellConnected = [UIImage imageNamed:@"3g_connected.png"];

    NSString *netStatusText = [notification object];
    
    
    if([netStatusText isEqualToString:@"Not Reachable"]) {
        statusIcon.image = notConnected;
        statusText = @"nointernetz";
        
    }
    else if([netStatusText isEqualToString:@"Reachable View Wi-Fi"]) {
        statusIcon.image = connected;
        statusText = @"wifiz";
    }
    else if([netStatusText isEqualToString:@"Reachable View WWAN"]) {
        statusIcon.image = cellConnected;
        statusText = @"wanz";
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
    [self.loadingView setHidden:NO];
    
    //Check if registration was successful and show an error if it failed
    if(!registered){
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error connecting to server!"
//                                                        message:@"Please make sure you are connected to the SAP Corporate Network"
//                                                       delegate:self
//                                              cancelButtonTitle:@"OK"
//                                              otherButtonTitles:nil];
//        [alert show];


        //We are registered so lets send of the first request to populate the main menu
        [dataProvider requestMaterialGroupsWithCompletion: ^(NSArray* matGroups) {
            
            
            self.titleLabel.text = [NSString stringWithFormat:@"%d Product Categories", [matGroups count]];
            if (!mgAdapter) {
                mgAdapter = [BSMaterialGroupAdapter new];
            }
            
            mgAdapter.materialGroups = matGroups;
            self.gridView.dataSource = mgAdapter;
            [self.gridView reloadData];
            [self.loadingView setHidden:YES];
        }
                                                  onError: ^(NSString *errMsg) {
                                                      NSLog(@"BSMaterialGroupViewController: A Received error from data provider while requesting material groups: %@", errMsg);
                                                      self.loadingLabel.text = @"D Unable to connect to SMP Server...";
                                                      [self.retryBtn setHidden:NO];
                                                  }
         ];
        
    }else{
        //We are registered so lets send of the first request to populate the main menu
        [dataProvider requestMaterialGroupsWithCompletion: ^(NSArray* matGroups) {

            self.titleLabel.text = [NSString stringWithFormat:@"%d Product Categories", [matGroups count]];
            if (!mgAdapter) {
                mgAdapter = [BSMaterialGroupAdapter new];
            }
            
            mgAdapter.materialGroups = matGroups;
            self.gridView.dataSource = mgAdapter;
            [self.gridView reloadData];
            [self.loadingView setHidden:YES];
        }
                                                  onError: ^(NSString *errMsg) {
                                                      NSLog(@"BSMaterialGroupViewController: B Received error from data provider while requesting material groups: %@", errMsg);

                                                      self.loadingLabel.text = @"E Unable to connect to SMP Server...";
                                                      [self.retryBtn setHidden:NO];
                                                  }
         ];
    }
}

- (BOOL) createAppConnection {
    
    
    if (![SMPHelper isSMPUserRegistered]) {
        //Check that username and password are not empty
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
            //Registration succeeded:
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            NSString *appConnectionId = [defaults stringForKey:kApplicationConnectionId];
            if ([appConnectionId length] > 0) {
                NSLog(@"BSMaterialGroupViewController: Current App Connection ID: %@", appConnectionId);
                NSString *appCIDMessage = [NSString stringWithFormat:@"Application Connection ID: %@", appConnectionId];
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Registration Succeeded"
                                                                message:appCIDMessage
                                                               delegate:nil
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil];
                [alert show];
            }
            
            NSError *getEndPointError = nil;
            
            //Set Service URL for ConnectivitySettings
            NSString *endPoint = [SMPHelper getSMPApplicationEndPointWithCredentials:credentials error:&getEndPointError];
            
            if (!getEndPointError) {
                endPoint = [NSString stringWithFormat:@"%@/",endPoint];
                [ConnectivitySettings setServiceURL:endPoint];
            } else {
                NSLog(@"BSMaterialGroupViewController: ERROR: Failed to get application endpoint/service URL. Error message: %@", [error localizedDescription]);
                return NO;
            }
            
            //Save credentials in keychain
            NSError *saveCredentialsError = nil;
            [KeychainHelper saveCredentials:credentials error:&saveCredentialsError];
            if (saveCredentialsError) {
                NSLog(@"BSMaterialGroupViewController: ERROR: Credentials could not be saved in keychain. %@", saveCredentialsError);
            }
        } else {
            NSLog(@"BSMaterialGroupViewController: Registration failed with error code %d", [error code]);
            return NO;
        }
    } else {
        //Check for different user.
        if ([KeychainHelper isCredentialsSaved]) {
            CredentialsData *credentials = [[CredentialsData alloc] init];
            NSError *error = nil;
            credentials = [KeychainHelper loadCredentialsAndReturnError:&error];
            
            if (![credentials.username isEqualToString:self.username]) {
                //Alert user that unregistration of existing user must take place first
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Different user entered"
                                                                message:@"Unregister existing user first."
                                                               delegate:nil
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil];
                [alert show];
            }
        } else {
            NSLog(@"BSMaterialGroupViewController: Device already registered proceeding with login.");
        }
    }
    return YES;
}

#pragma mark - CollectionView

- (void)  collectionView: (UICollectionView *) collectionView
didSelectItemAtIndexPath: (NSIndexPath *) indexPath {
    
    NSLog(@"AA didSelectItemAtIndexPath: %ld",(long)indexPath.row);
    
    BSMaterialViewController *matVC = [[BSMaterialViewController alloc] initWithNibName: nil
                                                                                 bundle: nil];
    matVC.bgColor = [BSUtils colorForIndex: indexPath.row];
    
    if (indexPath.row < [mgAdapter.materialGroups count])
        matVC.matGroup = [mgAdapter.materialGroups objectAtIndex: indexPath.row];
    
    [self.navigationController pushViewController: matVC
                                         animated: YES];
}

- (CGSize) collectionView: (UICollectionView *) collectionView
                   layout: (UICollectionViewLayout *) collectionViewLayout
   sizeForItemAtIndexPath: (NSIndexPath *) indexPath {
    return CGSizeMake(280.0f, 80.0f);
}

#pragma mark - Category Data Load Handler

- (void)handleGRPDataLoad
{
    NSLog(@"handleGRPDataLoad called");
    if (!loadCompletedObserver) {
        loadCompletedObserver = [[NSNotificationCenter defaultCenter] addObserverForName:@"blahblah" object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *notification) {
            
            [self updateCache];
            
            if (!mgAdapter) {
                mgAdapter = [BSMaterialGroupAdapter new];
            }
            
            mgAdapter.materialGroups = [notification.userInfo objectForKey:@"displayrows"];
            self.gridView.dataSource = mgAdapter;
            
            [self.gridView reloadData];
            [self.loadingView setHidden:YES];
            
        }];
    }
}


#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    switch (buttonIndex) {
        case 0:
            self.loadingLabel.text = @"C Unable to connect to SMP Server...";
            [self.retryBtn setHidden:NO];
            //Exit the app because we can't continue from here without a bvackend SMP server
            //exit(0);
            break;
        default:
            break;
    }
}


-(void)btnSalesOrdersClicked:(id)sender
{
    if(!gridVC){
        gridVC = [[BSSalesOrderViewController alloc] initWithNibName: nil bundle: nil];
    }
    
    [gridVC reload];
    
    [self.navigationController pushViewController: gridVC
                                         animated: YES];
}

-(IBAction)btnRetryClicked:(id)sender
{
    [self.retryBtn setHidden:YES];
    [self.loadingLabel setText:@"Working Please Wait..."];
    
    [self performSelector:@selector(registerConnection) withObject:self afterDelay:0.1 ];
    //self perform
    //[self registerConnection];
}

#pragma mark - Cache

-(void)updateCache {
    [self.gridView reloadData];
}



#pragma mark - Memory Warning

- (void) didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
