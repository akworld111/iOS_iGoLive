//
//  Common.h
//  iphoneLive
//
//  Created by AK on 17/2/3.
//  Copyright © 2016年 cat. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Common : NSObject

+ (UIImage *)createImageWithColor:(UIColor *)color;

//set corner radius for only top|bottom left|right corner of a UIView
+ (UIView *)roundCornersOnView:(UIView *)view onTopLeft:(BOOL)tl topRight:(BOOL)tr bottomLeft:(BOOL)bl bottomRight:(BOOL)br radius:(float)radius;

+ (NSString *)getGenderImageNameWithType:(NSString *)type;

+ (NSString *)getEllipseImageNameWithLevle:(NSString *)levle;

+ (NSString *)getHeartImageNameWithLevle:(NSString *)levle;

+ (NSString *)clearNil:(NSString *)string;

+ (NSString *)getInterestsWithTag:(long)tag;

+ (NSData *)compressImage:(UIImage *)image;

+ (NSString *)countNumAndChangeformat:(NSString *)num;

+ (NSString *)likeStringWithNum:(long)num;
@end
