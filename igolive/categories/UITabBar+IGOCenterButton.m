//
//  UITabBar+IGOCenterButton.m
//  igolive
//
//  Created by Dev on 9/17/16.
//  Copyright © 2016 iGoLive LLC. All rights reserved.
//

#import "UITabBar+IGOCenterButton.h"
#import <objc/runtime.h>

#define kScreenW [UIScreen mainScreen].bounds.size.width

@implementation UITabBar (IGOCenterButton)

static UIButton *centerButton;
typedef void (^CenterBtnClickBlock)();
CenterBtnClickBlock centerBtnClickBlock;

- (void)setInitBackgroundImgProperties
{
    // note: cannot simply call [self.tabBar setBackgroundImage:]
    //  tabBar.backgroundImage seems to always be 'tiled to fit'
    //  and we need the image to extend above the top bounds a little bit
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, -3, self.frame.size.width, self.frame.size.height)];
    [imageView setImage:[UIImage imageNamed:f_imgTabBar]];
    [imageView setContentMode:UIViewContentModeCenter];
    [self insertSubview:imageView atIndex:0];
}
- (void)setInitCenterBtnPropertiesWithClickBlock:(void(^ _Nonnull)())clickBlock
{
    centerBtnClickBlock = clickBlock;
    [self setInitCenterBtnProperties];
}
- (void)setInitCenterBtnProperties
{
    XL_enter();
    
    // add center button overlay
    if (!centerButton) {
        centerButton = [UIButton buttonWithType:UIButtonTypeCustom];
        
        // set background image
        [centerButton setBackgroundImage:[UIImage imageNamed:@"Livestream_button"] forState:UIControlStateNormal];
        [centerButton setBackgroundImage:[UIImage imageNamed:@"Livestream_button"] forState:UIControlStateSelected];
        [centerButton setContentMode:UIViewContentModeScaleAspectFill];
        
        // set frame and bounds correctly (iOS 10)
        CGRect frame = centerButton.frame;
        centerButton.frame = CGRectMake(frame.origin.x, 0, frame.size.width, frame.size.height);
        centerButton.bounds = CGRectMake(0, 0, centerButton.currentBackgroundImage.size.width, centerButton.currentBackgroundImage.size.height);
        XLM_alert(@"centerButton.bounds: %@\n centerButton.frame: %@\n\n\n", CGRectString(centerButton.bounds), CGRectString(centerButton.frame));
        
        // center the button
        centerButton.center = CGPointMake(self.frame.size.width * 0.5, self.frame.size.height * 0.4);
        
        // add touch handler
        
        [centerButton addTarget:self action:@selector(onCenterBtnClick) forControlEvents:UIControlEventTouchUpInside];
        
        // add it to the tabbar
        [self addSubview:centerButton];
    }
    
    // disable native center button
    self.items[2].enabled = NO;
    

}
- (void)onCenterBtnClick
{
    [MBProgressHUD showMessage:@"Loading..."];
    [HttpService getLevelLimitWithResult:^(CommonReturn *commonReturn) {
        [MBProgressHUD hideHUD];
        if (commonReturn.state == 1) {
            if (centerBtnClickBlock)
            {
                centerBtnClickBlock();
            }
        }
        else
        {
            XLM_error(@"getLevelLimitWithResult request failed; presenting error alert view");
            [AlertViewHelpers presentAlertWithTitle:@"Network Error : /" message:@"Please try again ; )" delegate:nil];
        }
    }];
}
- (void)tintColorDidChange
{
    XLM_alert(@"_enter_ UITabBar (XZMTabbarExtension)");
}

////////////////////////////////////////////////////////////////////////
#pragma mark - KNOWLEDGEBASE
////////////////////////////////////////////////////////////////////////
/** NOTE_09.16.16 _ KNOWLEDGEBASE _
 *  legacy tab bar category code left over for syntax and simantecs knowledge base (XZMTabbarExtension)
 *   specifically... 
 *      dispatch_once w/ 
 *          class_getInstanceMethod([self class], @selector(layoutSubviews));
 *          class_getInstanceMethod([self class], @selector(swizzled_layoutSubviews));
 *          method_exchangeImplementations(...)
 *      objc_setAssociatedObject(...)
 *      objc_getAssociatedObject(self, &AssociatedButtonKey);
 *      - (void)setUpTabBarCenterButton:(void ( ^ _Nullable )(UIButton * _Nullable centerButton ))centerButtonBlock
 */
