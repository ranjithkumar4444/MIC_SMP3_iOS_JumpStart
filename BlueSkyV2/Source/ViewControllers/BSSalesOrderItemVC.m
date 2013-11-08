//
//  BSSalesOrderItemVC.m
//  BlueSkyV2
//
//  Created by Murphy, Damien on 8/26/13.
//  Copyright (c) 2013 SAP MIC. All rights reserved.
//

#import "BSSalesOrderItemVC.h"
#import "BSSalesOrder.h"
#import "BSSalesOrderItem.h"
#import "BSSalesOrderCreate.h"
#import "BSProduct.h"
#import "BSSalesOrderDetailVC.h"
#import "ODataServiceDocument.h"
#import "SalesOrderDataController.h"
#import "ODataPropertyValues.h"


@interface BSSalesOrderItemVC ()
{
    //id<BSDataProvider>       dataProvider;
}
@end

@implementation BSSalesOrderItemVC

@synthesize productEntry;
@synthesize skuLabel;
@synthesize nameLabel;
@synthesize addressLabel;
@synthesize quantityLabel;
@synthesize txtQuantity;
@synthesize activity;



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didFinishCreateSalesOrder:) name:@"createSalesOrderNotification" object:nil];
        
        
    }
    return self;
}

-(void)setSalesOrderList:(NSMutableArray *)newList {
    if(_salesOrderList != newList) {
        _salesOrderList = [newList mutableCopy];
    }
}




-(void)didFinishCreateSalesOrder:(id)sender {
    NSLog(@"didFinishCreateSalesOrder : BSSalesOrderItemVC.m");
    [activity stopAnimating];
    self.orderBtn.enabled = YES;
    self.orderBtn.titleLabel.text = @"Order Item";
    [self.view removeFromSuperview];
}





- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *Ausername = [defaults stringForKey:@"username"];
    NSString *Apassword = [defaults stringForKey:@"password"];
    self.username = Ausername;
    self.password = Apassword;
    [activity stopAnimating];
    
    
    self.skuLabel.text = [[self.productEntry getPropertyValueByPath:@"Material"] getValue];
    self.nameLabel.text = [[self.productEntry getPropertyValueByPath:@"MaterialDescription"] getValue];
    self.orderBtn.titleLabel.text = @"Order Item";

}

