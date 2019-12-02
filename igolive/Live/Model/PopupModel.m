//
//  PopupModel.m
//  iphoneLive
//
//  Created by 高翔 on 16/8/9.
//  Copyright © 2016年 cat. All rights reserved.
//
//

#import "PopupModel.h"

NSString *const kPopupModelAttentionnum = @"attentionnum";
NSString *const kPopupModelAvatar = @"avatar";
NSString *const kPopupModelCity = @"city";
NSString *const kPopupModelCoinrecord3 = @"coinrecord3";
NSString *const kPopupModelExperience = @"experience";
NSString *const kPopupModelFansnum = @"fansnum";
NSString *const kPopupModelGender = @"gender";
NSString *const kPopupModelIdField = @"id";
NSString *const kPopupModelIsattention = @"isattention";
NSString *const kPopupModelIsblack = @"isblack";
NSString *const kPopupModelIsblackto = @"isblackto";
NSString *const kPopupModelIsrecommend = @"isrecommend";
NSString *const kPopupModelLevel = @"level";
NSString *const kPopupModelLikes = @"likes";
NSString *const kPopupModelLiverecordnum = @"liverecordnum";
NSString *const kPopupModelMobile = @"mobile";
NSString *const kPopupModelProvince = @"province";
NSString *const kPopupModelSignature = @"signature";
NSString *const kPopupModelStars = @"stars";
NSString *const kPopupModelUserNickname = @"user_nickname";
NSString *const kPopupModelVotes = @"votes";
NSString *const kPopupModelVotestotal = @"votestotal";
NSString *const kPopupModelStarsTotal = @"stars_total";
NSString *const kPopupModelBirthday = @"birthday";


@interface PopupModel ()
@end
@implementation PopupModel




/**
 * Instantiate the instance using the passed dictionary values to set the properties values
 */

-(instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if(![dictionary[kPopupModelAttentionnum] isKindOfClass:[NSNull class]]){
        self.attentionnum = [dictionary[kPopupModelAttentionnum] integerValue];
    }
    
    if(![dictionary[kPopupModelAvatar] isKindOfClass:[NSNull class]]){
        self.avatar = dictionary[kPopupModelAvatar];
    }
    if(![dictionary[kPopupModelCity] isKindOfClass:[NSNull class]]){
        self.city = dictionary[kPopupModelCity];
    }
    if(![dictionary[kPopupModelCoinrecord3] isKindOfClass:[NSNull class]]){
        self.coinrecord3 = dictionary[kPopupModelCoinrecord3];
    }
    if(![dictionary[kPopupModelExperience] isKindOfClass:[NSNull class]]){
        self.experience = dictionary[kPopupModelExperience];
    }
    if(![dictionary[kPopupModelFansnum] isKindOfClass:[NSNull class]]){
        self.fansnum = [dictionary[kPopupModelFansnum] integerValue];
    }
    
    if(![dictionary[kPopupModelGender] isKindOfClass:[NSNull class]]){
        self.gender = dictionary[kPopupModelGender];
    }
    if(![dictionary[kPopupModelIdField] isKindOfClass:[NSNull class]]){
        self.idField = dictionary[kPopupModelIdField];
    }
    if(![dictionary[kPopupModelIsattention] isKindOfClass:[NSNull class]]){
        self.isattention = [dictionary[kPopupModelIsattention] integerValue];
    }
    
    if(![dictionary[kPopupModelIsblack] isKindOfClass:[NSNull class]]){
        self.isblack = [dictionary[kPopupModelIsblack] integerValue];
    }
    
    if(![dictionary[kPopupModelIsblackto] isKindOfClass:[NSNull class]]){
        self.isblackto = [dictionary[kPopupModelIsblackto] integerValue];
    }
    
    if(![dictionary[kPopupModelIsrecommend] isKindOfClass:[NSNull class]]){
        self.isrecommend = dictionary[kPopupModelIsrecommend];
    }
    if(![dictionary[kPopupModelLevel] isKindOfClass:[NSNull class]]){
        self.level = dictionary[kPopupModelLevel];
    }
    if(![dictionary[kPopupModelLikes] isKindOfClass:[NSNull class]]){
        self.likes = [dictionary[kPopupModelLikes] integerValue];
    }
    
    if(![dictionary[kPopupModelLiverecordnum] isKindOfClass:[NSNull class]]){
        self.liverecordnum = [dictionary[kPopupModelLiverecordnum] integerValue];
    }
    
    if(![dictionary[kPopupModelMobile] isKindOfClass:[NSNull class]]){
        self.mobile = dictionary[kPopupModelMobile];
    }
    if(![dictionary[kPopupModelProvince] isKindOfClass:[NSNull class]]){
        self.province = dictionary[kPopupModelProvince];
    }
    if(![dictionary[kPopupModelSignature] isKindOfClass:[NSNull class]]){
        self.signature = dictionary[kPopupModelSignature];
    }
    if(![dictionary[kPopupModelStars] isKindOfClass:[NSNull class]]){
        self.stars = dictionary[kPopupModelStars];
    }
    if(![dictionary[kPopupModelUserNickname] isKindOfClass:[NSNull class]]){
        self.userNickname = dictionary[kPopupModelUserNickname];
    }
    if(![dictionary[kPopupModelVotes] isKindOfClass:[NSNull class]]){
        self.votes = dictionary[kPopupModelVotes];
    }
    if(![dictionary[kPopupModelVotestotal] isKindOfClass:[NSNull class]]){
        self.votestotal = dictionary[kPopupModelVotestotal];
    }
    if(![dictionary[kPopupModelStarsTotal] isKindOfClass:[NSNull class]]){
        self.starsTotal = dictionary[kPopupModelStarsTotal];
    }
    if(![dictionary[kPopupModelBirthday] isKindOfClass:[NSNull class]]){
        self.birthday = dictionary[kPopupModelBirthday];
    }
    return self;
}


