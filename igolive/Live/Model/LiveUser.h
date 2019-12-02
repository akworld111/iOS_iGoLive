//
//  LiveUser.h
//  iphoneLive
//
//  Created by cat on 16/3/9.
//  Copyright © 2016年 cat. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LiveUser : NSObject
@property (nonatomic, strong)NSString *avatar;
@property (nonatomic, strong)NSString *birthday;
@property (nonatomic, strong)NSString *coin;
@property (nonatomic, strong)NSString *create_time;
@property (nonatomic, strong)NSString *expiretime;
@property (nonatomic, strong)NSString *ID;
@property (nonatomic, strong)NSString *gender;
@property (nonatomic, strong)NSString *token;
@property (nonatomic, strong)NSString *user_nickname;
@property (nonatomic, strong)NSString *user_type;
@property (nonatomic, strong)NSString *signature;
@property (nonatomic, strong)NSString *city;
@property (nonatomic, strong)NSString *level;
@property (nonatomic, strong)NSString *first;
@property (nonatomic, strong) NSArray * interests;


-(void)setValue:(id)value forUndefinedKey:(NSString *)key;
-(instancetype)initWithDic:(NSDictionary *) dic;
+(instancetype)modelWithDic:(NSDictionary *) dic;

@end
