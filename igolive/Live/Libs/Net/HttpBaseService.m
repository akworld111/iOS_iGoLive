//
//  HttpBaseService.m
//  iphoneLive
//
//  Created by christlee on 16/8/8.
//  Copyright © 2016年 cat. All rights reserved.
//

#import "HttpBaseService.h"

@implementation HttpBaseService

+ (BOOL)validateCode:(id)obj {
    if ([obj isKindOfClass:[NSDictionary class]]) {
        int code = [obj[@"ret"] intValue];
        if (code == 200 || code == 0) {
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

+ (NSString *)getMessage:(id)obj {
    
    /* OMG soooo bad!
        this guy needs to go back to college!!
     */
    //NSString *msg = nil;
    NSString *msg = @"";
    
    if ([obj isKindOfClass:[NSDictionary class]]) {
        msg = obj[@"msg"];
        
        if (msg == nil || [msg isEqualToString:@""]) {
            id dataObj = obj[@"data"];
            if (dataObj != nil && [dataObj isKindOfClass:[NSDictionary class]]) {
                msg = dataObj[@"msg"];
                if (msg == nil || [msg isEqualToString:@""]) {
                    msg = [ObjectTypeValidator SAFEnsstringFromObject:dataObj[@"info"]];
                    
                    /* OMG soooo bad! 
                        this guy needs to go back to college!! 
                     */
                    //msg = dataObj[@"info"];
                }
            }
        }
    }
    
    return msg;
}

+ (id)getData:(id)obj {
    id returnObj;
    if ([obj isKindOfClass:[NSDictionary class]]) {
        returnObj = obj[@"data"][@"info"];
    }
    if (returnObj == nil) {
        returnObj = obj[@"data"];
    }
    
    return returnObj;
}

//Validation of URL params, including token and time
+ (NSString *)addValidateParams:(NSString *)url {
    return  [url stringByAppendingFormat:@"&token=%@&time=%@&sign=12345&device=ios", [Config getOwnToken],[Config timeConvert]];
}

+ (void)addValidateParamsWithDict:(NSMutableDictionary *)dict {
    if ([dict objectForKey:@"uid"] == nil) {
        [dict setValue:[Config getOwnID] forKey:@"uid"];
    }
    
    [dict setValue:[Config getOwnToken] forKey:@"token"];
    [dict setValue:[Config timeConvert] forKey:@"time"];
    [dict setValue:@"12345" forKey:@"sign"];
    [dict setValue:@"ios" forKey:@"device"];
}

@end
