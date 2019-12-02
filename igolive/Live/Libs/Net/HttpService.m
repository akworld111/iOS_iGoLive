//
//  HttpService.m
//  iphoneLive
//
//  Created by 高翔 on 16/8/5.
//  Copyright © 2016年 cat. All rights reserved.
//

#import "HttpService.h"
#import "HttpRequest.h"
#import "ServerURL.h"

@implementation HttpService

+ (void)requestWithWithUrl:(NSString *)url parameters:(NSMutableDictionary *)parameters Result:(CommonResultBlock)resultBlock {
    if (parameters == nil) {
        parameters = [NSMutableDictionary dictionary];
    }
    [self addValidateParamsWithDict:parameters];
    CommonReturn *commonReturn = [[CommonReturn alloc] init];
    [HttpRequest getWithURLString:url parameters:parameters success:^(id responseObject) {
        [MBProgressHUD hideHUD];
        if ([self validateCode:responseObject]) {
            commonReturn.state = 1;
            commonReturn.data = [self getData:responseObject];
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
+ (void)getOldestAppVersionSupportForDevice:(NSString*)strDevice withCallback:(CommonResultBlock)cb_result
{
    NSString *url = [ServerURL getServiceUrl:api_getVersion];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [self requestWithWithUrl:url parameters:dict Result:cb_result]; // already adds device=ios to query string or http body
}

#pragma mark - Login

+ (void)uplaodHeadImageWithloadParam:(UploadParam *)uploadParam result:(CommonResultBlock)resultBlock {
    NSString *url = [purl stringByAppendingFormat:@"/?service=User.upload&uid=%@&token=%@",[Config getOwnID],[Config getOwnToken]];
    CommonReturn *commonReturn = [[CommonReturn alloc] init];

    [HttpRequest uploadWithURLString:url parameters:nil uploadParam:uploadParam success:^(id responseObject) {
        if ([self validateCode:responseObject]) {
            commonReturn.state = 1;
            commonReturn.data = [self getData:responseObject];
        } else {
            commonReturn.msg = [self getMessage:responseObject];
        }
        resultBlock(commonReturn);
    } failure:^(NSError *error) {
        XLM_error(@"error: %@", error.description);
        commonReturn.msg = [error description];
        resultBlock(commonReturn);
    }];

}

+ (void)getSMSCodeWithMobile:(NSString *)mobile country:(NSString *)country result:(CommonResultBlock)resultBlock {
    NSString *url = [ServerURL getSMSCode];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:mobile forKey:@"mobile"];
    [dict setValue:country forKey:@"country"];
    [self requestWithWithUrl:url parameters:dict Result:resultBlock];
    
}

+ (void)loginWithMobile:(NSString *)mobile country:(NSString *)country verificationCode:(NSString *)verificationCode result:(CommonResultBlock)resultBlock {
    NSString *url = [ServerURL userLogin];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:mobile forKey:@"user_login"];
    [dict setValue:country forKey:@"country"];
    [dict setValue:verificationCode forKey:@"code"];
    [self requestWithWithUrl:url parameters:dict Result:resultBlock];
}

+ (void)userLoginByThirdWith:(NSString*)type withPersonInfoModel:(LoginByThirdModel*)loginByThirdModel result:(CommonResultBlock)resultBlock {
    NSString *url = [ServerURL userLoginByThird];
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"type"]= type;
    dic[@"openid"] = loginByThirdModel.openid;
    dic[@"nicename"] = loginByThirdModel.nicename;
    dic[@"email"] = loginByThirdModel.email;
    dic[@"birth"] = loginByThirdModel.birth;
    dic[@"gender"] = loginByThirdModel.gender;
    dic[@"avatar"] = loginByThirdModel.avatar;
    dic[@"likes"] = loginByThirdModel.likes;

    
    CommonReturn *commonReturn = [[CommonReturn alloc] init];
    [HttpRequest getWithURLString:url parameters:dic success:^(id responseObject) {
        if ([self validateCode:responseObject]) {
            if ([responseObject[@"data"][@"code"] intValue] == 0) {
                commonReturn.state = 1;
                commonReturn.data = [self getData:responseObject];
            } else {
                commonReturn.msg = responseObject[@"data"][@"msg"];
            }
        } else {
            commonReturn.msg = [self getMessage:responseObject];
        }
        resultBlock(commonReturn);
    } failure:^(NSError *error) {
        commonReturn.msg = [error description];
        resultBlock(commonReturn);
    }];

}

#pragma mark - Live
+ (void)getChannelForId:(NSNumber*)chId offset:(int)offset withResult:(CommonResultBlock)resultBlock {
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    if (parameters == nil) {
        parameters = [NSMutableDictionary dictionary];
    }
    
    [parameters setObject:chId forKey:kChanIdReq];
    [parameters setObject:[NSNumber numberWithInt:offset] forKey:kStreamReqOffset];
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

+ (void)getLevelLimitWithResult:(CommonResultBlock)resultBlock {
    [self requestWithWithUrl:[ServerURL getLevelLimit] parameters:nil Result:resultBlock];
}

+ (void)getTagsWithResult:(CommonResultBlock)resultBlock {
    [self requestWithWithUrl:[ServerURL getTags] parameters:nil Result:resultBlock];
}

+ (void)getChannelsWithResult:(CommonResultBlock)resultBlock {
    [self requestWithWithUrl:[ServerURL getChannels] parameters:nil Result:resultBlock];
}

+ (void)createRoomWithTitle:(NSString *)title province:(NSString *)province city:(NSString *)city longitude:(NSString *)longitude latitude:(NSString *)latitude channel:(NSString *)channel tags:(NSString *)tags result:(CommonResultBlock)resultBlock {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:title forKey:@"title"];
    [dict setValue:province forKey:@"province"];
    [dict setValue:city forKey:@"city"];
    [dict setValue:tags?:@"" forKey:@"tags"];
    [dict setValue:channel?:@"" forKey:@"channel"];
    [dict setValue:longitude?:@"" forKey:@"longitude"];
    [dict setValue:latitude?:@"" forKey:@"latitude"];
    [self requestWithWithUrl:[ServerURL createRoom] parameters:dict Result:resultBlock];
}

+ (void)setNodejsInfoWithShowid:(NSString *)showid result:(CommonResultBlock)resultBlock {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:showid forKey:@"showid"];
    [self requestWithWithUrl:[ServerURL setNodejsInfo] parameters:dict Result:resultBlock];
}

