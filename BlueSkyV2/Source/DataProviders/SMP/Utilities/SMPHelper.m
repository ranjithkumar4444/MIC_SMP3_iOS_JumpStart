/*
 
 File: SMPHelper.m
 Abstract: Helper class for SMP Server connectivity SMPport.
 
 */

#import "SMPHelper.h"
#import "KeychainHelper.h"

/**
 * TODO: Uncomment the following lines for SMP Server connectivity SMPport.
 * Make sure to uncomment the additional required methods implementation under "Methods for SMP Server connectivity" pragma mark.
 * In addition, make sure to reference in the project the ODP client libraries and headers required for SMP connectivity.
 */

#import "SMPClientConnection.h"
#import "SMPUserManager.h"
#import "SMPAppSettings.h"
#import "EncryptionKeyManager.h"
#import "Constants.h"
#import "ConnectivitySettings.h" //Added for HTTPS SMPport

@implementation SMPHelper

#pragma  mark - Methods for SMP Server connectivity

/**
 * TODO: Uncomment the following methods implementation for SMP Server connectivity SMPport
 */

static SMPClientConnection *clientConnection;

+ (BOOL)setSMPConnectionProfileWithHost:(NSString *)aSMPHost andSMPPort:(NSInteger)aSMPPort andDomain:(NSString *)aDomain andAppId:(NSString *)aAppId andSecurityConfigName:(NSString *)aSecurityConfigName
{
    BOOL result = NO;
    
    
    // ADDED /micsmp3prod string for RELAY
    
    
    NSString *farmString = @"/micsmp3prod";
    
    
    
    clientConnection = [SMPClientConnection initializeWithAppID:aAppId domain:aDomain secConfiguration:aSecurityConfigName];
    //If the user has already registered before using this application, get the application connection ID from the user defaults.
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    

    
    
    
    
    NSString *appConnectionId = [defaults stringForKey:kApplicationConnectionId];
    if ([appConnectionId length] > 0) {
        clientConnection.applicationConnectionID = appConnectionId;
    }
    
    NSString *port = [NSString stringWithFormat:@"%d",aSMPPort];
    
    NSLog(@"Use SSL set to : %@",[ConnectivitySettings useSSL] ? @"Yes" : @"No");
    //Modified for HTTPS
    if ([ConnectivitySettings useSSL]) {
        NSString *url = [NSString stringWithFormat:@"https://%@:%@", aSMPHost, port];
        result = [clientConnection setConnectionProfileWithUrl:url];
        NSLog(@"URL:%@",url);
    } else {
        
        // ADDED /micsmp3prod string farmString for Relay
        
        result = [clientConnection setConnectionProfileWithHost:aSMPHost port:port farm:farmString relayServerUrlTemplate:nil enableHTTP:YES];
        
        NSString *url = [NSString stringWithFormat:@"https://%@:%@", aSMPHost, port];
        NSLog(@"XXXX URL:%@",url);
    }
    
    return result;
}


+ (BOOL)registerSMPUserWithCredentials:(CredentialsData *)aCredential error:(NSError * __autoreleasing *)error
{
    BOOL result = NO;
    
    SMPUserManager *userManager = [SMPUserManager initializeWithConnection:clientConnection];
    result = [userManager registerUser:aCredential.username password:aCredential.password error:error isSyncFlag:YES];
    
    if (result && [clientConnection.applicationConnectionID length] > 0) {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setValue:clientConnection.applicationConnectionID forKeyPath:kApplicationConnectionId];
    }
    
    return result;
}

+ (BOOL)unregisterSMPUserWithCredentials:(CredentialsData *)aCredential error:(NSError * __autoreleasing *)error
{
    BOOL result = NO;
    
    SMPUserManager *userManager = [SMPUserManager initializeWithConnection:clientConnection];
    result = [userManager deleteUser:aCredential.username password:aCredential.password error:error];
    
    if (result) {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setValue:nil forKeyPath:kApplicationConnectionId];
    }
    
    return result;
}

+ (BOOL)isSMPUserRegistered
{
    BOOL result = NO;
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *appConnectionId = [defaults stringForKey:kApplicationConnectionId];
    if ([appConnectionId length] > 0) {
        NSLog(@"SMPHelper: Current App Connection ID: %@", appConnectionId);
        result = YES;
    }

    return result;
}


+ (NSString *)getSMPApplicationEndPointWithCredentials:(CredentialsData *)aCredential error:(NSError * __autoreleasing *)error
{
    NSString *result = nil;
    
    SMPAppSettings *appSettings = [SMPAppSettings initializeWithConnection:clientConnection userName:aCredential.username password:aCredential.password];
    result = [appSettings getApplicationEndpointWithError:error];
    
    return result;
}


+ (void)sendDeviceTokenForPushWithCredentials:(CredentialsData *)aCredentials andDeviceToken:(NSData *)aDeviceToken andApplication:(UIApplication *)aApplication error:(NSError * __autoreleasing *)error
{
    SMPAppSettings *appSettings = [SMPAppSettings initializeWithConnection:clientConnection userName:aCredentials.username password:aCredentials.password];
    
    //parse token into NSString
    NSString *token = [[[[aDeviceToken description]
                         stringByReplacingOccurrencesOfString: @"<" withString: @""]
                        stringByReplacingOccurrencesOfString: @">" withString: @""]
                       stringByReplacingOccurrencesOfString: @" " withString: @""];
    
    NSDictionary *props = @{@"d:ApnsDeviceToken": token};
    [appSettings setConfigProperty:props error:error];
}


+ (NSString *)getSMPApplicationPushEndPointWithCredentials:(CredentialsData *)aCredentials error:(NSError * __autoreleasing *)error
{
    NSString *result = nil;
    
    SMPAppSettings *appSettings = [SMPAppSettings initializeWithConnection:clientConnection userName:aCredentials.username password:aCredentials.password];
    result = [appSettings getPushEndpointWithError:error];
    
    return result;
}


@end
