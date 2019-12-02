//
//  ViewModifierHelpers.m
//  igolive
//
//  Created by greenhouse on 8/24/16.
//  Copyright © 2016 iGoLive LLC. All rights reserved.
//

#import "ViewModifierHelpers.h"

@implementation ViewModifierHelpers

+ (void)setDefaultDropShadowForView:(UIView*)view
{
    // set drop shadow
    UIBezierPath *shadowPathTop = [UIBezierPath bezierPathWithRect:view.bounds];
    view.layer.masksToBounds = NO;
    view.layer.shadowColor = [UIColor blackColor].CGColor;
    view.layer.shadowOffset = CGSizeMake(3.0f, 3.0f);
    view.layer.shadowOpacity = 0.2f;
    view.layer.shadowPath = shadowPathTop.CGPath;
    view.layer.shadowRadius = 0.0f; // blur effect (defaults to 3)
}
+ (void)setDefaultDropShadowForChannelStreamCell:(UIView*)view
{
    // set drop shadow
    UIBezierPath *shadowPathTop = [UIBezierPath bezierPathWithRect:view.bounds];
    view.layer.masksToBounds = NO;
    view.layer.shadowColor = [UIColor blackColor].CGColor;
    view.layer.shadowOffset = CGSizeMake(2.0f, 1.0f);
    view.layer.shadowOpacity = 0.7f;
    view.layer.shadowPath = shadowPathTop.CGPath;
    view.layer.shadowRadius = 3.0f; // blur effect (defaults to 3)
}
+ (void)setDropShadowForWZCell:(UIView*)view
{
    // set drop shadow
    UIBezierPath *shadowPathTop = [UIBezierPath bezierPathWithRect:view.bounds];
    view.layer.masksToBounds = NO;
    view.layer.shadowColor = UIColorFromHexAlpha(0xA5A5A5, 1.0f).CGColor;
    view.layer.shadowOffset = CGSizeMake(3.0f, 3.0f);
    view.layer.shadowOpacity = 0.2f;
    view.layer.shadowPath = shadowPathTop.CGPath;
    view.layer.shadowRadius = 0.0f; // blur effect (defaults to 3)
}
+ (void)setDropShadowSize:(CGSize)size forView:(UIView*)view
{
    UIBezierPath *shadowPath = [UIBezierPath bezierPathWithRect:view.bounds];
    view.layer.masksToBounds = NO;
    view.layer.shadowColor = [UIColor blackColor].CGColor;
    view.layer.shadowOffset = size;
    view.layer.shadowOpacity = 0.65f;
    view.layer.shadowPath = shadowPath.CGPath;
}
+ (void)removeDropShadowForView:(UIView*)view
{
    //    view.layer.masksToBounds = NO;
    view.layer.shadowColor = nil;
    view.layer.shadowOffset = CGSizeMake(0.0f, 0.0f);
    view.layer.shadowOpacity = 0.0f;
    view.layer.shadowPath = nil;
}

+ (void)setTabBarItemTitleNilWithImgOffset:(UITabBarItem*)item
{
    if (!item)
    {
        XLM_error(@"item is nil; returning");
        return;
    }
    
    NSString *title = item.title;
    if (title)
    {
        XLM_warning(@"item.title = %@; setting item.title to nil", title);
        title = nil;
    }
    
    int offset = 7;
    UIEdgeInsets imageInset = UIEdgeInsetsMake(offset, 0, -offset, 0);
    item.imageInsets = imageInset;
}
+ (CGFloat)getFrameCenterX:(CGRect)frame
{
    return frame.origin.x + (frame.size.width / 2);
    
}
+ (CGFloat)getFrameCenterY:(CGRect)frame
{
    return frame.origin.y + (frame.size.height / 2);
}

