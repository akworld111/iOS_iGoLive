//
//  NetworkDefines.h
//  igolive
//
//  Created by greenhouse on 8/30/16.
//  Copyright © 2016 iGoLive LLC. All rights reserved.
//

#ifndef NetworkDefines_h
#define NetworkDefines_h


////////////////////////////////////////////
#pragma mark - chat socket keys
////////////////////////////////////////////
#define kSockConn @"conn"
#define kSockDisconnect @"disconnect"
#define kSockReconnect @"reconnect"
#define kSockError @"error"
#define kSockBroadcastListen @"broadcastingListen"

////////////////////////////////////////////
#pragma mark - new api response keys
////////////////////////////////////////////
#define kRespStatus @"ret"
#define kRespData @"data"
#define kRespMsg @"msg"

#define kRespDataArr @"dataArr"

#define kRespStateFailure 0
#define kRespStateSuccess 1

// channels
#define kChanIdReq @"cid"
#define kTagNameReq @"Tag"
#define kStreamReqOffset @"offset"
#define kChanId @"id"
#define kChanColor @"color"
#define kChanName @"channel_name"
#define kTagsArr @"tags"
#define kChanStreamCount @"stream_count"

// tags
#define kTagChId @"channel_id"
#define kTagId @"id"
#define kTagName @"tag"

////////////////////////////////////////////
#pragma mark - response service APIs/paths
////////////////////////////////////////////
#define api_updateProfile @"User.UpdateProfile"

// home view
#define api_getAllChannels @"Room.getChannels" // return 'data' key = array
#define api_getChannel  @"Lobby.getChannel"
#define api_getVersion @"Base.getVersion"


// live streaming
#define api_createProfile  @"User.createProfile"
#define api_block @"Room.Block"
#define api_unblock @"Room.Unblock"
#define api_isBlocked @"Room.IsBlocked"

// transactions
#define api_inAppPay  @"Pay.inAppPay"


////////////////////////////////////////////
#pragma mark - request constants / defaults
////////////////////////////////////////////
#define req_img_size_perc 0.10f // range: 0.0 - 1.0
#define req_img_qual_comp 0.0f  // range: 0.0 - 1.0 "compression is 0(most)..1(least)"

#endif /* NetworkDefines_h */