/**
 * Returns all the available property values in the form of NSDictionary object where the key is the approperiate json key and the value is the value of the corresponding property
 */
-(NSDictionary *)toDictionary
{
    NSMutableDictionary * dictionary = [NSMutableDictionary dictionary];
    dictionary[kPopupModelAttentionnum] = @(self.attentionnum);
    if(self.avatar != nil){
        dictionary[kPopupModelAvatar] = self.avatar;
    }
    if(self.city != nil){
        dictionary[kPopupModelCity] = self.city;
    }
    if(self.coinrecord3 != nil){
        dictionary[kPopupModelCoinrecord3] = self.coinrecord3;
    }
    if(self.experience != nil){
        dictionary[kPopupModelExperience] = self.experience;
    }
    dictionary[kPopupModelFansnum] = @(self.fansnum);
    if(self.gender != nil){
        dictionary[kPopupModelGender] = self.gender;
    }
    if(self.idField != nil){
        dictionary[kPopupModelIdField] = self.idField;
    }
    dictionary[kPopupModelIsattention] = @(self.isattention);
    dictionary[kPopupModelIsblack] = @(self.isblack);
    dictionary[kPopupModelIsblackto] = @(self.isblackto);
    if(self.isrecommend != nil){
        dictionary[kPopupModelIsrecommend] = self.isrecommend;
    }
    if(self.level != nil){
        dictionary[kPopupModelLevel] = self.level;
    }
    dictionary[kPopupModelLikes] = @(self.likes);
    dictionary[kPopupModelLiverecordnum] = @(self.liverecordnum);
    if(self.mobile != nil){
        dictionary[kPopupModelMobile] = self.mobile;
    }
    if(self.province != nil){
        dictionary[kPopupModelProvince] = self.province;
    }
    if(self.signature != nil){
        dictionary[kPopupModelSignature] = self.signature;
    }
    if(self.stars != nil){
        dictionary[kPopupModelStars] = self.stars;
    }
    if(self.userNickname != nil){
        dictionary[kPopupModelUserNickname] = self.userNickname;
    }
    if(self.votes != nil){
        dictionary[kPopupModelVotes] = self.votes;
    }
    if(self.votestotal != nil){
        dictionary[kPopupModelVotestotal] = self.votestotal;
    }if(self.starsTotal != nil){
        dictionary[kPopupModelStarsTotal] = self.starsTotal;
    }
    if(self.birthday != nil){
        dictionary[kPopupModelBirthday] = self.birthday;
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
    [aCoder encodeObject:@(self.attentionnum) forKey:kPopupModelAttentionnum];	if(self.avatar != nil){
        [aCoder encodeObject:self.avatar forKey:kPopupModelAvatar];
    }
    if(self.city != nil){
        [aCoder encodeObject:self.city forKey:kPopupModelCity];
    }
    if(self.coinrecord3 != nil){
        [aCoder encodeObject:self.coinrecord3 forKey:kPopupModelCoinrecord3];
    }
    if(self.experience != nil){
        [aCoder encodeObject:self.experience forKey:kPopupModelExperience];
    }
    [aCoder encodeObject:@(self.fansnum) forKey:kPopupModelFansnum];	if(self.gender != nil){
        [aCoder encodeObject:self.gender forKey:kPopupModelGender];
    }
    if(self.idField != nil){
        [aCoder encodeObject:self.idField forKey:kPopupModelIdField];
    }
    [aCoder encodeObject:@(self.isattention) forKey:kPopupModelIsattention];	[aCoder encodeObject:@(self.isblack) forKey:kPopupModelIsblack];	[aCoder encodeObject:@(self.isblackto) forKey:kPopupModelIsblackto];	if(self.isrecommend != nil){
        [aCoder encodeObject:self.isrecommend forKey:kPopupModelIsrecommend];
    }
    if(self.level != nil){
        [aCoder encodeObject:self.level forKey:kPopupModelLevel];
    }
    [aCoder encodeObject:@(self.likes) forKey:kPopupModelLikes];	[aCoder encodeObject:@(self.liverecordnum) forKey:kPopupModelLiverecordnum];	if(self.mobile != nil){
        [aCoder encodeObject:self.mobile forKey:kPopupModelMobile];
    }
    if(self.province != nil){
        [aCoder encodeObject:self.province forKey:kPopupModelProvince];
    }
    if(self.signature != nil){
        [aCoder encodeObject:self.signature forKey:kPopupModelSignature];
    }
    if(self.stars != nil){
        [aCoder encodeObject:self.stars forKey:kPopupModelStars];
    }
    if(self.userNickname != nil){
        [aCoder encodeObject:self.userNickname forKey:kPopupModelUserNickname];
    }
    if(self.votes != nil){
        [aCoder encodeObject:self.votes forKey:kPopupModelVotes];
    }
    if(self.votestotal != nil){
        [aCoder encodeObject:self.votestotal forKey:kPopupModelVotestotal];
    }
    if(self.starsTotal != nil) {
        [aCoder encodeObject:self.starsTotal forKey:kPopupModelStarsTotal];
    }
    if(self.birthday != nil){
        [aCoder encodeObject:self.birthday forKey:kPopupModelBirthday];
    }
}

/**
 * Implementation of NSCoding initWithCoder: method
 */
- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    self.attentionnum = [[aDecoder decodeObjectForKey:kPopupModelAttentionnum] integerValue];
    self.avatar = [aDecoder decodeObjectForKey:kPopupModelAvatar];
    self.city = [aDecoder decodeObjectForKey:kPopupModelCity];
    self.coinrecord3 = [aDecoder decodeObjectForKey:kPopupModelCoinrecord3];
    self.experience = [aDecoder decodeObjectForKey:kPopupModelExperience];
    self.fansnum = [[aDecoder decodeObjectForKey:kPopupModelFansnum] integerValue];
    self.gender = [aDecoder decodeObjectForKey:kPopupModelGender];
    self.idField = [aDecoder decodeObjectForKey:kPopupModelIdField];
    self.isattention = [[aDecoder decodeObjectForKey:kPopupModelIsattention] integerValue];
    self.isblack = [[aDecoder decodeObjectForKey:kPopupModelIsblack] integerValue];
    self.isblackto = [[aDecoder decodeObjectForKey:kPopupModelIsblackto] integerValue];
    self.isrecommend = [aDecoder decodeObjectForKey:kPopupModelIsrecommend];
    self.level = [aDecoder decodeObjectForKey:kPopupModelLevel];
    self.likes = [[aDecoder decodeObjectForKey:kPopupModelLikes] integerValue];
    self.liverecordnum = [[aDecoder decodeObjectForKey:kPopupModelLiverecordnum] integerValue];
    self.mobile = [aDecoder decodeObjectForKey:kPopupModelMobile];
    self.province = [aDecoder decodeObjectForKey:kPopupModelProvince];
    self.signature = [aDecoder decodeObjectForKey:kPopupModelSignature];
    self.stars = [aDecoder decodeObjectForKey:kPopupModelStars];
    self.userNickname = [aDecoder decodeObjectForKey:kPopupModelUserNickname];
    self.votes = [aDecoder decodeObjectForKey:kPopupModelVotes];
    self.votestotal = [aDecoder decodeObjectForKey:kPopupModelVotestotal];
    self.starsTotal = [aDecoder decodeObjectForKey:kPopupModelStarsTotal];
    self.birthday = [aDecoder decodeObjectForKey:kPopupModelBirthday];

    return self;
    
}

