//
//  MiscUtilities.m
//  igolive
//
//  Created by greenhouse on 8/24/16.
//  Copyright © 2016 iGoLive LLC. All rights reserved.
//

#import "MiscUtilities.h"

#import <CoreLocation/CoreLocation.h>
#import <Photos/Photos.h>
#import <Social/Social.h>

@implementation MiscUtilities

+ (NSString*)getApplicationBuildNumber
{
    // set build number
    NSBundle *mainb = [NSBundle mainBundle];
    NSDictionary *infoDictionary = [mainb infoDictionary];
    NSString *strBundleVersion = infoDictionary[(NSString*)kCFBundleVersionKey];
    NSString * strAppVersion = [mainb  objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
    
    NSString *run_mode = @"dev_mode";
    if (run_release_mode)
        run_mode = @"rel_mode";
    else if (run_stage_mode)
        run_mode = @"stag_mode";
    
    return [NSString stringWithFormat:@"[v%@(%@) %@ (%@)]", strAppVersion, strBundleVersion, run_mode, git_build_branch];
}
+ (NSString *)hexStringForColor:(UIColor *)color
{
    const CGFloat *components = CGColorGetComponents(color.CGColor);
    CGFloat r = components[0];
    CGFloat g = components[1];
    CGFloat b = components[2];
    NSString *hexString=[NSString stringWithFormat:@"%02X%02X%02X", (int)(r * 255), (int)(g * 255), (int)(b * 255)];
    return hexString;
}
// takes in hashtag hex color string format ('#FF3412')
//  returns hex value color string format ('0xFF3214')
+ (NSString*)hexObjcStringFromHexWebString:(NSString*)webHex
{
    if (!webHex || [webHex isEqualToString:@""])
    {
        XLM_error(@"param string format to convert is nil or empty; returning nil");
        return nil;
    }
    
    NSString *toReturn = [webHex stringByReplacingOccurrencesOfString:@"#" withString:@"0x"];
    if (!toReturn || [toReturn isEqualToString:@""])
    {
        XLM_error(@"'stringByReplacingOccurrencesOfString' returned nil or an empty string; returning nil");
        return nil;
    }
    
    return toReturn;
}

// takes in hex value color string format ('0xFF3214')
//  returns hashtag hex color string format ('#FF3412')
+ (NSString*)hexWebStringFromHexObjcString:(NSString*)objcHex
{
    if (!objcHex || [objcHex isEqualToString:@""])
    {
        XLM_error(@"param string format to convert is nil or empty; returning nil");
        return nil;
    }
    
    
    NSString *toReturn = [objcHex stringByReplacingOccurrencesOfString:@"0x" withString:@"#"];
    if (!toReturn || [toReturn isEqualToString:@""])
    {
        XLM_error(@"'stringByReplacingOccurrencesOfString' returned nil or an empty string; returning nil");
        return nil;
    }
    
    
    return toReturn;
}
// note: param 'hexString' must be of format '0x....', as in '0xFF3412'
//  if something goes wrong, then blackColor will be returned
//+ (UIColor*)uicolorFromHexString:(NSString*)hexString
+ (UIColor*)hexStringToUIColor:(NSString*)hexString
{
    unsigned colorInt = [MiscUtilities hexIntFromHexString:hexString];
    UIColor *color = UIColorFromHexAlpha(colorInt, 1.0f);
    if (!color)
        color = [UIColor blackColor];
    
    return color;
}
// note: param 'hexString' must be of format '0x....', as in '0xFF3412'
+ (unsigned)hexIntFromHexString:(NSString*)hexString
{
    unsigned hexInt = 0;
    [[NSScanner scannerWithString:hexString] scanHexInt:&hexInt];
    
    return hexInt;
}
+ (unsigned)subtractHexint:(unsigned)hexint1 fromHexInt:(unsigned)hexint2
{
    return hexint1 - hexint2;
}
+ (UIColor*)randomUIColor
{
    
    CGFloat hue = ( arc4random() % 256 / 256.0 );  //  0.0 to 1.0
    CGFloat saturation = ( arc4random() % 128 / 256.0 ) + 0.5;  //  0.5 to 1.0, away from white
    CGFloat brightness = ( arc4random() % 128 / 256.0 ) + 0.5;  //  0.5 to 1.0, away from black
    UIColor *color = [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:1];
    return color;
}
+ (UIImage*)uiimagefromUIColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return theImage;
}
+ (void)copyToPastboard:(NSString*)text
{
    // copy to pasteboard
    // ref: http://stackoverflow.com/a/8869593/2298002
    NSString *copyStringverse = text;
    UIPasteboard *pb = [UIPasteboard generalPasteboard];
    [pb setString:copyStringverse];
}
+ (void)launchUrlWithString:(NSString *)urlStr
{
    NSURL *url = [NSURL URLWithString:urlStr];
    [[UIApplication sharedApplication] openURL:url];
}
+ (void)callPhoneNumber:(NSString *)strphone // str example: @"7327660120"
{
    // NOTE: for both string formats below, the '//' doesn't appear to be needed
    //  (will work just fine with or without it)
    
    // goes straight to making the call (no additional pop-up prompt)
    NSString *urlStr = [NSString stringWithFormat:@"tel://%@", strphone];
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlStr]];
}
+ (void)callPhoneNumberPrompt:(NSString *)strphone // str example: @"7327660120"
{
    // NOTE: for both string formats below, the '//' doesn't appear to be needed
    //  (will work just fine with or without it)
    
    // provides additional pop-up prompt for user to confirm making the call
    NSString *urlStr = [NSString stringWithFormat:@"telprompt://%@", strphone];
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlStr]];
}

