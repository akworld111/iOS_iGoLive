//
//  HttpBaseController.m
//  igolive
//
//  Created by greenhouse on 8/30/16.
//  Copyright © 2016 iGoLive LLC. All rights reserved.
//

#import "HttpBaseController.h"
#import "ObjectTypeValidator.h"

@implementation HttpBaseController

+ (BOOL)validateCode:(id)obj {
    if ([obj isKindOfClass:[NSDictionary class]]) {
        int code = [obj[@"ret"] intValue];
        if (code == 200) {
            id dataObj = obj[@"data"];
            if (dataObj != nil && [dataObj isKindOfClass:[NSDictionary class]]) {
                code = [dataObj[@"code"] intValue];
                if (code == 0) {
                    return YES;
                } else {
                    return NO;
                }
            }
            return YES;
        }
    }
    
    return NO;
}
+ (int)getRetStatusFromRespObj:(id)obj
{
    if (!obj)
    {
        XLM_error(@"response object is nil; returning -1");
        return -1;
    }
    
    NSDictionary *respDict = [ObjectTypeValidator nsdictionaryFromObject:obj];
    if (!respDict)
    {
        XLM_error(@"response object is not of type nsdictionary (key/value); returning -1");
        return -1;
    }
    
    id retObj = respDict[kRespStatus];
    if (!retObj)
    {
        XLM_error(@"'ret' key not found in response object; returning -1");
        return -1;
    }
    
    NSInteger retInt = [ObjectTypeValidator nsintegerFromObject:retObj];
    if (retInt < 0)
    {
        XLM_error(@"'ret' key indeed found in response object, but it parsed out to: %li; returning -1", (long)retInt);
        return -1;
    }
    
    return (int)retInt;
    
//    // retInt == 0 - 9 means server api executed its task successfully
//    if (retInt >= 0 && retInt <= 9)
//    {
//        return (int)retInt;
//    }
}
+ (NSString *)getMsgStringFromRespObj:(id)obj
{
    if (!obj)
    {
        XLM_error(@"response object is nil; returning empty str");
        return @"";
    }
    
    NSDictionary *respDict = [ObjectTypeValidator nsdictionaryFromObject:obj];
    if (!respDict)
    {
        XLM_error(@"response object is not of type nsdictionary (key/value); returning empty str");
        return @"";
    }
    
    id msgObj = respDict[kRespMsg];
    if (!msgObj)
    {
        XLM_error(@"'msg' key not found in response object; returning empty str");
        return @"";
    }
    
    NSString *msgStr = [ObjectTypeValidator nsstringFromObject:msgObj];
    if (!msgStr)
    {
        XLM_error(@"'msg' key indeed found in response object, but it is not of type nsstring; returning empty str");
        return @"";
    }
    
    return msgStr;
}

+ (NSDictionary*)getDataDictFromRespObj:(id)obj
{
    if (!obj)
    {
        XLM_error(@"response object is nil; returning empty dict\n\n");
        return @{};
    }
    
    NSDictionary *respDict = [ObjectTypeValidator nsdictionaryFromObject:obj];
    if (!respDict)
    {
        XLM_error(@"response object is not of type nsdictionary (key/value); returning empty dict\n\n");
        return @{};
    }
    
    id dataObj = respDict[kRespData];
    if (!dataObj)
    {
        XLM_error(@"'data' key not found in response object; returning empty dict\n\n");
        return @{};
    }
    
    NSDictionary *dataDict = [ObjectTypeValidator nsdictionaryFromObject:dataObj];
    if (!dataDict)
    {        
        NSArray *dataArr = [ObjectTypeValidator nsarrayFromObject:dataObj];
        if (!dataArr)
        {
            XLM_error(@"'data' key indeed found in response object, but it is not of type nsdictionary (key/value) and not of type nssarray; returning empty dict\n\n");
            return @{};
        }
        
        XLM_warning(@"'data' key in response object is of type nsarray; returning single key/value dict: @{'%@':dataArr}\n\n", kRespDataArr);
        return @{kRespDataArr:dataArr};
    }
    
    return dataDict;
}

//Validation of URL params, including token and time
+ (NSString *)addValidateParams:(NSString *)url {
    NSString *thisusertoken = [Config getOwnToken];
    NSString *strDateNow = [Config timeConvert];
    NSString *validateParmasUrl = [url stringByAppendingFormat:@"&token=%@&time=%@&sign=12345&device=ios", thisusertoken, strDateNow];
    
    NSString *retUrl = [NSString stringWithString:validateParmasUrl];
    
    return  retUrl;
}

+ (NSDictionary*)appendRequiredParams:(NSDictionary *)dict
{
    NSMutableDictionary *mDict = nil;
    if (!dict) {
        mDict = [NSMutableDictionary dictionary];
    }
    else {
        mDict = [ObjectTypeValidator SAFEnsmutabledictionaryFromObject:dict];
    }
    
    if ([mDict objectForKey:@"uid"] == nil) {
        [mDict setValue:[Config getOwnID] forKey:@"uid"];
    }
    
    //[dict setValue:[Config getOwnToken] forKey:@"token"];
    //[dict setValue:[Config timeConvert] forKey:@"time"];
    
    NSString *token = [ObjectTypeValidator SAFEnsstringFromObject:[Config getOwnToken]];
    NSString *timeConvert = [ObjectTypeValidator SAFEnsstringFromObject:[Config timeConvert]];
    
    [mDict setValue:token forKey:@"token"];
    [mDict setValue:timeConvert forKey:@"time"];
    [mDict setValue:@"12345" forKey:@"sign"];
    [mDict setValue:@"ios" forKey:@"device"];
    
    return [NSDictionary dictionaryWithDictionary:mDict];
}

@end




