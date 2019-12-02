//
//  Common.m
//  iphoneLive
//
//  Created by AK on 17/2/3.
//  Copyright © 2016年 cat. All rights reserved.
//

#import "Common.h"
#import "ProfileSetupViewController.h"

@implementation Common

+ (UIImage *)createImageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return theImage;
}

//set corner radius for only top|bottom left|right corner of a UIView
+(UIView *)roundCornersOnView:(UIView *)view onTopLeft:(BOOL)tl topRight:(BOOL)tr bottomLeft:(BOOL)bl bottomRight:(BOOL)br radius:(float)radius {
    
    if (tl || tr || bl || br) {
        UIRectCorner corner = 0; //holds the corner
        //Determine which corner(s) should be changed
        if (tl) {
            corner = corner | UIRectCornerTopLeft;
        }
        if (tr) {
            corner = corner | UIRectCornerTopRight;
        }
        if (bl) {
            corner = corner | UIRectCornerBottomLeft;
        }
        if (br) {
            corner = corner | UIRectCornerBottomRight;
        }
        
        UIView *roundedView = view;
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:roundedView.bounds byRoundingCorners:corner cornerRadii:CGSizeMake(radius, radius)];
        CAShapeLayer *maskLayer = [CAShapeLayer layer];
        maskLayer.frame = roundedView.bounds;
        maskLayer.path = maskPath.CGPath;
        roundedView.layer.mask = maskLayer;
        
        return roundedView;
    } else {
        return view;
    }
}

+ (NSString *)getGenderImageNameWithType:(NSString *)type {
    
    if ([type isEqualToString:@"1"]) {
        return @"male_gender";
    } else if ([type isEqualToString:@"2"]) {
        return @"female_gender";
    } else {
        return @"female_gender";
    }
}

+ (NSString *)getEllipseImageNameWithLevle:(NSString *)levle {
    
    switch ([levle intValue]) {
        case 1:
            return @"green_ellipse";
            break;
        case 2:
            return @"teal_ellipse";
            break;
        case 3:
            return @"blue_ellipse";
            break;
        case 4:
            return @"purple_ellipse";
            break;
        case 5:
            return @"pink_ellipse";
            break;
        case 6:
            return @"red_ellipse";
            break;
        case 7:
            return @"orange_ellipse";
            break;
        case 8:
            return @"bronze_ellipse";
            break;
        case 9:
            return @"silver_ellipse";
            break;
        case 10:
            return @"gold_ellipse";
            break;
        default:
            return @"";
            break;
    }
}

+ (NSString *)getHeartImageNameWithLevle:(NSString *)levle {
    return [NSString stringWithFormat:@"heart_%@",levle];
}

+ (NSString *)clearNil:(NSString *)string {
    return string?:@"";
}

+ (NSString *)getInterestsWithTag:(long)tag
{
    switch (tag) {
        case 501:
        {
            return @"ACTING";
        }
            break;
        case 502:
        {
            return @"MODELING";
        }
            break;
        case 503:
        {
            return @"SINGING";
        }
            break;
        case 504:
        {
            return @"DANCING";
        }
            break;
        case 505:
        {
            return @"FAHING";
        }
            break;
        case 506:
        {
            return @"NEWS";
        }
            break;
        case 507:
        {
            return @"BEAUTY";
        }
            break;
        case 508:
        {
            return @"TECH";
        }
            break;
            
        default:
        {
            return @"SPORTS";
        }
            break;
    }
}

+ (NSData *)compressImage:(UIImage *)image {
    CGSize size = [self scaleSize:image.size];
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage * scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    NSUInteger maxFileSize = 500 * 1024;
    CGFloat compressionRatio = 0.7f;
    CGFloat maxCompressionRatio = 0.1f;
    
    NSData *imageData = UIImageJPEGRepresentation(scaledImage, compressionRatio);
    
    while (imageData.length > maxFileSize && compressionRatio > maxCompressionRatio) {
        compressionRatio -= 0.1f;
        imageData = UIImageJPEGRepresentation(image, compressionRatio);
    }
    
    return imageData;
}

+ (CGSize)scaleSize:(CGSize)sourceSize {
    float width = sourceSize.width;
    float height = sourceSize.height;
    if (width >= height) {
        return CGSizeMake(800, 800 * height / width);
    } else {
        return CGSizeMake(800 * width / height, 800);
    }
}

+ (NSString *)countNumAndChangeformat:(NSString *)num {
    int count = 0;
    long long int a = num.longLongValue;
    while (a != 0)
    {
        count++;
        a /= 10;
    }
    NSMutableString *string = [NSMutableString stringWithString:[NSString stringWithFormat:@"%@",num]];
    NSMutableString *newstring = [NSMutableString string];
    while (count > 3)
    {
        count -= 3;
        NSRange rang = NSMakeRange(string.length - 3, 3);
        NSString *str = [string substringWithRange:rang];
        [newstring insertString:str atIndex:0];
        [newstring insertString:@"," atIndex:0];
        [string deleteCharactersInRange:rang];
    }
    [newstring insertString:string atIndex:0];
    return newstring;
}

+ (NSString *)likeStringWithNum:(long)num {
    if (num < 10000) {
        return [NSString stringWithFormat:@"%ld",num];
    } else if (num < 1000000) {
        return [NSString stringWithFormat:@"%.1fK",num / 1000.0];
    } else {
        return [NSString stringWithFormat:@"%.1fM",num / 1000000.0];
    }
}
@end
