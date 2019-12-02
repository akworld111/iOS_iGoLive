//
//  HttpBaseController.h
//  igolive
//
//  Created by greenhouse on 8/30/16.
//  Copyright © 2016 iGoLive LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CommonReturn.h"

typedef void (^CommonResultBlock)(CommonReturn *cr); // legacy

@interface HttpBaseController : NSObject

/* legacy */
+ (BOOL)validateCode:(id)obj;
//+ (NSString *)getMessage:(id)obj;
//+ (id)getData:(id)obj;

//Validation of URL params, including token and time
+ (NSString *)addValidateParams:(NSString *)url;
/* _legacy */

/* new */
+ (NSDictionary*)appendRequiredParams:(NSDictionary *)dict;

+ (int)getRetStatusFromRespObj:(id)obj;
+ (NSString*)getMsgStringFromRespObj:(id)obj;
+ (NSDictionary*)getDataDictFromRespObj:(id)obj;


@end



