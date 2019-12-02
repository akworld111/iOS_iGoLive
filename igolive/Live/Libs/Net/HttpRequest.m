//
//  HttpRequest.m
//  iphoneLive
//
//  Created by 高翔 on 16/8/1.
//  Copyright © 2016年 cat. All rights reserved.
//

#import "HttpRequest.h"
#import "AFNetworking.h"
#import "UploadParam.h"

@implementation HttpRequest
#pragma mark -- GET请求 --
+ (void)getWithURLString:(NSString *)URLString
              parameters:(id)parameters
                 success:(void (^)(id))success
                 failure:(void (^)(NSError *))failure {
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    /**
     *  可以接受的类型 ('acceptible type')
     */
    //    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    /**
     *  请求队列的最大并发数 ('The maximum number of concurrent request queue')
     */
    //    manager.operationQueue.maxConcurrentOperationCount = 5;
    /**
     *  请求超时的时间 ('request timeout')
     */
    //    manager.requestSerializer.timeoutInterval = 5;
    
#if log_http_req_params
    XLM_enter(@"\n\n *** EXECUTE GET REQUESTS ***\n Url: %@ \n parameters: %@\n\n",URLString,parameters);
#else
    XLM_enter(@"\n\n *** EXECUTE GET REQUESTS ***\n Url: %@\n\n",URLString);
#endif
    
    URLString = [URLString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [manager GET:URLString parameters:parameters
     
         success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject)
            {
                
#if log_http_resp_body
                XLM_info(@"\n\n *** SUCCESSFUL GET REQUESTS ***\n Url:%@\n response : %@\n\n", URLString, responseObject);
#else
                XLM_info(@"\n\n *** SUCCESSFUL GET REQUESTS ***\n Url:%@\n\n", URLString);
#endif
                if (success) {
                    success(responseObject);
                }
            }
         failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
            {
                XLM_error(@"\n *** FAILED GET REQUESTS ***\n Url:%@\n\n Error: %@\n\n\n", URLString, error.description);
                if (failure) {
                    failure(error);
                }
            }
    ];
}

#pragma mark -- POST --
+ (void)postWithURLString:(NSString *)URLString
               parameters:(id)parameters
                  success:(void (^)(id))success
                  failure:(void (^)(NSError *))failure {
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
//    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager POST:URLString parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
}

#pragma mark -- POST/GET --
+ (void)requestWithURLString:(NSString *)URLString
                  parameters:(id)parameters
                        type:(HttpRequestType)type
                     success:(void (^)(id))success
                     failure:(void (^)(NSError *))failure {
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
//    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    switch (type) {
        case HttpRequestTypeGet:
        {
            [manager GET:URLString parameters:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                if (success) {
                    success(responseObject);
                }
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                if (failure) {
                    failure(error);
                }
            }];
        }
            break;
        case HttpRequestTypePost:
        {
            [manager POST:URLString parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                if (success) {
                    success(responseObject);
                }
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                if (failure) {
                    failure(error);
                }
            }];
        }
            break;
    }
}

#pragma mark -- 上传图片 --
+ (void)uploadWithURLString:(NSString *)URLString
                 parameters:(id)parameters
                uploadParam:(UploadParam *)uploadParam
                    success:(void (^)(id responseObject))success
                    failure:(void (^)(NSError *))failure {
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager POST:URLString parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        [formData appendPartWithFileData:uploadParam.data name:uploadParam.name fileName:uploadParam.filename mimeType:uploadParam.mimeType];
    } success:^(NSURLSessionDataTask * _Nonnull task, id _Nullable responseObject)
     {
         if (success) {
             success(responseObject);
         }
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
         if (failure) {
             failure(error);
         }
     }];
}@end