+ (void)getRedislistWithShowid:(NSString *)showid result:(CommonResultBlock)resultBlock {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:showid forKey:@"showid"];
    [dict setValue:@"0" forKey:@"size"];
    [self requestWithWithUrl:[ServerURL getRedislist] parameters:dict Result:resultBlock];
}

+ (void)getIsAdminWithUid:(NSString *)uid showid:(NSString *)showid result:(CommonResultBlock)resultBlock {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:uid forKey:@"uid"];
    [dict setValue:showid forKey:@"showid"];
    [self requestWithWithUrl:[ServerURL getIsAdmin] parameters:dict Result:resultBlock];
}

+ (void)setLightWithShowid:(NSString *)showid result:(CommonResultBlock)resultBlock {
    NSString *url = [[ServerURL setLight] stringByAppendingFormat:@"&uid=%@&showid=%@",[Config getOwnID],showid];
    url = [self addValidateParams:url];
    CommonReturn *commonReturn = [[CommonReturn alloc] init];
    
    [HttpRequest getWithURLString:url parameters:nil success:^(id responseObject) {
        if ([self validateCode:responseObject]) {
            commonReturn.state = 1;
            commonReturn.data = [self getData:responseObject];
        } else {
            commonReturn.msg = [self getMessage:responseObject];
        }
        resultBlock(commonReturn);
    } failure:^(NSError *error) {
        commonReturn.msg = [error description];
        resultBlock(commonReturn);
    }];
}

