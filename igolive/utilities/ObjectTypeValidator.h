//
//  ObjectTypeValidator.h
//  igolive
//
//  Created by greenhouse on 8/27/16.
//  Copyright © 2016 iGoLive LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GiftItem.h"

@interface ObjectTypeValidator : NSObject

// igolive specific
+ (ChannelModel*)channelmodelFromObj:(id)obj;
+ (GiftItem*)IGOGiftItemFromObj:(id)obj;

// general
+ (UIScrollView*)uiscrollviewFromObject:(id)obj;
+ (UIImageView*)uiimageviewFromObject:(id)obj;
+ (UIView*)uiviewFromObject:(id)obj;
+ (id)objectFromNSArray:(NSArray*)arr atIndex:(NSInteger)index;
+ (BOOL)nsstringIsNil:(NSString*)str;
+ (BOOL)nsstringIsNilOrEmpty:(NSString*)str;


+ (NSString*)nsstringFromNSInteger:(NSInteger)integer useTwoCharForZero:(BOOL)useTwoCharForZero;
+ (BOOL)nsdateIsPM:(NSDate*)date;
+ (NSString*)SAFEnsstringFromObject:(id)obj;
+ (NSString*)nsstringFromObject:(id)obj;
+ (NSString*)nsstringFromNSDate:(NSDate*)date format:(NSString*)format;
+ (NSString*)nsstringFullTimeFormatFromNSDate:(NSDate*)date;
+ (NSString*)nsstringDateFormatFromNSDate:(NSDate*)date;
+ (NSDate*)nsdateFromObject:(id)obj;
+ (NSDate*)nsdateFromMilliSecObject:(id)mSecObj;
+ (NSNumber*)nsnumberMillisecFromNSNumberSec:(NSNumber*)sec;
+ (NSNumber*)nsnumberMillisecFromIntegerSec:(NSInteger)sec;
+ (NSNumber*)nsnumberMillisecFromDoubleSec:(double)sec;
+ (NSNumber*)nsnumberSecFromNSNumberMillisec:(NSNumber*)msec;
+ (NSInteger)nsintegerFromObject:(id)obj;
+ (NSNumber*)SAFEnsnumberBoolFromObject:(id)obj;
+ (NSNumber*)SAFEnsnumberFloatFromObject:(id)obj;
+ (NSNumber*)SAFEnsnumberIntFromObject:(id)obj;
+ (NSNumber*)SAFEnsnumberFromObject:(id)obj;
+ (NSNumber*)nsnumberFloatFromObject:(id)obj;
+ (NSNumber*)nsnumberIntFromObject:(id)obj;
+ (NSNumber*)nsnumberFromObject:(id)obj;
+ (NSMutableDictionary*)SAFEnsmutabledictionaryFromObject:(id)obj;
+ (NSDictionary*)SAFEnsdictionaryFromObject:(id)obj;
+ (NSDictionary*)nsdictionaryFromObject:(id)obj;
+ (NSArray*)nsarrayFromObject:(id)obj;
+ (BOOL)nsarrayIsNilOrEmpty:(NSArray*)arr;
+ (NSNumber*)nsnumberFromNSString:(NSString*)str;
+ (NSDictionary*)nsdictionaryFromSingleCountArrayObj:(id)obj;
+ (NSValue*)nsvalueFromObject:(id)obj;
+ (NSArray*)nsstringArrayFromNSNumberArray:(NSArray*)nsnumArray;
+ (NSString*)firstnameFromFullnameString:(NSString*)fullname;
+ (NSString*)lastnameFromFullnameString:(NSString*)fullname;


@end


