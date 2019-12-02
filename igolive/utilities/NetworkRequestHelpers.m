//
//  NetworkRequestHelpers.m
//  igolive
//
//  Created by greenhouse on 9/3/16.
//  Copyright © 2016 iGoLive LLC. All rights reserved.
//

#import "NetworkRequestHelpers.h"
#import <SystemConfiguration/SystemConfiguration.h> // has internet
#import <netinet/in.h>  // has internet
#import "ISO8601DateFormatter.h"

@implementation NetworkRequestHelpers


/////////////////////////////////////////////
#pragma mark - misc helpers
/////////////////////////////////////////////
+ (BOOL)hasInternet
{
#ifndef use_test_data
    return [NetworkRequestHelpers hasInternetConnectivity];
#else
    return YES;
#endif
}

/*
 ref: http://stackoverflow.com/questions/1083701/how-to-check-for-an-active-internet-connection-on-iphone-sdk
 */
+ (BOOL)hasInternetConnectivity
{
    XLog(@"Checking Internet . . . ");
    struct sockaddr_in zeroAddress;
    bzero(&zeroAddress, sizeof(zeroAddress));
    zeroAddress.sin_len = sizeof(zeroAddress);
    zeroAddress.sin_family = AF_INET;
    
    SCNetworkReachabilityRef reachability = SCNetworkReachabilityCreateWithAddress(kCFAllocatorDefault, (const struct sockaddr*)&zeroAddress);
    if(reachability != NULL) {
        //NetworkStatus retVal = NotReachable;
        SCNetworkReachabilityFlags flags;
        if (SCNetworkReachabilityGetFlags(reachability, &flags)) {
            if ((flags & kSCNetworkReachabilityFlagsReachable) == 0)
            {
                // if target host is not reachable
                XLog(@"Internet: Down :(");
                return NO;
            }
            
            if ((flags & kSCNetworkReachabilityFlagsConnectionRequired) == 0)
            {
                // if target host is reachable and no connection is required
                //  then we'll assume (for now) that your on Wi-Fi
                XLog(@"Internet: Up :) - on wifi!");
                return YES;
            }
            
            
            if ((((flags & kSCNetworkReachabilityFlagsConnectionOnDemand ) != 0) ||
                 (flags & kSCNetworkReachabilityFlagsConnectionOnTraffic) != 0))
            {
                // ... and the connection is on-demand (or on-traffic) if the
                //     calling application is using the CFSocketStream or higher APIs
                
                if ((flags & kSCNetworkReachabilityFlagsInterventionRequired) == 0)
                {
                    // ... and no [user] intervention is needed
                    XLog(@"Internet: Up :) ");
                    return YES;
                }
            }
            
            if ((flags & kSCNetworkReachabilityFlagsIsWWAN) == kSCNetworkReachabilityFlagsIsWWAN)
            {
                // ... but WWAN connections are OK if the calling application
                //     is using the CFNetwork (CFSocketStream?) APIs.
                XLog(@"Internet: Up :) ");
                return YES;
            }
        }
    }
    
    XLog(@"Internet: Down :( ");
    return NO;
}