+ (void)updateRoomnumWithUid:(NSString *)uid type:(NSString *)type result:(CommonResultBlock)resultBlock {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:uid forKey:@"uid"];
    [dict setValue:type forKey:@"type"];
    [self requestWithWithUrl:[ServerURL updateRoomnum] parameters:dict Result:resultBlock];
}

+ (void)isShutUpWithUid:(NSString *)uid showid:(NSString *)showid result:(CommonResultBlock)resultBlock {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:uid forKey:@"uid"];
    [dict setValue:showid forKey:@"showid"];
    [self requestWithWithUrl:[ServerURL isShutUp] parameters:dict Result:resultBlock];
}

+ (void)setShutUpWithUid:(NSString *)uid showid:(NSString *)showid touid:(NSString *)touid result:(CommonResultBlock)resultBlock {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:uid forKey:@"uid"];
    [dict setValue:showid forKey:@"showid"];
    [dict setValue:touid forKey:@"touid"];
    [self requestWithWithUrl:[ServerURL setShutUp] parameters:dict Result:resultBlock];
}

+ (void)sendGiftWithTouid:(NSString *)touid giftid:(NSString *)giftid giftcount:(NSString *)giftcount result:(CommonResultBlock)resultBlock {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:touid forKey:@"touid"];
    [dict setValue:giftid forKey:@"giftid"];
    [dict setValue:giftcount forKey:@"giftcount"];
    [self requestWithWithUrl:[ServerURL sendGift] parameters:dict Result:resultBlock];
}

+ (void)sendBarrageWithTouid:(NSString *)touid content:(NSString *)content result:(CommonResultBlock)resultBlock {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:touid forKey:@"touid"];
    [dict setValue:content forKey:@"content"];
    [self requestWithWithUrl:[ServerURL sendBarrage] parameters:dict Result:resultBlock];
}

+ (void)getPopupWithUid:(NSString *)uid result:(CommonResultBlock)resultBlock {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:uid forKey:@"uid"];
    [self requestWithWithUrl:[ServerURL getPopup] parameters:dict Result:resultBlock];
}

+ (void)getAttentionLiveWithResult:(CommonResultBlock)resultBlock {
    [self requestWithWithUrl:[ServerURL getAttentionLive] parameters:nil Result:resultBlock];
}

+ (void)getNewListWithResult:(CommonResultBlock)resultBlock {
    [self requestWithWithUrl:[ServerURL getNewLiveList] parameters:nil Result:resultBlock];
}

+ (void)getSearchAreaListWithResult:(CommonResultBlock)resultBlock {
    [self requestWithWithUrl:[ServerURL getSearchAreaLiveList] parameters:nil Result:resultBlock];
}

+ (void)stopRoomWithResult:(CommonResultBlock)resultBlock {
    [self requestWithWithUrl:[ServerURL getStopRoom] parameters:nil Result:resultBlock];
}

+ (void)getOrderWithProductId:(NSString *)productId result:(CommonResultBlock)resultBlock {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:productId forKey:@"product_id"];
    [dict setValue:@"0" forKey:@"os"];
    [self requestWithWithUrl:[ServerURL getOrder] parameters:dict Result:resultBlock];
}

+ (void)getGiftsWithResult:(CommonResultBlock)resultBlock {
    [self requestWithWithUrl:[ServerURL getGifts] parameters:nil Result:resultBlock];
}

+ (void)appPayWithOrderId:(NSString *)orderId receipt:(NSString *)receipt result:(CommonResultBlock)resultBlock {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:orderId forKey:@"order_id"];
    [dict setObject:@0 forKey:@"os"];
    [dict setObject:receipt forKey:@"receipt"];
    [self requestWithWithUrl:[ServerURL getInAppPay] parameters:dict Result:resultBlock];
}

