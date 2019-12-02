//
//	PersonalInfoModel.m
//
//	Create by 丽花 唐 on 30/8/2016
//	Copyright © 2016. All rights reserved.
//	Model file Generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport



#import "PersonalInfoModel.h"

NSString *const kPersonalInfoModelAttentionnum = @"attentionnum";
NSString *const kPersonalInfoModelAvatar = @"avatar";
NSString *const kPersonalInfoModelBirthday = @"birthday";
NSString *const kPersonalInfoModelCity = @"city";
NSString *const kPersonalInfoModelCoin = @"coin";
NSString *const kPersonalInfoModelCoinrecord3 = @"coinrecord3";
NSString *const kPersonalInfoModelConsumption = @"consumption";
NSString *const kPersonalInfoModelExperience = @"experience";
NSString *const kPersonalInfoModelFansnum = @"fansnum";
NSString *const kPersonalInfoModelGender = @"gender";
NSString *const kPersonalInfoModelIdField = @"id";
NSString *const kPersonalInfoModelInterests = @"interests";
NSString *const kPersonalInfoModelIsrecommend = @"isrecommend";
NSString *const kPersonalInfoModelLevel = @"level";
NSString *const kPersonalInfoModelLikes = @"likes";
NSString *const kPersonalInfoModelLiverecordnum = @"liverecordnum";
NSString *const kPersonalInfoModelMobile = @"mobile";
NSString *const kPersonalInfoModelProvince = @"province";
NSString *const kPersonalInfoModelSignature = @"signature";
NSString *const kPersonalInfoModelStars = @"stars";
NSString *const kPersonalInfoModelStarsTotal = @"stars_total";
NSString *const kPersonalInfoModelUserNickname = @"user_nickname";
NSString *const kPersonalInfoModelVotes = @"votes";
NSString *const kPersonalInfoModelVotestotal = @"votestotal";

@interface PersonalInfoModel ()
@end
@implementation PersonalInfoModel




/**
 * Instantiate the instance using the passed dictionary values to set the properties values
 *
 *  eg: NOTE_09.06.16: added self.coinRecordFan1, self.coinRecordFan2, self.coinRecordFan3
 *                  parsing from self.coinrecord3
 */

