//
//  ServerURL.m
//  iphoneLive
//
//  Created by christlee on 16/8/8.
//  Copyright © 2016年 cat. All rights reserved.
//
#import "ServerURL.h"
//Login
#define g_getSMSCodeURL  @"User.GetVerificationForMobile"
#define g_userLogin  @"User.userLogin"
#define g_userLoginByThird  @"User.UserLoginByThird"

//Live
//#define g_getChannel  @"Lobby.getChannel"
#define g_getLevelLimit  @"Room.GetLevelLimit"
#define g_getTags  @"User.GetTags"
#define g_getChannels  @"Room.getChannels"
#define g_setNodejsInfo  @"Room.setNodejsInfo"
#define g_createRoom  @"Room.CreateRoom"
#define g_getRedislist  @"Room.GetRedislist"
#define g_getPushUrl  @"/broadcast/"
#define g_getIsAdmin  @"Room.GetIsAdmin"
#define g_getIsAttention  @"User.isAttention"
#define g_setAttention  @"User.setAttention"
#define g_setLight  @"Room.SetLight"
#define g_updateRoomnum  @"Room.UpdateRoomnum"
#define g_setShutUp  @"User.isAttention"
#define g_isShutUp  @"Room.isShutUp"
#define g_sendBarrage  @"Room.sendBarrage"
#define g_sendSendGift  @"Room.SendGift"
#define g_getPopup  @"User.getPopup"
#define g_attentionLive  @"Lobby.AttentionLive"
#define g_getNew  @"Lobby.GetNew"
#define g_searchArea  @"Lobby.SearchArea"
#define g_getCoins  @"Base.getCoins"
#define g_stopRoom  @"Room.StopRoom"
#define g_getOrder  @"Pay.getOrder"
#define g_inAppPay  @"Pay.inAppPay"
#define g_getGifts  @"Base.GetGifts"
#define g_uplaodHeadInage  @"User.Upload"
#define g_getBlackList  @"Room.GetBlockList"
#define g_Recommand  @"Lobby.Recommand"
#define g_setBlockList  @"Room.SetBlackList"
#define g_reportUser  @"Room.Report"


//personal
#define g_getInfo  @"User.getInfo"
#define g_getCoinRecord  @"Coin.GetCoinRecord"
#define g_getFollowers  @"User.GetFollowers"
#define g_getFollowings  @"User.GetFollowings"
#define g_getTerms  @"Base.GetService"
#define g_getLevel  @"User.GetLevel"
#define g_getWithdraw  @"Coin.GetWithdraw"
#define g_getLiveRecord  @"User.GetLiveRecord"
#define g_getCharge  @"Coin.GetCharge"

//user
#define g_IsFollowing  @"User.IsFollowing"
#define g_IsShutUp  @"Room.IsShutUp"
#define g_follow  @"User.Follow"
#define g_userUpdateProfile  @"User.UpdateProfile"
#define g_userFollowAll  @"User.followAll"
#define g_userUnFollowAll  @"User.unFollowAll"
#define g_getInterestList  @"User.interestList"
//#define g_aboutUs  @"http://web.igo.live/public/appcmf/index.php?g=portal&m=page&a=lists"
#define g_aboutUs  @"http://igo.live/support.html"
@implementation ServerURL

////////////////////////////////////////////////////////////
#pragma mark - NEW api support
////////////////////////////////////////////////////////////
+ (NSString *)getServiceUrl:(NSString*)service {
    return [NSString stringWithFormat:@"%@%@",SERVER_URL,service];
}

////////////////////////////////////////////////////////////
#pragma mark - legacy api support
////////////////////////////////////////////////////////////
#pragma mark - Login
+ (NSString *)getSMSCode {
    return [ServerURL getServiceUrl:g_getSMSCodeURL];
}

+ (NSString *)userLogin {
    return [ServerURL getServiceUrl: g_userLogin];
}

+ (NSString *)userLoginByThird {
    return [ServerURL getServiceUrl: g_userLoginByThird];
}

#pragma mark - Live
//+ (NSString *)getChannel {
//    return [ServerURL getServiceUrl: g_getChannel];
//}

+ (NSString *)getLevelLimit {
    return [ServerURL getServiceUrl: g_getLevelLimit];
}

+ (NSString *)getTags {
    return [ServerURL getServiceUrl: g_getTags];
}

+ (NSString *)getChannels {
    return [ServerURL getServiceUrl:g_getChannels];
}

+ (NSString *)setNodejsInfo {
    return [ServerURL getServiceUrl: g_setNodejsInfo];
}

+ (NSString *)createRoom {
    return [ServerURL getServiceUrl: g_createRoom];
}

