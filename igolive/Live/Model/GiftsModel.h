//
//  GiftsModel.h
//  iphoneLive
//
//  Created by 高翔 on 16/8/7.
//  Copyright © 2016年 cat. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GiftsModel : NSObject

@property (nonatomic, strong) NSString * addtime;
@property (nonatomic, strong) NSString * experience;
@property (nonatomic, strong) NSString * gifticon;
@property (nonatomic, strong) NSString * gifticonMini;
@property (nonatomic, strong) NSString * giftname;
@property (nonatomic, strong) NSString * idField;
@property (nonatomic, strong) NSString * needcoin;
@property (nonatomic, strong) NSString * orderno;
@property (nonatomic, strong) NSString * sid;
@property (nonatomic, strong) NSString * type;

-(instancetype)initWithDictionary:(NSDictionary *)dictionary;

-(NSDictionary *)toDictionary;
@end
