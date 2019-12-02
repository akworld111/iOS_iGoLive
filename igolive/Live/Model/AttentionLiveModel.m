//
//	AttentionLiveModel.m
//	Model file Generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport



#import "AttentionLiveModel.h"

NSString *const kAttentionLiveModelAddress = @"address";
NSString *const kAttentionLiveModelAvatar = @"avatar";
NSString *const kAttentionLiveModelCity = @"city";
NSString *const kAttentionLiveModelEndtime = @"endtime";
NSString *const kAttentionLiveModelGender = @"gender";
NSString *const kAttentionLiveModelIdField = @"id";
NSString *const kAttentionLiveModelIslive = @"islive";
NSString *const kAttentionLiveModelLevel = @"level";
NSString *const kAttentionLiveModelLight = @"light";
NSString *const kAttentionLiveModelNums = @"nums";
NSString *const kAttentionLiveModelProvince = @"province";
NSString *const kAttentionLiveModelShowid = @"showid";
NSString *const kAttentionLiveModelStarttime = @"starttime";
NSString *const kAttentionLiveModelTags = @"tags";
NSString *const kAttentionLiveModelTitle = @"title";
NSString *const kAttentionLiveModelUid = @"uid";
NSString *const kAttentionLiveModelUserNickname = @"user_nickname";

@interface AttentionLiveModel ()
@end
@implementation AttentionLiveModel




/**
 * Instantiate the instance using the passed dictionary values to set the properties values
 */

-(instancetype)initWithDictionary:(NSDictionary *)dictionary
{
	self = [super init];
	if(![dictionary[kAttentionLiveModelAddress] isKindOfClass:[NSNull class]]){
		self.address = dictionary[kAttentionLiveModelAddress];
	}	
	if(![dictionary[kAttentionLiveModelAvatar] isKindOfClass:[NSNull class]]){
		self.avatar = dictionary[kAttentionLiveModelAvatar];
	}	
	if(![dictionary[kAttentionLiveModelCity] isKindOfClass:[NSNull class]]){
		self.city = dictionary[kAttentionLiveModelCity];
	}	
	if(![dictionary[kAttentionLiveModelEndtime] isKindOfClass:[NSNull class]]){
		self.endtime = dictionary[kAttentionLiveModelEndtime];
	}	
	if(![dictionary[kAttentionLiveModelGender] isKindOfClass:[NSNull class]]){
		self.gender = dictionary[kAttentionLiveModelGender];
	}	
	if(![dictionary[kAttentionLiveModelIdField] isKindOfClass:[NSNull class]]){
		self.idField = dictionary[kAttentionLiveModelIdField];
	}	
	if(![dictionary[kAttentionLiveModelIslive] isKindOfClass:[NSNull class]]){
		self.islive = dictionary[kAttentionLiveModelIslive];
	}	
	if(![dictionary[kAttentionLiveModelLevel] isKindOfClass:[NSNull class]]){
		self.level = dictionary[kAttentionLiveModelLevel];
	}	
	if(![dictionary[kAttentionLiveModelLight] isKindOfClass:[NSNull class]]){
		self.light = dictionary[kAttentionLiveModelLight];
	}	
	if(![dictionary[kAttentionLiveModelNums] isKindOfClass:[NSNull class]]){
		self.nums = dictionary[kAttentionLiveModelNums];
	}	
	if(![dictionary[kAttentionLiveModelProvince] isKindOfClass:[NSNull class]]){
		self.province = dictionary[kAttentionLiveModelProvince];
	}	
	if(![dictionary[kAttentionLiveModelShowid] isKindOfClass:[NSNull class]]){
		self.showid = dictionary[kAttentionLiveModelShowid];
	}	
	if(![dictionary[kAttentionLiveModelStarttime] isKindOfClass:[NSNull class]]){
		self.starttime = dictionary[kAttentionLiveModelStarttime];
	}	
	if(![dictionary[kAttentionLiveModelTags] isKindOfClass:[NSNull class]]){
		self.tags = dictionary[kAttentionLiveModelTags];
	}	
	if(![dictionary[kAttentionLiveModelTitle] isKindOfClass:[NSNull class]]){
		self.title = dictionary[kAttentionLiveModelTitle];
	}	
	if(![dictionary[kAttentionLiveModelUid] isKindOfClass:[NSNull class]]){
		self.uid = dictionary[kAttentionLiveModelUid];
	}	
	if(![dictionary[kAttentionLiveModelUserNickname] isKindOfClass:[NSNull class]]){
		self.userNickname = dictionary[kAttentionLiveModelUserNickname];
	}	
	return self;
}


