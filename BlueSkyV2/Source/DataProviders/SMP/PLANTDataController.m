//
//  BSSMPMaterialGroupDataController.m
//  BlueSky
//
//  Created by Jones, Jeffry on 7/11/13.
//  Copyright (c) 2013 SAP MIC. All rights reserved.
//

#import "PLANTDataController.h"


@implementation PLANTDataController

- (id) init {
    if (self = [super init]) {
        
        //Callback Notification Name
        _kLoadODataCompletedNotification = kLoadPLANTCompletedNotification;
        
        //Endpoint credentials (Load them from storage if possible)
        NSError *error = nil;
        _credentials = [KeychainHelper loadCredentialsAndReturnError: &error];
        if (error) {
            _credentials = [[CredentialsData alloc] initWithUsername: @"MICDEMO"
                                                             andPassword: @"welcome"];
        }

        //OData Collection Name
        _odataCollectionName = kPLANTCollection;

        //Service & Metadata Document URLs
        NSString * url = [[[ConnectivitySettings serviceURL] substringToIndex:[[ConnectivitySettings serviceURL] length]-1] stringByAppendingString:@".plant/"];
        _serviceDocumentURL = url;
        _metadataDocumentURL = [NSString stringWithFormat:@"%@%@", _serviceDocumentURL, kMetadata];
        
        [self setup];
    }
    return self;
}

/*
 This is our OData response handler
 */
- (void) getODataCompleted: (id <Requesting>) request{
    NSLog(@"PLANT Request succeeded!");

    //FOR DEBUG
    NSData *responseData = [request responseData];
    NSString *responseString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
    NSLog(@"PLANT Response string: %@", responseString);

    //Parses a feed or an entry xml or json.
    [_odataParser parse:[request responseData]];

    //The array of parsed entry/entries can be accessed via the "entries" property of the parser after parsing.
    //Array of OData Entries can be iterated and diplay the requisite data in tableview
    _odataEntriesList = _odataParser.entries;

    NSDictionary * dict = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:_odataEntriesList, nil] forKeys:[NSArray arrayWithObjects:@"data", nil ] ];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:_kLoadODataCompletedNotification object:self userInfo:dict];
}

/*
 This is our request builder and request sender
 */
- (void)getOData:(NSDictionary *)params andDidFinishSelector:(SEL)aFinishSelector {
    
    NSLog(@"PLANT Reuqest Called");

    //Parse the params from the dictionary
    NSString * plant = [params objectForKey:@"plant"];
    
    //Create the request url to call the OData REST service
    NSString *grpURL = [NSString stringWithFormat: @"%@%@(werks='%@')", _serviceDocumentURL, _odataCollectionName, plant];
    NSLog(@"PLANT Request URL=%@", grpURL);
    [RequestBuilder setRequestType: _HTTPRequestType];
    [RequestBuilder enableXCSRF: YES];
    id<Requesting> request = [RequestBuilder requestWithURL: [NSURL URLWithString: grpURL]];
    [request setRequestMethod: @"GET"];

    //Use JSON if set
    if ([ConnectivitySettings useJSON]) {
        [request addRequestHeader: @"Accept" value: kApplicationJSON];
    }

    [request addRequestHeader:kX_SMP_APPCID value:_applicationConnectionID];
    
    [request setUsername: _credentials.username];
    [request setPassword: _credentials.password];

    [request setDelegate: self];

    //Set finish selector for request
    if (aFinishSelector) {
        request.didFinishSelector = aFinishSelector;
    }

    NSLog(@"Starting initial asynchronous GET request for PLANT");
    [request startAsynchronous];
}


@end
