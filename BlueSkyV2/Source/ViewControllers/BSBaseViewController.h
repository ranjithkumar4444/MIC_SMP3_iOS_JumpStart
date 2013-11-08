//
//  BSBaseViewController.h
//  BlueSky
//
//  Created by Jones, Jeffry on 7/10/13.
//  Copyright (c) 2013 SAP MIC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BSBaseViewController : UIViewController

@property (nonatomic, weak) IBOutlet UIImageView      *bgView;
@property (nonatomic, weak) IBOutlet UIButton         *infoButton;
@property (nonatomic, weak) IBOutlet UITextField      *searchField;
@property (nonatomic, weak) IBOutlet UILabel          *titleLabel;
@property (nonatomic, weak) IBOutlet UIButton         *backButton;

- (IBAction) infoButtonClicked: (id) sender;
- (IBAction) backButtonClicked: (id) sender;
- (CGRect)getScreenFrameForCurrentOrientation;
@end