+ (void)sendTextMessage:(NSString*)message phone:(NSString*)phone vcDelegate:(UIViewController<MFMessageComposeViewControllerDelegate>*)vc
{
    if ([MFMessageComposeViewController canSendText])
    {
        MFMessageComposeViewController *messageComposer = [[MFMessageComposeViewController alloc] init];
        
        [messageComposer setBody:message];
        [messageComposer setRecipients:@[phone]];
        
        [messageComposer disableUserAttachments];
        
        messageComposer.messageComposeDelegate = vc;
        
        [vc presentViewController:messageComposer animated:YES completion:nil];
    }
    else
    {
        [AlertViewHelpers presentAlertWithTitle:@"Error" message:@"Your device is unable to send text messages :/" delegate:nil];
    }
}
+ (void)sendEmailSubject:(NSString*)subject toEmail:(NSString*)toEmail body:(NSString*)body vcDelegate:(UIViewController<MFMailComposeViewControllerDelegate>*)vc
{
    if([MFMailComposeViewController canSendMail]) {
        MFMailComposeViewController *mailCont = [[MFMailComposeViewController alloc] init];
        mailCont.mailComposeDelegate = vc;        // Required to invoke mailComposeController when send
        
        [mailCont setSubject:subject];
        [mailCont setToRecipients:[NSArray arrayWithObject:toEmail]];
        [mailCont setMessageBody:body isHTML:NO];
        
        [vc presentViewController:mailCont animated:YES completion:nil];
    }
    else
    {
        [AlertViewHelpers presentAlertWithTitle:@"Error" message:@"Your device is unable to send emails :/" delegate:nil];
    }
}
+ (void)shareToFacebookWithImage:(UIImage*)image text:(NSString*)text url:(NSString*)url vcDelegate:(UIViewController*)vc
{
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook]) {
        SLComposeViewController *controller = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
        [controller addImage:image];
        [controller setInitialText:text];
        [controller addURL:[NSURL URLWithString:url]];
        [vc presentViewController:controller animated:YES completion:nil];
        
        controller.completionHandler = ^(SLComposeViewControllerResult result) {
            switch(result) {
                case SLComposeViewControllerResultCancelled:
                    NSLog(@"facebook: CANCELLED");
                    break;
                case SLComposeViewControllerResultDone:
                    NSLog(@"facebook: SHARED");
                    break;
            }
        };
    }
    else {
        [AlertViewHelpers presentAlertWithTitle:@"Facebook Unavailable" message:@"Sorry, we're unable to find a Facebook account on your device.\nPlease setup an account in your devices settings and try again." delegate:nil];
    }
}

