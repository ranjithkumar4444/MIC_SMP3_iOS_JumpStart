/*
 
 File: KeychainHelper.m
 Abstract: Helper class for using Keychain services.
 
 */

#import "KeychainHelper.h"
#import <Security/Security.h>


@implementation KeychainHelper

static NSString * const kCredentialsIdentifier = @"GSUserCredentials";
static NSString * const kClientCertificateIdentifier = @"GSClientCertificate";

static NSString *_accessGroup = nil;


+ (void)setAccessGroup:(NSString *)accessGroup
{
    _accessGroup = accessGroup;
}

+ (NSString *)accessGroup
{
    return _accessGroup;
}


#pragma mark - Username & Password

+ (NSMutableDictionary *)createPasswordAttributesItem
{
    NSMutableDictionary *attributesDictionary = [[NSMutableDictionary alloc] init];
    
    attributesDictionary[(__bridge id)kSecClass] = (__bridge id)kSecClassGenericPassword;
    attributesDictionary[(__bridge id)kSecAttrGeneric] = kCredentialsIdentifier;
    
    if ([KeychainHelper accessGroup] != nil)
    {
#if TARGET_IPHONE_SIMULATOR
        // Ignore the access group if running on the iPhone simulator to avoide error, since apps that are built for the simulator aren't signed and there's no keychain access group for the simulator to check (all apps can see all keychain items when run on the simulator).
#else
        attributesDictionary[(__bridge id)kSecAttrAccessGroup] = [KeychainHelper accessGroup];
#endif
    }
    
    return attributesDictionary;
}

+ (NSMutableDictionary *)createPasswordAttributesReadQuery
{
    NSMutableDictionary *passwordQuery = [KeychainHelper createPasswordAttributesItem];
    
    // Use the proper search constants, return only the attributes of the first match
    passwordQuery[(__bridge id)kSecMatchLimit] = (__bridge id)kSecMatchLimitOne;
    passwordQuery[(__bridge id)kSecReturnAttributes] = (__bridge id)kCFBooleanTrue;
    return passwordQuery;
}

+ (CredentialsData *)loadCredentialsAndReturnError:(NSError * __autoreleasing *)error
{
    CredentialsData *credentials = nil;
    
    // Find the attributes for the password item
    NSMutableDictionary *passwordQuery = [KeychainHelper createPasswordAttributesReadQuery];
    CFTypeRef attributesResult = NULL;
    OSStatus status = SecItemCopyMatching((__bridge CFDictionaryRef)passwordQuery, &attributesResult);
    if (status == errSecSuccess)
    {
        NSMutableDictionary *resultDictionary = [(__bridge NSDictionary *)attributesResult mutableCopy];
        
        // Acquire the password data from the attributes
        
        resultDictionary[(__bridge id)kSecReturnData] = (__bridge id)kCFBooleanTrue;
        resultDictionary[(__bridge id)kSecClass] = (__bridge id)kSecClassGenericPassword;
        
        CFTypeRef passwordResult = NULL;
        status = SecItemCopyMatching((__bridge CFDictionaryRef)resultDictionary, &passwordResult);
        if (status == errSecSuccess) {
            NSData *passwordData = (__bridge NSData *)passwordResult;
            NSString *password = [[NSString alloc] initWithBytes:[passwordData bytes] length:[passwordData length] encoding:NSUTF8StringEncoding];
            NSString *username = resultDictionary[(__bridge id)kSecAttrAccount];
            credentials =  [[CredentialsData alloc] initWithUsername:username andPassword:password];
        }
        else {
            if (error) {
                NSString *errorMessage = NSLocalizedString(@"Credentials item could not be found in Keychain.", @"Credentials item could not be found in Keychain.");
                *error = [NSError errorWithDomain:kErrorDomain code:status userInfo:@{NSLocalizedDescriptionKey: errorMessage}];
            }
        }
        if (passwordResult) CFRelease(passwordResult);
    }
    else {
        if (error) {
            NSString *errorMessage = NSLocalizedString(@"Credentials item attributes could not be found in Keychain.", @"Credentials item attributes could not be found in Keychain.");
            *error = [NSError errorWithDomain:kErrorDomain code:status userInfo:@{NSLocalizedDescriptionKey: errorMessage}];
        }
    }
    
    if (attributesResult) CFRelease(attributesResult);
    return credentials;
}