-(instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if(![dictionary[kPersonalInfoModelAttentionnum] isKindOfClass:[NSNull class]]){
        self.attentionnum = [dictionary[kPersonalInfoModelAttentionnum] integerValue];
    }
    
    if(![dictionary[kPersonalInfoModelAvatar] isKindOfClass:[NSNull class]]){
        self.avatar = dictionary[kPersonalInfoModelAvatar];
    }
    if(![dictionary[kPersonalInfoModelBirthday] isKindOfClass:[NSNull class]]){
        self.birthday = dictionary[kPersonalInfoModelBirthday];
    }
    if(![dictionary[kPersonalInfoModelCity] isKindOfClass:[NSNull class]]){
        self.city = dictionary[kPersonalInfoModelCity];
    }
    if(![dictionary[kPersonalInfoModelCoin] isKindOfClass:[NSNull class]]){
        self.coin = dictionary[kPersonalInfoModelCoin];
    }
    if(![dictionary[kPersonalInfoModelCoinrecord3] isKindOfClass:[NSNull class]]){
        self.coinrecord3 = dictionary[kPersonalInfoModelCoinrecord3];
        [self setCoinRecordTopFans];
    }
    if(![dictionary[kPersonalInfoModelConsumption] isKindOfClass:[NSNull class]]){
        self.consumption = dictionary[kPersonalInfoModelConsumption];
    }
    if(![dictionary[kPersonalInfoModelExperience] isKindOfClass:[NSNull class]]){
        self.experience = dictionary[kPersonalInfoModelExperience];
    }
    if(![dictionary[kPersonalInfoModelFansnum] isKindOfClass:[NSNull class]]){
        self.fansnum = [dictionary[kPersonalInfoModelFansnum] integerValue];
    }
    
    if(![dictionary[kPersonalInfoModelGender] isKindOfClass:[NSNull class]]){
        self.gender = dictionary[kPersonalInfoModelGender];
    }
    if(![dictionary[kPersonalInfoModelIdField] isKindOfClass:[NSNull class]]){
        self.idField = dictionary[kPersonalInfoModelIdField];
    }
    if(dictionary[kPersonalInfoModelInterests] != nil && [dictionary[kPersonalInfoModelInterests] isKindOfClass:[NSArray class]]){
        NSArray * interestsDictionaries = dictionary[kPersonalInfoModelInterests];
        NSMutableArray * interestsItems = [NSMutableArray array];
        for(NSDictionary * interestsDictionary in interestsDictionaries){
            InterestModel * interestsItem = [[InterestModel alloc] initWithDictionary:interestsDictionary];
            [interestsItems addObject:interestsItem];
        }
        self.interests = interestsItems;
    }
    if(![dictionary[kPersonalInfoModelIsrecommend] isKindOfClass:[NSNull class]]){
        self.isrecommend = dictionary[kPersonalInfoModelIsrecommend];
    }
    if(![dictionary[kPersonalInfoModelLevel] isKindOfClass:[NSNull class]]){
        self.level = dictionary[kPersonalInfoModelLevel];
    }
    if(![dictionary[kPersonalInfoModelLikes] isKindOfClass:[NSNull class]]){
        self.likes = [dictionary[kPersonalInfoModelLikes] integerValue];
    }
    
    if(![dictionary[kPersonalInfoModelLiverecordnum] isKindOfClass:[NSNull class]]){
        self.liverecordnum = [dictionary[kPersonalInfoModelLiverecordnum] integerValue];
    }
    
    if(![dictionary[kPersonalInfoModelMobile] isKindOfClass:[NSNull class]]){
        self.mobile = dictionary[kPersonalInfoModelMobile];
    }
    if(![dictionary[kPersonalInfoModelProvince] isKindOfClass:[NSNull class]]){
        self.province = dictionary[kPersonalInfoModelProvince];
    }
    if(![dictionary[kPersonalInfoModelSignature] isKindOfClass:[NSNull class]]){
        self.signature = dictionary[kPersonalInfoModelSignature];
    }
    if(![dictionary[kPersonalInfoModelStars] isKindOfClass:[NSNull class]]){
        self.stars = dictionary[kPersonalInfoModelStars];
    }
    if(![dictionary[kPersonalInfoModelStarsTotal] isKindOfClass:[NSNull class]]){
        self.starsTotal = dictionary[kPersonalInfoModelStarsTotal];
    }
    if(![dictionary[kPersonalInfoModelUserNickname] isKindOfClass:[NSNull class]]){
        self.userNickname = dictionary[kPersonalInfoModelUserNickname];
    }
    if(![dictionary[kPersonalInfoModelVotes] isKindOfClass:[NSNull class]]){
        self.votes = dictionary[kPersonalInfoModelVotes];
    }
    if(![dictionary[kPersonalInfoModelVotestotal] isKindOfClass:[NSNull class]]){
        self.votestotal = dictionary[kPersonalInfoModelVotestotal];
    }
    return self;
}
- (void)setCoinRecordTopFans
{
    if ([ObjectTypeValidator nsarrayIsNilOrEmpty:self.coinrecord3])
    {
        XLM_error(@"self.coinrecord3 is nil or empty; failed to set coinrecord top 3 fans properties (coinRecordFan1, coinRecordFan2, coinRecordFan3");
        return;
    }

    if (self.coinrecord3.count > 0) {
        NSDictionary *dict0 = [ObjectTypeValidator nsdictionaryFromObject:self.coinrecord3[0]];
        self.coinRecordFan1 = [[CoinRecordModel alloc] initWithDictionary:dict0];
    }
    if (self.coinrecord3.count > 1) {
        NSDictionary *dict1 = [ObjectTypeValidator nsdictionaryFromObject:self.coinrecord3[1]];
        self.coinRecordFan2 = [[CoinRecordModel alloc] initWithDictionary:dict1];
    }
    if (self.coinrecord3.count > 2) {
        NSDictionary *dict2 = [ObjectTypeValidator nsdictionaryFromObject:self.coinrecord3[2]];
        self.coinRecordFan3 = [[CoinRecordModel alloc] initWithDictionary:dict2];
    }
}