+ (void)shareToTwitterWithImage:(UIImage*)image text:(NSString*)text url:(NSString*)url vcDelegate:(UIViewController*)vc
{
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter]) {
        SLComposeViewController *controller = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
        [controller addImage:image];
        [controller setInitialText:text];
        [controller addURL:[NSURL URLWithString:url]];
        [vc presentViewController:controller animated:YES completion:nil];
        
        controller.completionHandler = ^(SLComposeViewControllerResult result) {
            switch(result) {
                case SLComposeViewControllerResultCancelled:
                    NSLog(@"facebook: CANCELLED");
                    break;
                case SLComposeViewControllerResultDone:
                    NSLog(@"facebook: SHARED");
                    break;
            }
        };
    }
    else {
        [AlertViewHelpers presentAlertWithTitle:@"Twitter Unavailable" message:@"Sorry, we're unable to find a Twitter account on your device.\nPlease setup an account in your devices settings and try again." delegate:nil];
    }
}

////////////////////////////////////////////////////////////////
#pragma mark - date helpers
////////////////////////////////////////////////////////////////
// note use negative (-) int for years in the past
+ (NSDate*)nsdateWithYearsFromNow:(int)years
{
    unsigned unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth |  NSCalendarUnitDay;
    NSDate *now = [NSDate date];
    NSCalendar *gregorian = [NSCalendar currentCalendar];
    NSDateComponents *comps = [gregorian components:unitFlags fromDate:now];
    [comps setYear:[comps year] + years];
    NSDate *yearsAgo = [gregorian dateFromComponents:comps];
    return yearsAgo;
}
+ (BOOL)nsdate:(NSDate*)dateOne isEarlierThan:(NSDate*)dateTwo
{
    if ([dateOne compare:dateTwo] == NSOrderedDescending) {
        return NO;
    } else if ([dateOne compare:dateTwo] == NSOrderedAscending) {
        return YES;
    } else {
        return NO;
    }
}
+ (NSString*)nsstringHHmmssFromDoubleSeconds:(int)sec
{
    int totmin = sec / 60;
    
    NSMutableString *strHHmmss = [NSMutableString string];
    
    int hrdisp = totmin / 60;
    if (hrdisp > 0 && hrdisp < 10)
    [strHHmmss appendFormat:@"0"];
    if (hrdisp > 0)
    [strHHmmss appendFormat:@"%d:", hrdisp];
    
    int mindisp = totmin % 60;
    if (mindisp > 0 && mindisp < 10)
    [strHHmmss appendFormat:@"0"];
    if (mindisp > 0)
    [strHHmmss appendFormat:@"%d:", mindisp];
    if (mindisp <= 0)
    [strHHmmss appendFormat:@"00:"];
    
    int secdisp = sec % 60;
    if (secdisp < 10)
    [strHHmmss appendFormat:@"0"];
    [strHHmmss appendFormat:@"%d", secdisp];
    
    
    
    return [NSString stringWithString:strHHmmss];
}
// get num(1530) from str(15:30) <-- 24 hour conversation doesn't matter
+ (NSNumber*)nsnumberTimeFromStringTime:(NSString*)strtime
{
    strtime = [strtime stringByReplacingOccurrencesOfString:@":" withString:@""];
    NSNumber *ntime = [NSNumber numberWithInteger:strtime.integerValue];
    
    if (ntime)
    return ntime;
    
    XLM_error(@"ntime came out nil during conversion; returning nil");
    return nil;
}
// check if num(1530) is PM
+ (BOOL)nsnumber24HourTimeIsPM:(NSNumber*)n24hourTime
{
    NSInteger minutes = n24hourTime.integerValue % 100;
    NSInteger hours = (n24hourTime.integerValue - minutes) / 100;
    
    if (hours > 23)
    {
        XLM_error(@"hours: '%li' > than 23; returning NO", (long)hours);
        return 0;
    }
    
    return hours > 11;
}
// get int(30) from num(1530)
+ (NSInteger)nsintegerMinutesFromNSNumber24HourTime:(NSNumber*)n24hourTime
{
    NSInteger minutes = n24hourTime.integerValue % 100;
    //NSInteger hours = (n24hourTime.integerValue - minutes) / 100;
    
    if (minutes < 0)
    {
        XLM_error(@"minutes: '%li' < 0; returning 0", (long)minutes);
        return 0;
    }
    if (minutes > 59)
    {
        XLM_error(@"minutes: '%li' > than 59; returning 0", (long)minutes);
        return 0;
    }
    
    return minutes;
}
// get int(03) from num(1530)
+ (NSInteger)nsintegerAMPMHoursFromNSNumber24HourTime:(NSNumber*)n24hourTime
{
    NSInteger minutes = n24hourTime.integerValue % 100;
    NSInteger hours = (n24hourTime.integerValue - minutes) / 100;
    
    if (hours < 0)
    {
        XLM_error(@"hours: '%li' < 0; returning 0", (long)hours);
        return 0;
    }
    if (hours > 23)
    {
        XLM_error(@"hours: '%li' > than 23; returning 0", (long)hours);
        return 0;
    }
    
    if (hours == 0)
    return 12;
    if (hours > 12)
    return hours - 12;
    
    return hours;
}
// get 24hr format int(15 <- HH) from nsdate
+ (NSInteger)nsintegerHHFromNSDate:(NSDate*)date
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:str_dateformat_HH];
    NSString *hours = [dateFormatter stringFromDate:date];
    
    return hours.integerValue;
}
// get 24hr format int(1500 <- HHmm) from nsdate
+ (NSInteger)nsintegerHHmmFromNSDate:(NSDate*)date
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:str_dateformat_HHmm];
    NSString *hours = [dateFormatter stringFromDate:date];
    
    return hours.integerValue;
}
// get 24hr format num(1500 <- HHmm) from nsdate
+ (NSNumber*)nsnumberHHmmFromNSDate:(NSDate*)date
{
    NSInteger iHHmm = [MiscUtilities nsintegerHHmmFromNSDate:date];
    NSNumber *nHHmm = [NSNumber numberWithInteger:iHHmm];
    
    return nHHmm;
}
// get str(h:mm) format from nsdate
+ (NSString*)nsstringHourMinuteTimeFormatFromNSDate:(NSDate*)date
{
    if (!date)
    {
        XLog(@"warning: date == nil; failed to get date string; return garbage");
        return @"time_error";
    }
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //[dateFormatter setDateFormat:str_dateformat_h_mm];
    [dateFormatter setDateFormat:str_dateformat_HH_mm];
    
    
    NSString *time = [dateFormatter stringFromDate:date];
    return time;
}
// convert hours to seconds
+ (double)getDoubleSecondsForHours:(int)hours
{
    return (double)hours * 60 * 60;
}
// convert hours to second and min to seconds; return total seconds
+ (double)getDoubleSecondsForHours:(int)hours min:(int)min
{
    double hrsec  = (double)hours * 60.0f * 60.0f;
    double minsec = (double)min * 60.0f;
    
    return hrsec + minsec;
}
+ (NSString*)nsstringHourMinuteTimeFormatFromNSIntegerHours:(NSInteger)hours nsintegerMinutes:(NSInteger)minutes
{
    NSString *strhours = [ObjectTypeValidator nsstringFromNSInteger:hours useTwoCharForZero:YES];
    NSString *strminutes = [ObjectTypeValidator nsstringFromNSInteger:minutes useTwoCharForZero:YES];
    return [NSString stringWithFormat:@"%@:%@", strhours, strminutes];
}
+ (NSString*)nsstringHourMinuteTimeFormatFromNSIntegerHours:(NSInteger)hours nsintegerMinutes:(NSInteger)minutes isPM:(BOOL)isPM
{
    NSString *am_pm = isPM ? @"PM" : @"AM";
    NSString *strhours = [ObjectTypeValidator nsstringFromNSInteger:hours useTwoCharForZero:YES];
    NSString *strminutes = [ObjectTypeValidator nsstringFromNSInteger:minutes useTwoCharForZero:YES];
    return [NSString stringWithFormat:@"%@:%@ %@", strhours, strminutes, am_pm];
}
+ (double)getNowInDoubleSecondsSince1970
{
    return [[NSDate date] timeIntervalSince1970];
}
+ (NSArray*)getBase12HoursStringArrayWithIntervalMinutes:(NSInteger)minutes
{
    switch (minutes)
    {
        case 15:
            return @[@"12:00 AM", @"12:15 AM", @"12:30 AM", @"12:45 AM", // AM
                     @"1:00 AM", @"1:15 AM", @"1:30 AM", @"1:45 AM",
                     @"2:00 AM", @"2:15 AM", @"2:30 AM", @"2:45 AM",
                     @"3:00 AM", @"3:15 AM", @"3:30 AM", @"3:45 AM",
                     @"4:00 AM", @"4:15 AM", @"4:30 AM", @"4:45 AM",
                     @"5:00 AM", @"5:15 AM", @"5:30 AM", @"5:45 AM",
                     @"6:00 AM", @"6:15 AM", @"6:30 AM", @"6:45 AM",
                     @"7:00 AM", @"7:15 AM", @"7:30 AM", @"7:45 AM",
                     @"8:00 AM", @"8:15 AM", @"8:30 AM", @"8:45 AM",
                     @"9:00 AM", @"9:15 AM", @"9:30 AM", @"9:45 AM",
                     @"10:00 AM", @"10:15 AM", @"10:30 AM", @"10:45 AM",
                     @"11:00 AM", @"11:15 AM", @"11:30 AM", @"11:45 AM",
                     @"12:00 PM", @"12:15 PM", @"12:30 PM", @"12:45 PM", // PM
                     @"1:00 PM", @"1:15 PM", @"1:30 PM", @"1:45 PM",
                     @"2:00 PM", @"2:15 PM", @"2:30 PM", @"2:45 PM",
                     @"3:00 PM", @"3:15 PM", @"3:30 PM", @"3:45 PM",
                     @"4:00 PM", @"4:15 PM", @"4:30 PM", @"4:45 PM",
                     @"5:00 PM", @"5:15 PM", @"5:30 PM", @"5:45 PM",
                     @"6:00 PM", @"6:15 PM", @"6:30 PM", @"6:45 PM",
                     @"7:00 PM", @"7:15 PM", @"7:30 PM", @"7:45 PM",
                     @"8:00 PM", @"8:15 PM", @"8:30 PM", @"8:45 PM",
                     @"9:00 PM", @"9:15 PM", @"9:30 PM", @"9:45 PM",
                     @"10:00 PM", @"10:15 PM", @"10:30 PM", @"10:45 PM",
                     @"11:00 PM", @"11:15 PM", @"11:30 PM", @"11:45 PM"];
        case 30:
            return @[@"12:00 AM", @"12:30 AM", // AM
                     @"1:00 AM", @"1:30 AM",
                     @"2:00 AM", @"2:30 AM",
                     @"3:00 AM", @"3:30 AM",
                     @"4:00 AM", @"4:30 AM",
                     @"5:00 AM", @"5:30 AM",
                     @"6:00 AM", @"6:30 AM",
                     @"7:00 AM", @"7:30 AM",
                     @"8:00 AM", @"8:30 AM",
                     @"9:00 AM", @"9:30 AM",
                     @"10:00 AM", @"10:30 AM",
                     @"11:00 AM", @"11:30 AM",
                     @"12:00 PM", @"12:30 PM", // PM
                     @"1:00 PM", @"1:30 PM",
                     @"2:00 PM", @"2:30 PM",
                     @"3:00 PM", @"3:30 PM",
                     @"4:00 PM", @"4:30 PM",
                     @"5:00 PM", @"5:30 PM",
                     @"6:00 PM", @"6:30 PM",
                     @"7:00 PM", @"7:30 PM",
                     @"8:00 PM", @"8:30 PM",
                     @"9:00 PM", @"9:30 PM",
                     @"10:00 PM", @"10:30 PM",
                     @"11:00 PM", @"11:30 PM"];
        case 60:
            return @[@"12:00 AM", // AM
                     @"1:00 AM",
                     @"2:00 AM",
                     @"3:00 AM",
                     @"4:00 AM",
                     @"5:00 AM",
                     @"6:00 AM",
                     @"7:00 AM",
                     @"8:00 AM",
                     @"9:00 AM",
                     @"10:00 AM",
                     @"11:00 AM",
                     @"12:00 PM", // PM
                     @"1:00 PM",
                     @"2:00 PM",
                     @"3:00 PM",
                     @"4:00 PM",
                     @"5:00 PM",
                     @"6:00 PM",
                     @"7:00 PM",
                     @"8:00 PM",
                     @"9:00 PM",
                     @"10:00 PM",
                     @"11:00 PM"];
        default:
            return @[@"Oh No!"];
    }
}



