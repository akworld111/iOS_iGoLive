//
//  IGOTabBarController.m
//  igolive
//
//  Created by Dev on 9/17/16.
//  Copyright © 2016 iGoLive LLC. All rights reserved.
//

#import "IGOTabBarController.h"
#import "UITabBar+IGOCenterButton.h"

@interface IGOTabBarController ()

@end

@implementation IGOTabBarController

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)viewDidLoad {
    [super viewDidLoad];
            
    [self setTabBarFrameIfIndeeded]; // prints view and tabBar bounds / frame if set was needed
    [self.tabBar setInitBackgroundImgProperties];
    
    // u need it, Because u don't need an line black :)
    [[UITabBar appearance] setShadowImage:[UIImage new]];
    [[UITabBar appearance] setBackgroundImage:[[UIImage alloc]init]];

    
    /* legacy (XZMTabBarViewControllerr)
        note_09.16.16: not sure why this was integrated, but it doesn't appear to be needed
     */
    //[[UITabBar appearance] setShadowImage:[MiscUtilities uiimagefromUIColor:[UIColor clearColor]]];
    //[[UITabBar appearance] setBackgroundImage:[MiscUtilities uiimagefromUIColor:[UIColor clearColor]]];
    //UITabBar.appearance.tintColor = [UIColor whiteColor];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // cannot be set from viewDidLoad
    [self.tabBar setInitCenterBtnPropertiesWithClickBlock:^{
        UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"LiveStream" bundle:[NSBundle mainBundle]];
        UINavigationController *liveStreamNavController = (UINavigationController*)[storyboard instantiateViewControllerWithIdentifier:@"LiveStreamNavigation"];
        [self presentViewController:liveStreamNavController animated:YES completion:nil];
    }];
}

////////////////////////////////////////////////////
#pragma mark - priv - initializers
////////////////////////////////////////////////////
- (void)setTabBarFrameIfIndeeded // in use, but for no reason apparently
{
    CGFloat stdHeight = 49.0f;
    
    CGRect tbFrame = self.tabBar.frame;
    if (tbFrame.size.height == stdHeight) {
        XLM_alert(@"tbFrame height is already 49.0f, continuing w/o setting frame\n\n\n");
    }
    else
    {
        XLM_alert(@"WARNING... tbFrame height: %f != 49.0f, setting frame calculated with height 49.0f\n\n\n", tbFrame.size.height);
        self.tabBar.frame = CGRectMake(0, tbFrame.origin.y - stdHeight, tbFrame.size.width, stdHeight);
        
        XLM_alert(@"\nNEW self.tabBar.bounds: %@\nNEW  self.tabBar.frame: %@\n\nNEW self.view.bounds: %@\nNEW  self.view.frame: %@\n\n\n", CGRectString(self.tabBar.bounds), CGRectString(self.tabBar.frame), CGRectString(self.view.bounds), CGRectString(self.view.frame));
    }
    
    /* BUG_NOTE_09.24.16:
        for some reason on iOS 9.0 and below, the tab bar's top broder appears very slim in black
            this does not occur on iOS 10
        i guess this bug is not too unexpected, since we had to switch from instantiating the child
         VCs from inside the UITabBarController subclass, to outside of it in the app delegate
            (this was when we got rid of 'XZMTabBarViewController')
     */
    //[ViewModifierHelpers setBorderWidth:2.0f color:UIColorFromHexAlpha(0x7650C6, 1.0f).CGColor forView:self.tabBar];   
}