+ (BOOL)isCredentialsSaved;
{
    BOOL hasCredentials = NO;
    
    // Find the attributes for the password item
    NSMutableDictionary *passwordQuery = [KeychainHelper createPasswordAttributesReadQuery];
    CFTypeRef attributesResult = NULL;
    OSStatus status = SecItemCopyMatching((__bridge CFDictionaryRef)passwordQuery, &attributesResult);
    if (status == errSecSuccess) {
        hasCredentials = YES;
    }
    
    if (attributesResult) CFRelease(attributesResult);
    return hasCredentials;
}

+ (BOOL)saveCredentials:(CredentialsData *)credentials error:(NSError * __autoreleasing *)error
{
    // Find the attributes for the password item
    NSMutableDictionary *passwordQuery = [KeychainHelper createPasswordAttributesReadQuery];
    CFTypeRef attributesResult = NULL;
    OSStatus status = SecItemCopyMatching((__bridge CFDictionaryRef)passwordQuery, &attributesResult);
    if (status == errSecSuccess) {
        // Update existing credentials
        NSMutableDictionary *attributesDictionary = [(__bridge NSDictionary *)attributesResult mutableCopy];
        attributesDictionary[(__bridge id)kSecClass] = (__bridge id)kSecClassGenericPassword;
        
        NSMutableDictionary *updateDictionary = [[NSMutableDictionary alloc] init];
        
        NSData *passwordData = [credentials.password dataUsingEncoding:NSUTF8StringEncoding];
        updateDictionary[(__bridge id)kSecValueData] = passwordData;
        
        updateDictionary[(__bridge id)kSecAttrAccount] = credentials.username;
        
        status = SecItemUpdate((__bridge CFDictionaryRef)attributesDictionary, (__bridge CFDictionaryRef)updateDictionary);
        if (attributesResult) CFRelease(attributesResult);
        if (status == errSecSuccess) {
            return YES;
        }
        else {
            if (error) {
                NSString *errorMessage = NSLocalizedString(@"Failed to update credentials item in Keychain.",@"Failed to update credentials item in Keychain.");
                *error = [NSError errorWithDomain:kErrorDomain code:status userInfo:@{NSLocalizedDescriptionKey: errorMessage}];
            }
        }
    }
    else {
        // Create new credentials (password item not exist)
        if (attributesResult) CFRelease(attributesResult);
        NSMutableDictionary *attributesDictionary = [KeychainHelper createPasswordAttributesItem];
        NSData *passwordData = [credentials.password dataUsingEncoding:NSUTF8StringEncoding];
        attributesDictionary[(__bridge id)kSecValueData] = passwordData;
        
        attributesDictionary[(__bridge id)kSecAttrAccount] = credentials.username;
        
        status = SecItemAdd((__bridge CFDictionaryRef)attributesDictionary, NULL);
        if (status == errSecSuccess) {
            return YES;
        }
        else {
            if (error) {
                NSString *errorMessage = NSLocalizedString(@"Failed to create credentials item in Keychain.",@"Failed to create credentials item in Keychain.");
                *error = [NSError errorWithDomain:kErrorDomain code:status userInfo:@{NSLocalizedDescriptionKey: errorMessage}];
            }
        }
    }
    
    return NO;
    
}

+ (BOOL)deleteCredentialsAndReturnError:(NSError * __autoreleasing *)error
{
    
    NSMutableDictionary *passwordAttributesDictionary = [KeychainHelper createPasswordAttributesItem];
    
    OSStatus status = SecItemDelete((__bridge CFDictionaryRef)passwordAttributesDictionary);
    if (status == errSecSuccess || status == errSecItemNotFound) {
        return YES;
    }
    else {
        if (error) {
            NSString *errorMessage = NSLocalizedString(@"Failed to delete credentials item in Keychain.",@"Failed to delete credentials item in Keychain.");
            *error = [NSError errorWithDomain:kErrorDomain code:status userInfo:@{NSLocalizedDescriptionKey: errorMessage}];
        }
    }
    
    return NO;
}

#pragma mark - X.509 certificates


+ (NSMutableDictionary *)createCertificateAttributesItem
{
    NSMutableDictionary *attributesDictionary = [[NSMutableDictionary alloc] init];
    
    attributesDictionary[(__bridge id)kSecClass] = (__bridge id)kSecClassIdentity;
    attributesDictionary[(__bridge id)kSecAttrLabel] = kClientCertificateIdentifier;
    
    if ([KeychainHelper accessGroup] != nil)
    {
#if TARGET_IPHONE_SIMULATOR
        // Ignore the access group if running on the iPhone simulator to avoide error, since apps that are built for the simulator aren't signed and there's no keychain access group for the simulator to check (all apps can see all keychain items when run on the simulator).
#else
        attributesDictionary[(__bridge id)kSecAttrAccessGroup] = [KeychainHelper accessGroup];
#endif
    }
    
    return attributesDictionary;
}

