//
//  HttpService.h
//  iphoneLive
//
//  Created by 高翔 on 16/8/5.
//  Copyright © 2016年 cat. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UploadParam.h"
#import "HttpBaseService.h"

@interface HttpService : HttpBaseService

+ (void)getOldestAppVersionSupportForDevice:(NSString*)strDevice withCallback:(CommonResultBlock)cb_result;
+ (void)uplaodHeadImageWithloadParam:(UploadParam *)uploadParam result:(CommonResultBlock)resultBlock;

#pragma mark - Login
//Get SMS verification code
+ (void)getSMSCodeWithMobile:(NSString *)mobile country:(NSString *)country result:(CommonResultBlock)resultBlock;

+ (void)loginWithMobile:(NSString *)mobile country:(NSString *)country verificationCode:(NSString *)verificationCode result:(CommonResultBlock)resultBlock;

+ (void)userLoginByThirdWith:(NSString*)type withPersonInfoModel:(LoginByThirdModel*)loginByThirdModel result:(CommonResultBlock)resultBlock;

#pragma mark - Live
+ (void)getChannelForId:(NSNumber*)chId offset:(int)offset withResult:(CommonResultBlock)resultBlock;

+ (void)getLevelLimitWithResult:(CommonResultBlock)resultBlock;

+ (void)getTagsWithResult:(CommonResultBlock)resultBlock;

+ (void)getChannelsWithResult:(CommonResultBlock)resultBlock;

+ (void)createRoomWithTitle:(NSString *)title province:(NSString *)province city:(NSString *)city longitude:(NSString *)longitude latitude:(NSString *)latitude channel:(NSString *)channel tags:(NSString *)tags result:(CommonResultBlock)resultBlock;

+ (void)setNodejsInfoWithShowid:(NSString *)showid result:(CommonResultBlock)resultBlock;

+ (void)getRedislistWithShowid:(NSString *)showid result:(CommonResultBlock)resultBlock;

+ (void)getIsAdminWithUid:(NSString *)uid showid:(NSString *)showid result:(CommonResultBlock)resultBlock;

+ (void)setLightWithShowid:(NSString *)showid result:(CommonResultBlock)resultBlock;

+ (void)updateRoomnumWithUid:(NSString *)uid type:(NSString *)type result:(CommonResultBlock)resultBlock;

+ (void)isShutUpWithUid:(NSString *)uid showid:(NSString *)showid result:(CommonResultBlock)resultBlock;

+ (void)setShutUpWithUid:(NSString *)uid showid:(NSString *)showid touid:(NSString *)touid result:(CommonResultBlock)resultBlock;

+ (void)sendGiftWithTouid:(NSString *)touid giftid:(NSString *)giftid giftcount:(NSString*)giftcount result:(CommonResultBlock)resultBlock;

+ (void)sendBarrageWithTouid:(NSString *)touid content:(NSString *)content result:(CommonResultBlock)resultBlock;;

+ (void)getPopupWithUid:(NSString *)uid result:(CommonResultBlock)resultBlock;

+ (void)getAttentionLiveWithResult:(CommonResultBlock)resultBlock;

+ (void)getNewListWithResult:(CommonResultBlock)resultBlock;

+ (void)getSearchAreaListWithResult:(CommonResultBlock)resultBlock;

+ (void)stopRoomWithResult:(CommonResultBlock)resultBlock;

+ (void)getOrderWithProductId:(NSString *)productId result:(CommonResultBlock)resultBlock;

+ (void)getGiftsWithResult:(CommonResultBlock)resultBlock;

+ (void)appPayWithOrderId:(NSString *)orderId receipt:(NSString *)receipt result:(CommonResultBlock)resultBlock;

+ (void)getBlackListResult:(CommonResultBlock)resultBlock;

+ (void)getRecommandList:(CommonResultBlock)resultBlock;

+ (void)setBlockListWithBlockId:(NSString*)blockId result:(CommonResultBlock)resultBlock;

+ (void)reportUserWithTargId:(NSString*)targId description:(NSString*)content result:(CommonResultBlock)resultBlock;


#pragma mark - personal

+ (void)getInfoWithUcuid:(NSString *)ucuid result:(CommonResultBlock)resultBlock;

+ (void)getCoinsListWithResult:(CommonResultBlock)resultBlock;

+ (void)getCoinRecordWithShowid:(NSString *)showid result:(CommonResultBlock)resultBlock;

+ (void)getFollowersWithoffset:(NSString *)offset ucuid:(NSString *)ucuid result:(CommonResultBlock)resultBlock;

+ (void)getFollowingsWithUcuid:(NSString *)ucuid withoffSet:(NSString*)offSet result:(CommonResultBlock)resultBlock;

+ (void)getTermsAndConditionsresult:(CommonResultBlock)resultBlock;

+ (void)getLevelWithResult:(CommonResultBlock)resultBlock;

+ (void)getLiveRecordWithAnchorId:(NSString *)anchorId result:(CommonResultBlock)resultBlock;

+ (void)getChargeResult:(CommonResultBlock)resultBlock;

#pragma mark - User
+ (void)getIsFollowingWithTouid:(NSString *)touid result:(CommonResultBlock)resultBlock;

+ (void)getIsShutUpWithUid:(NSString *)uid showid:(NSString *)showid result:(CommonResultBlock)resultBlock;

+ (void)setFollowWithShowid:(NSString *)showid result:(CommonResultBlock)resultBlock;

+ (void)setUpLoadHeadImageWithUid:(NSString*)uid withFile:(NSString*)file result:(CommonResultBlock)resultBlock;

+ (void)getWithdrawWithResult:(CommonResultBlock)resultBlock;

+ (void)upLaodUserInfoWithPersonInfoModel:(PersonalInfoModel *)personInfoModel result:(CommonResultBlock)resultBlock;

+ (void)setFollwAllWithShowIdArray:(NSArray *)showIdArray result:(CommonResultBlock)resultBlock;

+ (void)getUserInterestListResult:(CommonResultBlock)resultBlock;
@end
