//
//  BSSMPMaterialGroupDataController.m
//  BlueSky
//
//  Created by Jones, Jeffry on 7/11/13.
//  Copyright (c) 2013 SAP MIC. All rights reserved.
//

#import "BSSMPMaterialGroupDataController.h"

@interface BSSMPMaterialGroupDataController ()

@property (nonatomic, strong) NSString *connectionName;

@end

@implementation BSSMPMaterialGroupDataController

- (id) init {
    if (self = [super init]) {
        //Endpoint credentials (Load them from storage if possible)
        NSError *error = nil;
        self.credentials = [KeychainHelper loadCredentialsAndReturnError: &error];
        if (error) {
            self.credentials = [[CredentialsData alloc] initWithUsername: @"MICDEMO"
                                                             andPassword: @"welcome"];
        }

        // Connection name
        self.connectionName = @"com.sap.mic.dig.grp";
        
        //OData Collection Name
        self.odataCollectionName = @"z_grpCollection";

        //Service & Metadata Document URLs
        self.serviceDocumentURL = [NSString stringWithFormat:@"%@%@", [ConnectivitySettings baseURL], self.connectionName];
        self.metadataDocumentURL = [NSString stringWithFormat:@"%@/%@", self.serviceDocumentURL, kMetadata];
        
        [self setup];
    }
    return self;
}

/*
 This is our OData response handler
 */
- (void) requestFinished: (Request *) request {
    NSLog(@"Request for material groups succeeded!");

    //FOR DEBUG
    NSData *responseData = [request responseData];
    NSString *responseString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
    NSLog(@"Getting Response string: %@", responseString);

    //Parses a feed or an entry xml or json.
    [self.odataParser parse:[request responseData]];

    //The array of parsed entry/entries can be accessed via the "entries" property of the parser after parsing.
    //Array of OData Entries can be iterated and diplay the requisite data in tableview
    //self.odataEntry = self.odataParser.entries[0];

    for (id odEntry in self.odataParser.entries) {
        NSLog(@"Received entry: %@", odEntry);
    }

}

/*
 This is our request builder and request sender
 */
- (void) getOData: (NSDictionary *) params {
    
    NSLog(@"Get ATP Reuqest Called");

    //Create the request url to call the OData REST service
    NSString *grpURL = [NSString stringWithFormat: @"%@/%@", self.serviceDocumentURL, self.odataCollectionName];
    NSLog(@"ATP Request URL=%@", grpURL);
    [RequestBuilder setRequestType: _HTTPRequestType];
    [RequestBuilder enableXCSRF: YES];
    id<Requesting> request = [RequestBuilder requestWithURL: [NSURL URLWithString: grpURL]];
    [request setRequestMethod: @"GET"];

    //Use JSON if set
    if ([ConnectivitySettings useJSON]) {
        [request addRequestHeader: @"Accept" value: kApplicationJSON];
    }

    [request setUsername: self.credentials.username];
    [request setPassword: self.credentials.password];

    //[request setDelegate: self];

    //[request setDidFinishSelector: @selector(requestFinished:)];

    NSLog(@"Starting initial asynchronous GET request for ATP");
    [request startAsynchronous];
}


@end
