//
//  BSMapViewController.m
//  BlueSky
//
//  Created by Jones, Jeffry on 7/10/13.
//  Copyright (c) 2013 SAP MIC. All rights reserved.
//

#import "BSSOCreateViewController.h"
//#import "BSDummyDataProvider.h"
#import "BSSMPDataProvider.h"
#import "Constants.h"
#import "BSSalesOrder.h"

@interface BSSOCreateViewController ()

@end

@implementation BSSOCreateViewController {
    id<BSDataProvider>       dataProvider;
}


- (id) initWithNibName: (NSString *) nibNameOrNil
                bundle:( NSBundle *) nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        //dataProvider = [BSDummyDataProvider new];
        dataProvider = [BSSMPDataProvider new];
    }
    return self;
}

- (void) viewDidLoad {
    [super viewDidLoad];

}

- (void) didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(IBAction)btnCreateClicked:(id)sender
{
    NSLog(@"btnCreateClicked");
    BSSalesOrderCreate * soCreate = [BSSalesOrderCreate new];
    
    [dataProvider createSalesOrder: soCreate
                      onCompletion: ^(NSArray *soRecords) {
                          //ann.soRecords = soRecords[0];
                          BSSalesOrderCreate * so =  ((BSSalesOrderCreate*)soRecords[0]);
                          NSLog(@"Sales Order Create Response: %@", [soRecords[0] description]);
                          UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"Sales Order %@ Created!", so.salesOrderId]
                                                                          message:@"Success your sales order has been created."
                                                                         delegate:self
                                                                cancelButtonTitle:@"OK"
                                                                otherButtonTitles:nil];
                          [alert show];
                          
                          [self.navigationController popViewControllerAnimated:YES];
                      }
                           onError: ^(NSString *errMsg) {
                               NSLog(@"Received error from data provider while creating Sales Order record: %@", errMsg);
                           }];
}

-(IBAction)btnCancelClicked:(id)sender
{
    NSLog(@"btnCancelClicked");
}

@end
