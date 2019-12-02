//
//  UIViewController+LoadingView.h
//  cp-client-sup
//
//  Created by greenhouse on 4/21/16.
//  Copyright © 2016 copark llc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (LoadingView)

//- (void)presentLoadingViewController;
//- (void)dismissLoadingViewController;

- (void)presentStreamLoadingViewWhileBlurringBgView:(UIView*)view;
- (void)presentStreamLoadingViewWithCustomAnimation:(BOOL)animation;
- (void)dismissStreamLoadingView;
- (void)presentStandardLoadingView;
- (void)dismissStandardLoadingView;



@end
