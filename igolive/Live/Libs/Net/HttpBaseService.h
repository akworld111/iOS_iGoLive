//
//  HttpBaseService.h
//  iphoneLive
//
//  Created by christlee on 16/8/8.
//  Copyright © 2016年 cat. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CommonReturn.h"

typedef void (^CommonResultBlock)(CommonReturn *commonReturn);

@interface HttpBaseService : NSObject

+ (BOOL)validateCode:(id)obj;
+ (NSString *)getMessage:(id)obj;
+ (id)getData:(id)obj;
//Validation of URL params, including token and time
+ (NSString *)addValidateParams:(NSString *)url;
+ (void)addValidateParamsWithDict:(NSMutableDictionary *)dict;

@end
