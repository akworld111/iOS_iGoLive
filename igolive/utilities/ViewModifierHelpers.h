//
//  ViewModifierHelpers.h
//  igolive
//
//  Created by greenhouse on 8/24/16.
//  Copyright © 2016 iGoLive LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ViewModifierHelpers : NSObject

+ (void)setDefaultDropShadowForView:(UIView*)view;
+ (void)setDefaultDropShadowForChannelStreamCell:(UIView*)view;
+ (void)setDropShadowForWZCell:(UIView*)view;
+ (void)setDropShadowSize:(CGSize)size forView:(UIView*)view;
+ (void)removeDropShadowForView:(UIView*)view;

+ (void)setTabBarItemTitleNilWithImgOffset:(UITabBarItem*)item;
+ (CGFloat)getFrameCenterX:(CGRect)frame;
+ (CGFloat)getFrameCenterY:(CGRect)frame;
+ (UIImage *)uiimageFromColor:(UIColor *)color;
+ (void)setTextField:(UITextField*)tf phColor:(UIColor*)phcolor textColor:(UIColor*)textcolor;
+ (void)setCornerRadius:(CGFloat)radius forView:(UIView*)view;
+ (void)removeCornerRadiusForView:(UIView*)view;
+ (void)setBorderWidth:(CGFloat)width color:(CGColorRef)color forView:(UIView*)view;
+ (void)setBorderWidth:(CGFloat)width forView:(UIView*)view;
+ (void)setBorderColor:(CGColorRef)color forView:(UIView*)view;


+ (void)addGradientColorFadeSubLayerToView:(UIView*)view;
+ (void)addGradientColorDownUpFadedSubLayerToView:(UIView*)view hexColorStart:(int)hexstart hexColorEnd:(int)hexend;
+ (void)addGradientColorRightLeftFadedSubLayerToView:(UIView*)view hexColorStart:(int)hexstart hexColorEnd:(int)hexend;
+ (void)addGradientColorFadedSubLayerToView:(UIView*)view hexColorStart:(int)hexstart hexColorEnd:(int)hexend;
+ (void)addGradientColorFadedSubLayerToNavBarView:(UINavigationBar*)navbar hexColorStart:(int)hexstart hexColorEnd:(int)hexend;


+ (CGRect)getNavigatoinBarHeaderFrame:(UINavigationBar*)navbar;
+ (UIImage*)uiimageFromView:(UIView*)view;
+ (UIImage*)blurredImageFromView:(UIView*)view withBlurRadius:(CGFloat)radius;
+ (UIImage*)blurredImageFromImage:(UIImage*)image withBlurRadius:(CGFloat)radius;


@end


