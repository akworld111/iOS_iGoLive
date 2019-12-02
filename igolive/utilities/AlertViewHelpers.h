//
//  AlertViewHelpers.h
//  igolive
//
//  Created by greenhouse on 8/27/16.
//  Copyright © 2016 iGoLive LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol AlertViewHelpersDelegate <NSObject>
- (void)alertCancelClicked;
- (void)alertSubmitClickedWithText:(NSString*)text;
@end

@interface AlertViewHelpers : NSObject

+ (void)presentAlertWithTitle:(NSString*)title
                      message:(NSString*)msg
                     delegate:(id<UIAlertViewDelegate>)delegate;

+ (void)presentAlertWithTextFieldPlaceholder:(NSString*)placeholder
                                       title:(NSString*)title
                                     message:(NSString*)msg
                                    parentVc:(UIViewController*)vc
                              helperDelegate:(id<AlertViewHelpersDelegate>)delegate;

@end



