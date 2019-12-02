//
//  AlertViewHelpers.m
//  igolive
//
//  Created by greenhouse on 8/27/16.
//  Copyright © 2016 iGoLive LLC. All rights reserved.
//

#import "AlertViewHelpers.h"
#import "ObjectTypeValidator.h"

@implementation AlertViewHelpers

+ (void)presentAlertWithTitle:(NSString*)title
                      message:(NSString*)msg
                     delegate:(id<UIAlertViewDelegate>)delegate
{
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle:title
                          message:msg
                          delegate:delegate
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil];
    [alert show];
}

+ (void)presentAlertWithTextFieldPlaceholder:(NSString*)placeholder
                                       title:(NSString*)title
                                     message:(NSString*)msg
                                    parentVc:(UIViewController*)vc
                              helperDelegate:(id<AlertViewHelpersDelegate>)delegate
{
    UIAlertController *ac = [UIAlertController alertControllerWithTitle:title
                                                                message:msg
                                                         preferredStyle:UIAlertControllerStyleAlert];
    
    [ac addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = placeholder;
        [textField setKeyboardType:UIKeyboardTypeDefault];
    }];
    
    [ac addAction:[UIAlertAction actionWithTitle:@"Cancel"
                                           style:UIAlertActionStyleCancel
                                         handler:^(UIAlertAction * _Nonnull action)
                                            {
                                                [delegate alertCancelClicked];
                                            }]];
    [ac addAction:[UIAlertAction actionWithTitle:@"Submit"
                                           style:UIAlertActionStyleDefault
                                         handler:^(UIAlertAction * _Nonnull action)
                                            {
                                                NSString *strtext = ac.textFields[0].text;
                                                if ([ObjectTypeValidator nsstringIsNilOrEmpty:strtext])
                                                {
                                                    [AlertViewHelpers presentAlertWithTitle:@"Missing Text : /"
                                                                                    message:@"Please try again!"
                                                                                   delegate:nil];
                                                }
                                                else
                                                {
                                                    [delegate alertSubmitClickedWithText:strtext];
                                                }
                                                
                                            }]];

    [vc presentViewController:ac animated:YES completion:nil];
}


@end


