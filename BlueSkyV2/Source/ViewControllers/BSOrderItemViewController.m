//
//  BSOrderItemController.m
//  BlueSkyV2
//
//  Created by Murphy, Damien on 8/26/13.
//  Copyright (c) 2013 SAP MIC. All rights reserved.
//

#import "BSOrderItemViewController.h"
#import "BSSalesOrder.h"
#import "BSSalesOrderCreate.h"
#import "BSSMPDataProvider.h"
#import "BSSMPDataProvider.h"
#import "BSSOListViewController.h"

@interface BSOrderItemViewController ()
{
    id<BSDataProvider>       dataProvider;
}
@end

@implementation BSOrderItemViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    if(!dataProvider){
        dataProvider = [BSSMPDataProvider new];
    }
}

- (void) viewWillAppear: (BOOL) animated {
    NSLog(@"BSOrderItemViewController");
    
    [super viewWillAppear: animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dismissClicked:(id)sender
{
    [self.view removeFromSuperview];
}

-(void)orderClicked:(id)sender
{
    
    int quantity = [self.txtQuantity.text intValue];
    if(!quantity){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Invalid quantity entered!"
                                                        message:[NSString stringWithFormat:@"Please enter a value from 1 & %@", self.quantityLabel.text]
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }else if(quantity > 0 && quantity <= [self.quantityLabel.text intValue]){
        
        //[self.view endEditing:YES];
        //[self.loadingView setHidden:NO];
        BSSalesOrderCreate * soCreate = [BSSalesOrderCreate new];
        BSSalesOrder * item = [[BSSalesOrder alloc] init];
        item.quantity = self.txtQuantity.text;
        item.material = self.material.materialID;
        item.plant = self.atpRecord.plant;
        soCreate.soItems = [[NSArray alloc] initWithObjects:item, nil];
        
        
        
        [dataProvider createSalesOrder: soCreate
                          onCompletion: ^(NSArray *soRecords) {
                              //calloutView = nil;
                              [self getSalesOrderAndShowDetails];
                          }
                               onError: ^(NSString *errMsg) {
                                   //[self.loadingView setHidden:YES];
                                   NSLog(@"Received error from data provider while creating Sales Order record: %@", errMsg);
                                   UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error!"
                                                                                   message:errMsg
                                                                                  delegate:self
                                                                         cancelButtonTitle:@"OK"
                                                                         otherButtonTitles:nil];
                                   [alert show];
                               }];
        
    }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Quantity not available!"
                                                        message:[NSString stringWithFormat:@"Max available in stock is %@ ", self.quantityLabel.text]
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
    
}

- (void)getSalesOrderAndShowDetails
{
    NSLog(@"getSalesOrderAndShowDetails called");
    [dataProvider requestSalesOrders:@"0000006677"
                        onCompletion:^(NSMutableArray *soRecords) {
                            NSLog(@"____1___:");
                            NSLog(@"Sales Order List Response: %@", [soRecords[0] description]);
                            BSSOListViewController *soVC = [[BSSOListViewController alloc] initWithNibName: nil
                                                                                                    bundle: nil];
                            
                            soVC.salesOrder = soRecords[0];
                            
                            
                            
                            [self.view removeFromSuperview];
                            [self.realParent.navigationController pushViewController: soVC
                                                                 animated: YES];
                            
                            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Success!"
                                                                            message:[NSString stringWithFormat:@"Sales Order [%@] Created!", soVC.salesOrder.orderId]
                                                                           delegate:self
                                                                  cancelButtonTitle:@"OK"
                                                                  otherButtonTitles:nil];
                            [alert show];
                            //[self.loadingView setHidden:YES];
                            //[self.mapView deselectAnnotation:self.mapView.selectedAnnotations[0] animated:NO];
                        }
                             onError:^(NSString *errMsg) {
                                 NSLog(@"Received error from data provider while getting the Sales Order List: %@", errMsg);
                             }
     ];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    self.txtQuantity.text = @"";
    NSTimeInterval animationDuration = 0.300000011920929;
    CGRect frame = self.view.frame;
    frame.origin.y -= 150.0;
    frame.size.height += 150.0;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    self.view.frame = frame;
    [UIView commitAnimations];
    
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if([self.txtQuantity.text isEqualToString:@""]){
        self.txtQuantity.text = @"Enter Quantity...";
    }
    NSTimeInterval animationDuration = 0.300000011920929;
    CGRect frame = self.view.frame;
    frame.origin.y += 150.0;
    frame.size.height -= 150.0;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    self.view.frame = frame;
    [UIView commitAnimations];
    
}
@end
