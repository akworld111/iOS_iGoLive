//
//  HttpController.h
//  igolive
//
//  Created by greenhouse on 8/30/16.
//  Copyright © 2016 iGoLive LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HttpBaseController.h"

@interface HttpController : HttpBaseController

+ (void)upLaodUserInfoWithPersonInfoModel:(PersonalInfoModel *)personInfoModel callback:(CommonResultBlock)cb_result;

+ (void)appPayWithOrderId:(NSString *)orderId receipt:(NSString *)receipt callback:(CommonResultBlock)cb_result;
+ (void)getChannelsListWithCallback:(CommonResultBlock)cb_result;

+ (void)createProfileWithUserNick:(NSString*)nick birthday:(NSString*)bday callback:(CommonResultBlock)cb_result;
+ (void)setBlockedUserTargetId:(NSString*)targ_id callback:(CommonResultBlock)cb_result;
+ (void)setUnblockedUserTargetId:(NSString*)targ_id callback:(CommonResultBlock)cb_result;
+ (void)getIsBlockedUserTargetId:(NSString*)targ_id callback:(CommonResultBlock)cb_result;
+ (void)getOldestAppVersionSupportForDevice:(NSString*)strDevice withCallback:(CommonResultBlock)cb_result;

@end


