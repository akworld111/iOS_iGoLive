//
//	FollowModel.m
//
//	Create by sdd on 19/8/2016
//	Copyright © 2016. All rights reserved.
//	Model file Generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport



#import "FollowModel.h"

NSString *const kFollowModelAvatar = @"avatar";
NSString *const kFollowModelCity = @"city";
NSString *const kFollowModelExperience = @"experience";
NSString *const kFollowModelGender = @"gender";
NSString *const kFollowModelIdField = @"id";
NSString *const kFollowModelIsattention = @"isattention";
NSString *const kFollowModelIsrecommend = @"isrecommend";
NSString *const kFollowModelLevel = @"level";
NSString *const kFollowModelMobile = @"mobile";
NSString *const kFollowModelProvince = @"province";
NSString *const kFollowModelSignature = @"signature";
NSString *const kFollowModelStars = @"stars";
NSString *const kFollowModelStarsTotal = @"stars_total";
NSString *const kFollowModelUserNickname = @"user_nickname";
NSString *const kFollowModelVotes = @"votes";
NSString *const kFollowModelVotestotal = @"votestotal";

@interface FollowModel ()
@end
@implementation FollowModel




/**
 * Instantiate the instance using the passed dictionary values to set the properties values
 */

-(instancetype)initWithDictionary:(NSDictionary *)dictionary
{
	self = [super init];
	if(![dictionary[kFollowModelAvatar] isKindOfClass:[NSNull class]]){
		self.avatar = dictionary[kFollowModelAvatar];
	}	
	if(![dictionary[kFollowModelCity] isKindOfClass:[NSNull class]]){
		self.city = dictionary[kFollowModelCity];
	}	
	if(![dictionary[kFollowModelExperience] isKindOfClass:[NSNull class]]){
		self.experience = dictionary[kFollowModelExperience];
	}	
	if(![dictionary[kFollowModelGender] isKindOfClass:[NSNull class]]){
		self.gender = dictionary[kFollowModelGender];
	}	
	if(![dictionary[kFollowModelIdField] isKindOfClass:[NSNull class]]){
		self.idField = dictionary[kFollowModelIdField];
	}	
	if(![dictionary[kFollowModelIsattention] isKindOfClass:[NSNull class]]){
		self.isattention = [dictionary[kFollowModelIsattention] integerValue];
	}

	if(![dictionary[kFollowModelIsrecommend] isKindOfClass:[NSNull class]]){
		self.isrecommend = dictionary[kFollowModelIsrecommend];
	}	
	if(![dictionary[kFollowModelLevel] isKindOfClass:[NSNull class]]){
		self.level = dictionary[kFollowModelLevel];
	}	
	if(![dictionary[kFollowModelMobile] isKindOfClass:[NSNull class]]){
		self.mobile = dictionary[kFollowModelMobile];
	}	
	if(![dictionary[kFollowModelProvince] isKindOfClass:[NSNull class]]){
		self.province = dictionary[kFollowModelProvince];
	}	
	if(![dictionary[kFollowModelSignature] isKindOfClass:[NSNull class]]){
		self.signature = dictionary[kFollowModelSignature];
	}	
	if(![dictionary[kFollowModelStars] isKindOfClass:[NSNull class]]){
		self.stars = dictionary[kFollowModelStars];
	}	
	if(![dictionary[kFollowModelStarsTotal] isKindOfClass:[NSNull class]]){
		self.starsTotal = dictionary[kFollowModelStarsTotal];
	}	
	if(![dictionary[kFollowModelUserNickname] isKindOfClass:[NSNull class]]){
		self.userNickname = dictionary[kFollowModelUserNickname];
	}	
	if(![dictionary[kFollowModelVotes] isKindOfClass:[NSNull class]]){
		self.votes = dictionary[kFollowModelVotes];
	}	
	if(![dictionary[kFollowModelVotestotal] isKindOfClass:[NSNull class]]){
		self.votestotal = dictionary[kFollowModelVotestotal];
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
		dictionary[kFollowModelAvatar] = self.avatar;
	}
	if(self.city != nil){
		dictionary[kFollowModelCity] = self.city;
	}
	if(self.experience != nil){
		dictionary[kFollowModelExperience] = self.experience;
	}
	if(self.gender != nil){
		dictionary[kFollowModelGender] = self.gender;
	}
	if(self.idField != nil){
		dictionary[kFollowModelIdField] = self.idField;
	}
	dictionary[kFollowModelIsattention] = @(self.isattention);
	if(self.isrecommend != nil){
		dictionary[kFollowModelIsrecommend] = self.isrecommend;
	}
	if(self.level != nil){
		dictionary[kFollowModelLevel] = self.level;
	}
	if(self.mobile != nil){
		dictionary[kFollowModelMobile] = self.mobile;
	}
	if(self.province != nil){
		dictionary[kFollowModelProvince] = self.province;
	}
	if(self.signature != nil){
		dictionary[kFollowModelSignature] = self.signature;
	}
	if(self.stars != nil){
		dictionary[kFollowModelStars] = self.stars;
	}
	if(self.starsTotal != nil){
		dictionary[kFollowModelStarsTotal] = self.starsTotal;
	}
	if(self.userNickname != nil){
		dictionary[kFollowModelUserNickname] = self.userNickname;
	}
	if(self.votes != nil){
		dictionary[kFollowModelVotes] = self.votes;
	}
	if(self.votestotal != nil){
		dictionary[kFollowModelVotestotal] = self.votestotal;
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
		[aCoder encodeObject:self.avatar forKey:kFollowModelAvatar];
	}
	if(self.city != nil){
		[aCoder encodeObject:self.city forKey:kFollowModelCity];
	}
	if(self.experience != nil){
		[aCoder encodeObject:self.experience forKey:kFollowModelExperience];
	}
	if(self.gender != nil){
		[aCoder encodeObject:self.gender forKey:kFollowModelGender];
	}
	if(self.idField != nil){
		[aCoder encodeObject:self.idField forKey:kFollowModelIdField];
	}
	[aCoder encodeObject:@(self.isattention) forKey:kFollowModelIsattention];	if(self.isrecommend != nil){
		[aCoder encodeObject:self.isrecommend forKey:kFollowModelIsrecommend];
	}
	if(self.level != nil){
		[aCoder encodeObject:self.level forKey:kFollowModelLevel];
	}
	if(self.mobile != nil){
		[aCoder encodeObject:self.mobile forKey:kFollowModelMobile];
	}
	if(self.province != nil){
		[aCoder encodeObject:self.province forKey:kFollowModelProvince];
	}
	if(self.signature != nil){
		[aCoder encodeObject:self.signature forKey:kFollowModelSignature];
	}
	if(self.stars != nil){
		[aCoder encodeObject:self.stars forKey:kFollowModelStars];
	}
	if(self.starsTotal != nil){
		[aCoder encodeObject:self.starsTotal forKey:kFollowModelStarsTotal];
	}
	if(self.userNickname != nil){
		[aCoder encodeObject:self.userNickname forKey:kFollowModelUserNickname];
	}
	if(self.votes != nil){
		[aCoder encodeObject:self.votes forKey:kFollowModelVotes];
	}
	if(self.votestotal != nil){
		[aCoder encodeObject:self.votestotal forKey:kFollowModelVotestotal];
	}

}