/**
 * Implementation of NSCopying copyWithZone: method
 */
- (instancetype)copyWithZone:(NSZone *)zone
{
    PopupModel *copy = [PopupModel new];
    
    copy.attentionnum = self.attentionnum;
    copy.avatar = [self.avatar copyWithZone:zone];
    copy.city = [self.city copyWithZone:zone];
    copy.coinrecord3 = [self.coinrecord3 copyWithZone:zone];
    copy.experience = [self.experience copyWithZone:zone];
    copy.fansnum = self.fansnum;
    copy.gender = [self.gender copyWithZone:zone];
    copy.idField = [self.idField copyWithZone:zone];
    copy.isattention = self.isattention;
    copy.isblack = self.isblack;
    copy.isblackto = self.isblackto;
    copy.isrecommend = [self.isrecommend copyWithZone:zone];
    copy.level = [self.level copyWithZone:zone];
    copy.likes = self.likes;
    copy.liverecordnum = self.liverecordnum;
    copy.mobile = [self.mobile copyWithZone:zone];
    copy.province = [self.province copyWithZone:zone];
    copy.signature = [self.signature copyWithZone:zone];
    copy.stars = [self.stars copyWithZone:zone];
    copy.userNickname = [self.userNickname copyWithZone:zone];
    copy.votes = [self.votes copyWithZone:zone];
    copy.votestotal = [self.votestotal copyWithZone:zone];
    copy.birthday = [self.birthday copyWithZone:zone];

    
    return copy;
}
@end