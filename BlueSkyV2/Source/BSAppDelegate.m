//
//  BSAppDelegate.m
//  BlueSky
//
//  Created by Ivan Reyes on 10/3/13.
//  Copyright (c) 2013 SAP MIC. All rights reserved.
//

#import "BSAppDelegate.h"
#import "BSCategoryVC.h"
#import "BSSalesOrderListVC.h"
#import "SMPHelper.h"
#import "ConnectivitySettings.h"
#import "CredentialsData.h"
#import "KeychainHelper.h"
#import "SettingsUtilities.h"
#import "Constants.h"
#import "EncryptionKeyManager.h"


@implementation BSAppDelegate

@synthesize reach;


- (BOOL)          application: (UIApplication *) application
didFinishLaunchingWithOptions: (NSDictionary *) launchOptions {
    self.window = [[UIWindow alloc] initWithFrame: [[UIScreen mainScreen] bounds]];

    BSCategoryVC *gridVC = [[BSCategoryVC alloc] initWithNibName: nil bundle: nil];
    

    self.navigationController = [[UINavigationController alloc] initWithRootViewController: gridVC];
    self.navigationController.navigationBarHidden = YES;

    self.window.rootViewController = self.navigationController;
    
    //SMP3 Load app settings
    [SettingsUtilities updateConnectivitySettingsFromUserSettings];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    
    NSString *Ausername = [defaults stringForKey:@"username"];
    NSString *Apassword = [defaults stringForKey:@"password"];
    
    if(!Ausername) {
        [self registerDefaultsFromSettingsBundle];
        Ausername = [defaults stringForKey:@"username"];
        Apassword = [defaults stringForKey:@"password"];
    }

    NSString *encryptionKey = [defaults stringForKey:kEncryptionKey ];
    NSError *error;
    
    if(!encryptionKey) {
        NSString *key = [EncryptionKeyManager getEncryptionKey:&error];
        [defaults setValue:key forKeyPath:kEncryptionKey];
    }
    else {
        [EncryptionKeyManager setEncryptionKey:encryptionKey withError:&error];
    }
    
    
    //Initialize Reachability
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:) name:kReachabilityChangedNotification object:nil];
    
    self.reach = [Reachability reachabilityForInternetConnection]; //retain reach
    [reach startNotifier];
    
    NetworkStatus remoteHostStatus = [reach currentReachabilityStatus];

    if(remoteHostStatus == NotReachable) {NSLog(@"BSAppDelegate: init **** Not Reachable ****");}
    else if (remoteHostStatus == ReachableViaWiFi) {NSLog(@"BSAppDelegate: int **** wifi ****"); }
    else if (remoteHostStatus == ReachableViaWWAN) {NSLog(@"BSAppDelegate: init **** cell ****"); }
    
//    Reachability *reachability =[Reachability reachabilityForInternetConnection];
//    [reachability startNotifier];


    [self.window makeKeyAndVisible];
    return YES;
}




- (void)registerDefaultsFromSettingsBundle {
    NSString *settingsBundle = [[NSBundle mainBundle] pathForResource:@"Settings" ofType:@"bundle"];
    if(!settingsBundle) {
        NSLog(@"Could not find Settings.bundle");
        return;
    }
    NSDictionary *settings = [NSDictionary dictionaryWithContentsOfFile:[settingsBundle stringByAppendingPathComponent:@"Root.plist"]];
    NSArray *preferences = [settings objectForKey:@"PreferenceSpecifiers"];
    
    NSMutableDictionary *defaultsToRegister = [[NSMutableDictionary alloc] initWithCapacity:[preferences count]];
    for(NSDictionary *prefSpecification in preferences) {
        NSString *key = [prefSpecification objectForKey:@"Key"];
        if(key && [[prefSpecification allKeys] containsObject:@"DefaultValue"]) {
            [defaultsToRegister setObject:[prefSpecification objectForKey:@"DefaultValue"] forKey:key];
        }
    }
    [[NSUserDefaults standardUserDefaults] registerDefaults:defaultsToRegister];
}



-(void)reachabilityChanged:(NSNotification*)notice {
    NetworkStatus remoteHostStatus = [reach currentReachabilityStatus];
    if(remoteHostStatus == NotReachable) {

    [[NSNotificationCenter defaultCenter] postNotificationName:@"testA"
                                                                object:@"Not Reachable"];
    }
    else if (remoteHostStatus == ReachableViaWiFi) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"testA"
                                                            object:@"Reachable View Wi-Fi"];
    }
    else if (remoteHostStatus == ReachableViaWWAN) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"testA"
                                                            object:@"Reachable View WWAN"];
    }
}



- (void) applicationWillResignActive: (UIApplication *) application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void) applicationDidEnterBackground: (UIApplication *) application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void) applicationWillEnterForeground: (UIApplication *) application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void) applicationDidBecomeActive: (UIApplication *) application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void) applicationWillTerminate: (UIApplication *) application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