// ref: http://stackoverflow.com/a/35982887/2298002
+ (void)checkLocationServicesEnabled
{
    //Checking authorization status
    if (![CLLocationManager locationServicesEnabled] || [CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied)
    {
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Location Services Disabled!"
                                                            message:@"You need to enable your GPS location in order to find live broadcasts near you"
                                                           delegate:self
                                                  cancelButtonTitle:@"Cancel"
                                                  otherButtonTitles:@"Settings", nil];
        
        //TODO if user has not given permission to device
        if (![CLLocationManager locationServicesEnabled])
        {
            alertView.tag = 100;
        }
        //TODO if user has not given permission to particular app
        else
        {
            alertView.tag = 200;
        }
        
        [alertView show];
        
        return;
    }
}
+ (void)checkNotificationServicesEnabled
{
    if (![[UIApplication sharedApplication] isRegisteredForRemoteNotifications])
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Notification Services Disabled!"
                                                            message:@"Enabling your Notifications allows you to receive important updates from iGoLive!"
                                                           delegate:self
                                                  cancelButtonTitle:@"Cancel"
                                                  otherButtonTitles:@"Settings", nil];
        
        alertView.tag = 300;
        
        [alertView show];
        
        return;
    }
}
+ (void)checkMicrophoneServiceEnabled
{
    if ([AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeAudio] == AVAuthorizationStatusDenied ||
        [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeAudio] == AVAuthorizationStatusNotDetermined)
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Microphone Services Disabled!"
                                                            message:@"Enabling Microphone access is required for broadcasting live, so people can hear you!"
                                                           delegate:self
                                                  cancelButtonTitle:@"Cancel"
                                                  otherButtonTitles:@"Settings", nil];
        
        alertView.tag = 400;
        
        [alertView show];
    }
}
+ (void)checkCameraServiceEnabled
{
    if ([AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo] == AVAuthorizationStatusDenied ||
        [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo] == AVAuthorizationStatusNotDetermined)
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Camera/Photo Services Disabled!"
                                                            message:@"Enabling Camera/Photo access is required for broadcasting live, so people can see you!"
                                                           delegate:self
                                                  cancelButtonTitle:@"Cancel"
                                                  otherButtonTitles:@"Settings", nil];
        
        alertView.tag = 400;
        
        [alertView show];
    }
}
+ (void)checkPhotoServiceEnabled
{
    if ([PHPhotoLibrary authorizationStatus] == PHAuthorizationStatusDenied ||
        [PHPhotoLibrary authorizationStatus] == PHAuthorizationStatusNotDetermined)
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Camera/Photo Services Disabled!"
                                                            message:@"Enabling Camera/Photo access is required for broadcasting live, so people can see you!"
                                                           delegate:self
                                                  cancelButtonTitle:@"Cancel"
                                                  otherButtonTitles:@"Settings", nil];
        
        alertView.tag = 400;
        
        [alertView show];
    }
}
//+ (void)checkCameraServiceEnabledBuyer
//{
//    if ([AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo] == AVAuthorizationStatusDenied ||
//        [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo] == AVAuthorizationStatusNotDetermined)
//    {
//        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Camera/Photo Services Disabled!"
//                                                            message:@"Enabling Camera access allows you to easily scan your credit card and check-in faster"
//                                                           delegate:self
//                                                  cancelButtonTitle:@"Cancel"
//                                                  otherButtonTitles:@"Settings", nil];
//        
//        alertView.tag = 400;
//        
//        [alertView show];
//    }
//}
+ (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if(buttonIndex == 0)// Cancel button pressed
    {
        //TODO for cancel
    }
    else if(buttonIndex == 1)// Settings button pressed.
    {
        if (alertView.tag == 100)
        {
            //This will open ios devices location settings
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"prefs:root=LOCATION_SERVICES"]];
        }
        else if (alertView.tag == 200)
        {
            //This will open particular app location settings
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
        }
        else if (alertView.tag == 300)
        {
            //This will open particular app notification settings
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
        }
        else if (alertView.tag == 400)
        {
            //This will open particular app camera/photo settings
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
        }
    }
}

+ (BOOL)isDepricatedAppVersion:(float)min_app_ver // min app version set in db
{
    NSString * strAppVersion = [[NSBundle mainBundle]  objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
    float thisAppVersion = strAppVersion.floatValue; // this release's build num
    
    if (thisAppVersion < min_app_ver)
    {
        return YES;
    }
    
    return NO;
}


+ (BOOL)isDepricatedBundleVersion:(float)min_ios_build // min build set in db
{
    NSDictionary *infoDictionary = [[NSBundle mainBundle]infoDictionary];
    NSString *strBundleVersion = infoDictionary[(NSString*)kCFBundleVersionKey];
    
    float thisBundleVersion = strBundleVersion.floatValue; // this release's build num
    
    if (thisBundleVersion < min_ios_build)
    {
        return YES;
    }
    
    return NO;
}

@end






