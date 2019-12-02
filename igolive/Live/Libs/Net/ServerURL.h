//
//  ServerURL.h
//  iphoneLive
//
//  Created by christlee on 16/8/8.
//  Copyright © 2016年 cat. All rights reserved.
//

#import <Foundation/Foundation.h>

//#define SERVER_URI @"http://web.igo.live/public?service="
//#define SERVER_URI @"http://sandbox.igo.live/?service="

@interface ServerURL : NSObject

#pragma mark - NEW api support
+ (NSString *)getServiceUrl:(NSString*)service;

#pragma mark - Login
+ (NSString *)userLogin;

+ (NSString *)getSMSCode;

+ (NSString *)userLoginByThird;

#pragma mark - Live
//+ (NSString *)getChannel;

+ (NSString *)getLevelLimit;

+ (NSString *)getTags;

+ (NSString *)getChannels;

+ (NSString *)createRoom;

+ (NSString *)setNodejsInfo;

+ (NSString *)getRedislist;

+ (NSURL *)getPushUrl;

+ (NSString *)getIsAdmin;

+ (NSString *)getIsAttention;

+ (NSString *)setAttention;

+ (NSString *)setLight;

+ (NSString *)updateRoomnum;

+ (NSString *)isShutUp;

+ (NSString *)setShutUp;

+ (NSString *)sendBarrage;

+ (NSString *)sendGift;

+ (NSString *)getPopup;

+ (NSString *)getAttentionLive;

+ (NSString *)getNewLiveList;

+ (NSString *)getSearchAreaLiveList;

+ (NSString *)getCoinsList;

+ (NSString *)getStopRoom;

+ (NSString *)getOrder;

+ (NSString *)getInAppPay;

+ (NSString *)getGifts;

+ (NSString *)getUpLoadImage;

+ (NSString *)getBlackList;

+ (NSString *)getRecommand;

+ (NSString *)setBlackList;

+ (NSString *)reportUser;

#pragma mark - pensonal

+ (NSString *)getInfo;

+ (NSString *)getCoinRecord;

+ (NSString *)getFollowers;

+ (NSString *)getFollowings;

+ (NSString *)getTermsAndConditions;

+ (NSString *)getLevel;

+ (NSString *)getWithdraw;

+ (NSString *)getLiveRecord;

+ (NSString *)getCharge;

#pragma mark - User
+ (NSString *)isFollowing;

+ (NSString *)isIsShutUp;

+ (NSString *)setFollow;

+ (NSString *)upLoadUserInfo;

+ (NSString *)setFollowAll;

+ (NSString *)getUserInterestList;

+ (NSURL *)aboutUsUrl;
@end