// returns format: yyyy-MM-dd'T'HH:mm:ss
+ (NSString *)datetimeUploadReady:(double)timeInterval
{
    ISO8601DateFormatter *formatter = [[ISO8601DateFormatter alloc] init];
    NSString *dt_return = [formatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:timeInterval]];
    formatter = nil;
    return dt_return;
}
+ (NSString *)datetimeUtcUploadReady:(double)timeInterval
{
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeInterval];
    NSString *dt_return = [NetworkRequestHelpers getUTCFormatDate:date];
    return dt_return;
}
+ (NSString *)datetimeUtcUploadReadyNow
{
    NSDate *date = [NSDate date];
    NSString *dt_return = [NetworkRequestHelpers getUTCFormatDate:date];
    return dt_return;
}
+ (NSString *)getUTCFormatDate:(NSDate *)localDate
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    // remote server support only
    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"UTC"];    // for remote server
    
    /* 
        remote server & local server support
         requires #define support (ref: copark project)
     */
        //NSTimeZone *timeZone;
        //if ([domain_copark isEqualToString:domain_copark_local])
        //    timeZone = [NSTimeZone localTimeZone];  // for local server
        //else
        //    timeZone = [NSTimeZone timeZoneWithName:@"UTC"];    // for remote server
    
    [dateFormatter setTimeZone:timeZone];
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
    //[dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *dateString = [dateFormatter stringFromDate:localDate];
    //[dateFormatter release];
    return dateString;
}
// return base64 encoding
+ (NSString *)imageUploadReady : (UIImage *)img {
    if (!img)
    {
        XLM_error(@"img is nil; returning empty string");
        return @"";
    }
    
    
    CGFloat size_perc = req_img_size_perc;
    CGSize size = CGSizeMake(img.size.width*size_perc, img.size.height*size_perc);
    UIImage *resized = [NetworkRequestHelpers resizeImage:img withSize:size];
    NSString *strreturn = [UIImageJPEGRepresentation(resized, req_img_qual_comp) base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    if (!strreturn)
    {
        XLM_error(@"UIImageJPEGRepresentation:base64EncodedStringWithOptions: returned nil; returning empty string");
        strreturn = @"";
    }
    
    return strreturn;
}

+ (UIImage *)resizeImage:(UIImage *)img withSize:(CGSize)size {
    if (!img)
        return nil;
    
    UIGraphicsBeginImageContext(size);
    [img drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *new = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return new;
}
+ (NSString*)getJSONDescriptionFromArrayPayload:(NSArray*)aPayload
{
    NSError *error;
    NSData* jsondata;
    @try{
        jsondata = [NSJSONSerialization
                    dataWithJSONObject:aPayload // Here you can pass array or dictionary
                    options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
                    error:&error];
    }
    @catch (NSException *e){
        XLM_error(@"EXCEPTION:\n %@", e.description);
        XLM_error(@"JSON ERROR:\n %@", error.description);
    }
    
    NSString* jsonstr = nil;
    
    if (!jsondata)
    {
        XLM_error(@"NSArray aPayload encountered error \"%@\"; returning '[]'", error);
        jsonstr = @"[]";
    } else
    {
        jsonstr = [[NSString alloc] initWithData:jsondata encoding:NSUTF8StringEncoding];
        jsonstr = [jsonstr stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        jsonstr = [jsonstr stringByReplacingOccurrencesOfString:@"\"" withString:@""];
        jsonstr = [jsonstr stringByReplacingOccurrencesOfString:@"\\" withString:@""];
        jsonstr = [jsonstr stringByReplacingOccurrencesOfString:@"," withString:@",\n"];
        jsonstr = [jsonstr stringByReplacingOccurrencesOfString:@"[" withString:@"\n[\n"];
        jsonstr = [jsonstr stringByReplacingOccurrencesOfString:@"{" withString:@"\n{\n"];
        jsonstr = [jsonstr stringByReplacingOccurrencesOfString:@"]" withString:@"\n]\n"];
        jsonstr = [jsonstr stringByReplacingOccurrencesOfString:@"]\n," withString:@"],\n"];
        jsonstr = [jsonstr stringByReplacingOccurrencesOfString:@"}" withString:@"\n}\n"];
        jsonstr = [jsonstr stringByReplacingOccurrencesOfString:@" " withString:@""];
    }
    
    return jsonstr;
}
+ (NSString*)getJSONDescriptionFromDictPayload:(NSDictionary*)dPayload
{
    NSError *error;
    NSData* jsondata;
    @try{
        jsondata = [NSJSONSerialization
                    dataWithJSONObject:dPayload // Here you can pass array or dictionary
                    options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
                    error:&error];
    }
    @catch (NSException *e){
        XLM_error(@"EXCEPTION:\n %@", e.description);
        XLM_error(@"JSON ERROR:\n %@", error.description);
    }
    
    NSString* jsonstr = nil;
    
    if (!jsondata)
    {
        XLM_error(@"NSDictionary dPayload encountered error \"%@\"; returning '{}'", error);
        jsonstr = @"{}";
        //jsonstr = @"[]"; // from above
    } else
    {
        jsonstr = [[NSString alloc] initWithData:jsondata encoding:NSUTF8StringEncoding];
        jsonstr = [jsonstr stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        jsonstr = [jsonstr stringByReplacingOccurrencesOfString:@" " withString:@""];
    }
    
    return jsonstr;
}
/*  reference */
// ref: http://stackoverflow.com/a/26143873/2298002
+ (NSString *)imageToNSString:(UIImage *)img
{
    CGSize size = CGSizeMake(img.size.width/2, img.size.height/2);
    UIImage *image = [NetworkRequestHelpers resizeImage:img withSize:size];
    
    NSData *imageData = UIImagePNGRepresentation(image);
    return [imageData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
}

+ (UIImage *)stringToUIImage:(NSString *)string
{
    NSData *data = [[NSData alloc]initWithBase64EncodedString:string
                                                      options:NSDataBase64DecodingIgnoreUnknownCharacters];
    return [UIImage imageWithData:data];
}


@end



