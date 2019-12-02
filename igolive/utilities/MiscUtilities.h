//
//  MiscUtilities.h
//  igolive
//
//  Created by greenhouse on 8/24/16.
//  Copyright © 2016 iGoLive LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>

@interface MiscUtilities : NSObject

+ (NSString*)getApplicationBuildNumber;
+ (NSString *)hexStringForColor:(UIColor *)color;
+ (NSString*)hexObjcStringFromHexWebString:(NSString*)webHex;
+ (NSString*)hexWebStringFromHexObjcString:(NSString*)objcHex;
+ (UIColor*)hexStringToUIColor:(NSString*)hexString;
+ (unsigned)hexIntFromHexString:(NSString*)hexString;
+ (unsigned)subtractHexint:(unsigned)hexint1 fromHexInt:(unsigned)hexint2;
+ (UIColor*)randomUIColor;
+ (UIImage*)uiimagefromUIColor:(UIColor *)color;

// social media sharing
+ (void)copyToPastboard:(NSString*)text;
+ (void)launchUrlWithString:(NSString *)urlStr;
+ (void)callPhoneNumber:(NSString *)strphone; // str example: @"7327660120"
+ (void)callPhoneNumberPrompt:(NSString *)strphone; // str example: @"7327660120"
+ (void)sendTextMessage:(NSString*)message phone:(NSString*)phone vcDelegate:(UIViewController<MFMessageComposeViewControllerDelegate>*)vc;
+ (void)sendEmailSubject:(NSString*)subject toEmail:(NSString*)toEmail body:(NSString*)body vcDelegate:(UIViewController<MFMailComposeViewControllerDelegate>*)vc;
+ (void)shareToFacebookWithImage:(UIImage*)image text:(NSString*)text url:(NSString*)url vcDelegate:(UIViewController*)vc;
+ (void)shareToTwitterWithImage:(UIImage*)image text:(NSString*)text url:(NSString*)url vcDelegate:(UIViewController*)vc;

// date helpers
+ (NSDate*)nsdateWithYearsFromNow:(int)years;
+ (BOOL)nsdate:(NSDate*)dateOne isEarlierThan:(NSDate*)dateTwo;
+ (NSString*)nsstringHHmmssFromDoubleSeconds:(int)sec;
+ (NSNumber*)nsnumberTimeFromStringTime:(NSString*)strtime;
+ (NSInteger)nsintegerHHFromNSDate:(NSDate*)date;
+ (NSInteger)nsintegerHHmmFromNSDate:(NSDate*)date;
+ (NSNumber*)nsnumberHHmmFromNSDate:(NSDate*)date;
+ (BOOL)nsnumber24HourTimeIsPM:(NSNumber*)n24hourTime;
+ (NSInteger)nsintegerMinutesFromNSNumber24HourTime:(NSNumber*)n24hourTime;
+ (NSInteger)nsintegerAMPMHoursFromNSNumber24HourTime:(NSNumber*)n24hourTime;
+ (NSString*)nsstringHourMinuteTimeFormatFromNSDate:(NSDate*)date;
+ (double)getDoubleSecondsForHours:(int)hours;
+ (double)getDoubleSecondsForHours:(int)hours min:(int)min;
+ (NSString*)nsstringHourMinuteTimeFormatFromNSIntegerHours:(NSInteger)hours nsintegerMinutes:(NSInteger)minutes;
+ (NSString*)nsstringHourMinuteTimeFormatFromNSIntegerHours:(NSInteger)hours nsintegerMinutes:(NSInteger)minutes isPM:(BOOL)isPM;
+ (double)getNowInDoubleSecondsSince1970;
+ (NSArray*)getBase12HoursStringArrayWithIntervalMinutes:(NSInteger)minutes;


+ (void)checkLocationServicesEnabled;
+ (void)checkNotificationServicesEnabled;
+ (void)checkMicrophoneServiceEnabled;
+ (void)checkCameraServiceEnabled;
+ (void)checkPhotoServiceEnabled;
//+ (void)checkCameraServiceEnabledBuyer;

+ (BOOL)isDepricatedAppVersion:(float)min_app_ver; // min app version set in db
+ (BOOL)isDepricatedBundleVersion:(float)min_ios_build; // min build set in db

@end


