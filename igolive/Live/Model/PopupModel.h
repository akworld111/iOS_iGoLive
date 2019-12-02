//
//  PopupModel.h
//  iphoneLive
//
//  Created by 高翔 on 16/8/9.
//  Copyright © 2016年 cat. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PopupModel : NSObject

@property (nonatomic, assign) NSInteger attentionnum;
@property (nonatomic, strong) NSString * avatar;
@property (nonatomic, strong) NSString * city;
@property (nonatomic, strong) NSArray * coinrecord3;
@property (nonatomic, strong) NSString * experience;
@property (nonatomic, assign) NSInteger fansnum;
@property (nonatomic, strong) NSString * gender;
@property (nonatomic, strong) NSString * idField;
@property (nonatomic, assign) NSInteger isattention;
@property (nonatomic, assign) NSInteger isblack;
@property (nonatomic, assign) NSInteger isblackto;
@property (nonatomic, strong) NSString * isrecommend;
@property (nonatomic, strong) NSString * level;
@property (nonatomic, assign) NSInteger likes;
@property (nonatomic, assign) NSInteger liverecordnum;
@property (nonatomic, strong) NSString * mobile;
@property (nonatomic, strong) NSString * province;
@property (nonatomic, strong) NSString * signature;
@property (nonatomic, strong) NSString * stars;
@property (nonatomic, strong) NSString * userNickname;
@property (nonatomic, strong) NSString * votes;
@property (nonatomic, strong) NSString * votestotal;
@property (nonatomic, strong) NSString * starsTotal;
@property (nonatomic, strong) NSString * birthday;



-(instancetype)initWithDictionary:(NSDictionary *)dictionary;

-(NSDictionary *)toDictionary;

@end