+ (NSString *)getRedislist {
    return [ServerURL getServiceUrl: g_getRedislist];
}

+ (NSURL *)getPushUrl {
    return [NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@", pushRtmpUrl, g_getPushUrl,[Config getOwnID]]];
}

+ (NSString *)getIsAdmin {
    return [ServerURL getServiceUrl: g_getIsAdmin];
}

+ (NSString *)getIsAttention {
    return [ServerURL getServiceUrl: g_getIsAttention];
}

+ (NSString *)setAttention {
    return [ServerURL getServiceUrl: g_setAttention];
}

+ (NSString *)setLight {
    return [ServerURL getServiceUrl: g_setLight];
}

+ (NSString *)updateRoomnum {
    return [ServerURL getServiceUrl: g_setLight];
}

+ (NSString *)isShutUp {
    return [ServerURL getServiceUrl: g_isShutUp];
}

+ (NSString *)setShutUp {
    return [ServerURL getServiceUrl: g_setShutUp];
}

+ (NSString *)sendBarrage {
    return [ServerURL getServiceUrl: g_sendBarrage];
}

+ (NSString *)sendGift {
    return [ServerURL getServiceUrl: g_sendSendGift];
}

+ (NSString *)getPopup {
    return [ServerURL getServiceUrl: g_getPopup];
}

+ (NSString *)getAttentionLive {
    return [ServerURL getServiceUrl: g_attentionLive];
}

+ (NSString *)getNewLiveList {
    return [ServerURL getServiceUrl: g_getNew];
}

+ (NSString *)getSearchAreaLiveList {
    return [ServerURL getServiceUrl: g_searchArea];
}

+ (NSString *)getCoinsList {
    return [ServerURL getServiceUrl: g_getCoins];
}

+ (NSString *)getStopRoom {
    return [ServerURL getServiceUrl: g_stopRoom];
}

+ (NSString *)getOrder {
    return [ServerURL getServiceUrl: g_getOrder];
}

+ (NSString *)getInAppPay {
    return [ServerURL getServiceUrl: g_inAppPay];
}

+ (NSString *)getGifts {
    return [ServerURL getServiceUrl: g_getGifts];
}

+ (NSString *)getUpLoadImage {
    return [ServerURL getServiceUrl: g_uplaodHeadInage];
}

+ (NSString *)getBlackList {
    return [ServerURL getServiceUrl:g_getBlackList];
}

+ (NSString *)getRecommand {
    return [ServerURL getServiceUrl:g_Recommand];
}

+ (NSString *)setBlackList {
    return [ServerURL getServiceUrl:g_setBlockList];
}

+ (NSString *)reportUser {
    return [ServerURL getServiceUrl:g_reportUser];
    
}

#pragma mark - persenal

+ (NSString *)getInfo {
    return [ServerURL getServiceUrl:g_getInfo];
}

+ (NSString *)getCoinRecord {
    return [ServerURL getServiceUrl:g_getCoinRecord];
}

+ (NSString *)getFollowers {
    return [ServerURL getServiceUrl:g_getFollowers];
}

+ (NSString *)getFollowings {
    return [ServerURL getServiceUrl:g_getFollowings];
}

+ (NSString *)getTermsAndConditions {
    return [ServerURL getServiceUrl:g_getTerms];
}

+ (NSString *)getLevel {
    return [ServerURL getServiceUrl: g_getLevel];
}

+ (NSString *)getWithdraw {
    return [ServerURL getServiceUrl: g_getWithdraw];
}

+ (NSString *)getLiveRecord {
    return [ServerURL getServiceUrl: g_getLiveRecord];
}

+ (NSString *)getCharge{
     return [ServerURL getServiceUrl: g_getCharge];
}


#pragma mark - User
+ (NSString *)isFollowing {
    return [ServerURL getServiceUrl: g_IsFollowing];
}

+ (NSString *)isIsShutUp {
    return [ServerURL getServiceUrl: g_IsShutUp];
}

+ (NSString *)setFollow {
    return [ServerURL getServiceUrl: g_follow];
}

+ (NSString *)upLoadUserInfo {
    return [ServerURL getServiceUrl: g_userUpdateProfile];
}

+ (NSString *)setFollowAll {
    return [ServerURL getServiceUrl: g_userFollowAll];
}

+ (NSString *)setUnFollowAll {
    return [ServerURL getServiceUrl: g_userFollowAll];
}

+ (NSString *)getUserInterestList {
    return [ServerURL getServiceUrl: g_getInterestList];
}

+ (NSURL *)aboutUsUrl {
    return [NSURL URLWithString:[NSString stringWithFormat:@"%@",g_aboutUs]];
}

@end
