//
//  UITabBar+IGOCenterButton.h
//  igolive
//
//  Created by Dev on 9/17/16.
//  Copyright © 2016 iGoLive LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITabBar (IGOCenterButton)

// 设置个性化中间按钮 ('Personalize middle button')
//- (void)setUpTabBarCenterButton:(void ( ^ _Nullable )(UIButton * _Nullable centerButton ))centerButtonBlock;

- (void)setInitCenterBtnPropertiesWithClickBlock:(void(^ _Nonnull)())clickBlock;
- (void)setSubviewBarButtonFrames; // not in use
- (void)setInitBackgroundImgProperties;
- (void)setInitCenterBtnProperties;

@end