/**
 * Returns all the available property values in the form of NSDictionary object where the key is the approperiate json key and the value is the value of the corresponding property
 
 *      eg: NOTE_09.08.16: self.coinRecordFan1, self.coinRecordFan2, self.coinRecordFan3
 *          not included
 */
-(NSDictionary *)toDictionary
{
    NSMutableDictionary * dictionary = [NSMutableDictionary dictionary];
    dictionary[kPersonalInfoModelAttentionnum] = @(self.attentionnum);
    if(self.avatar != nil){
        dictionary[kPersonalInfoModelAvatar] = self.avatar;
    }
    if(self.birthday != nil){
        dictionary[kPersonalInfoModelBirthday] = self.birthday;
    }
    if(self.city != nil){
        dictionary[kPersonalInfoModelCity] = self.city;
    }
    if(self.coin != nil){
        dictionary[kPersonalInfoModelCoin] = self.coin;
    }
    if(self.coinrecord3 != nil){
        dictionary[kPersonalInfoModelCoinrecord3] = self.coinrecord3;
    }
    if(self.consumption != nil){
        dictionary[kPersonalInfoModelConsumption] = self.consumption;
    }
    if(self.experience != nil){
        dictionary[kPersonalInfoModelExperience] = self.experience;
    }
    dictionary[kPersonalInfoModelFansnum] = @(self.fansnum);
    if(self.gender != nil){
        dictionary[kPersonalInfoModelGender] = self.gender;
    }
    if(self.idField != nil){
        dictionary[kPersonalInfoModelIdField] = self.idField;
    }
    if(self.interests != nil){
        NSMutableArray * dictionaryElements = [NSMutableArray array];
        for(InterestModel * interestsElement in self.interests){
            [dictionaryElements addObject:[interestsElement toDictionary]];
        }
        dictionary[kPersonalInfoModelInterests] = dictionaryElements;
    }
    if(self.isrecommend != nil){
        dictionary[kPersonalInfoModelIsrecommend] = self.isrecommend;
    }
    if(self.level != nil){
        dictionary[kPersonalInfoModelLevel] = self.level;
    }
    dictionary[kPersonalInfoModelLikes] = @(self.likes);
    dictionary[kPersonalInfoModelLiverecordnum] = @(self.liverecordnum);
    if(self.mobile != nil){
        dictionary[kPersonalInfoModelMobile] = self.mobile;
    }
    if(self.province != nil){
        dictionary[kPersonalInfoModelProvince] = self.province;
    }
    if(self.signature != nil){
        dictionary[kPersonalInfoModelSignature] = self.signature;
    }
    if(self.stars != nil){
        dictionary[kPersonalInfoModelStars] = self.stars;
    }
    if(self.starsTotal != nil){
        dictionary[kPersonalInfoModelStarsTotal] = self.starsTotal;
    }
    if(self.userNickname != nil){
        dictionary[kPersonalInfoModelUserNickname] = self.userNickname;
    }
    if(self.votes != nil){
        dictionary[kPersonalInfoModelVotes] = self.votes;
    }
    if(self.votestotal != nil){
        dictionary[kPersonalInfoModelVotestotal] = self.votestotal;
    }
    return dictionary;
    
}

/**
 * Implementation of NSCoding encoding method
 */
