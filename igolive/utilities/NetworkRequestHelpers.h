//
//  NetworkRequestHelpers.h
//  igolive
//
//  Created by greenhouse on 9/3/16.
//  Copyright © 2016 iGoLive LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NetworkRequestHelpers : NSObject

// misc helpers
+ (BOOL)hasInternet;
+ (BOOL)hasInternetConnectivity; // note: should use 'hasInternet' above
+ (NSString *)datetimeUploadReady:(double)timeInterval;
+ (NSString *)datetimeUtcUploadReady:(double)timeInterval;
+ (NSString *)datetimeUtcUploadReadyNow;
+ (NSString *)getUTCFormatDate:(NSDate *)localDate;
+ (NSString *)imageUploadReady : (UIImage *)img;
+ (UIImage *)resizeImage:(UIImage *)img withSize:(CGSize)size;
+ (NSString*)getJSONDescriptionFromArrayPayload:(NSArray*)aPayload;
+ (NSString*)getJSONDescriptionFromDictPayload:(NSDictionary*)dPayload;


@end



