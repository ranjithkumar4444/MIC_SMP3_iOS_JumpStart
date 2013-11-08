//
//  BSCategoryVC.m
//  BlueSky
//
//  Created by Ivan Reyes on 10/3/13.
//  Copyright (c) 2013 SAP MIC. All rights reserved.
//

#import "BSCategoryVC.h"
#import "BSCategoryCell.h"
#import "BSProductVC.h"
#import "BSSalesOrderListVC.h"
#import "BSUtils.h"
#import "SMPHelper.h"
#import "ConnectivitySettings.h"
#import "CredentialsData.h"
#import "KeychainHelper.h"
#import "SettingsUtilities.h"
#import "Reachability.h"
#import "BSAppDelegate.h"
#import "ODataEntry.h"
#import "Constants.h"
#import "BSCategory.h"
#import "ODataPropertyValues.h"


@implementation BSCategoryVC
{
    BSSalesOrderListVC *gridVC;
}

@synthesize statusIcon;
@synthesize statusText;
@synthesize loadingView;


#pragma mark - Initialization

- (id) initWithNibName: (NSString *) nibNameOrNil
                bundle: (NSBundle *) nibBundleOrNil {
    self = [super initWithNibName: nibNameOrNil
                           bundle: nibBundleOrNil];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateNetStatusLabel:) name:@"testA" object:nil];


    }
    return self;
}

-(void)setCategoryList:(NSMutableArray *)newList {
    if(_categoryList != newList) {
        _categoryList = [newList mutableCopy];
    }
}


#pragma mark - View

- (void) viewDidLoad {
    [super viewDidLoad];
    [self.gridView registerNib: [BSCategoryCell nibFile] forCellWithReuseIdentifier: BS_MATGROUP_CELL_ID];
    /* Set the username and password here In the next version we will use a login screen for this */
    
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSString *Ausername = [defaults stringForKey:@"username"];
    NSString *Apassword = [defaults stringForKey:@"password"];
    
    NSLog(@"check UserDefault: %@  %@",Ausername,Apassword);
    
    self.username = Ausername;
    self.password = Apassword;

    [self registerConnection];

}


- (void) viewWillAppear: (BOOL) animated {
    NSLog(@"BSCategoryVC");
    [self.loadingView setHidden:YES];
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

    NSLog(@"Initialized the data controller, so now the listener for mergecomplete is registered\n");
    [self handleCategoryCollectionLoad];
}

#pragma mark - handle Data Load
- (void)handleCategoryCollectionLoad
{
    if (!loadCompletedObserver) {
        loadCompletedObserver = [[NSNotificationCenter defaultCenter] addObserverForName:kLoadCategoryCollectionCompletedNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *notification) {
            NSLog(@"loadCompletedObserver Category ");
            // [self.loadingView setHidden:YES];
            if ([self.categoryDataController.serverEntriesCopyList count] > 0)
                self.categoryList = self.categoryDataController.displayRowsArray;
            else
                self.categoryList = self.categoryDataController.categoryList;
            
            
            [self.gridView reloadData];
            
            
        }];
        
    }
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
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error connecting to server!"
                                                        message:@"Please make sure you are connected to the SAP Corporate Network"
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        
    }else{

        
        
    self.categoryDataController = [CategoryDataController uniqueInstance];
       // [self performSelector:@selector(registerConnection) withObject:self afterDelay:0.1 ];
       // NSLog(@"aaa");

    if([statusText isEqualToString:@"nointernetz"]) {
        NSLog(@"no Internet");
    }
    else {
        NSLog(@"yes Internet");
        // [self performSelector:@selector(registerConnection) withObject:self afterDelay:0.1 ];
    }

    if ([self.categoryDataController.serverEntriesCopyList count] > 0)
            self.categoryList = self.categoryDataController.displayRowsArray;
        else
            self.categoryList = self.categoryDataController.categoryList;


    if ([self.categoryList count] > 0)  {
        NSLog(@"from cache");
        [self.gridView reloadData];
        } else {
    NSLog(@"no from cache");
    [self.categoryDataController loadCategoryCollectionWithDidFinishSelector:@selector(loadCategoryCollectionCompleted:) forUrl:nil];
        }
        
        
        
        

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

#pragma mark - CollectionView

- (void) collectionView: (UICollectionView *) collectionView didSelectItemAtIndexPath: (NSIndexPath *) indexPath {
    
    [self.loadingView setHidden:NO];
    BSCategoryCell *selectedCell= (id)[collectionView cellForItemAtIndexPath:indexPath];
    
    
    NSLog(@"selectedCell material: %@", selectedCell.categoryID);
   
    
    //NSString categoryString = selectedCell.

 
    BSProductVC *matVC = [[BSProductVC alloc] initWithNibName: nil bundle: nil];
    
    matVC.selectedCategory = selectedCell.categoryID;
    
    
    matVC.bgColor = [BSUtils colorForIndex: indexPath.row];
    
    matVC.color = selectedCell.backgroundColor;
    
    if (indexPath.row < [self.categoryList count])
        matVC.matGroupEntry = [self.categoryList objectAtIndex: indexPath.row];
    NSLog(@"********** push matVC: %@", matVC.matGroupEntry.fields );
    [self.navigationController pushViewController: matVC animated: YES];
}

- (CGSize) collectionView: (UICollectionView *) collectionView layout: (UICollectionViewLayout *) collectionViewLayout sizeForItemAtIndexPath: (NSIndexPath *) indexPath {
    return CGSizeMake(280.0f, 80.0f);
}


- (NSInteger) collectionView: (UICollectionView *) collectionView
      numberOfItemsInSection: (NSInteger) section {
    return [self.categoryList count];
}

- (UICollectionViewCell *) collectionView: (UICollectionView *) collectionView
                   cellForItemAtIndexPath: (NSIndexPath *) indexPath {
    
    BSCategoryCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier: BS_MATGROUP_CELL_ID
                                                                     forIndexPath: indexPath];
    if (indexPath.row < [self.categoryList count]) {
        BSCategory *category;
        
        NSString * ID = [[[self.categoryList objectAtIndex:indexPath.row] getPropertyValueByPath:kGRPID] getValue];
        NSString * name = [[[self.categoryList objectAtIndex:indexPath.row] getPropertyValueByPath:kGRPname] getValue];
        
        category = [BSCategory new];
        category.groupID = ID;
        category.name = name;
        
        cell.groupNameLabel.text = category.name;
        cell.categoryID = category.groupID;
        cell.iconView.image = [category iconImage];
        cell.backgroundColor = [BSUtils colorForIndex: indexPath.row];
        
        [BSUtils addCellShadow:cell];
    }
    
    return cell;
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

#pragma mark - Button Actions

-(void)btnSalesOrdersClicked:(id)sender
{
    if(!gridVC){
        gridVC = [[BSSalesOrderListVC alloc] initWithNibName: nil bundle: nil];
    }
    
    [gridVC reload];
    
    [self.navigationController pushViewController: gridVC
                                         animated: YES];
}

-(IBAction)btnRetryClicked:(id)sender
{
   // [self.retryBtn setHidden:YES];
    [self.loadingLabel setText:@"Working Please Wait..."];
    [self performSelector:@selector(registerConnection) withObject:self afterDelay:0.1 ];
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