/**
 * Returns all the available property values in the form of NSDictionary object where the key is the approperiate json key and the value is the value of the corresponding property
 
 *      eg: NOTE_09.08.16: self.coinRecordFan1, self.coinRecordFan2, self.coinRecordFan3
 *          not included
 */
- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:@(self.attentionnum) forKey:kPersonalInfoModelAttentionnum];	if(self.avatar != nil){
        [aCoder encodeObject:self.avatar forKey:kPersonalInfoModelAvatar];
    }
    if(self.birthday != nil){
        [aCoder encodeObject:self.birthday forKey:kPersonalInfoModelBirthday];
    }
    if(self.city != nil){
        [aCoder encodeObject:self.city forKey:kPersonalInfoModelCity];
    }
    if(self.coin != nil){
        [aCoder encodeObject:self.coin forKey:kPersonalInfoModelCoin];
    }
    if(self.coinrecord3 != nil){
        [aCoder encodeObject:self.coinrecord3 forKey:kPersonalInfoModelCoinrecord3];
    }
    if(self.consumption != nil){
        [aCoder encodeObject:self.consumption forKey:kPersonalInfoModelConsumption];
    }
    if(self.experience != nil){
        [aCoder encodeObject:self.experience forKey:kPersonalInfoModelExperience];
    }
    [aCoder encodeObject:@(self.fansnum) forKey:kPersonalInfoModelFansnum];	if(self.gender != nil){
        [aCoder encodeObject:self.gender forKey:kPersonalInfoModelGender];
    }
    if(self.idField != nil){
        [aCoder encodeObject:self.idField forKey:kPersonalInfoModelIdField];
    }
    if(self.interests != nil){
        [aCoder encodeObject:self.interests forKey:kPersonalInfoModelInterests];
    }
    if(self.isrecommend != nil){
        [aCoder encodeObject:self.isrecommend forKey:kPersonalInfoModelIsrecommend];
    }
    if(self.level != nil){
        [aCoder encodeObject:self.level forKey:kPersonalInfoModelLevel];
    }
    [aCoder encodeObject:@(self.likes) forKey:kPersonalInfoModelLikes];	[aCoder encodeObject:@(self.liverecordnum) forKey:kPersonalInfoModelLiverecordnum];	if(self.mobile != nil){
        [aCoder encodeObject:self.mobile forKey:kPersonalInfoModelMobile];
    }
    if(self.province != nil){
        [aCoder encodeObject:self.province forKey:kPersonalInfoModelProvince];
    }
    if(self.signature != nil){
        [aCoder encodeObject:self.signature forKey:kPersonalInfoModelSignature];
    }
    if(self.stars != nil){
        [aCoder encodeObject:self.stars forKey:kPersonalInfoModelStars];
    }
    if(self.starsTotal != nil){
        [aCoder encodeObject:self.starsTotal forKey:kPersonalInfoModelStarsTotal];
    }
    if(self.userNickname != nil){
        [aCoder encodeObject:self.userNickname forKey:kPersonalInfoModelUserNickname];
    }
    if(self.votes != nil){
        [aCoder encodeObject:self.votes forKey:kPersonalInfoModelVotes];
    }
    if(self.votestotal != nil){
        [aCoder encodeObject:self.votestotal forKey:kPersonalInfoModelVotestotal];
    }
    
}

/**
 * Implementation of NSCoding initWithCoder: method
 *  
 *      eg: NOTE_09.08.16: self.coinRecordFan1, self.coinRecordFan2, self.coinRecordFan3
 *          not included
 */
- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    self.attentionnum = [[aDecoder decodeObjectForKey:kPersonalInfoModelAttentionnum] integerValue];
    self.avatar = [aDecoder decodeObjectForKey:kPersonalInfoModelAvatar];
    self.birthday = [aDecoder decodeObjectForKey:kPersonalInfoModelBirthday];
    self.city = [aDecoder decodeObjectForKey:kPersonalInfoModelCity];
    self.coin = [aDecoder decodeObjectForKey:kPersonalInfoModelCoin];
    self.coinrecord3 = [aDecoder decodeObjectForKey:kPersonalInfoModelCoinrecord3];
    self.consumption = [aDecoder decodeObjectForKey:kPersonalInfoModelConsumption];
    self.experience = [aDecoder decodeObjectForKey:kPersonalInfoModelExperience];
    self.fansnum = [[aDecoder decodeObjectForKey:kPersonalInfoModelFansnum] integerValue];
    self.gender = [aDecoder decodeObjectForKey:kPersonalInfoModelGender];
    self.idField = [aDecoder decodeObjectForKey:kPersonalInfoModelIdField];
    self.interests = [aDecoder decodeObjectForKey:kPersonalInfoModelInterests];
    self.isrecommend = [aDecoder decodeObjectForKey:kPersonalInfoModelIsrecommend];
    self.level = [aDecoder decodeObjectForKey:kPersonalInfoModelLevel];
    self.likes = [[aDecoder decodeObjectForKey:kPersonalInfoModelLikes] integerValue];
    self.liverecordnum = [[aDecoder decodeObjectForKey:kPersonalInfoModelLiverecordnum] integerValue];
    self.mobile = [aDecoder decodeObjectForKey:kPersonalInfoModelMobile];
    self.province = [aDecoder decodeObjectForKey:kPersonalInfoModelProvince];
    self.signature = [aDecoder decodeObjectForKey:kPersonalInfoModelSignature];
    self.stars = [aDecoder decodeObjectForKey:kPersonalInfoModelStars];
    self.starsTotal = [aDecoder decodeObjectForKey:kPersonalInfoModelStarsTotal];
    self.userNickname = [aDecoder decodeObjectForKey:kPersonalInfoModelUserNickname];
    self.votes = [aDecoder decodeObjectForKey:kPersonalInfoModelVotes];
    self.votestotal = [aDecoder decodeObjectForKey:kPersonalInfoModelVotestotal];
    return self;
    
}

/**
 * Implementation of NSCopying copyWithZone: method
 *
 *      eg: NOTE_09.08.16: self.coinRecordFan1, self.coinRecordFan2, self.coinRecordFan3
 *          not included
 */
- (instancetype)copyWithZone:(NSZone *)zone
{
    PersonalInfoModel *copy = [PersonalInfoModel new];
    
    copy.attentionnum = self.attentionnum;
    copy.avatar = [self.avatar copyWithZone:zone];
    copy.birthday = [self.birthday copyWithZone:zone];
    copy.city = [self.city copyWithZone:zone];
    copy.coin = [self.coin copyWithZone:zone];
    copy.coinrecord3 = [self.coinrecord3 copyWithZone:zone];
    copy.consumption = [self.consumption copyWithZone:zone];
    copy.experience = [self.experience copyWithZone:zone];
    copy.fansnum = self.fansnum;
    copy.gender = [self.gender copyWithZone:zone];
    copy.idField = [self.idField copyWithZone:zone];
    copy.interests = [self.interests copyWithZone:zone];
    copy.isrecommend = [self.isrecommend copyWithZone:zone];
    copy.level = [self.level copyWithZone:zone];
    copy.likes = self.likes;
    copy.liverecordnum = self.liverecordnum;
    copy.mobile = [self.mobile copyWithZone:zone];
    copy.province = [self.province copyWithZone:zone];
    copy.signature = [self.signature copyWithZone:zone];
    copy.stars = [self.stars copyWithZone:zone];
    copy.starsTotal = [self.starsTotal copyWithZone:zone];
    copy.userNickname = [self.userNickname copyWithZone:zone];
    copy.votes = [self.votes copyWithZone:zone];
    copy.votestotal = [self.votestotal copyWithZone:zone];
    
    return copy;
}
@end