+ (void)getFollowingsWithUcuid:(NSString *)ucuid withoffSet:(NSString*)offSet result:(CommonResultBlock)resultBlock {
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setValue:ucuid forKey:@"ucuid"];
    [dic setValue:offSet forKey:@"offset"];
    [self requestWithWithUrl:[ServerURL getFollowings] parameters:dic Result:resultBlock];

}

+ (void)getBlackListResult:(CommonResultBlock)resultBlock {
    [self requestWithWithUrl:[ServerURL getBlackList] parameters:nil Result:resultBlock];
}

+ (void)getRecommandList:(CommonResultBlock)resultBlock {
    [self requestWithWithUrl:[ServerURL getRecommand] parameters:nil Result:resultBlock];
}

+ (void)setBlockListWithBlockId:(NSString*)blockId result:(CommonResultBlock)resultBlock {
    NSString *url = [self addValidateParams:[[ServerURL setBlackList] stringByAppendingFormat:@"&uid=%@&black_id=%@",[Config getOwnID],blockId]];
    CommonReturn *commonReturn = [[CommonReturn alloc] init];
    [HttpRequest getWithURLString:url parameters:nil success:^(id responseObject) {
        if ([self validateCode:responseObject]) {
            commonReturn.state = 1;
            commonReturn.data = [self getData:responseObject];
        }else{
            commonReturn.msg = [self getMessage:responseObject];
        }
        resultBlock(commonReturn);
    } failure:^(NSError *error) {
        commonReturn.msg = [error description];
        resultBlock(commonReturn);
    }];
}

+ (void)reportUserWithTargId:(NSString*)targId description:(NSString*)content result:(CommonResultBlock)resultBlock
{
    NSString *url = [self addValidateParams:[[ServerURL reportUser] stringByAppendingFormat:@"&uid=%@&token=%@&touid=%@&content=%@",[Config getOwnID],[Config getOwnToken], targId, content]];
    CommonReturn *commonReturn = [[CommonReturn alloc] init];
    [HttpRequest getWithURLString:url parameters:nil success:^(id responseObject) {
        if ([self validateCode:responseObject]) {
            commonReturn.state = 1;
            //commonReturn.data = [self getData:responseObject];
            commonReturn.msg = [self getMessage:responseObject];
        }else{
            commonReturn.msg = [self getMessage:responseObject];
        }
        resultBlock(commonReturn);
    } failure:^(NSError *error) {
        commonReturn.msg = [error description];
        resultBlock(commonReturn);
    }];
}

#pragma mark - personal

+ (void)getInfoWithUcuid:(NSString *)ucuid result:(CommonResultBlock)resultBlock {
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setValue:ucuid forKey:@"ucuid"];
    [self requestWithWithUrl:[ServerURL getInfo] parameters:dic Result:resultBlock];
}

+ (void)getCoinsListWithResult:(CommonResultBlock)resultBlock {
    [self requestWithWithUrl:[ServerURL getCoinsList] parameters:nil Result:resultBlock];
}

+ (void)getCoinRecordWithShowid:(NSString *)showid result:(CommonResultBlock)resultBlock {
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setValue:showid forKey:@"showid"];
    [self requestWithWithUrl:[ServerURL getCoinRecord] parameters:dic Result:resultBlock];
}

+ (void)getFollowersWithoffset:(NSString *)offset ucuid:(NSString *)ucuid result:(CommonResultBlock)resultBlock {
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setValue:offset forKey:@"offset"];
    [dic setValue:ucuid forKey:@"ucuid"];
    [self requestWithWithUrl:[ServerURL getFollowers] parameters:dic Result:resultBlock];
}

+ (void)getTermsAndConditionsresult:(CommonResultBlock)resultBlock {
     NSString *url = [self addValidateParams:[ServerURL getTermsAndConditions]];
    CommonReturn *commonReturn = [[CommonReturn alloc] init];
    [HttpRequest getWithURLString:url parameters:nil success:^(id responseObject) {
        if ([self validateCode:responseObject]) {
            commonReturn.state = 1;
            commonReturn.data = [self getData:responseObject];
        }else{
            commonReturn.msg = [self getMessage:responseObject];
        }
        resultBlock(commonReturn);
    } failure:^(NSError *error) {
        commonReturn.msg = [error description];
        resultBlock(commonReturn);
    }];

}

