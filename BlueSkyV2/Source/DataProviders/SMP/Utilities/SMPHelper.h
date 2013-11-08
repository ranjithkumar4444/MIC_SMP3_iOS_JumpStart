/*
 
 File: SMPHelper.h
 Abstract: Helper class for SMP Server connectivity SMPport.
 
 */

#import <Foundation/Foundation.h>
#import "CredentialsData.h"

/**
 Helper class for SMP Server connectivity SMPport.
 */
@interface SMPHelper : NSObject

#pragma  mark - Methods for SMP Server connectivity

/**
 Set the SMP server connection profile for the application.
 This process should be performed once in the application first run.
 You must call this method to initialize the ClientConnection before using an other method of this class.
 @param aSMPHost a SMP Server host as configured by the Administrator of Sybase Control Center.
 @param aSMPPort a SMP Server port as configured by the Administrator of Sybase Control Center.
 @param aDomain a SMP server domain.
 @param aAppId an Application Id as configured by the Administrator of Sybase Control Center.
 @param aSecurityConfigName as configured by the Administrator of Sybase Control Center.
 @return BOOL indicating if the operation is successful or not.
 */
+ (BOOL)setSMPConnectionProfileWithHost:(NSString *)aSMPHost andSMPPort:(NSInteger)aSMPPort andDomain:(NSString *)aDomain andAppId:(NSString *)aAppId andSecurityConfigName:(NSString *)aSecurityConfigName;


/**
 Registers a new user for your application.
 Refer to SMPUserManager class documentation.
 @param aCredentials a credentials object containing username and password.
 @param error a pointer to an NSError object.
 @return BOOL indicating if the operation is successful or not.
 */
+ (BOOL)registerSMPUserWithCredentials:(CredentialsData *)aCredential error:(NSError * __autoreleasing *)error;

/**
 Unregisters the registered user for your application.
 @param aCredentials a credentials object containing username and password.
 @param error a pointer to an NSError object.
 @return BOOL indicating if the operation is successful or not.
 */
+ (BOOL)unregisterSMPUserWithCredentials:(CredentialsData *)aCredential error:(NSError * __autoreleasing *)error;

/**
 Checks if there is a registered user for your application.
 @return YES if there is a registered user or NO otherwise.
 */
+ (BOOL)isSMPUserRegistered;


/**
 Get the application end point URL from SMP server.
 Refer to SMPAppSettings class documentation.
 @param aCredentials a credentials object containing username and password.
 @param error a pointer to an NSError object.
 @return The end point URL as NSString object.
 */
+ (NSString *)getSMPApplicationEndPointWithCredentials:(CredentialsData *)aCredential error:(NSError * __autoreleasing *)error;


#pragma  mark - Methods for Push notifications

/**
 Sends the device token received to the SMP server.
 The device token must be sent to the SMP server for it to send notification through APNS. This is to be put in the applicationDidRegisterForRemoteNotifications delegate.
 @param aCredentials a credentials object containing username and password.
 @param aDeviceToken The device token that is received from the delegate.
 @param aApplication Instance of the application class.
 @param error a pointer to an NSError object.
 */
+ (void)sendDeviceTokenForPushWithCredentials:(CredentialsData *)aCredentials andDeviceToken:(NSData *)aDeviceToken andApplication:(UIApplication *)aApplication error:(NSError * __autoreleasing *)error;

/**
 Get the application push end point URL from SMP server.
 Refer to SMPAppSettings class documentation.
 @param aCredentials a credentials object containing username and password.
 @param error a pointer to an NSError object.
 @return The push end point URL as NSString object.
 */
+ (NSString *)getSMPApplicationPushEndPointWithCredentials:(CredentialsData *)aCredentials error:(NSError * __autoreleasing *)error;

@end