/**
 * Implementation of NSCoding initWithCoder: method
 */
- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
	self = [super init];
	self.avatar = [aDecoder decodeObjectForKey:kFollowModelAvatar];
	self.city = [aDecoder decodeObjectForKey:kFollowModelCity];
	self.experience = [aDecoder decodeObjectForKey:kFollowModelExperience];
	self.gender = [aDecoder decodeObjectForKey:kFollowModelGender];
	self.idField = [aDecoder decodeObjectForKey:kFollowModelIdField];
	self.isattention = [[aDecoder decodeObjectForKey:kFollowModelIsattention] integerValue];
	self.isrecommend = [aDecoder decodeObjectForKey:kFollowModelIsrecommend];
	self.level = [aDecoder decodeObjectForKey:kFollowModelLevel];
	self.mobile = [aDecoder decodeObjectForKey:kFollowModelMobile];
	self.province = [aDecoder decodeObjectForKey:kFollowModelProvince];
	self.signature = [aDecoder decodeObjectForKey:kFollowModelSignature];
	self.stars = [aDecoder decodeObjectForKey:kFollowModelStars];
	self.starsTotal = [aDecoder decodeObjectForKey:kFollowModelStarsTotal];
	self.userNickname = [aDecoder decodeObjectForKey:kFollowModelUserNickname];
	self.votes = [aDecoder decodeObjectForKey:kFollowModelVotes];
	self.votestotal = [aDecoder decodeObjectForKey:kFollowModelVotestotal];
	return self;

}

/**
 * Implementation of NSCopying copyWithZone: method
 */
- (instancetype)copyWithZone:(NSZone *)zone
{
	FollowModel *copy = [FollowModel new];

	copy.avatar = [self.avatar copyWithZone:zone];
	copy.city = [self.city copyWithZone:zone];
	copy.experience = [self.experience copyWithZone:zone];
	copy.gender = [self.gender copyWithZone:zone];
	copy.idField = [self.idField copyWithZone:zone];
	copy.isattention = self.isattention;
	copy.isrecommend = [self.isrecommend copyWithZone:zone];
	copy.level = [self.level copyWithZone:zone];
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