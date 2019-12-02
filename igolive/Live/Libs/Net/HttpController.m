//
//  HttpServiceController.m
//  igolive
//
//  Created by greenhouse on 8/30/16.
//  Copyright © 2016 iGoLive LLC. All rights reserved.
//

#import "HttpController.h"
#import "HttpRequest.h"
#import "ServerURL.h"

@implementation HttpController

// note_09.19.16: not called from anywhere
+ (void)upLaodUserInfoWithPersonInfoModel:(PersonalInfoModel *)personInfoModel callback:(CommonResultBlock)cb_result {
    NSString *value = [NSString stringWithFormat:@"user_nickname=%@&signature=%@&gender=%@&birthday=%@&address=%@",personInfoModel.userNickname,personInfoModel.signature,personInfoModel.gender,personInfoModel.birthday,personInfoModel.city];
//    for (int i=0; i<personInfoModel.interestsArray.count; i++) {
//        value = [NSString stringWithFormat:@"%@&interests[]=%@",value,personInfoModel.interestsArray[i]];
//    }
    
    XLM_info(@"---%@",value);
    
    NSString *thisuid = [Config getOwnID];
    NSString *servEndpoint = [ServerURL getServiceUrl:api_updateProfile];
    NSString *fullReqUrl = [servEndpoint stringByAppendingFormat:@"&uid=%@&value=%@", thisuid, value];
    NSString *url = [self addValidateParams:fullReqUrl];
    
    [self performGETRequestWithUrl:url callback:cb_result];
}



+ (void)appPayWithOrderId:(NSString *)orderId receipt:(NSString *)receipt callback:(CommonResultBlock)cb_result {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:orderId forKey:@"order_id"];
    [dict setObject:@0 forKey:@"os"];
    [dict setObject:receipt forKey:@"receipt"];
    
    NSString *requestUrl = [ServerURL getServiceUrl:api_inAppPay];
    [self performGETRequestWithUrl:requestUrl params:dict callback:cb_result];
    //[self requestWithWithUrl:[ServerURL getInAppPay] parameters:dict Result:resultBlock];
}

+ (void)getChannelsListWithCallback:(CommonResultBlock)cb_result {
    
    NSDictionary *params = [self appendRequiredParams:nil]; // set uid and token (and others)
    
    NSString *requestUrl = [ServerURL getServiceUrl:api_getAllChannels];
    [self performGETRequestWithUrl:requestUrl params:params callback:cb_result];
}
+ (void)getOldestAppVersionSupportForDevice:(NSString*)strDevice withCallback:(CommonResultBlock)cb_result
{
//    NSString *thisuid = [Config getOwnID];
    NSString *servEndpoint = [ServerURL getServiceUrl:api_getVersion];
//    NSString *fullReqUrl = [servEndpoint stringByAppendingFormat:@"&uid=%@&touid=%@", thisuid, targ_id];
    NSString *url = [self addValidateParams:servEndpoint]; // note: device=ios already included
    [self performGETRequestWithUrl:url callback:cb_result];
    
//    NSDictionary *params = [self appendRequiredParams:@{@"device":strDevice}]; // set uid and token (and others)
//    
//    NSString *requestUrl =
//    [self performGETRequestWithUrl:requestUrl params:params callback:cb_result];
}
/*
+ (void)getChannelWithResult:(CommonResultBlock)resultBlock {
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    if (parameters == nil) {
        parameters = [NSMutableDictionary dictionary];
    }
    [self addValidateParamsWithDict:parameters];
    CommonReturn *commonReturn = [[CommonReturn alloc] init];
    [HttpRequest getWithURLString:[ServerURL getServiceUrl:api_getChannel] parameters:parameters success:^(id responseObject) {
        [MBProgressHUD hideHUD];
        if ([self validateCode:responseObject]) {
            commonReturn.state = 1;
            commonReturn.data = responseObject[@"data"];
        } else {
            commonReturn.msg = [self getMessage:responseObject];
            [MBProgressHUD showError:commonReturn.msg];
        }
        resultBlock(commonReturn);
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:@"Net Error!"];
        resultBlock(commonReturn);
    }];
}
 */
