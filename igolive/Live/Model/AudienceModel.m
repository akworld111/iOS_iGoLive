//
//  AudienceModel.m
//  iphoneLive
//
//  Created by 高翔 on 16/8/6.
//  Copyright © 2016年 cat. All rights reserved.
//

#import "AudienceModel.h"

NSString *const kAudienceModelAvatar = @"avatar";
NSString *const kAudienceModelCity = @"city";
NSString *const kAudienceModelCoin = @"coin";
NSString *const kAudienceModelExperience = @"experience";
NSString *const kAudienceModelGender = @"gender";
NSString *const kAudienceModelIdField = @"id";
NSString *const kAudienceModelIslive = @"islive";
NSString *const kAudienceModelIsrecommend = @"isrecommend";
NSString *const kAudienceModelLevel = @"level";
NSString *const kAudienceModelProvince = @"province";
NSString *const kAudienceModelSign = @"sign";
NSString *const kAudienceModelSignature = @"signature";
NSString *const kAudienceModelUserType = @"userType";
NSString *const kAudienceModelUserNicename = @"user_nickname";
NSString *const kAudienceModelVotes = @"votes";

@implementation AudienceModel
/**
 * Instantiate the instance using the passed dictionary values to set the properties values
 */

-(instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if(![dictionary[kAudienceModelAvatar] isKindOfClass:[NSNull class]]){
        self.avatar = dictionary[kAudienceModelAvatar];
    }
    if(![dictionary[kAudienceModelCity] isKindOfClass:[NSNull class]]){
        self.city = dictionary[kAudienceModelCity];
    }
    if(![dictionary[kAudienceModelCoin] isKindOfClass:[NSNull class]]){
        self.coin = dictionary[kAudienceModelCoin];
    }
    if(![dictionary[kAudienceModelExperience] isKindOfClass:[NSNull class]]){
        self.experience = dictionary[kAudienceModelExperience];
    }
    if(![dictionary[kAudienceModelGender] isKindOfClass:[NSNull class]]){
        self.gender = dictionary[kAudienceModelGender];
    }
    if(![dictionary[kAudienceModelIdField] isKindOfClass:[NSNull class]]){
        self.idField = dictionary[kAudienceModelIdField];
    }
    if(![dictionary[kAudienceModelIslive] isKindOfClass:[NSNull class]]){
        self.islive = [dictionary[kAudienceModelIslive] integerValue];
    }
    
    if(![dictionary[kAudienceModelIsrecommend] isKindOfClass:[NSNull class]]){
        self.isrecommend = dictionary[kAudienceModelIsrecommend];
    }
    if(![dictionary[kAudienceModelLevel] isKindOfClass:[NSNull class]]){
        self.level = dictionary[kAudienceModelLevel];
    }
    if(![dictionary[kAudienceModelProvince] isKindOfClass:[NSNull class]]){
        self.province = dictionary[kAudienceModelProvince];
    }
    if(![dictionary[kAudienceModelSign] isKindOfClass:[NSNull class]]){
        self.sign = dictionary[kAudienceModelSign];
    }
    if(![dictionary[kAudienceModelSignature] isKindOfClass:[NSNull class]]){
        self.signature = dictionary[kAudienceModelSignature];
    }
    if(![dictionary[kAudienceModelUserType] isKindOfClass:[NSNull class]]){
        self.userType = [dictionary[kAudienceModelUserType] integerValue];
    }
    
    if(![dictionary[kAudienceModelUserNicename] isKindOfClass:[NSNull class]]){
        self.userNicename = dictionary[kAudienceModelUserNicename];
    }
    if(![dictionary[kAudienceModelVotes] isKindOfClass:[NSNull class]]){
        self.votes = dictionary[kAudienceModelVotes];
    }
    if (![dictionary[@"likes"] isKindOfClass:[NSNull class]]) {
        self.likes = dictionary[@"likes"];
    }
    return self;
}


/**
 * Returns all the available property values in the form of NSDictionary object where the key is the approperiate json key and the value is the value of the corresponding property
 */
-(NSDictionary *)toDictionary
{
    NSMutableDictionary * dictionary = [NSMutableDictionary dictionary];
    if(self.avatar != nil){
        dictionary[kAudienceModelAvatar] = self.avatar;
    }
    if(self.city != nil){
        dictionary[kAudienceModelCity] = self.city;
    }
    if(self.coin != nil){
        dictionary[kAudienceModelCoin] = self.coin;
    }
    if(self.experience != nil){
        dictionary[kAudienceModelExperience] = self.experience;
    }
    if(self.gender != nil){
        dictionary[kAudienceModelGender] = self.gender;
    }
    if(self.idField != nil){
        dictionary[kAudienceModelIdField] = self.idField;
    }
    dictionary[kAudienceModelIslive] = @(self.islive);
    if(self.isrecommend != nil){
        dictionary[kAudienceModelIsrecommend] = self.isrecommend;
    }
    if(self.level != nil){
        dictionary[kAudienceModelLevel] = self.level;
    }
    if(self.province != nil){
        dictionary[kAudienceModelProvince] = self.province;
    }
    if(self.sign != nil){
        dictionary[kAudienceModelSign] = self.sign;
    }
    if(self.signature != nil){
        dictionary[kAudienceModelSignature] = self.signature;
    }
    dictionary[kAudienceModelUserType] = @(self.userType);
    if(self.userNicename != nil){
        dictionary[kAudienceModelUserNicename] = self.userNicename;
    }
    if(self.votes != nil){
        dictionary[kAudienceModelVotes] = self.votes;
    }
    return dictionary;
    
}

