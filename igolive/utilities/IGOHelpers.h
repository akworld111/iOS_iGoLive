//
//  IGOHelpers.h
//  igolive
//
//  Created by greenhouse on 9/9/16.
//  Copyright © 2016 iGoLive LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IGOHelpers : NSObject

+ (void)runGiftAnimationForGiftID:(NSString*)strid withImageView:(UIImageView*)iv;
+ (void)killGiftAnimation:(UIImageView*)iv;
+ (void)vibratePhone;
+ (NSString*)getCoinStringShort:(NSString*)coin;

@end
