//
//	RedisModel.m
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport



#import "RedisModel.h"

NSString *const kRedisModelAvatar = @"avatar";
NSString *const kRedisModelCity = @"city";
NSString *const kRedisModelCoin = @"coin";
NSString *const kRedisModelExperience = @"experience";
NSString *const kRedisModelGender = @"gender";
NSString *const kRedisModelIdField = @"id";
NSString *const kRedisModelIslive = @"islive";
NSString *const kRedisModelIsrecommend = @"isrecommend";
NSString *const kRedisModelLevel = @"level";
NSString *const kRedisModelMobile = @"mobile";
NSString *const kRedisModelProvince = @"province";
NSString *const kRedisModelSign = @"sign";
NSString *const kRedisModelSignature = @"signature";
NSString *const kRedisModelStars = @"stars";
NSString *const kRedisModelUserType = @"userType";
NSString *const kRedisModelUserNickname = @"user_nickname";
NSString *const kRedisModelVotes = @"votes";
NSString *const kRedisModelVotestotal = @"votestotal";

@implementation RedisModel

/**
 * Instantiate the instance using the passed dictionary values to set the properties values
 */

-(instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if(![dictionary[kRedisModelAvatar] isKindOfClass:[NSNull class]]){
        self.avatar = dictionary[kRedisModelAvatar];
    }
    if(![dictionary[kRedisModelCity] isKindOfClass:[NSNull class]]){
        self.city = dictionary[kRedisModelCity];
    }
    if(![dictionary[kRedisModelCoin] isKindOfClass:[NSNull class]]){
        self.coin = dictionary[kRedisModelCoin];
    }
    if(![dictionary[kRedisModelExperience] isKindOfClass:[NSNull class]]){
        self.experience = dictionary[kRedisModelExperience];
    }
    if(![dictionary[kRedisModelGender] isKindOfClass:[NSNull class]]){
        self.gender = dictionary[kRedisModelGender];
    }
    if(![dictionary[kRedisModelIdField] isKindOfClass:[NSNull class]]){
        self.idField = dictionary[kRedisModelIdField];
    }
    if(![dictionary[kRedisModelIslive] isKindOfClass:[NSNull class]]){
        self.islive = [dictionary[kRedisModelIslive] integerValue];
    }
    
    if(![dictionary[kRedisModelIsrecommend] isKindOfClass:[NSNull class]]){
        self.isrecommend = dictionary[kRedisModelIsrecommend];
    }
    if(![dictionary[kRedisModelLevel] isKindOfClass:[NSNull class]]){
        self.level = dictionary[kRedisModelLevel];
    }
    if(![dictionary[kRedisModelMobile] isKindOfClass:[NSNull class]]){
        self.mobile = dictionary[kRedisModelMobile];
    }
    if(![dictionary[kRedisModelProvince] isKindOfClass:[NSNull class]]){
        self.province = dictionary[kRedisModelProvince];
    }
    if(![dictionary[kRedisModelSign] isKindOfClass:[NSNull class]]){
        self.sign = dictionary[kRedisModelSign];
    }
    if(![dictionary[kRedisModelSignature] isKindOfClass:[NSNull class]]){
        self.signature = dictionary[kRedisModelSignature];
    }
    if(![dictionary[kRedisModelStars] isKindOfClass:[NSNull class]]){
        self.stars = dictionary[kRedisModelStars];
    }
    if(![dictionary[kRedisModelUserType] isKindOfClass:[NSNull class]]){
        self.userType = [dictionary[kRedisModelUserType] integerValue];
    }
    
    if(![dictionary[kRedisModelUserNickname] isKindOfClass:[NSNull class]]){
        self.userNickname = dictionary[kRedisModelUserNickname];
    }
    if(![dictionary[kRedisModelVotes] isKindOfClass:[NSNull class]]){
        self.votes = dictionary[kRedisModelVotes];
    }
    if(![dictionary[kRedisModelVotestotal] isKindOfClass:[NSNull class]]){
        self.votestotal = dictionary[kRedisModelVotestotal];
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
        dictionary[kRedisModelAvatar] = self.avatar;
    }
    if(self.city != nil){
        dictionary[kRedisModelCity] = self.city;
    }
    if(self.coin != nil){
        dictionary[kRedisModelCoin] = self.coin;
    }
    if(self.experience != nil){
        dictionary[kRedisModelExperience] = self.experience;
    }
    if(self.gender != nil){
        dictionary[kRedisModelGender] = self.gender;
    }
    if(self.idField != nil){
        dictionary[kRedisModelIdField] = self.idField;
    }
    dictionary[kRedisModelIslive] = @(self.islive);
    if(self.isrecommend != nil){
        dictionary[kRedisModelIsrecommend] = self.isrecommend;
    }
    if(self.level != nil){
        dictionary[kRedisModelLevel] = self.level;
    }
    if(self.mobile != nil){
        dictionary[kRedisModelMobile] = self.mobile;
    }
    if(self.province != nil){
        dictionary[kRedisModelProvince] = self.province;
    }
    if(self.sign != nil){
        dictionary[kRedisModelSign] = self.sign;
    }
    if(self.signature != nil){
        dictionary[kRedisModelSignature] = self.signature;
    }
    if(self.stars != nil){
        dictionary[kRedisModelStars] = self.stars;
    }
    dictionary[kRedisModelUserType] = @(self.userType);
    if(self.userNickname != nil){
        dictionary[kRedisModelUserNickname] = self.userNickname;
    }
    if(self.votes != nil){
        dictionary[kRedisModelVotes] = self.votes;
    }
    if(self.votestotal != nil){
        dictionary[kRedisModelVotestotal] = self.votestotal;
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
        [aCoder encodeObject:self.avatar forKey:kRedisModelAvatar];
    }
    if(self.city != nil){
        [aCoder encodeObject:self.city forKey:kRedisModelCity];
    }
    if(self.coin != nil){
        [aCoder encodeObject:self.coin forKey:kRedisModelCoin];
    }
    if(self.experience != nil){
        [aCoder encodeObject:self.experience forKey:kRedisModelExperience];
    }
    if(self.gender != nil){
        [aCoder encodeObject:self.gender forKey:kRedisModelGender];
    }
    if(self.idField != nil){
        [aCoder encodeObject:self.idField forKey:kRedisModelIdField];
    }
    [aCoder encodeObject:@(self.islive) forKey:kRedisModelIslive];	if(self.isrecommend != nil){
        [aCoder encodeObject:self.isrecommend forKey:kRedisModelIsrecommend];
    }
    if(self.level != nil){
        [aCoder encodeObject:self.level forKey:kRedisModelLevel];
    }
    if(self.mobile != nil){
        [aCoder encodeObject:self.mobile forKey:kRedisModelMobile];
    }
    if(self.province != nil){
        [aCoder encodeObject:self.province forKey:kRedisModelProvince];
    }
    if(self.sign != nil){
        [aCoder encodeObject:self.sign forKey:kRedisModelSign];
    }
    if(self.signature != nil){
        [aCoder encodeObject:self.signature forKey:kRedisModelSignature];
    }
    if(self.stars != nil){
        [aCoder encodeObject:self.stars forKey:kRedisModelStars];
    }
    [aCoder encodeObject:@(self.userType) forKey:kRedisModelUserType];	if(self.userNickname != nil){
        [aCoder encodeObject:self.userNickname forKey:kRedisModelUserNickname];
    }
    if(self.votes != nil){
        [aCoder encodeObject:self.votes forKey:kRedisModelVotes];
    }
    if(self.votestotal != nil){
        [aCoder encodeObject:self.votestotal forKey:kRedisModelVotestotal];
    }
    
}

