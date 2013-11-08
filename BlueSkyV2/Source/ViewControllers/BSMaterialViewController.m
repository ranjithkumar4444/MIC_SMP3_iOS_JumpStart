//
//  BSMaterialViewController.m
//  BlueSky
//
//  Created by Jones, Jeffry on 6/14/13.
//  Copyright (c) 2013 SAP MIC. All rights reserved.
//

#import "BSMaterialViewController.h"
#import "BSMaterialAdapter.h"
#import "BSMaterialCell.h"
#import "BSMaterialGroup.h"
#import "BSDummyDataProvider.h"
#import "BSSMPDataProvider.h"
#import "BSMapViewController.h"
#import "BSLocationListViewController.h"

@interface BSMaterialViewController ()

@end

@implementation BSMaterialViewController {
    id<BSDataProvider>       dataProvider;
    BSMaterialAdapter       *matAdapter;
    CALayer                 *bgTintLayer;
    BSMapViewController *mapVC;
    BSLocationListViewController *llVC;
    BOOL showMap;
    int selectedIndex;
}

#pragma mark - Initialization

- (id) initWithNibName: (NSString *) nibNameOrNil
                bundle: (NSBundle *) nibBundleOrNil {
    self = [super initWithNibName: nibNameOrNil
                           bundle: nibBundleOrNil];
    if (self) {
        //dataProvider = [BSDummyDataProvider new];
        dataProvider = [BSSMPDataProvider new];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(toggleMap)
                                                     name:@"toggleMap" object:nil];
    }
    return self;
}

#pragma mark - View

- (void) viewDidLoad {
    [super viewDidLoad];
    [self.gridView registerNib: [BSMaterialCell nibFile]
    forCellWithReuseIdentifier: BS_MATERIAL_CELL_ID];

    bgTintLayer = [CALayer new];
    bgTintLayer.frame = [self getScreenFrameForCurrentOrientation];
    
    self.bgView.frame = bgTintLayer.frame;
    [self.bgView.layer addSublayer: bgTintLayer];
    [self.loadingView setHidden:NO];
    [dataProvider requestMaterialsForGroup: self.matGroup.groupID
                              onCompletion: ^(NSArray *materials) {
                                  NSLog(@"data returned: requestMaterialsForGroup: %@",materials);
                                  self.titleLabel.text = [NSString stringWithFormat:@"%d Products", [materials count]];
                                  if (!matAdapter) {
                                      matAdapter = [BSMaterialAdapter new];
                                      matAdapter.color = self.bgColor;
                                  }
                                  matAdapter.materials = materials;
                                  self.gridView.dataSource = matAdapter;
                                  [self.loadingView setHidden:YES];
                              }
                                   onError: ^(NSString *errMsg) {
                                       NSLog(@"Received error from data provider while requesting materials: %@", errMsg);
                                       UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error!"
                                                                                       message:errMsg
                                                                                      delegate:self
                                                                             cancelButtonTitle:@"OK"
                                                                             otherButtonTitles:nil];
                                       [alert show];
                                   }
     ];
}

- (void) viewWillAppear: (BOOL) animated {
    
    NSLog(@"BSMaterialViewController:");
    
    [super viewWillAppear: animated];

    self.subtitleLabel.text = self.matGroup.name;

    CGFloat red = 1.0f, blue = 1.0f, green = 1.0f, alpha = 1.0f;
    [self.bgColor getRed: &red
                   green: &green
                    blue: &blue
                   alpha: &alpha];
    /*bgTintLayer.backgroundColor = [[UIColor colorWithRed: red
                                                   green: green
                                                    blue: blue
                                                   alpha: 0.7f] CGColor];
*/
}

-(void)viewWillLayoutSubviews
{
    bgTintLayer.frame = [self getScreenFrameForCurrentOrientation];
    
    self.bgView.frame = bgTintLayer.frame;
}

#pragma mark - CollectionView

- (void)  collectionView: (UICollectionView *) collectionView
didSelectItemAtIndexPath: (NSIndexPath *) indexPath {
    NSLog(@"BB didSelectItemAtIndexPath: %ld",(long)indexPath.row);
    
    BOOL offline = NO;
    
    if(!offline){
        if(!mapVC){
            mapVC = [[BSMapViewController alloc] initWithNibName: nil bundle: nil];
        }else{
            [mapVC reload];
        }
        if (indexPath.row < [matAdapter.materials count]) {
            
            selectedIndex = indexPath.row;
            mapVC.material = [matAdapter.materials objectAtIndex: indexPath.row];
            NSLog(@"selectedIndex + material %d - %@",selectedIndex, mapVC.material);
        }
        NSLog(@"pushViewController mapVC");
        [self.navigationController pushViewController: mapVC
                                             animated: YES];
    }else{
        
        if(!llVC){
            NSLog(@"No llVC");
            llVC = [[BSLocationListViewController alloc] initWithNibName: nil bundle: nil];
        }else{
            
            NSLog(@"llVC");
            [llVC reload];
        }
        if (indexPath.row < [matAdapter.materials count]) {
            selectedIndex = indexPath.row;
            llVC.material = [matAdapter.materials objectAtIndex: indexPath.row];
        }
        NSLog(@"pushViewController llVC");
        [self.navigationController pushViewController: llVC
                                             animated: YES];
    }
}

- (CGSize) collectionView: (UICollectionView *) collectionView
                   layout: (UICollectionViewLayout *) collectionViewLayout
   sizeForItemAtIndexPath: (NSIndexPath *) indexPath {
    return CGSizeMake(280.0f, 80.0f);
}

#pragma mark - Memory Warning

- (void) didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - toggleMap

-(void)toggleMap
{
    [self.navigationController popViewControllerAnimated:NO];
    if(showMap){
        if(!mapVC){
            mapVC = [[BSMapViewController alloc] initWithNibName: nil bundle: nil];
        }else{
            [mapVC reload];
        }
        if (selectedIndex < [matAdapter.materials count]) {
            mapVC.material = [matAdapter.materials objectAtIndex: selectedIndex];
        }
        [self.navigationController pushViewController: mapVC
                                             animated: YES];
    }else{
        
        if(!llVC){
            llVC = [[BSLocationListViewController alloc] initWithNibName: nil bundle: nil];
        }else{
            [llVC reload];
        }
        if (selectedIndex < [matAdapter.materials count]) {
            llVC.material = [matAdapter.materials objectAtIndex: selectedIndex];
        }
        [self.navigationController pushViewController: llVC
                                             animated: YES];
    }

    showMap = !showMap;
}
@end
