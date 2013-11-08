//
//  BSMapCalloutView.m
//  BlueSky
//
//  Created by Ivan Reyes on 10/3/13.
//  Copyright (c) 2013 SAP MIC. All rights reserved.
//

#import "BSMapCalloutView.h"

static UINib *nib;

@implementation BSMapCalloutView

+ (void) initialize {
    nib = [UINib nibWithNibName: @"BSMapCalloutView"
                         bundle: nil];
}

+ (BSMapCalloutView *) calloutView {
    NSArray *arr = [nib instantiateWithOwner: nil
                                     options: nil];
    if (![arr count])
        return nil;
    BSMapCalloutView *view = [arr objectAtIndex: 0];

    view.layer.cornerRadius = 5.0f;
    
    
    return view;
}

-(void)setTextFieldDelegate
{
    self.txtQuantity.delegate = self;
}



- (void)textFieldDidBeginEditing:(UITextField *)textField {
    self.txtQuantity.text = @"";
    NSTimeInterval animationDuration = 0.300000011920929;
    CGRect frame = self.frame;
    frame.origin.y -= 150.0;
    frame.size.height += 150.0;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    self.frame = frame;
    [UIView commitAnimations];
    
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if([self.txtQuantity.text isEqualToString:@""]){
        self.txtQuantity.text = @"Enter Quantity...";
    }
    NSTimeInterval animationDuration = 0.300000011920929;
    CGRect frame = self.frame;
    frame.origin.y += 150.0;
    frame.size.height -= 150.0;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    self.frame = frame;
    [UIView commitAnimations];
    
}
@end