/**
 * Implementation of NSCoding initWithCoder: method
 */
- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    self.avatar = [aDecoder decodeObjectForKey:kRedisModelAvatar];
    self.city = [aDecoder decodeObjectForKey:kRedisModelCity];
    self.coin = [aDecoder decodeObjectForKey:kRedisModelCoin];
    self.experience = [aDecoder decodeObjectForKey:kRedisModelExperience];
    self.gender = [aDecoder decodeObjectForKey:kRedisModelGender];
    self.idField = [aDecoder decodeObjectForKey:kRedisModelIdField];
    self.islive = [[aDecoder decodeObjectForKey:kRedisModelIslive] integerValue];
    self.isrecommend = [aDecoder decodeObjectForKey:kRedisModelIsrecommend];
    self.level = [aDecoder decodeObjectForKey:kRedisModelLevel];
    self.mobile = [aDecoder decodeObjectForKey:kRedisModelMobile];
    self.province = [aDecoder decodeObjectForKey:kRedisModelProvince];
    self.sign = [aDecoder decodeObjectForKey:kRedisModelSign];
    self.signature = [aDecoder decodeObjectForKey:kRedisModelSignature];
    self.stars = [aDecoder decodeObjectForKey:kRedisModelStars];
    self.userType = [[aDecoder decodeObjectForKey:kRedisModelUserType] integerValue];
    self.userNickname = [aDecoder decodeObjectForKey:kRedisModelUserNickname];
    self.votes = [aDecoder decodeObjectForKey:kRedisModelVotes];
    self.votestotal = [aDecoder decodeObjectForKey:kRedisModelVotestotal];
    return self;
    
}

/**
 * Implementation of NSCopying copyWithZone: method
 */
- (instancetype)copyWithZone:(NSZone *)zone
{
    RedisModel *copy = [RedisModel new];
    
    copy.avatar = [self.avatar copyWithZone:zone];
    copy.city = [self.city copyWithZone:zone];
    copy.coin = [self.coin copyWithZone:zone];
    copy.experience = [self.experience copyWithZone:zone];
    copy.gender = [self.gender copyWithZone:zone];
    copy.idField = [self.idField copyWithZone:zone];
    copy.islive = self.islive;
    copy.isrecommend = [self.isrecommend copyWithZone:zone];
    copy.level = [self.level copyWithZone:zone];
    copy.mobile = [self.mobile copyWithZone:zone];
    copy.province = [self.province copyWithZone:zone];
    copy.sign = [self.sign copyWithZone:zone];
    copy.signature = [self.signature copyWithZone:zone];
    copy.stars = [self.stars copyWithZone:zone];
    copy.userType = self.userType;
    copy.userNickname = [self.userNickname copyWithZone:zone];
    copy.votes = [self.votes copyWithZone:zone];
    copy.votestotal = [self.votestotal copyWithZone:zone];
    
    return copy;
}
@end