+ (NSMutableDictionary *)createCertificateAttributesReadQuery
{
    NSMutableDictionary *certificateQuery = [KeychainHelper createCertificateAttributesItem];
    
    // Use the proper search constants, return only the attributes of the first match
    certificateQuery[(__bridge id)kSecMatchLimit] = (__bridge id)kSecMatchLimitOne;
    certificateQuery[(__bridge id)kSecReturnAttributes] = (__bridge id)kCFBooleanTrue;
    return certificateQuery;
}

+ (SecIdentityRef)extractIdentityFromClientCertificate:(NSData *)aCertificate WithPassword:(NSString *)aPassword
{
    CFDataRef inPKCS12Data = (__bridge CFDataRef)aCertificate;
    SecIdentityRef myIdentity = NULL;
    OSStatus securityError = errSecSuccess;
    
    // Enter password to open certificate
    CFStringRef password = (__bridge CFStringRef)aPassword;
    const void *keys[] = { kSecImportExportPassphrase };
    const void *values[] = { password };
    CFDictionaryRef optionsDictionary = CFDictionaryCreate(NULL, keys,
                                                           values, 1,
                                                           NULL, NULL);
    CFArrayRef credItems = CFArrayCreate(NULL, 0, 0, NULL);
    
    // Import the client certificate
    securityError = SecPKCS12Import(inPKCS12Data,
                                    optionsDictionary,
                                    &credItems);
    if (securityError == errSecSuccess) {
        CFDictionaryRef myIdentityAndTrust = CFArrayGetValueAtIndex (credItems, 0);
        const void *tempIdentity = NULL;
        tempIdentity = CFDictionaryGetValue (myIdentityAndTrust, kSecImportItemIdentity);
        myIdentity = (SecIdentityRef)tempIdentity;
    }
    
    if (optionsDictionary){
        CFRelease(optionsDictionary);
    }
    return myIdentity;
}


+ (BOOL)saveIdentityToKeychain:(SecIdentityRef)anIdentity error:(NSError * __autoreleasing *)error
{
    OSStatus status;
    
    // check if certificate not empty
    if (anIdentity == NULL) {
        if (error) {
            NSString *errorMessage = NSLocalizedString(@"Failed to add client certificate to Keychain. Check that certificate is not empty.",@"Failed to add client certificate to Keychain.Check that certificate is not empty.");
            *error = [NSError errorWithDomain:kErrorDomain code:errSecParam userInfo:@{NSLocalizedDescriptionKey: errorMessage}];
        }
        return NO;
    }
    
    // Check if the certificate already exists in keychain - if yes delete it before saveing it
    if([KeychainHelper isCertificateSaved]) {
        BOOL deleteSuccessfull = [KeychainHelper deleteCertificateAndReturnError:error];
        if (!deleteSuccessfull) {
            return NO;
        }
    }
    // Create new credentials (password item not exist)
    
    // Create a dictionary with two key-values:
    // kSecAttrLabel - represents the key for entering the label of the item in the keychain
    // kSecValueRef - the item that is added to the keychain
    NSMutableDictionary *attributesDictionary = [[NSMutableDictionary alloc] init];
    
    attributesDictionary[(__bridge id)kSecAttrLabel] = kClientCertificateIdentifier;
    attributesDictionary[(__bridge id)kSecValueRef] = (__bridge id)(anIdentity);
    
    if ([KeychainHelper accessGroup] != nil)
    {
#if TARGET_IPHONE_SIMULATOR
        // Ignore the access group if running on the iPhone simulator to avoide error, since apps that are built for the simulator aren't signed and there's no keychain access group for the simulator to check (all apps can see all keychain items when run on the simulator).
#else
        attributesDictionary[(__bridge id)kSecAttrAccessGroup] = [KeychainHelper accessGroup];
        
#endif
    }
    
    CFDictionaryRef dict = (__bridge CFDictionaryRef)attributesDictionary;
    
    // Add the item to the keychain based on the dictionary defined above
    // Second parameter is null - no persistance reference needed
    status = SecItemAdd(dict, NULL);
    
    if(status == errSecSuccess){
        return YES;
    }
    else{
        if (error) {
            NSString *errorMessage = NSLocalizedString(@"Failed to add client certificate to Keychain.",@"Failed to add client certificate to Keychain.");
            *error = [NSError errorWithDomain:kErrorDomain code:status userInfo:@{NSLocalizedDescriptionKey: errorMessage}];
        }
    }
    return NO;
}