- (void) viewWillAppear: (BOOL) animated {
    NSLog(@"BSSalesOrderItemVC");
    self.salesOrderDataController = [SalesOrderDataController uniqueInstance];
    [self.salesOrderDataController loadServiceDocumentAndMetaData];
    
    
    NSString *customerURL = @"http://micrelay.sap.com/micsmp3prod/BlueSky.svc/SalesOrders?$filter=CustomerId+eq+'BLUESKY1'&$expand=SalesOrderItems";
    [self.salesOrderDataController loadSalesOrderCollectionWithDidFinishSelector:@selector(loadSalesOrderCollectionCompleted:) forUrl:customerURL];
    
    
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

-(void)orderClicked:(id)sender {
    NSLog(@"BSSalesOrderItemVC OrderClicked: ");
    NSLog(@"aaa: %@",self.salesOrderDataController.salesOrderEntry.fields);
    NSLog(@"entitySchema a: %@", self.salesOrderDataController.salesOrderCollection.entitySchema);
    
    
    self.orderBtn.titleLabel.text = @"Processing...";
    self.orderBtn.enabled = NO;
    [activity startAnimating];
    
    
    
    int quantity = [self.txtQuantity.text intValue];
    if(!quantity){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Invalid quantity entered!"
                                                        message:[NSString stringWithFormat:@"Please enter a value from 1 & %@", self.quantityLabel.text]
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }else if(quantity > 0 && quantity <= [self.quantityLabel.text intValue]){

        BSSalesOrderCreate * soCreate = [BSSalesOrderCreate new];
        BSSalesOrderItem * item = [[BSSalesOrderItem alloc] init];
        item.quantity = self.txtQuantity.text;

        item.plant = @"3000";
        
        soCreate.soItems = [[NSArray alloc] initWithObjects:item, nil];


        ODataEntry *newOrder = [[ODataEntry alloc] initWithEntitySchema:self.salesOrderDataController.salesOrderCollection.entitySchema];

        ODataEntry *newOrderItem = [[ODataEntry alloc] initWithEntitySchema:self.salesOrderDataController.salesOrderItemCollection.entitySchema];

        
    [self.salesOrderDataController setStringValueForEntry:newOrder withValue:@"USD" forSDMPropertyWithName:@"Currency"];
    [self.salesOrderDataController setStringValueForEntry:newOrder withValue:@"BLUESKY1" forSDMPropertyWithName:@"CustomerId"];
    [self.salesOrderDataController setStringValueForEntry:newOrder withValue:@"10" forSDMPropertyWithName:@"DistChannel"];
    [self.salesOrderDataController setStringValueForEntry:newOrder withValue:@"00" forSDMPropertyWithName:@"Division"];
    [self.salesOrderDataController setStringValueForEntry:newOrder withValue:@"2013-07-10T00:00:00" forSDMPropertyWithName:@"DocumentDate"];
    [self.salesOrderDataController setStringValueForEntry:newOrder withValue:@"TA" forSDMPropertyWithName:@"DocumentType"];
    [self.salesOrderDataController setStringValueForEntry:newOrder withValue:@"0000007995" forSDMPropertyWithName:@"OrderId"];
    [self.salesOrderDataController setStringValueForEntry:newOrder withValue:@"23.00" forSDMPropertyWithName:@"OrderValue"];
    [self.salesOrderDataController setStringValueForEntry:newOrder withValue:@"3000" forSDMPropertyWithName:@"SalesOrg"];

        
        [self.salesOrderDataController setStringValueForEntry:newOrderItem withValue:@"0000007995" forSDMPropertyWithName:@"OrderId"];
        [self.salesOrderDataController setStringValueForEntry:newOrderItem withValue:@"000010" forSDMPropertyWithName:@"Item"];
        [self.salesOrderDataController setStringValueForEntry:newOrderItem withValue:self.skuLabel.text forSDMPropertyWithName:@"Material"];
        [self.salesOrderDataController setStringValueForEntry:newOrderItem withValue:self.nameLabel.text forSDMPropertyWithName:@"Description"];
        [self.salesOrderDataController setStringValueForEntry:newOrderItem withValue:self.txtQuantity.text forSDMPropertyWithName:@"Quantity"];
        [self.salesOrderDataController setStringValueForEntry:newOrderItem withValue:@"FT3" forSDMPropertyWithName:@"UoM"];
        [self.salesOrderDataController setStringValueForEntry:newOrderItem withValue:@"3000" forSDMPropertyWithName:@"Plant"];
        [self.salesOrderDataController setStringValueForEntry:newOrderItem withValue:@"0.000000000" forSDMPropertyWithName:@"Value"];
        [self.salesOrderDataController setStringValueForEntry:newOrderItem withValue:@"USD" forSDMPropertyWithName:@"Currency"];
        [self.salesOrderDataController setStringValueForEntry:newOrderItem withValue:@"C" forSDMPropertyWithName:@"ItemDlvyStatus"];
        [self.salesOrderDataController setStringValueForEntry:newOrderItem withValue:@"Completely processed" forSDMPropertyWithName:@"ItemDlvyStaTx"];
        
        
        NSMutableDictionary *inlineDict = [[NSMutableDictionary alloc] initWithObjectsAndKeys:newOrderItem,@"SalesOrderItems", nil];
        
        [newOrder setInlinedRelatedEntries:inlineDict];

        [self.salesOrderDataController createSalesOrderWithOrder:newOrder withTempEntryId:@"SalesOrders('0000007995')"];

    }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Quantity not available!"
                                                        message:[NSString stringWithFormat:@"Max available in stock is %@ ", self.quantityLabel.text]
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
    
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
