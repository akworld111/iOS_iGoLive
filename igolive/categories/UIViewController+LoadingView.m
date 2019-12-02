//
//  UIViewController+LoadingView.m
//  cp-client-sup
//
//  Created by greenhouse on 4/21/16.
//  Copyright © 2016 copark llc. All rights reserved.
//

#import "UIViewController+LoadingView.h"
#import "xlogger.h"
#import "LoadingViewController.h"
#import "UIImage+animatedGIF.h"

LoadingViewController *loadingViewController;

@implementation UIViewController (LoadingView)

- (void)presentStreamLoadingViewWhileBlurringBgView:(UIView*)view
{
#if show_stream_load_view
    XL_enter();
    [self presentLoadingViewController];
    
    [self.view insertSubview:loadingViewController.view atIndex:1];
    
    loadingViewController.vLoadingShadow.hidden = YES;
    
    UIImage *imgblur = [ViewModifierHelpers blurredImageFromView:view withBlurRadius:15.0f];
    [loadingViewController.ivLoadingImg setImage:imgblur]; // ivLoadingImg is inside vLoadingImgOverlay
    
    loadingViewController.ivLoadingImg.hidden = NO;
    loadingViewController.vLoadingImgOverlay.hidden = NO;
    loadingViewController.aiLoading.hidden = NO;
    loadingViewController.btnCloseLoadingView.hidden = YES;

    [loadingViewController.view bringSubviewToFront:loadingViewController.vLoadingImgOverlay];
    [loadingViewController.view bringSubviewToFront:loadingViewController.aiLoading];
#endif
}

- (void)presentStreamLoadingViewWithCustomAnimation:(BOOL)animation
{
#if show_stream_load_view
    XL_enter();
    [self presentLoadingViewController];
    loadingViewController.vLoadingShadow.hidden = YES;
    loadingViewController.aiLoading.hidden = YES;
    
    loadingViewController.btnCloseLoadingView.hidden = NO;
    loadingViewController.vLoadingImgOverlay.hidden = NO;
    
    loadingViewController.vLoadingImgOverlay.backgroundColor = UIColorFromHexAlpha(col_header_lt_green, 1.0f);
    
    [loadingViewController.view bringSubviewToFront:loadingViewController.vLoadingImgOverlay];
    
    if (animation)
    {
        NSURL *urlGif = [[NSBundle mainBundle] URLForResource:f_imgLoadStream withExtension:@"gif"];
        UIImage *imgGif = [UIImage animatedImageWithAnimatedGIFData:[NSData dataWithContentsOfURL:urlGif]];
        [loadingViewController.ivAnimation setImage:imgGif];
    }
    else
    {
        loadingViewController.aiLoading.hidden = NO;
        [loadingViewController.view bringSubviewToFront:loadingViewController.aiLoading];
    }
#endif
}
- (void)dismissStreamLoadingView
{
#if show_stream_load_view
    XL_enter();
    [self dismissLoadingViewController];
#endif
}
- (void)presentStandardLoadingView
{
    [self presentLoadingViewController];
    loadingViewController.vLoadingImgOverlay.hidden = YES;
    
    
    loadingViewController.vLoadingShadow.hidden = NO;
    loadingViewController.aiLoading.hidden = NO;
    
    [loadingViewController.view bringSubviewToFront:loadingViewController.vLoadingShadow];
    [loadingViewController.view bringSubviewToFront:loadingViewController.aiLoading];
}
- (void)dismissStandardLoadingView
{
    [self dismissLoadingViewController];
}
- (void)presentLoadingViewController
{
    [self.view endEditing:YES]; // resign all view's and subviews' first responders
    
    if (!loadingViewController)
    {
        loadingViewController = [[LoadingViewController alloc] init];
        // should stay self.view
        [self.view addSubview:loadingViewController.view];
        [loadingViewController.view setFrame:self.view.bounds];
    }
    
    [self.view bringSubviewToFront:loadingViewController.view];
}
- (void)dismissLoadingViewController
{
    if (loadingViewController)
    {
        [loadingViewController.view removeFromSuperview];
        loadingViewController = nil;
    }
}

@end