+ (SecIdentityRef)loadClientCertificateInKeychainAndReturnError:(NSError * __autoreleasing *)error
{
    // will hold a ref to the cert we're trying to retrieve
    CFTypeRef certificateRef = NULL;
    
    // the search we need - a string match for a UTF8 String.
    //    CFStringRef certLabel = (__bridge CFStringRef)(kClientCertificateIdentifier);
    
    // Create a dictionary with three key-values in order to search for the Identity
    // kSecClass - specify the class of the item retrieved. In our case it is kSecClassIdentity
    // kSecAttrLabel - represents the the label of the item in the keychain
    // kSecReturnRef - represents a boolean value for retrieving the value ref or not.
    
    NSMutableDictionary *attributesDictionary = [KeychainHelper createCertificateAttributesItem];
    attributesDictionary[(__bridge id)kSecReturnRef] = (__bridge id)kCFBooleanTrue;
    
    CFDictionaryRef dict = (__bridge CFDictionaryRef)attributesDictionary;
    
    // Search the keychain, returning in dict
    OSStatus status = SecItemCopyMatching(dict, &certificateRef);
    
    if(status == errSecSuccess) {
        return (SecIdentityRef)certificateRef;
    }
    else {
        if (error) {
            NSString *errorMessage = NSLocalizedString(@"Failed to find client certificate in Keychain.",@"Failed to find client certificate in Keychain.");
            *error = [NSError errorWithDomain:kErrorDomain code:status userInfo:@{NSLocalizedDescriptionKey: errorMessage}];
        }
    }
    return NULL;
}

+ (BOOL)deleteCertificateAndReturnError:(NSError * __autoreleasing *)error
{
    NSMutableDictionary *certificateAttributesDictionary = [KeychainHelper createCertificateAttributesItem];
    
    OSStatus status = SecItemDelete((__bridge CFDictionaryRef)certificateAttributesDictionary);
    if (status == errSecSuccess || status == errSecItemNotFound) {
        return YES;
    }
    else {
        if (error) {
            NSString *errorMessage = NSLocalizedString(@"Failed to delete client certificate from Keychain.",@"Failed to delete client certificate from Keychain.");
            *error = [NSError errorWithDomain:kErrorDomain code:status userInfo:@{NSLocalizedDescriptionKey: errorMessage}];
        }
    }
    
    return NO;
}

+ (BOOL)isCertificateSaved
{
    BOOL hasCredentials = NO;
    
    // Find the attributes for the password item
    NSMutableDictionary *certificateQuery = [KeychainHelper createCertificateAttributesReadQuery];
    CFTypeRef attributesResult = NULL;
    OSStatus status = SecItemCopyMatching((__bridge CFDictionaryRef)certificateQuery, &attributesResult);
    if (status == errSecSuccess) {
        hasCredentials = YES;
    }
    
    if (attributesResult) CFRelease(attributesResult);
    return hasCredentials;
}

+ (NSString *)extractSubjectFromStoredCertificateAndReturnError:(NSError * __autoreleasing *)error
{
    SecIdentityRef identityRef = [KeychainHelper loadClientCertificateInKeychainAndReturnError:error];
    if (identityRef != NULL) {
        SecCertificateRef certificateRef = NULL;
        SecIdentityCopyCertificate(identityRef, &certificateRef);
        CFStringRef cSubject = SecCertificateCopySubjectSummary(certificateRef);
        NSString *subject = (__bridge NSString *)cSubject;
        CFRelease(cSubject);
        return subject;
    }
    return nil;
}

+ (NSString *)extractSubjectFromIdentity:(SecIdentityRef)anIdentity
{
    SecCertificateRef certificateRef = NULL;
    SecIdentityCopyCertificate(anIdentity, &certificateRef);
    CFStringRef cSubject = SecCertificateCopySubjectSummary(certificateRef);
    NSString *subject = (__bridge NSString *)cSubject;
    CFRelease(cSubject);
    return subject;
}

@end