+ (void)createProfileWithUserNick:(NSString*)nick birthday:(NSString*)bday callback:(CommonResultBlock)cb_result
{
    NSString *thisuid = [Config getOwnID];
    NSString *servEndpoint = [ServerURL getServiceUrl:api_createProfile];
    NSString *fullReqUrl = [servEndpoint stringByAppendingFormat:@"&uid=%@&user_nickname=%@&birthday=%@", thisuid, nick, bday];
    NSString *url = [self addValidateParams:fullReqUrl];
    [self performGETRequestWithUrl:url callback:cb_result];
}

+ (void)setBlockedUserTargetId:(NSString*)targ_id callback:(CommonResultBlock)cb_result
{
    NSString *thisuid = [Config getOwnID];
    NSString *servEndpoint = [ServerURL getServiceUrl:api_block];
    NSString *fullReqUrl = [servEndpoint stringByAppendingFormat:@"&uid=%@&block_id=%@", thisuid, targ_id];
    NSString *url = [self addValidateParams:fullReqUrl];
    [self performGETRequestWithUrl:url callback:cb_result];
}

+ (void)setUnblockedUserTargetId:(NSString*)targ_id callback:(CommonResultBlock)cb_result
{
    NSString *thisuid = [Config getOwnID];
    NSString *servEndpoint = [ServerURL getServiceUrl:api_unblock];
    NSString *fullReqUrl = [servEndpoint stringByAppendingFormat:@"&uid=%@&block_id=%@", thisuid, targ_id];
    NSString *url = [self addValidateParams:fullReqUrl];
    [self performGETRequestWithUrl:url callback:cb_result];
}

+ (void)getIsBlockedUserTargetId:(NSString*)targ_id callback:(CommonResultBlock)cb_result
{
    NSString *thisuid = [Config getOwnID];
    NSString *servEndpoint = [ServerURL getServiceUrl:api_isBlocked];
    NSString *fullReqUrl = [servEndpoint stringByAppendingFormat:@"&uid=%@&touid=%@", thisuid, targ_id];
    NSString *url = [self addValidateParams:fullReqUrl];
    [self performGETRequestWithUrl:url callback:cb_result];
}

+ (void)performGETRequestWithUrl:(NSString*)url params:(NSDictionary*)params callback:(CommonResultBlock)cb_result
{
    CommonReturn *commonReturn = [[CommonReturn alloc] init];
    [HttpRequest getWithURLString:url
                       parameters:params
                          success:^(id responseObject) {
                              commonReturn.ret = [self getRetStatusFromRespObj:responseObject];
                              commonReturn.data = [self getDataDictFromRespObj:responseObject];
                              commonReturn.msg = [self getMsgStringFromRespObj:responseObject];
                              
                              commonReturn.state = commonReturn.ret < 0 ? kRespStateFailure : kRespStateSuccess;
                              cb_result(commonReturn);
                          }
                          failure:^(NSError *error) {
                              NSString *errdesc = [NSString stringWithString:error.description];
                              XLM_error(@"HTTP request error...\n url: %@\n error: %@\n\n", url, errdesc);
                              commonReturn.state = kRespStateFailure;
                              commonReturn.msg = errdesc;
                              cb_result(commonReturn);
                          }];
}
+ (void)performGETRequestWithUrl:(NSString*)url callback:(CommonResultBlock)cb_result
{
    CommonReturn *commonReturn = [[CommonReturn alloc] init];
    [HttpRequest getWithURLString:url
                       parameters:nil
                          success:^(id responseObject) {
                              commonReturn.ret = [self getRetStatusFromRespObj:responseObject];
                              commonReturn.data = [self getDataDictFromRespObj:responseObject];
                              commonReturn.msg = [self getMsgStringFromRespObj:responseObject];
                              
                              commonReturn.state = commonReturn.ret < 0 ? kRespStateFailure : kRespStateSuccess;
                              cb_result(commonReturn);
                          }
                          failure:^(NSError *error) {
                              NSString *errdesc = [NSString stringWithString:error.description];
                              XLM_error(@"HTTP request error...\n url: %@\n error: %@\n\n", url, errdesc);
                              commonReturn.state = kRespStateFailure;
                              commonReturn.msg = errdesc;
                              cb_result(commonReturn);
                          }];
}
@end
