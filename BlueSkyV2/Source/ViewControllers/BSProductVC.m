//
//  BSProductVC.m
//  BlueSky
//
//  Created by Ivan Reyes on 10/3/13.
//  Copyright (c) 2013 SAP MIC. All rights reserved.
//

#import "BSProductVC.h"
#import "BSCategoryCell.h"
#import "BSProductCell.h"
#import "BSCategory.h"
#import "ProductDataController.h"
#import "BSMapVC.h"
#import "BSLocationListVC.h"
#import "Constants.h"
#import "ODataPropertyValues.h"
#import "BSProduct.h"
#import "BSUtils.h"
#import "ODataEntry.h"
#import "SMPHelper.h"
#import "BSAppDelegate.h"

#import "Constants.h"
#import "SMPHelper.h"
#import "ConnectivitySettings.h"
#import "CredentialsData.h"
#import "KeychainHelper.h"
#import "SettingsUtilities.h"
#import "Reachability.h"

@interface BSProductVC ()

@end

@implementation BSProductVC {
    CALayer                 *bgTintLayer;
    BSMapVC *mapVC;
    BSLocationListVC *llVC;
    BOOL showMap;
    int selectedIndex;
}

//@synthesize statusIcon;
@synthesize statusText;
@synthesize loadingView;
@synthesize selectedCategory;
@synthesize clearCacheButton;

#pragma mark - Initialization

- (id) initWithNibName: (NSString *) nibNameOrNil
                bundle: (NSBundle *) nibBundleOrNil {
    self = [super initWithNibName: nibNameOrNil
                           bundle: nibBundleOrNil];
    if (self) {
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(toggleMap)
                                                     name:@"toggleMap" object:nil];
    }
    return self;
}


-(void)setProductList:(NSMutableArray *)newList {
    if(_productList != newList) {
        _productList = [newList mutableCopy];
    }
}



- (void)handleProductCollectionLoad {
    if (!loadCompletedObserver) {
        //NSLog(@"handleProductCollectionLoad - loadCompletedObserver - wut?");
    [self.loadingView setHidden:NO];
        loadCompletedObserver = [[NSNotificationCenter defaultCenter] addObserverForName:kLoadProductCompletedNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *notification) {
            //NSLog(@"handleProductCollectionLoad - loadCompletedObserver: Products ");

            
             [self.loadingView setHidden:YES];
            if ([self.productDataController.serverEntriesCopyList count] > 0)
                self.productList = self.productDataController.displayRowsArray;
            else
                self.productList = self.productDataController.productList;
            
            //NSLog(@"handleProductCollectionLoad - self.productList: %@",self.productList);
            //NSLog(@"handleProductCollectionLoad - self.productDataController.displayRowsArray: %@",self.productDataController.displayRowsArray);
            
            
            
            [self.gridView reloadData];
            
            
        }];
        
    }
}



#pragma mark - View

- (void) viewDidLoad {
    [super viewDidLoad];
    /* Set the username and password here In the next version we will use a login screen for this */
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *Ausername = [defaults stringForKey:@"username"];
    NSString *Apassword = [defaults stringForKey:@"password"];
    self.username = Ausername;
    self.password = Apassword;

    [clearCacheButton addTarget:self action:@selector(clearCacheAction:) forControlEvents:UIControlEventTouchUpInside];
}


-(void)viewWillDisappear:(BOOL)animated {

}

- (void) viewWillAppear: (BOOL) animated {
    //NSLog(@"BSProductVC:");
    [super viewWillAppear: animated];

    self.subtitleLabel.text = self.matGroup.name;

//    CGFloat red = 1.0f, blue = 1.0f, green = 1.0f, alpha = 1.0f;
//    [self.bgColor getRed: &red
//                   green: &green
//                    blue: &blue
//                   alpha: &alpha];
    /*bgTintLayer.backgroundColor = [[UIColor colorWithRed: red
                                                   green: green
                                                    blue: blue
                                                   alpha: 0.7f] CGColor];
*/
    [self.gridView registerNib: [BSProductCell nibFile] forCellWithReuseIdentifier: BS_PRODUCT_CELL_ID];
    
    self.productDataController = [ProductDataController uniqueInstance];
    //[self.productDataController loadProductWithID:self.selectedCategory andDidFinishSelector:@selector(loadProductCompleted:)];

//    if([statusText isEqualToString:@"nointernetz"]) {
//        NSLog(@"no Iternetsz");
//        
//    }
//    else {
//        NSLog(@"gonna register Connection");
//        [self performSelector:@selector(registerConnection) withObject:self afterDelay:0.1 ];
//    }
    
    
    if ([self.productDataController.serverEntriesCopyList count] > 0)
        self.productList = self.productDataController.displayRowsArray;
    else
        self.productList = self.productDataController.productList;
    
     [self handleProductCollectionLoad];

    
    if ([self.productList count] > 0)  {
        NSLog(@"from cache");
        [self.productDataController clearTheCache];
        [self.productDataController loadProductWithID:self.selectedCategory andDidFinishSelector:@selector(loadProductCompleted:)];
        [self.gridView reloadData];
    } else {
        NSLog(@"no from cache");
        /* request Data from productDataController */
        [self.productDataController loadProductWithID:self.selectedCategory andDidFinishSelector:@selector(loadProductCompleted:)];
        [self.gridView reloadData];
    }
    
    
    
    bgTintLayer = [CALayer new];
    bgTintLayer.frame = [self getScreenFrameForCurrentOrientation];
    
    self.bgView.frame = bgTintLayer.frame;
    [self.bgView.layer addSublayer: bgTintLayer];
    [self.loadingView setHidden:NO];
    
    
}

