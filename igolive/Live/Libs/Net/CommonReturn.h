//
//  CommonReturn.h
//  iphoneLive
//
//  Created by christlee on 16/8/8.
//  Copyright © 2016年 cat. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CommonReturn : NSObject

/**
 *  message from server side
 */
@property (nonatomic, strong) NSString *msg;
/**
 *  state from server side. 0=NO 1=OK
 */
@property (nonatomic, assign) int state;
@property (nonatomic, strong) id data;

/**
 * return status from server api code task executed successfully
 *  0 - 9 means successful (ie. new user added successfully)
 *  10 - .... means failed (ie. user already exists)
 */
@property (nonatomic, assign) int ret;

@end