////////////////////////////////////////////////////
#pragma mark - priv - tab bar controller delegates (not working; tried in appDelegate as well)
////////////////////////////////////////////////////
//- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController*)viewController {
//
//    // 09.16.16: trying to get animation when switching tabs (not working)
//    //  ref: http://stackoverflow.com/a/13026771
//    XL_enter();
//    CATransition *animation = [CATransition animation];
//    [animation setType:kCATransitionFade];
//    [animation setDuration:0.25];
//    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:
//                                  kCAMediaTimingFunctionEaseIn]];
//    [self.mainTabBarController.view.window.layer addAnimation:animation forKey:@"fadeTransition"];
//}
//- (id<UIViewControllerAnimatedTransitioning>)tabBarController:(UITabBarController *)tabBarController animationControllerForTransitionFromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC
//{
//    // 09.16.16: trying to get animation when switching tabs (not working)
//
//    //  ref: http://stackoverflow.com/a/5180104
//    //    // Get views. controllerIndex is passed in as the controller we want to go to.
//    //    UIView * fromView = tabBarController.selectedViewController.view;
//    //    UIView * toView = [[tabBarController.viewControllers objectAtIndex:controllerIndex] view];
//    //
//    //    // Transition using a page curl.
//    //    [UIView transitionFromView:fromView
//    //                        toView:toView
//    //                      duration:0.5
//    //                       options:(controllerIndex > tabBarController.selectedIndex ? UIViewAnimationOptionTransitionCurlUp : UIViewAnimationOptionTransitionCurlDown)
//    //                    completion:^(BOOL finished) {
//    //                        if (finished) {
//    //                            tabBarController.selectedIndex = controllerIndex;
//    //                        }
//    //                    }];
//
//    //  ref: http://stackoverflow.com/a/5180104
//    //  ref: http://stackoverflow.com/a/26896392
//    //    // Disable interaction during animation to avoids bugs.
//    //    tabBarController.view.userInteractionEnabled = NO;
//    //
//    //    // Get the views.
//    //    UIView * fromView = tabBarController.selectedViewController.view;
//    //    UIView * toView = [[tabBarController.viewControllers objectAtIndex:controllerIndex] view];
//    //
//    //    // Get the size of the view area.
//    //    CGRect viewSize = fromView.frame;
//    //    BOOL scrollRight = controllerIndex > tabBarController.selectedIndex;
//    //
//    //    // Add the to view to the tab bar view.
//    //    [fromView.superview addSubview:toView];
//    //    [fromView.superview addSubview:fromView];
//    //
//    //    tabBarController.selectedIndex = 0;
//    //
//    //    // Position it off screen.
//    //    toView.frame = CGRectMake((scrollRight ? (viewSize.size.width *.25) : -(viewSize.size.width * .25 )), viewSize.origin.y, viewSize.size.width, viewSize.size.height);
//    //
//    //    [UIView animateWithDuration:0.25
//    //                     animations: ^{
//    //                         // Animate the views on and off the screen.
//    //                         [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
//    //                         fromView.frame = CGRectMake(viewSize.size.width * .95, viewSize.origin.y, viewSize.size.width, viewSize.size.height);
//    //                         toView.frame = CGRectMake((viewSize.origin.x * .90), viewSize.origin.y, viewSize.size.width, viewSize.size.height);
//    //                     }
//    //
//    //                     completion:^(BOOL finished) {
//    //                         if (finished) {
//    //                             // Being new animation.
//    //                             [UIView animateWithDuration:0.2
//    //                                              animations: ^{
//    //                                                  [UIView setAnimationCurve:UIViewAnimationCurveLinear];
//    //                                                  fromView.frame = CGRectMake(viewSize.size.width, viewSize.origin.y, viewSize.size.width, viewSize.size.height);
//    //                                                  toView.frame = CGRectMake((viewSize.origin.x), viewSize.origin.y, viewSize.size.width, viewSize.size.height);
//    //                                              }
//    //                                              completion:^(BOOL finished) {
//    //                                                  if (finished) {
//    //                                                      // Remove the old view from the tabbar view.
//    //                                                      [fromView removeFromSuperview];
//    //                                                      // Restore interaction.
//    //                                                      self.tabBarController.view.userInteractionEnabled = YES;
//    //                                                  }
//    //                                              }];
//    //                         }
//    //                     }];
//    //
//    return nil;
//}
//- (void)tabBarController:(UITabBarController *)tabBarController willBeginCustomizingViewControllers:(NSArray<__kindof UIViewController *> *)viewControllers
//{
//    XL_enter();
//    for (UIViewController *vc in viewControllers)
//    {
//        XLM_info(@"vc: %@", vc.description);
//        XLM_info(@"OMG vc willbegin!");
//    }
//}


@end