-(void)viewWillLayoutSubviews {
    bgTintLayer.frame = [self getScreenFrameForCurrentOrientation];
    self.bgView.frame = bgTintLayer.frame;
}


#pragma mark - button Action

-(void)clearCacheAction:(id)sender {
    NSLog(@"clear it");
    [self.productDataController clearTheCache];
}


#pragma mark - CollectionView

- (void)  collectionView: (UICollectionView *) collectionView
didSelectItemAtIndexPath: (NSIndexPath *) indexPath {
    
    [self.loadingView setHidden:NO];
    
    
    NSLog(@"BB didSelectItemAtIndexPath: %ld",(long)indexPath.row);
    
    BOOL offline = NO;
    
    if(!offline){
        if(!mapVC){
            mapVC = [[BSMapVC alloc] initWithNibName: nil bundle: nil];
        }else{
            [mapVC reload];
        }
        if (indexPath.row < [self.productList count]) {
            
            selectedIndex = indexPath.row;
            //NSString *matGroupID = [[self.matGroupEntry getPropertyValueByPath:kGRPID] getValue];
            
            
            
            
            //SEND PRODUCT TO MAP
            
            mapVC.product = [self.productList objectAtIndex: indexPath.row];
            
            mapVC.productEntry = [self.productList objectAtIndex:indexPath.row];
            
            
            
            NSLog(@"selectedIndex + material %d - %@",selectedIndex, mapVC.product);
        }
        NSLog(@"pushViewController mapVC");
        [self.navigationController pushViewController: mapVC
                                             animated: YES];
    }else{
        
        if(!llVC){
            NSLog(@"No llVC");
            llVC = [[BSLocationListVC alloc] initWithNibName: nil bundle: nil];
        }else{
            
            NSLog(@"llVC");
            [llVC reload];
        }
        if (indexPath.row < [self.productList count]) {
            selectedIndex = indexPath.row;
            llVC.product = [self.productList objectAtIndex: indexPath.row];
        }
        NSLog(@"pushViewController llVC");
        [self.navigationController pushViewController: llVC
                                             animated: YES];
    }
}

- (CGSize) collectionView: (UICollectionView *) collectionView layout: (UICollectionViewLayout *) collectionViewLayout sizeForItemAtIndexPath: (NSIndexPath *) indexPath {
    return CGSizeMake(280.0f, 80.0f);
}

- (NSInteger) collectionView: (UICollectionView *) collectionView
      numberOfItemsInSection: (NSInteger) section {
    return [self.productList count];
}

- (UICollectionViewCell *) collectionView: (UICollectionView *) collectionView
                   cellForItemAtIndexPath: (NSIndexPath *) indexPath {
    BSProductCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier: BS_PRODUCT_CELL_ID
                                                                    forIndexPath: indexPath];

    if (indexPath.row < [self.productList count]) {

        BSProduct *product;
        NSString * ID = [[[self.productList objectAtIndex:indexPath.row] getPropertyValueByPath:kMARAID] getValue];
        NSString * productName = [[[self.productList objectAtIndex:indexPath.row] getPropertyValueByPath:kMARAname] getValue];
        NSString * groupID = [[[self.productList objectAtIndex:indexPath.row] getPropertyValueByPath:kMARAgroupID] getValue];
        product = [BSProduct new];
        product.groupID = groupID;
        product.materialID = ID;
        product.productName = productName;

        cell.matNameLabel.text = product.productName;
        cell.matSubtitleLabel.text = product.materialID;
        cell.imgView.image = [BSUtils imageForMaterial: product.materialID];
        //cell.backgroundColor = [BSUtils colorForIndex:indexPath.row];
        
         cell.backgroundColor = self.color;
        
        [BSUtils addCellShadow:cell];
    }
    
    return cell;
}








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



#pragma mark - Application Connection


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


#pragma mark - Memory Warning

- (void) didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - toggleMap

-(void)toggleMap
{
    NSLog(@"toggleMap");
    NSLog(@"toggleMap - self.productList: %@",self.productList);
    
 
 
    
    [self.navigationController popViewControllerAnimated:NO];
    if(showMap){
        if(!mapVC){
            mapVC = [[BSMapVC alloc] initWithNibName: nil bundle: nil];
        }else{
            [mapVC reload];
        }

        if (selectedIndex < [self.productList count]) {
            mapVC.product = [self.productList objectAtIndex: selectedIndex];
            mapVC.productEntry = [self.productList objectAtIndex: selectedIndex];
            NSLog(@"mapVC.product: %@",mapVC.product);
        }
        
        
        
        [self.navigationController pushViewController: mapVC
                                             animated: YES];
    }else{
        
        if(!llVC){
            llVC = [[BSLocationListVC alloc] initWithNibName: nil bundle: nil];
        }else{
            [llVC reload];
        }
        if (selectedIndex < [self.productList count]) {
            llVC.product = [self.productList objectAtIndex: selectedIndex];
            llVC.productEntry = [self.productList objectAtIndex: selectedIndex];
            
            NSLog(@"llVC.product: %@",llVC.product);
        }
        [self.navigationController pushViewController: llVC
                                             animated: YES];
    }

    showMap = !showMap;
}
@end
