//
//  AudienceModel.h
//  iphoneLive
//
//  Created by 高翔 on 16/8/6.
//  Copyright © 2016年 cat. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AudienceModel : NSObject

@property (nonatomic, strong) NSString * avatar;
@property (nonatomic, strong) NSString * city;
@property (nonatomic, strong) NSString * coin;
@property (nonatomic, strong) NSString * experience;
@property (nonatomic, strong) NSString * gender;
@property (nonatomic, strong) NSString * idField;
@property (nonatomic, assign) NSInteger islive;
@property (nonatomic, strong) NSString * isrecommend;
@property (nonatomic, strong) NSString * likes;
@property (nonatomic, strong) NSString * level;
@property (nonatomic, strong) NSString * province;
@property (nonatomic, strong) NSString * sign;
@property (nonatomic, strong) NSString * signature;
@property (nonatomic, assign) NSInteger userType;
@property (nonatomic, strong) NSString * userNicename;
@property (nonatomic, strong) NSString * votes;

-(instancetype)initWithDictionary:(NSDictionary *)dictionary;

-(NSDictionary *)toDictionary;

@end