/**
 * Implementation of NSCoding encoding method
 */
/**
 * Returns all the available property values in the form of NSDictionary object where the key is the approperiate json key and the value is the value of the corresponding property
 */
- (void)encodeWithCoder:(NSCoder *)aCoder
{
    if(self.avatar != nil){
        [aCoder encodeObject:self.avatar forKey:kAudienceModelAvatar];
    }
    if(self.city != nil){
        [aCoder encodeObject:self.city forKey:kAudienceModelCity];
    }
    if(self.coin != nil){
        [aCoder encodeObject:self.coin forKey:kAudienceModelCoin];
    }
    if(self.experience != nil){
        [aCoder encodeObject:self.experience forKey:kAudienceModelExperience];
    }
    if(self.gender != nil){
        [aCoder encodeObject:self.gender forKey:kAudienceModelGender];
    }
    if(self.idField != nil){
        [aCoder encodeObject:self.idField forKey:kAudienceModelIdField];
    }
    [aCoder encodeObject:@(self.islive) forKey:kAudienceModelIslive];	if(self.isrecommend != nil){
        [aCoder encodeObject:self.isrecommend forKey:kAudienceModelIsrecommend];
    }
    if(self.level != nil){
        [aCoder encodeObject:self.level forKey:kAudienceModelLevel];
    }
    if(self.province != nil){
        [aCoder encodeObject:self.province forKey:kAudienceModelProvince];
    }
    if(self.sign != nil){
        [aCoder encodeObject:self.sign forKey:kAudienceModelSign];
    }
    if(self.signature != nil){
        [aCoder encodeObject:self.signature forKey:kAudienceModelSignature];
    }
    [aCoder encodeObject:@(self.userType) forKey:kAudienceModelUserType];	if(self.userNicename != nil){
        [aCoder encodeObject:self.userNicename forKey:kAudienceModelUserNicename];
    }
    if(self.votes != nil){
        [aCoder encodeObject:self.votes forKey:kAudienceModelVotes];
    }
    
}

/**
 * Implementation of NSCoding initWithCoder: method
 */
- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    self.avatar = [aDecoder decodeObjectForKey:kAudienceModelAvatar];
    self.city = [aDecoder decodeObjectForKey:kAudienceModelCity];
    self.coin = [aDecoder decodeObjectForKey:kAudienceModelCoin];
    self.experience = [aDecoder decodeObjectForKey:kAudienceModelExperience];
    self.gender = [aDecoder decodeObjectForKey:kAudienceModelGender];
    self.idField = [aDecoder decodeObjectForKey:kAudienceModelIdField];
    self.islive = [[aDecoder decodeObjectForKey:kAudienceModelIslive] integerValue];
    self.isrecommend = [aDecoder decodeObjectForKey:kAudienceModelIsrecommend];
    self.level = [aDecoder decodeObjectForKey:kAudienceModelLevel];
    self.province = [aDecoder decodeObjectForKey:kAudienceModelProvince];
    self.sign = [aDecoder decodeObjectForKey:kAudienceModelSign];
    self.signature = [aDecoder decodeObjectForKey:kAudienceModelSignature];
    self.userType = [[aDecoder decodeObjectForKey:kAudienceModelUserType] integerValue];
    self.userNicename = [aDecoder decodeObjectForKey:kAudienceModelUserNicename];
    self.votes = [aDecoder decodeObjectForKey:kAudienceModelVotes];
    return self;
    
}

/**
 * Implementation of NSCopying copyWithZone: method
 */
- (instancetype)copyWithZone:(NSZone *)zone
{
    AudienceModel *copy = [AudienceModel new];
    
    copy.avatar = [self.avatar copyWithZone:zone];
    copy.city = [self.city copyWithZone:zone];
    copy.coin = [self.coin copyWithZone:zone];
    copy.experience = [self.experience copyWithZone:zone];
    copy.gender = [self.gender copyWithZone:zone];
    copy.idField = [self.idField copyWithZone:zone];
    copy.islive = self.islive;
    copy.isrecommend = [self.isrecommend copyWithZone:zone];
    copy.level = [self.level copyWithZone:zone];
    copy.province = [self.province copyWithZone:zone];
    copy.sign = [self.sign copyWithZone:zone];
    copy.signature = [self.signature copyWithZone:zone];
    copy.userType = self.userType;
    copy.userNicename = [self.userNicename copyWithZone:zone];
    copy.votes = [self.votes copyWithZone:zone];
    
    return copy;
}

@end