+ (void)getLevelWithResult:(CommonResultBlock)resultBlock {
    [self requestWithWithUrl:[ServerURL getLevel] parameters:nil Result:resultBlock];
}

+ (void)getLiveRecordWithAnchorId:(NSString *)anchorId result:(CommonResultBlock)resultBlock {
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setValue:anchorId forKey:@"anchor_id"];
    [self requestWithWithUrl:[ServerURL getLiveRecord] parameters:dic Result:resultBlock];
}

+ (void)getChargeResult:(CommonResultBlock)resultBlock {
    NSString *url = [self addValidateParams:[[ServerURL getCharge] stringByAppendingFormat:@"&uid=%@", [Config getOwnID]]];
    CommonReturn *commonReturn = [[CommonReturn alloc] init];
    [HttpRequest getWithURLString:url parameters:nil success:^(id responseObject) {
        if ([self validateCode:responseObject]) {
            commonReturn.state = 1;
            commonReturn.data = [self getData:responseObject];
        }else{
            commonReturn.msg = [self getMessage:responseObject];
        }
        resultBlock(commonReturn);
    } failure:^(NSError *error) {
        commonReturn.msg = [error description];
        resultBlock(commonReturn);
    }];
}

#pragma mark - User
+ (void)getIsFollowingWithTouid:(NSString *)touid result:(CommonResultBlock)resultBlock {
    NSString *url = [[ServerURL isFollowing] stringByAppendingFormat:@"&uid=%@&touid=%@", [Config getOwnID],touid];
    url = [self addValidateParams:url];
    
    CommonReturn *commonReturn = [[CommonReturn alloc] init];
    [HttpRequest getWithURLString:url parameters:nil success:^(id responseObject) {
        if ([self validateCode:responseObject]) {
            commonReturn.state = 1;
            commonReturn.data = [self getData:responseObject];
        }else{
            commonReturn.msg = [self getMessage:responseObject];
        }
        resultBlock(commonReturn);

        
    } failure:^(NSError *error) {
        commonReturn.msg = [error description];
        resultBlock(commonReturn);
    }];

}

+ (void)getIsShutUpWithUid:(NSString *)uid showid:(NSString *)showid result:(CommonResultBlock)resultBlock {
    NSString *url = [[ServerURL isIsShutUp] stringByAppendingFormat:@"&uid=%@&showid=%@",uid,showid];
    url = [self addValidateParams:url];
    
    CommonReturn *commonReturn = [[CommonReturn alloc] init];
    [HttpRequest getWithURLString:url parameters:nil success:^(id responseObject) {
        if ([self validateCode:responseObject]) {
            commonReturn.state = 1;
            commonReturn.data = [self getData:responseObject];
        }else{
            commonReturn.msg = [self getMessage:responseObject];
        }
        resultBlock(commonReturn);
        
    } failure:^(NSError *error) {
        commonReturn.msg = [error description];
        resultBlock(commonReturn);
    }];
}

+ (void)setFollowWithShowid:(NSString *)showid result:(CommonResultBlock)resultBlock {
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setValue:showid forKey:@"showid"];
    [self requestWithWithUrl:[ServerURL setFollow] parameters:dic Result:resultBlock];
    
}

+ (void)setUpLoadHeadImageWithUid:(NSString*)uid withFile:(NSString*)file result:(CommonResultBlock)resultBlock {
    
    NSString *url = [self addValidateParams:[[ServerURL getUpLoadImage]stringByAppendingFormat:@"&uid=%@",uid]];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:uid forKey:@"uid"];
    [params setObject:file forKey:@"file"];
    CommonReturn *commonReturn = [[CommonReturn alloc] init];
    [HttpRequest getWithURLString:url parameters:params success:^(id responseObject) {
        if ([self validateCode:responseObject]) {
            commonReturn.state = 1;
            commonReturn.data = [self getData:responseObject];
        }else{
            commonReturn.msg = [self getMessage:responseObject];
        }
        resultBlock(commonReturn);
    } failure:^(NSError *error) {
        commonReturn.msg = [error description];
        resultBlock(commonReturn);
    }];
    
}

