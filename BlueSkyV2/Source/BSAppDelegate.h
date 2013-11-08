//
//  BSAppDelegate.h
//  BlueSky
//
//  Created by Ivan Reyes on 10/3/13.
//  Copyright (c) 2013 SAP MIC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Reachability.h"


@interface BSAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow                  *window;
@property (strong, nonatomic) UINavigationController    *navigationController;
@property (retain,nonatomic) Reachability *reach;


@end