// ref: http://stackoverflow.com/a/24615631/2298002
+ (UIImage *)uiimageFromColor:(UIColor *)color {
    CGRect rect = CGRectMake(0, 0, 1, 1);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

+ (void)setTextField:(UITextField*)tf phColor:(UIColor*)phcolor textColor:(UIColor*)textcolor
{
    // create colored placeholder string
    NSAttributedString *strplaceholder = [[NSAttributedString alloc] initWithString:tf.placeholder attributes:@{NSForegroundColorAttributeName:phcolor}];
    
    tf.attributedPlaceholder = strplaceholder;
    tf.textColor = textcolor;
}

+ (void)setCornerRadius:(CGFloat)radius forView:(UIView*)view
{
    [view.layer setCornerRadius:radius];
    [view.layer setMasksToBounds:YES];
}
+ (void)removeCornerRadiusForView:(UIView*)view
{
    [view.layer setCornerRadius:0.0f];
    [view.layer setMasksToBounds:YES];
}
+ (void)setBorderWidth:(CGFloat)width color:(CGColorRef)color forView:(UIView*)view
{
    [ViewModifierHelpers setBorderWidth:width forView:view];
    [ViewModifierHelpers setBorderColor:color forView:view];
}
+ (void)setBorderWidth:(CGFloat)width forView:(UIView*)view
{
    [view.layer setBorderWidth:width];
}
+ (void)setBorderColor:(CGColorRef)color forView:(UIView*)view
{
    [view.layer setBorderColor:color];
}
+ (void)addGradientColorFadeSubLayerToView:(UIView*)view
{
    
    //Option 1 for creating start and end colors
    //    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    //    CGFloat color1[4] = {0.0, 0.0, 0.0, 1.0};
    //    CGFloat color2[4] = {1.0, 1.0, 1.0, 1.0};
    //    CGColorRef start = CGColorCreate(colorSpace, color1);
    //    CGColorRef end = CGColorCreate(colorSpace, color2);
    
    //Option 2 for creating start and end colors
    //DimGray
    CGColorRef start = UIColorFromHexAlpha(0xFF696969, 1.0f).CGColor;
    CGColorRef end = UIColorFromHexAlpha(0xFF696969, 0.0f).CGColor;
    
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = view.bounds;
    gradient.colors = [NSArray arrayWithObjects:(__bridge id)start, (__bridge id)end, nil];
    
    // NOTE:
    //  for iOS: (0.0, 0.0) = top left of view & (1.0, 1.0) is bot right of view
    //  for OSx: (0.0, 0.0) = bot left of view & (1.0, 1.0) is top right of view
    //
    // startPoint: first color the view with 'start' from x:0.0 to x:1.0 and y:0.0 to y:1.0
    // endPoint: then fade the view with 'end' from x:1.0 to x:1.0 and y:1.0 to y:0.0
    gradient.startPoint = CGPointMake(1.0, 1.0); // dx & dy from init:(0.0, 0.0)
    gradient.endPoint = CGPointMake(1.0, 0.0);  // dx & dy from set:(1.0, 1.0)
    
    // add gradient color layer as a sub layer to the view
    [view.layer insertSublayer:gradient atIndex:0];
}
// this is down to up
+ (void)addGradientColorDownUpFadedSubLayerToView:(UIView*)view hexColorStart:(int)hexstart hexColorEnd:(int)hexend
{
    
    //Option 1 for creating start and end colors
    //    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    //    CGFloat color1[4] = {0.0, 0.0, 0.0, 1.0};
    //    CGFloat color2[4] = {1.0, 1.0, 1.0, 1.0};
    //    CGColorRef start = CGColorCreate(colorSpace, color1);
    //    CGColorRef end = CGColorCreate(colorSpace, color2);
    
    //Option 2 for creating start and end colors
    //DimGray
    //    CGColorRef start = UIColorFromHexAlpha(0xFF696969, 1.0f).CGColor;
    //    CGColorRef end = UIColorFromHexAlpha(0xFF696969, 0.0f).CGColor;
    
    CGColorRef start = UIColorFromHexAlpha(hexstart, 1.0f).CGColor;
    CGColorRef end = UIColorFromHexAlpha(hexend, 1.0f).CGColor;
    
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = view.bounds;
    gradient.colors = [NSArray arrayWithObjects:(__bridge id)start, (__bridge id)end, nil];
    
    // NOTE:
    //  for iOS: (0.0, 0.0) = top left of view & (1.0, 1.0) is bot right of view
    //  for OSx: (0.0, 0.0) = bot left of view & (1.0, 1.0) is top right of view
    //
    // startPoint: first color the view with 'start' from x:0.0 to x:1.0 and y:0.0 to y:1.0
    // endPoint: then fade the view with 'end' from x:1.0 to x:1.0 and y:1.0 to y:0.0
    //    gradient.startPoint = CGPointMake(1.0, 0.0); // full start & end colors from left to right
    //    gradient.endPoint = CGPointMake(1.0, 1.0);  // fade start color to end color from top to bottom
    
    gradient.startPoint = CGPointMake(1.0, 1.0); // full start & end colors from left to right
    gradient.endPoint = CGPointMake(1.0, 0.0);  // fade start color to end color from top to bottom
    
    // add gradient color layer as a sub layer to the view
    [view.layer insertSublayer:gradient atIndex:0];
    
//    [view setNeedsLayout];
//    [view setNeedsDisplay];
//    [view layoutIfNeeded];
}
// start color starts full y space on right, then fades the full y space to end color on left
+ (void)addGradientColorRightLeftFadedSubLayerToView:(UIView*)view hexColorStart:(int)hexstart hexColorEnd:(int)hexend
{
    
    //Option 1 for creating start and end colors
    //    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    //    CGFloat color1[4] = {0.0, 0.0, 0.0, 1.0};
    //    CGFloat color2[4] = {1.0, 1.0, 1.0, 1.0};
    //    CGColorRef start = CGColorCreate(colorSpace, color1);
    //    CGColorRef end = CGColorCreate(colorSpace, color2);
    
    //Option 2 for creating start and end colors
    //DimGray
    //    CGColorRef start = UIColorFromHexAlpha(0xFF696969, 1.0f).CGColor;
    //    CGColorRef end = UIColorFromHexAlpha(0xFF696969, 0.0f).CGColor;
    
    CGColorRef start = UIColorFromHexAlpha(hexstart, 1.0f).CGColor;
    CGColorRef end = UIColorFromHexAlpha(hexend, 1.0f).CGColor;
    
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = view.bounds;
    gradient.colors = [NSArray arrayWithObjects:(__bridge id)start, (__bridge id)end, nil];
    
    // NOTE:
    //  for iOS: (0.0, 0.0) = top left of view & (1.0, 1.0) is bot right of view
    //  for OSx: (0.0, 0.0) = bot left of view & (1.0, 1.0) is top right of view
    //
    // startPoint: first color the view with 'start' from x:0.0 to x:1.0 and y:0.0 to y:1.0
    // endPoint: then fade the view with 'end' from x:1.0 to x:1.0 and y:1.0 to y:0.0
    //    gradient.startPoint = CGPointMake(1.0, 0.0); // full start & end colors from left to right
    //    gradient.endPoint = CGPointMake(1.0, 1.0);  // fade start color to end color from top to bottom
    
    gradient.startPoint = CGPointMake(1.0, 1.0); // full start & end colors from left to right
    gradient.endPoint = CGPointMake(0.0, 1.0);  // fade start color to end color from top to bottom
    
    // add gradient color layer as a sub layer to the view
    [view.layer insertSublayer:gradient atIndex:0];
}
// this is right to left
+ (void)addGradientColorFadedSubLayerToView:(UIView*)view hexColorStart:(int)hexstart hexColorEnd:(int)hexend
{
    
    //Option 1 for creating start and end colors
    //    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    //    CGFloat color1[4] = {0.0, 0.0, 0.0, 1.0};
    //    CGFloat color2[4] = {1.0, 1.0, 1.0, 1.0};
    //    CGColorRef start = CGColorCreate(colorSpace, color1);
    //    CGColorRef end = CGColorCreate(colorSpace, color2);
    
    //Option 2 for creating start and end colors
    //DimGray
    //    CGColorRef start = UIColorFromHexAlpha(0xFF696969, 1.0f).CGColor;
    //    CGColorRef end = UIColorFromHexAlpha(0xFF696969, 0.0f).CGColor;
    
    CGColorRef start = UIColorFromHexAlpha(hexstart, 1.0f).CGColor;
    CGColorRef end = UIColorFromHexAlpha(hexend, 0.75f).CGColor;
    
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = view.bounds;
    gradient.colors = [NSArray arrayWithObjects:(__bridge id)start, (__bridge id)end, nil];
    
    // NOTE:
    //  for iOS: (0.0, 0.0) = top left of view & (1.0, 1.0) is bot right of view
    //  for OSx: (0.0, 0.0) = bot left of view & (1.0, 1.0) is top right of view
    //
    // startPoint: first color the view with 'start' from x:0.0 to x:1.0 and y:0.0 to y:1.0
    // endPoint: then fade the view with 'end' from x:1.0 to x:1.0 and y:1.0 to y:0.0
//    gradient.startPoint = CGPointMake(1.0, 0.0); // full start & end colors from left to right
//    gradient.endPoint = CGPointMake(1.0, 1.0);  // fade start color to end color from top to bottom
    
    gradient.startPoint = CGPointMake(1.0, 1.0); // full start & end colors from left to right
    gradient.endPoint = CGPointMake(0.0, 1.0);  // fade start color to end color from top to bottom
    
    // add gradient color layer as a sub layer to the view
    [view.layer insertSublayer:gradient atIndex:0];
}
+ (void)addGradientColorFadedSubLayerToNavBarView:(UINavigationBar*)navbar hexColorStart:(int)hexstart hexColorEnd:(int)hexend
{
    // create header bar frame to edit
    UIApplication *app = [UIApplication sharedApplication];
    CGFloat statusBarHeight = app.statusBarFrame.size.height; // get status bar height
    CGFloat navBarHeight = navbar.frame.size.height; // get navbar height
    CGFloat headerHeight = statusBarHeight + navBarHeight; // get header height
    CGRect headerFrame = CGRectMake(0, -statusBarHeight, [UIScreen mainScreen].bounds.size.width, headerHeight);
    
    // create header view out of frame to add gradient to
    UIView *headerBarView = [[UIView alloc] initWithFrame:headerFrame];
    [headerBarView setUserInteractionEnabled:NO];
    
    
    CGColorRef start = UIColorFromHexAlpha(hexstart, 1.0f).CGColor;
    CGColorRef end = UIColorFromHexAlpha(hexend, 0.75f).CGColor;
    
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = headerBarView.bounds;
    gradient.colors = [NSArray arrayWithObjects:(__bridge id)start, (__bridge id)end, nil];
    
    // NOTE:
    //  for iOS: (0.0, 0.0) = top left of view & (1.0, 1.0) is bot right of view
    //  for OSx: (0.0, 0.0) = bot left of view & (1.0, 1.0) is top right of view
    //
    // startPoint: first color the view with 'start' from x:0.0 to x:1.0 and y:0.0 to y:1.0
    // endPoint: then fade the view with 'end' from x:1.0 to x:1.0 and y:1.0 to y:0.0
    //    gradient.startPoint = CGPointMake(1.0, 0.0); // full start & end colors from left to right
    //    gradient.endPoint = CGPointMake(1.0, 1.0);  // fade start color to end color from top to bottom
    
    gradient.startPoint = CGPointMake(1.0, 1.0); // full start & end colors from left to right
    gradient.endPoint = CGPointMake(0.0, 1.0);  // fade start color to end color from top to bottom
    
    // add gradient color layer as a sub layer to the view
    [headerBarView.layer insertSublayer:gradient atIndex:0];
    
    // replace red background view
    //  note: can't figure out where this '0' index red background is being set,
    //          so we are changing the color to white
    UIView *red = (UIView*)[navbar.subviews objectAtIndex:0];
    [red setBackgroundColor:[UIColor whiteColor]];
    
    // add headerBarView with gradient color to the very back the navbar
    [navbar insertSubview:headerBarView atIndex:1];
}
+ (CGRect)getNavigatoinBarHeaderFrame:(UINavigationBar*)navbar
{
    // create header bar frame to edit
    UIApplication *app = [UIApplication sharedApplication];
    CGFloat statusBarHeight = app.statusBarFrame.size.height;
    CGFloat navBarHeight = navbar.frame.size.height;
    CGFloat headerHeight = statusBarHeight + navBarHeight;
    CGRect headerFrame = CGRectMake(0, -statusBarHeight, [UIScreen mainScreen].bounds.size.width, headerHeight);
    
    return headerFrame;
}
+ (UIImage*)uiimageFromView:(UIView*)view
{
    // Create the image context (size, opaque, scale = 1.0f reg || 2.0f retina)
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, NO, 2.0f);
    
    // There he is! The new API method
    [view drawViewHierarchyInRect:view.frame afterScreenUpdates:NO];
    
    // Get the snapshot
    UIImage *snapshotImage = UIGraphicsGetImageFromCurrentImageContext();
    
//    UIImage *blurredSnapshotImage = [self blurredImageFromImage:snapshotImage withBlurRadius:radius];
    
    // Be nice and clean your mess up
    UIGraphicsEndImageContext();
    
    return snapshotImage;
}
+ (UIImage*)blurredImageFromView:(UIView*)view withBlurRadius:(CGFloat)radius
{
    // Create the image context (size, opaque, scale = 1.0f reg || 2.0f retina)
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, NO, 2.0f);
    
    // There he is! The new API method
    [view drawViewHierarchyInRect:view.frame afterScreenUpdates:NO];
    
    // Get the snapshot
    UIImage *snapshotImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIImage *blurredSnapshotImage = [self blurredImageFromImage:snapshotImage withBlurRadius:radius];
    
    // Be nice and clean your mess up
    UIGraphicsEndImageContext();
    
    return blurredSnapshotImage;
}
+ (UIImage*)blurredImageFromImage:(UIImage*)image withBlurRadius:(CGFloat)radius
{
    // ***********If you need re-orienting (e.g. trying to blur a photo taken from the device camera front facing camera in portrait mode)
    // theImage = [self reOrientIfNeeded:theImage];
    
    // create our blurred image
    CIContext *context = [CIContext contextWithOptions:nil];
    CIImage *inputImage = [CIImage imageWithCGImage:image.CGImage];
    
    // setting up Gaussian Blur (we could use one of many filters offered by Core Image)
    CIFilter *filter = [CIFilter filterWithName:@"CIGaussianBlur"];
    [filter setValue:inputImage forKey:kCIInputImageKey];
    [filter setValue:[NSNumber numberWithFloat:radius] forKey:kCIInputRadiusKey];
    CIImage *result = [filter valueForKey:kCIOutputImageKey];
    
    // CIGaussianBlur has a tendency to shrink the image a little,
    // this ensures it matches up exactly to the bounds of our original image
    CGImageRef cgImage = [context createCGImage:result fromRect:[inputImage extent]];
    
    // Create UIImage for this function to "return" so that ARC can manage the memory of the blur...
    //    UIImage *returnImage = [UIImage imageWithCGImage:cgImage scale:image.scale orientation:image.imageOrientation];
    UIImage *returnImage = [UIImage imageWithCGImage:cgImage];
    
    // ARC can't manage CGImageRefs so we need to release it before this function "returns" and ends.
    CGImageRelease(cgImage);//release CGImageRef because ARC doesn't manage this on its own.
    
    return returnImage;
}

@end