+ (void)getWithdrawWithResult:(CommonResultBlock)resultBlock {
     [self requestWithWithUrl:[ServerURL getWithdraw] parameters:nil Result:resultBlock];
}

+ (void)upLaodUserInfoWithPersonInfoModel:(PersonalInfoModel *)personInfoModel result:(CommonResultBlock)resultBlock {
    
    NSString *value = [NSString stringWithFormat:@"user_nickname=%@&signature=%@&gender=%@&birthday=%@&address=%@",personInfoModel.userNickname,personInfoModel.signature,personInfoModel.gender,personInfoModel.birthday,personInfoModel.city];
    for (int i=0; i<personInfoModel.interests.count; i++) {
        value = [NSString stringWithFormat:@"%@&interests[]=%@",value,personInfoModel.interests[i]];
    }
    NSLog(@"---%@",value);
    NSString *url = [[ServerURL upLoadUserInfo] stringByAppendingFormat:@"&uid=%@&value=%@",[Config getOwnID],value];
    url = [self addValidateParams:url];
    
    CommonReturn *commonReturn = [[CommonReturn alloc] init];
    [HttpRequest getWithURLString:url parameters:nil success:^(id responseObject) {
        if ([self validateCode:responseObject]) {
            commonReturn.state = 1;
            commonReturn.data = [self getData:responseObject];
        }else{
            commonReturn.msg = [self getMessage:responseObject];
        }
        resultBlock(commonReturn);
        
    } failure:^(NSError *error) {
        commonReturn.msg = [error description];
        resultBlock(commonReturn);
    }];
//    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
//    NSString *value = [NSString string];
//    for (int i=0; i<personInfoModel.interests.count; i++) {
//        value = [NSString stringWithFormat:@"%@",personInfoModel.interests[i]];
//    }
//    [dic setValue:value forKey:@"interests[]"];
//
//    [dic setValue:personInfoModel.userNickname forKey:@"user_nickname"];
//    [dic setValue:personInfoModel.signature forKey:@"signature"];
//    [dic setValue:personInfoModel.gender forKey:@"gender"];
//    [dic setValue:personInfoModel.birthday forKey:@"birthday"];
//    [dic setValue:personInfoModel.city forKey:@"address"];
//    [self requestWithWithUrl:[ServerURL upLoadUserInfo] parameters:dic Result:resultBlock];
}

+ (void)setFollwAllWithShowIdArray:(NSArray *)showIdArray result:(CommonResultBlock)resultBlock {
   
    NSString  * showid = showIdArray[0] ;
    for (int i=0; i<showIdArray.count-1; i++) {
        showid = [NSString stringWithFormat:@"%@|%@",showid,showIdArray[i+1]];
    }
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setValue:showid forKey:@"showid"];
    [self requestWithWithUrl:[ServerURL setFollowAll] parameters:dic Result:resultBlock];
}

+ (void)getUserInterestListResult:(CommonResultBlock)resultBlock {
    NSString *url = [[ServerURL getUserInterestList] stringByAppendingFormat:@"&uid=%@",[Config getOwnID]];
    url = [self addValidateParams:url];
    
    CommonReturn *commonReturn = [[CommonReturn alloc] init];
    [HttpRequest getWithURLString:url parameters:nil success:^(id responseObject) {
        if ([self validateCode:responseObject]) {
            commonReturn.state = 1;
            commonReturn.data = [self getData:responseObject];
        }else{
            commonReturn.msg = [self getMessage:responseObject];
        }
        resultBlock(commonReturn);
        
    } failure:^(NSError *error) {
        commonReturn.msg = [error description];
        resultBlock(commonReturn);
    }];

}

@end