/*
    static NSString *AssociatedButtonKey;
    + (void)load {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            Method originalMethod = class_getInstanceMethod([self class], @selector(layoutSubviews));
            Method swizzledMethod = class_getInstanceMethod([self class], @selector(swizzled_layoutSubviews));
            method_exchangeImplementations(originalMethod, swizzledMethod);
        });
    }
    - (instancetype)initWithFrame:(CGRect)frame
    {
        if (self = [super initWithFrame:frame]) {
            
    //        UIButton  *centerButton = objc_getAssociatedObject(self, &AssociatedButtonKey);
            
    //        if (!centerButton) {
    //            centerButton = [UIButton buttonWithType:UIButtonTypeCustom];
    ////            objc_setAssociatedObject(self, &AssociatedButtonKey, centerButton, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    //        }
    //    
    //        [self addSubview:centerButton];
        }
        
        return self;
    }
    - (void)setUpTabBarCenterButton:(void ( ^ _Nullable )(UIButton * _Nullable centerButton ))centerButtonBlock
    {
        //    centerButtonBlock(objc_getAssociatedObject(self, &AssociatedButtonKey));
        centerButtonBlock(centerButton);
    }
    - (void)swizzled_layoutSubviews
    {
        // legacy note_09.16.16: logs do not change before/after setValue (i don't think we need this anymore)
        XLM_alert(@"(BEFORE [self setValue:[NSValue valueWithCGRect:self.bounds] forKeyPath:@\"_backgroundView.frame\"])\n self.bounds: %@\n self.frame: %@\n\n\n", CGRectString(self.bounds), CGRectString(self.frame));
        [self setValue:[NSValue valueWithCGRect:self.bounds] forKeyPath:@"_backgroundView.frame"];
        XLM_alert(@"(AFTER [self setValue:[NSValue valueWithCGRect:self.bounds] forKeyPath:@\"_backgroundView.frame\"])\n self.bounds: %@\n self.frame: %@\n\n\n", CGRectString(self.bounds), CGRectString(self.frame));
 
        //UIButton  *centerButton = objc_getAssociatedObject(self, &AssociatedButtonKey);
    }
 */

/* NOTE_09.16.16: this function's code was pulled from the legacy XZMTabbarExtension
     this function was created to be called in the tab bar controller's viewDidAppear:
      for fixing the bug where the tab bar buttons were not being rendered in iOS 10
 
     after re-design of the entire custom tab bar model, this function is no longer needed
      as the UITabBarController and child dependent classes now appear to all be rendering correctly
 
     maintaining this code for reference (potentially in other situations)
 */
- (void)setSubviewBarButtonFrames // not in use
{
    XL_enter();
    CGFloat buttonW = kScreenW / 5;
    CGFloat buttonH = self.frame.size.height;
    CGFloat buttonY = 0;
    CGFloat buttonX = 0;
    int index = 0;
    for (UIView *subview in self.subviews) {
        if ([subview isKindOfClass:NSClassFromString(@"UITabBarButton")]) {
            if (index == 2) {
                index++;
            }
            
            buttonX = index * buttonW;
            
            XLM_alert(@"subview index: %d\n\n subview bounds: %@\n subview frame: %@\n\n self.bounds: %@\n self.frame: %@\n\n\n", index, CGRectString(subview.bounds), CGRectString(subview.frame), CGRectString(self.bounds), CGRectString(self.frame));
            
            subview.frame = CGRectMake(buttonX, buttonY+6, buttonW, buttonH);
            //[ViewModifierHelpers setBorderWidth:2.0f color:[UIColor whiteColor].CGColor forView:subview];
            
            [subview setNeedsLayout];
            [subview layoutIfNeeded];
            XLM_alert(@"subview index: %d\n\n subview bounds: %@\n subview frame: %@\n\n self.bounds: %@\n self.frame: %@\n\n\n", index, CGRectString(subview.bounds), CGRectString(subview.frame), CGRectString(self.bounds), CGRectString(self.frame));
            
            index++;
        }
    }
}

@end



