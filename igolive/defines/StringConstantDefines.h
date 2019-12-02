//
//  StringConstantDefines.h
//  igolive
//
//  Created by greenhouse on 8/27/16.
//  Copyright © 2016 iGoLive LLC. All rights reserved.
//

#ifndef StringConstantDefines_h
#define StringConstantDefines_h


#define str_appstore_link @"itms://itunes.apple.com/us/app/apple-store/id1146243047?mt=8"
//[[UIApplication sharedApplication] openURL:[NSURL URLWithString:str_appstore_link]];

#define str_alert_title_version_update @"Uh-Oh! It's time for update!"
#define str_alert_msg_version_update @"Please download the latest iGoLive, so nothing goes wrong :]"
#define str_alert_btn_version_update @"Update iGoLive Now!"

////////////////////////////////////////
#pragma mark - NOTIFICATION defines
////////////////////////////////////////
#define NOTIFY_LOADING_CLOSE @"NotifyLoadingViewCloseClicked"

////////////////////////////////////////
#pragma mark - table view collection view
////////////////////////////////////////
#define kSquareCellReuseID @"NewEmergingCollectionViewCell"
#define kNewEmergingCellID @"NewEmergingCell" // must match in 'NewEmergingViewController' (ugly)

////////////////////////////////////////
#pragma mark - business requirements
////////////////////////////////////////
#define years_min_age 12

////////////////////////////////////////
#pragma mark - ui display contants
////////////////////////////////////////
#define corn_rad_avatar 35
#define corn_rad_avatar_small 10

////////////////////////////////////////
#pragma mark - ui displays strings
////////////////////////////////////////
#define str_no_title @"no title  :/"
#define str_no_tags @"no tags :/"
#define str_nav_title_explore @"Explore"
#define str_nav_title_follow @"Follow"
#define str_share_sms_body @"I am going live right now, on iGoLive!"
#define str_share_email_body @"I am going live right now, on iGoLive!"
#define str_share_email_subject @"iGoLive Now!"

#define str_no_name @"<none>"

////////////////////////////////////////
#pragma mark - error / warning constants
////////////////////////////////////////
#define warn_get_img_url @"failed to get remote img; alternate img has been set"


////////////////////////////////////////
#pragma mark - date formats
////////////////////////////////////////
#define str_dateformat_HH @"HH" // 24hr format (just hour)
#define str_dateformat_HH_mm @"HH:mm" // 24hr format
#define str_dateformat_HHmm @"HHmm" // 24hr format (no :)
#define str_dateformat_h_mm @"h:mm" // 12hr format
#define str_dateformat_h_mm_a @"h:mm a"
#define str_dateformat_h_mm_ss_a @"h:mm:ss a"


#endif /* StringConstantDefines_h */