/**
 * Returns all the available property values in the form of NSDictionary object where the key is the approperiate json key and the value is the value of the corresponding property
 */
-(NSDictionary *)toDictionary
{
	NSMutableDictionary * dictionary = [NSMutableDictionary dictionary];
	if(self.address != nil){
		dictionary[kAttentionLiveModelAddress] = self.address;
	}
	if(self.avatar != nil){
		dictionary[kAttentionLiveModelAvatar] = self.avatar;
	}
	if(self.city != nil){
		dictionary[kAttentionLiveModelCity] = self.city;
	}
	if(self.endtime != nil){
		dictionary[kAttentionLiveModelEndtime] = self.endtime;
	}
	if(self.gender != nil){
		dictionary[kAttentionLiveModelGender] = self.gender;
	}
	if(self.idField != nil){
		dictionary[kAttentionLiveModelIdField] = self.idField;
	}
	if(self.islive != nil){
		dictionary[kAttentionLiveModelIslive] = self.islive;
	}
	if(self.level != nil){
		dictionary[kAttentionLiveModelLevel] = self.level;
	}
	if(self.light != nil){
		dictionary[kAttentionLiveModelLight] = self.light;
	}
	if(self.nums != nil){
		dictionary[kAttentionLiveModelNums] = self.nums;
	}
	if(self.province != nil){
		dictionary[kAttentionLiveModelProvince] = self.province;
	}
	if(self.showid != nil){
		dictionary[kAttentionLiveModelShowid] = self.showid;
	}
	if(self.starttime != nil){
		dictionary[kAttentionLiveModelStarttime] = self.starttime;
	}
	if(self.tags != nil){
		dictionary[kAttentionLiveModelTags] = self.tags;
	}
	if(self.title != nil){
		dictionary[kAttentionLiveModelTitle] = self.title;
	}
	if(self.uid != nil){
		dictionary[kAttentionLiveModelUid] = self.uid;
	}
	if(self.userNickname != nil){
		dictionary[kAttentionLiveModelUserNickname] = self.userNickname;
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
	if(self.address != nil){
		[aCoder encodeObject:self.address forKey:kAttentionLiveModelAddress];
	}
	if(self.avatar != nil){
		[aCoder encodeObject:self.avatar forKey:kAttentionLiveModelAvatar];
	}
	if(self.city != nil){
		[aCoder encodeObject:self.city forKey:kAttentionLiveModelCity];
	}
	if(self.endtime != nil){
		[aCoder encodeObject:self.endtime forKey:kAttentionLiveModelEndtime];
	}
	if(self.gender != nil){
		[aCoder encodeObject:self.gender forKey:kAttentionLiveModelGender];
	}
	if(self.idField != nil){
		[aCoder encodeObject:self.idField forKey:kAttentionLiveModelIdField];
	}
	if(self.islive != nil){
		[aCoder encodeObject:self.islive forKey:kAttentionLiveModelIslive];
	}
	if(self.level != nil){
		[aCoder encodeObject:self.level forKey:kAttentionLiveModelLevel];
	}
	if(self.light != nil){
		[aCoder encodeObject:self.light forKey:kAttentionLiveModelLight];
	}
	if(self.nums != nil){
		[aCoder encodeObject:self.nums forKey:kAttentionLiveModelNums];
	}
	if(self.province != nil){
		[aCoder encodeObject:self.province forKey:kAttentionLiveModelProvince];
	}
	if(self.showid != nil){
		[aCoder encodeObject:self.showid forKey:kAttentionLiveModelShowid];
	}
	if(self.starttime != nil){
		[aCoder encodeObject:self.starttime forKey:kAttentionLiveModelStarttime];
	}
	if(self.tags != nil){
		[aCoder encodeObject:self.tags forKey:kAttentionLiveModelTags];
	}
	if(self.title != nil){
		[aCoder encodeObject:self.title forKey:kAttentionLiveModelTitle];
	}
	if(self.uid != nil){
		[aCoder encodeObject:self.uid forKey:kAttentionLiveModelUid];
	}
	if(self.userNickname != nil){
		[aCoder encodeObject:self.userNickname forKey:kAttentionLiveModelUserNickname];
	}

}

/**
 * Implementation of NSCoding initWithCoder: method
 */
- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
	self = [super init];
	self.address = [aDecoder decodeObjectForKey:kAttentionLiveModelAddress];
	self.avatar = [aDecoder decodeObjectForKey:kAttentionLiveModelAvatar];
	self.city = [aDecoder decodeObjectForKey:kAttentionLiveModelCity];
	self.endtime = [aDecoder decodeObjectForKey:kAttentionLiveModelEndtime];
	self.gender = [aDecoder decodeObjectForKey:kAttentionLiveModelGender];
	self.idField = [aDecoder decodeObjectForKey:kAttentionLiveModelIdField];
	self.islive = [aDecoder decodeObjectForKey:kAttentionLiveModelIslive];
	self.level = [aDecoder decodeObjectForKey:kAttentionLiveModelLevel];
	self.light = [aDecoder decodeObjectForKey:kAttentionLiveModelLight];
	self.nums = [aDecoder decodeObjectForKey:kAttentionLiveModelNums];
	self.province = [aDecoder decodeObjectForKey:kAttentionLiveModelProvince];
	self.showid = [aDecoder decodeObjectForKey:kAttentionLiveModelShowid];
	self.starttime = [aDecoder decodeObjectForKey:kAttentionLiveModelStarttime];
	self.tags = [aDecoder decodeObjectForKey:kAttentionLiveModelTags];
	self.title = [aDecoder decodeObjectForKey:kAttentionLiveModelTitle];
	self.uid = [aDecoder decodeObjectForKey:kAttentionLiveModelUid];
	self.userNickname = [aDecoder decodeObjectForKey:kAttentionLiveModelUserNickname];
	return self;

}

/**
 * Implementation of NSCopying copyWithZone: method
 */
- (instancetype)copyWithZone:(NSZone *)zone
{
	AttentionLiveModel *copy = [AttentionLiveModel new];

	copy.address = [self.address copyWithZone:zone];
	copy.avatar = [self.avatar copyWithZone:zone];
	copy.city = [self.city copyWithZone:zone];
	copy.endtime = [self.endtime copyWithZone:zone];
	copy.gender = [self.gender copyWithZone:zone];
	copy.idField = [self.idField copyWithZone:zone];
	copy.islive = [self.islive copyWithZone:zone];
	copy.level = [self.level copyWithZone:zone];
	copy.light = [self.light copyWithZone:zone];
	copy.nums = [self.nums copyWithZone:zone];
	copy.province = [self.province copyWithZone:zone];
	copy.showid = [self.showid copyWithZone:zone];
	copy.starttime = [self.starttime copyWithZone:zone];
	copy.tags = [self.tags copyWithZone:zone];
	copy.title = [self.title copyWithZone:zone];
	copy.uid = [self.uid copyWithZone:zone];
	copy.userNickname = [self.userNickname copyWithZone:zone];

	return copy;
}
@end