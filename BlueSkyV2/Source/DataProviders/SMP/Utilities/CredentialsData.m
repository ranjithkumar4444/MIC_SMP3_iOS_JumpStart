/*
 
 File: CredentialsData.m
 Abstract: Holds credential data (username and password) saved or loaded from Keychain.
 
 */

#import "CredentialsData.h"

@implementation CredentialsData

- (id)initWithUsername:(NSString *)aUsername andPassword:(NSString *)aPassword
{
    self = [super init];
    if (self) {
        self.username = aUsername;
        self.password = aPassword;
    }
    return self;
}

@end
